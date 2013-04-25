minetest.register_node("itest:watermill",{description="Watermill",
	groups={energy=1,cracky=2},
	tiles={"itest_watermill_top.png", "itest_watermill_top.png", "itest_watermill_side.png"},
	itest = {max_energy=500},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("energyf",0)
		meta:set_string("formspec", generators.get_formspec(pos)..
				"image[2,2;1,1;itest_water.png]")
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
	nodenames={"itest:watermill"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local meta=minetest.env:get_meta(pos)
		local prod = 0
		for x = pos.x-1, pos.x+1 do
		for y = pos.y-1, pos.y+1 do
		for z = pos.z-1, pos.z+1 do
			local n = minetest.env:get_node({x=x,y=y,z=z})
			if n.name == "default:water_source" or n.name == "default:water_flowing" then
				prod = prod+1
			end
		end
		end
		end
		if prod==0 then
			for i=1,20 do
				local energy = meta:get_int("energy")
				local use = math.min(energy,2)
				meta:set_int("energy",energy-use)
				generators.produce(pos,use)
			end
		else
			for i=1,20 do
				meta:set_int("energyf",meta:get_int("energyf")+prod%100)
				if meta:get_int("energyf") >= 100 then
					meta:set_int("energyf",meta:get_int("energyf")-100)
					generators.produce(pos,math.floor(prod/100)+1)
				else
					generators.produce(pos,math.floor(prod/100))
				end
			end
		end
		meta:set_string("formspec",generators.get_formspec(pos)..
				"image[2,2;1,1;itest_water.png]")
	end
})
