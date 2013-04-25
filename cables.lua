function cable_scanforobjects(pos)
	cable_autoroute({ x=pos.x-1, y=pos.y  , z=pos.z   })
	cable_autoroute({ x=pos.x+1, y=pos.y  , z=pos.z   })
	cable_autoroute({ x=pos.x  , y=pos.y-1, z=pos.z   })
	cable_autoroute({ x=pos.x  , y=pos.y+1, z=pos.z   })
	cable_autoroute({ x=pos.x  , y=pos.y  , z=pos.z-1 })
	cable_autoroute({ x=pos.x  , y=pos.y  , z=pos.z+1 })
	cable_autoroute(pos)
end

minetest.register_on_placenode(function(pos, newnode, placer, oldnode)
	if minetest.get_item_group(newnode.name,"energy") > 0 then
		cable_scanforobjects(pos)
	end
end)

minetest.register_on_dignode(function(pos, oldnode, digger)
	if minetest.get_item_group(oldnode.name,"energy") > 0 then
		cable_scanforobjects(pos)
	end
end)

function in_table(table,element)
	for _,el in ipairs(table) do
		if el==element then return true end
	end
	return false
end

function is_cable(nodename)
	return in_table(cablenodes,nodename)
end

function cable_autoroute(pos)
	nctr = minetest.env:get_node(pos)
	if (is_cable(nctr.name) == nil)
		and minetest.get_item_group(nctr.name, "energy") ~= 1 then return end

	pxm=0
	pxp=0
	pym=0
	pyp=0
	pzm=0
	pzp=0

	nxm = minetest.env:get_node({ x=pos.x-1, y=pos.y  , z=pos.z   })
	nxp = minetest.env:get_node({ x=pos.x+1, y=pos.y  , z=pos.z   })
	nym = minetest.env:get_node({ x=pos.x  , y=pos.y-1, z=pos.z   })
	nyp = minetest.env:get_node({ x=pos.x  , y=pos.y+1, z=pos.z   })
	nzm = minetest.env:get_node({ x=pos.x  , y=pos.y  , z=pos.z-1 })
	nzp = minetest.env:get_node({ x=pos.x  , y=pos.y  , z=pos.z+1 })

	if is_cable(nxm.name) 
		or minetest.get_item_group(nxm.name, "energy") == 1 then pxm=1 end
	if is_cable(nxp.name) 
		or minetest.get_item_group(nxp.name, "energy") == 1 then pxp=1 end
	if is_cable(nym.name) 
		or minetest.get_item_group(nym.name, "energy") == 1 then pym=1 end
	if is_cable(nyp.name) 
		or minetest.get_item_group(nyp.name, "energy") == 1 then pyp=1 end
	if is_cable(nzm.name) 
		or minetest.get_item_group(nzm.name, "energy") == 1 then pzm=1 end
	if is_cable(nzp.name) 
		or minetest.get_item_group(nzp.name, "energy") == 1 then pzp=1 end

	nsurround = pxm..pxp..pym..pyp..pzm..pzp
	if is_cable(nctr.name) then
		local meta=minetest.env:get_meta(pos)
		local meta0=meta:to_table()
		nctr.name=string.sub(nctr.name,1,-7)..nsurround
		minetest.env:add_node(pos, nctr)
		local meta=minetest.env:get_meta(pos)
		meta:from_table(meta0)
	end

end

function replace_name(tbl,tr,name)
	local ntbl={}
	for key,i in pairs(tbl) do
		if type(i)=="string" then
			ntbl[key]=string.gsub(i,tr,name)
		elseif type(i)=="table" then
			ntbl[key]=replace_name(i,tr,name)
		else
			ntbl[key]=i
		end
	end
	return ntbl
end

cablenodes={}

-- tables

function get_cable_leftstub(width)
	return {{ -0.5, -width/2, -width/2, width/2, width/2, width/2 }}
end

function get_cable_rightstub(width)
	return {{ -width/2, -width/2, -width/2,  0.5, width/2, width/2 }}
end

function get_cable_bottomstub(width)
	return {{ -width/2, -0.5, -width/2,   width/2, width/2, width/2 }}
end

function get_cable_topstub(width)
	return {{ -width/2, -width/2, -width/2,   width/2, 0.5, width/2 }}
end

function get_cable_frontstub(width)
	return {{ -width/2, -width/2, -0.5,   width/2, width/2, width/2 }}
end

function get_cable_backstub(width)
	return {{ -width/2, -width/2, -width/2,   width/2, width/2, 0.5 }} 
end

--[[function get_cable_selectboxes(width)
	return {{ -0.5,  -10/64,  -10/64,  10/64,  10/64,  10/64 },
		{ -10/64 ,  -10/64,  -10/64, 0.5,  10/64,  10/64 },
		{ -10/64 , -0.5,  -10/64,  10/64,  10/64,  10/64 },
		{ -10/64 ,  -10/64,  -10/64,  10/64, 0.5,  10/64 },
		{ -10/64 ,  -10/64, -0.5,  10/64,  10/64,  10/64 },
		{ -10/64 ,  -10/64,  -10/64,  10/64,  10/64, 0.5 }}
end]]

function cable_addbox(t, b)
	for i in ipairs(b)
		do table.insert(t, b[i])
	end
end

function register_cable(name,max_current,resistance,desc,width,plain_textures,noctr_textures,end_textures,inv_texture,special)
for xm = 0, 1 do
for xp = 0, 1 do
for ym = 0, 1 do
for yp = 0, 1 do
for zm = 0, 1 do
for zp = 0, 1 do
	local outboxes = {}
	local outsel = {}
	local outimgs = {}

	if yp==1 then
		cable_addbox(outboxes, get_cable_topstub(width))
		--table.insert(outsel, get_cable_topstub(width))
		table.insert(outimgs, noctr_textures[4])
	else
		table.insert(outimgs, plain_textures[4])
	end
	if ym==1 then
		cable_addbox(outboxes, get_cable_bottomstub(width))
		--table.insert(outsel, get_cable_bottomstub(width))
		table.insert(outimgs, noctr_textures[3])
	else
		table.insert(outimgs, plain_textures[3])
	end
	if xp==1 then
		cable_addbox(outboxes, get_cable_rightstub(width))
		--table.insert(outsel, get_cable_rightstub(width))
		table.insert(outimgs, noctr_textures[2])
	else
		table.insert(outimgs, plain_textures[2])
	end
	if xm==1 then
		cable_addbox(outboxes, get_cable_leftstub(width))
		--table.insert(outsel, get_cable_leftstub(width))
		table.insert(outimgs, noctr_textures[1])
	else
		table.insert(outimgs, plain_textures[1])
	end
	if zp==1 then
		cable_addbox(outboxes, get_cable_backstub(width))
		--table.insert(outsel, get_cable_backstub(width))
		table.insert(outimgs, noctr_textures[6])
	else
		table.insert(outimgs, plain_textures[6])
	end
	if zm==1 then
		cable_addbox(outboxes, get_cable_frontstub(width))
		--table.insert(outsel, get_cable_frontstub(width))
		table.insert(outimgs, noctr_textures[5])
	else
		table.insert(outimgs, plain_textures[5])
	end

	local jx = xp+xm
	local jy = yp+ym
	local jz = zp+zm

	if (jx+jy+jz) == 1 then
		if xm == 1 then 
			table.remove(outimgs, 3)
			table.insert(outimgs, 3, end_textures[3])
		end
		if xp == 1 then 
			table.remove(outimgs, 4)
			table.insert(outimgs, 4, end_textures[4])
		end
		if ym == 1 then 
			table.remove(outimgs, 1)
			table.insert(outimgs, 1, end_textures[1])
		end
		if xp == 1 then 
			table.remove(outimgs, 2)
			table.insert(outimgs, 2, end_textures[2])
		end
		if zm == 1 then 
			table.remove(outimgs, 5)
			table.insert(outimgs, 5, end_textures[5])
		end
		if zp == 1 then 
			table.remove(outimgs, 6)
			table.insert(outimgs, 6, end_textures[6])
		end
	end

	local tname = xm..xp..ym..yp..zm..zp
	local tgroups = ""

	if tname ~= "000000" then
		tgroups = {snappy=3, energy_conductor=1, not_in_creative_inventory=1}
		cabledesc = desc.." ("..tname..")... You hacker, you."
		iimg=nil
		wscale = {x=1,y=1,z=1}
	else
		tgroups = {snappy=3, energy_conductor=1}
		cabledesc = desc
		iimg=inv_texture
		outboxes={-width/2,-width/2,-width/2,width/2,width/2,width/2}
		wscale = {x=1,y=1,z=0.01}
	end
	table.insert(cablenodes,name.."_"..tname)
	
	nodedef={
		description = cabledesc,
		drawtype = "nodebox",
		tiles = outimgs,
		inventory_image=iimg,
		wield_image=iimg,
		wield_scale=wscale,
		paramtype = "light",
		selection_box = {
	             	type = "fixed",
			--fixed = outsel
			fixed = outboxes
		},
		node_box = {
			type = "fixed",
			fixed = outboxes
		},
		groups = tgroups,
		itest = {max_current = max_current,
			current_loss = resistance},
		sounds = default.node_sound_wood_defaults(),
		walkable = true,
		stack_max = 99,
		drop = name.."_000000",
		cablelike=1,
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("cablelike",1)
			if minetest.registered_nodes[name.."_"..tname].on_construct_ then
				minetest.registered_nodes[name.."_"..tname].on_construct_(pos)
			end
		end,
		after_place_node = function(pos)
			cable_scanforobjects(pos)
			if minetest.registered_nodes[name.."_"..tname].after_place_node_ then
				minetest.registered_nodes[name.."_"..tname].after_place_node_(pos)
			end
		end,
		after_dig_node = function(pos)
			cable_scanforobjects(pos)
			if minetest.registered_nodes[name.."_"..tname].after_dig_node_ then
				minetest.registered_nodes[name.."_"..tname].after_dig_node_(pos)
			end
		end
	}
	
	if special==nil then special={} end

	for key,value in pairs(special) do
		if key=="on_construct" or key=="after_dig_node" or key=="after_place_node" then
			nodedef[key.."_"]=value
		elseif key=="groups" then
			for group,val in pairs(value) do
				nodedef.groups[group]=val
			end
		elseif type(value)=="table" then
			nodedef[key]=replace_name(value,"#id",tname)
		elseif type(value)=="string" then
			nodedef[key]=string.gsub(value,"#id",tname)
		else
			nodedef[key]=value
		end
	end
	
	minetest.register_node(name.."_"..tname, nodedef)

end
end
end
end
end
end
end

function register_cables(name, desc, max_insulate, max_energy, res_table, wtable, textures, itextures)
	for insu=0,max_insulate do
		local d
		if insu == 0 then
			d="Uninsulated "..desc
		elseif insu==1 then
			d="Insulated "..desc
		else
			d=tostring(insu).."xIns. "..desc
		end
		local texture=textures[insu+1]
		local itexture=itextures[insu+1]
		local ntable={texture,texture,texture,texture,texture,texture}
		register_cable(name..tostring(insu),max_energy,res_table[insu+1],d,wtable[insu+1],ntable,ntable,ntable,itexture)
	end
end

register_cables("itest:copper_cable","copper cable",1,32,{0.3, 0.2},{4/16, 6/16},
	{"itest_copper_cable_0.png","itest_copper_cable_1.png"},
	{"itest_copper_cable_inv_0.png","itest_copper_cable_inv_1.png"})

register_cables("itest:gold_cable","gold cable",2,128,{0.5, 0.45, 0.4},{4/16, 5/16, 6/16},
	{"itest_gold_cable_0.png","itest_gold_cable_1.png","itest_gold_cable_2.png"},
	{"itest_gold_cable_inv_0.png","itest_gold_cable_inv_1.png","itest_gold_cable_inv_2.png"})

register_cables("itest:tin_cable","tin cable",0,5,{0.025},{5/16},
	{"itest_tin_cable_0.png"},
	{"itest_tin_cable_inv_0.png"})

register_cables("itest:hv_cable","HV cable",3,2048,{1, 0.95, 0.9, 0.8},{6/16, 8/16, 10/16, 12/16},
	{"itest_hv_cable_0.png","itest_hv_cable_1.png","itest_hv_cable_2.png","itest_hv_cable_3.png"},
	{"itest_hv_cable_inv_0.png","itest_hv_cable_inv_1.png","itest_hv_cable_inv_2.png","itest_hv_cable_inv_3.png"})
