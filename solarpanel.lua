minetest.register_node("itest:solar_panel",{description="Solar panel",
	groups={energy=1,cracky=2},
	tiles={"itest_solar_panel_top.png", "itest_solar_panel_side.png", "itest_solar_panel_side.png"},
	itest = {max_energy=500},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_string("formspec", generators.get_formspec(pos)..
				"image[2,2;1,1;itest_sun.png]")
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
	nodenames={"itest:solar_panel"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local l=minetest.env:get_node_light({x=pos.x, y=pos.y+1, z=pos.z})
		local meta=minetest.env:get_meta(pos)
		if l<15 then
			for i=1,20 do
				local energy = meta:get_int("energy")
				local use = math.min(energy,1)
				meta:set_int("energy",energy-use)
				generators.produce(pos,use)
			end
		else
			for i=1,20 do
				generators.produce(pos,1)
			end
		end
		meta:set_string("formspec",generators.get_formspec(pos)..
				"image[2,2;1,1;itest_sun.png]")
	end
})
