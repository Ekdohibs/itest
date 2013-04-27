function addVect(pos,vect)
	return {x=pos.x+vect.x,y=pos.y+vect.y,z=pos.z+vect.z}
end

adjlist={{x=0,y=0,z=1},{x=0,y=0,z=-1},{x=0,y=1,z=0},{x=0,y=-1,z=0},{x=1,y=0,z=0},{x=-1,y=0,z=0}}

function notdir(tbl,dir)
	tbl2={}
	for _,val in ipairs(tbl) do
		if val.x~=-dir.x or val.y~=-dir.y or val.z~=-dir.z then table.insert(tbl2,val) end
	end
	return tbl2
end

function posintbl(tbl,pos)
	for _,val in ipairs(tbl) do
		if val.x==pos.x and val.y==pos.y and val.z==pos.z then return true end
	end
	return false
end

function blast(pos)
	for _,dir in ipairs(adjlist) do
		minetest.env:set_node(addVect(pos,dir),{name="air"})
	end
	minetest.env:set_node(pos,{name="air"})
end

function round0(x) -- This function removes precision error when using decimal
	if x<=0.000001 and x>=-0.000001 then return 0 end
	return x
end

function send(pos,dir,power,explored)
	if power<=0.000001 then return nil end
	if posintbl(explored,pos) then return nil end
	explored[#explored+1]=pos
	local cnode=minetest.env:get_node(pos)
	local maxcurrent=get_node_field(cnode.name,nil,"max_current",pos)
	local currentloss=get_node_field_float(cnode.name,nil,"current_loss",pos)
	local p=math.ceil(round0(power-currentloss))
	local l={}
	local ret
	for i=1,6 do -- 6 should be a maximum
		local next=enegy_go_next(pos,dir,p)
		if next==1 then
			ret=1
			break
		end
		if next==nil or next==0 then
			break
		end
		if posintbl(l,next) then break end
		l[#l+1]=next
		local s=send(addVect(pos,next),next,power-currentloss,explored)
		if s==1 then
			ret=1
			break
		end
	end
	if ret==nil then return nil end
	local meta=minetest.env:get_meta(pos)
	if meta:get_int("get_current")>0 then -- We want to mesure current through cable.
		local c=meta:get_int("current")
		meta:set_int("current",c+p)
	end
	if maxcurrent<power then minetest.env:set_node(pos,{name="air"}) end -- Melt cable
	return ret
end

function send_packet(fpos,dir,psize)
	local conductor=get_node_field(
			minetest.env:get_node(addVect(fpos,dir)).name,nil,"energy_conductor",addVect(fpos,dir))
	local s
	local consumer=get_node_field(minetest.env:get_node(addVect(fpos,dir)).name,nil,"energy_consumer",addVect(fpos,dir))
	local closs=get_node_field_float(
			minetest.env:get_node(addVect(fpos,dir)).name,nil,"current_loss",addVect(fpos,dir))
	if conductor>0 then
		s=send(addVect(fpos,dir),dir,psize,{})
	elseif consumer>0 then
		local npos = addVect(fpos,dir)
		local node = minetest.env:get_node(npos)
		local meta = minetest.env:get_meta(npos)
		if not (minetest.registered_nodes[node.name].itest and
			minetest.registered_nodes[node.name].itest.can_receive and
				(not minetest.registered_nodes[node.name].itest.can_receive(npos,vect))) then
			local max_energy=get_node_field(node.name,meta,"max_energy")
			local current_energy=meta:get_int("energy")
			local max_psize=get_node_field(node.name,meta,"max_psize")
			if psize>max_psize then
				blast(npos)
				return psize
			elseif psize <= max_energy-current_energy then 
				meta:set_int("energy",meta:get_int("energy")+psize)
				return psize
			end
		end
	end
	return s
end

function send_packet_alldirs(pos,power)
	for _,dir in ipairs(adjlist) do
		local s=send_packet(pos,dir,power)
		if s~= nil then
			return 1
		end
	end
	return 0
end

function enegy_go_next(pos,dir,power)
	local consumers={}
	local cables={}
	local cnode=minetest.env:get_node(pos)
	local cmeta=minetest.env:get_meta(pos)
	local node
	local meta
	local conductor
	local consumer
	local n
	local can_go
	if minetest.registered_nodes[cnode.name] and
		minetest.registered_nodes[cnode.name].itest and
		minetest.registered_nodes[cnode.name].itest.can_go then
			can_go=minetest.registered_nodes[cnode.name].itest.can_go(pos,node,dir)
	else
		can_go=notdir(adjlist,dir) -- We don't want to go back
	end
	for _,vect in ipairs(can_go) do
		npos=addVect(pos,vect)
		node=minetest.env:get_node(npos)
		consumer=minetest.get_item_group(node.name,"energy_consumer")
		conductor=minetest.get_item_group(node.name,"energy_conductor")
		meta=minetest.env:get_meta(npos)
		if consumer==1 then
			if not (minetest.registered_nodes[node.name].itest and
				minetest.registered_nodes[node.name].itest.can_receive and
					(not minetest.registered_nodes[node.name].itest.can_receive(npos,vect))) then
				local max_energy=get_node_field(node.name,meta,"max_energy")
				local current_energy=meta:get_int("energy")
				local max_psize=get_node_field(node.name,meta,"max_psize")
				if power>max_psize then
					local i=#consumers+1
					consumers[i]={}
					consumers[i].pos=npos
					consumers[i].vect=vect
					consumers[i].overcharge=true
				elseif power <= max_energy-current_energy then -- We don't want to waste power 
					local i=#consumers+1
					consumers[i]={}
					consumers[i].pos=npos
					consumers[i].vect=vect
				end
			end
		elseif conductor==1 then
			local i=#cables+1
			cables[i]={}
			cables[i].pos=npos
			cables[i].vect=vect
		end
	end
	if consumers[1]==nil then
		if cables[1]==nil then
			return 0
		else
			local i=#cables
			n=(cmeta:get_int("cdir"))%i+1
			cmeta:set_int("cdir",n)
			return cables[n].vect
		end
	else -- Always try to send to a consumer first
		local i=#consumers
		n=(cmeta:get_int("cdir"))%i+1
		cmeta:set_int("cdir",n)
		if consumers[n].overcharge then
			blast(consumers[n].pos)
			return 1
		end
		local meta=minetest.env:get_meta(consumers[n].pos)
		meta:set_int("energy",meta:get_int("energy")+power)
		return 1
	end
end
