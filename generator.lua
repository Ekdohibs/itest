minetest.register_node("itest:generator", {
	description = "Generator",
	tiles = {"itest_generator_side.png", "itest_generator_side.png", "itest_generator_side.png",
		"itest_generator_side.png", "itest_generator_side.png", "itest_generator_front.png"},
	paramtype2 = "facedir",
	groups = {energy=1, cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	itest = {max_energy=4000},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		meta:set_string("formspec", generators.get_formspec(pos)..
				"list[current_name;fuel;2,3;1,1;]"..
				"image[2,2;1,1;default_furnace_fire_bg.png]")
		generators.on_construct(pos)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		end
		return generators.can_dig(pos,player)
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "fuel" then
			if is_fuel_no_lava(stack) then
				return stack:get_count()
			else
				return 0
			end
		end
		return generators.inventory(pos, listname, stack)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "fuel" then
			if is_fuel_no_lava(stack) then
				return count
			else
				return 0
			end
		end
		return generators.inventory(pos, to_list, stack)
	end,
})

minetest.register_node("itest:generator_active", {
	description = "Generator",
	tiles = {"itest_generator_side.png", "itest_generator_side.png", "itest_generator_side.png",
		"itest_generator_side.png", "itest_generator_side.png", "itest_generator_front_active.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "itest:generator",
	groups = {energy=1, cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	itest = {max_energy=4000},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		meta:set_string("formspec", generators.get_formspec(pos)..
				"list[current_name;fuel;2,3;1,1;]"..
				"image[2,2;1,1;default_furnace_fire_bg.png]")
		generators.on_construct(pos)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		end
		return generators.can_dig(pos,player)
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "fuel" then
			if is_fuel_no_lava(stack) then
				return stack:get_count()
			else
				return 0
			end
		end
		return generators.inventory(pos, listname, stack)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "fuel" then
			if is_fuel_no_lava(stack) then
				return count
			else
				return 0
			end
		end
		return generators.inventory(pos, to_list, stack)
	end,
})

minetest.register_abm({
	nodenames = {"itest:generator","itest:generator_active"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		
		if meta:get_string("ftime") == "" then
			meta:set_float("ftime", 0.0)
		end
		
		if meta:get_string("fburntime") == "" then
			meta:set_float("fburntime", 0.0)
		end
		
		local state=false
		for i=1,20 do
			local fuel = nil
			local afterfuel
			local fuellist = inv:get_list("fuel")
			
			if fuellist then
				fuel, afterfuel = minetest.get_craft_result(
					{method = "fuel", width = 1, items = fuellist})
			end
			
			if meta:get_float("ftime") < meta:get_float("fburntime") then
				meta:set_float("ftime", meta:get_float("ftime") + 1)
				generators.produce(pos,10)
			else
				local energy = meta:get_int("energy")
				local use = math.min(energy,10)
				meta:set_int("energy",energy-use)
				generators.produce(pos,use)
			end
			
			if meta:get_float("ftime") < meta:get_float("fburntime") then
				local percent = meta:get_float("ftime")/meta:get_float("fburntime")*100
				state = true
				meta:set_string("formspec", generators.get_formspec(pos)..
					"image[2,2;1,1;default_furnace_fire_bg.png^[lowpart:"..
							(100-percent)..":default_furnace_fire_fg.png]"..
					"list[current_name;fuel;2,3;1,1;]")
			else
			
				if fuellist then
					fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
				end
	
				if (not fuel) or fuel.time <= 0 then
					state = false
					meta:set_string("formspec", generators.get_formspec(pos)..
						"image[2,2;1,1;default_furnace_fire_bg.png]"..
						"list[current_name;fuel;2,3;1,1;]")
					break
				end
		
				meta:set_float("ftime", meta:get_float("ftime")-meta:get_float("fburntime"))
				meta:set_float("fburntime", fuel.time*5) -- Fuel will last 4 times less, but we have 20 ticks in a second
				meta:set_string("formspec", generators.get_formspec(pos)..
						"image[2,2;1,1;default_furnace_fire_fg.png]"..
						"list[current_name;fuel;2,3;1,1;]")
				inv:set_stack("fuel", 1, afterfuel.items[1])
			end
		end

		if state then
			hacky_swap_node(pos,"itest:generator_active")
		else
			hacky_swap_node(pos,"itest:generator")
		end
	end,
})
