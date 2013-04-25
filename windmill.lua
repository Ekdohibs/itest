wind_speed = 15

minetest.register_node("itest:windmill",{description="Windmill",
	groups={energy=1,cracky=2},
	tiles={"itest_windmill_top.png", "itest_windmill_top.png", "itest_windmill_side.png"},
	itest = {max_energy=500},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("energyf",0)
		meta:set_int("obstacles",200)
		meta:set_string("formspec", generators.get_formspec(pos)..
				"image[2,2;1,1;itest_wind.png]")
		generators.on_construct(pos)
	end,
	can_dig = generators.can_dig,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return generators.inventory(pos, listname, stack)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		return generators.inventory(pos, to_list, stack)
	end,
})

minetest.register_abm({
	nodenames={"itest:windmill"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local alt = pos.y
		if alt > 200 then alt = 200 end
		local meta=minetest.env:get_meta(pos)
		local prod=wind_speed*(alt-meta:get_int("obstacles"))
		if prod<=0 then
			for i=1,20 do
				local energy = meta:get_int("energy")
				local use = math.min(energy,5)
				meta:set_int("energy",energy-use)
				generators.produce(pos,use)
			end
		else
			for i=1,20 do
				meta:set_int("energyf",meta:get_int("energyf")+prod%750)
				if meta:get_int("energyf") >= 750 then
					meta:set_int("energyf",meta:get_int("energyf")-750)
					generators.produce(pos,math.floor(prod/750)+1)
				else
					generators.produce(pos,math.floor(prod/750))
				end
			end
		end
		if prod >= 3750 then
			if math.random()<=(prod-3750)/3750000 then
				minetest.env:set_node(pos,{name = "air"})
			end
		end
		meta:set_string("formspec",generators.get_formspec(pos)..
				"image[2,2;1,1;itest_wind.png]")
	end
})

minetest.register_abm({
	nodenames={"itest:windmill"},
	interval=20,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local obstacles = 0
		for x = pos.x-4,pos.x+4 do
		for y = pos.y-2,pos.y+4 do
		for z = pos.z-4,pos.z+4 do
			local n = minetest.env:get_node({x=x,y=y,z=z})
			if n.name ~= "air" and n.name ~= "ignore" then
				obstacles = obstacles + 1
			end
		end
		end
		end
		local meta = minetest.env:get_meta(pos)
		meta:set_int("obstacles",obstacles)
	end
})
