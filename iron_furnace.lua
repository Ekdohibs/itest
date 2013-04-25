iron_furnace = {}

function iron_furnace.get_formspec(pos)
	formspec = "size[8,9]"..
	"list[current_name;fuel;2,3;1,1;]"..
	"list[current_name;src;2,1;1,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"
	local meta = minetest.env:get_meta(pos)
	local percent
	if meta:get_float("fburntime") == 0 then
		percent = 0
	else
		percent = 100 - meta:get_float("ftime")/meta:get_float("fburntime")*100
	end
	local chrbar="image[2,2;1,1;default_furnace_fire_bg.png^[lowpart:"..
			percent..":default_furnace_fire_fg.png]"
	return formspec..chrbar
end

minetest.register_node("itest:iron_furnace", {
	description = "Iron furnace",
	tiles = {"itest_iron_furnace_side.png", "itest_iron_furnace_side.png", "itest_iron_furnace_side.png","itest_iron_furnace_side.png", "itest_iron_furnace_side.png", "itest_iron_furnace_front.png"},
	paramtype2 = "facedir",
	groups = {energy=1, energy_consumer=1, cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		inv:set_size("fuel", 1)
		meta:set_string("formspec", iron_furnace.get_formspec(pos))
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("src") and inv:is_empty("dst") and
			inv:is_empty("fuel")
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "dst" then
			return 0
		elseif listname == "src" then
			return stack:get_count()
		elseif listname == "fuel" then
			if is_fuel_no_lava(stack) then
				return stack:get_count()
			else
				return 0
			end
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "dst" then
			return 0
		elseif to_list == "src" then
			return stack:get_count()
		elseif to_list == "fuel" then
			if is_fuel_no_lava(stack) then
				return stack:get_count()
			else
				return 0
			end
		end
	end,
})

minetest.register_node("itest:iron_furnace_active", {
	description = "Iron furnace",
	tiles = {"itest_iron_furnace_side.png", "itest_iron_furnace_side.png", "itest_iron_furnace_side.png","itest_iron_furnace_side.png", "itest_iron_furnace_side.png", "itest_iron_furnace_front_active.png"},
	paramtype2 = "facedir",
	drop = "itest:iron_furnace",
	light_source = 8,
	groups = {energy=1, energy_consumer=1, cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	itest = {max_energy=4000},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		inv:set_size("fuel", 1)
		meta:set_string("formspec", iron_furnace.get_formspec(pos))
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("src") and inv:is_empty("dst") and
			inv:is_empty("fuel")
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "dst" then
			return 0
		elseif listname == "src" then
			return stack:get_count()
		elseif listname == "fuel" then
			if is_fuel_no_lava(stack) then
				return stack:get_count()
			else
				return 0
			end
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "dst" then
			return 0
		elseif to_list == "src" then
			return stack:get_count()
		elseif to_list == "fuel" then
			if is_fuel_no_lava(stack) then
				return stack:get_count()
			else
				return 0
			end
		end
	end,
})

minetest.register_abm({
	nodenames = {"itest:iron_furnace","itest:iron_furnace_active"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		
		local speed = 0.8
		
		if meta:get_string("stime") == "" then
			meta:set_float("stime", 0.0)
		end
		if meta:get_string("ftime") == "" then
			meta:set_float("ftime", 0.0)
		end
		if meta:get_string("fburntime") == "" then
			meta:set_float("fburntime", 0.0)
		end
		
		local state = false
		
		local srclist
		local cooked
		local aftercooked
		
		for i = 1,20 do
			srclist = inv:get_list("src")
			cooked = nil
			aftercooked = nil
		
			if srclist then
				cooked, aftercooked = minetest.get_craft_result({method = "cooking",
					width = 1, items = srclist})
			end
		
			local ftime = meta:get_float("ftime")
			local fburntime = meta:get_float("fburntime")
			if ftime < fburntime then
				state = true
				meta:set_float("ftime",ftime+1)
			else
				if cooked.item:is_empty() then
					state = false
					break
				else
					local fuel = nil
					local afterfuel
					local fuellist = inv:get_list("fuel")
					
					if fuellist then
						fuel, afterfuel = minetest.get_craft_result(
							{method = "fuel", width = 1, items = fuellist})
					end
					if fuel.time <= 0 then
						state = false
						break
					end
					state = true
					meta:set_float("ftime", meta:get_float("ftime")-meta:get_float("fburntime"))
					meta:set_float("fburntime", 20*fuel.time)
					inv:set_stack("fuel", 1, afterfuel.items[1])
				end
			end
			if cooked and cooked.item then
				state = true
				meta:set_float("stime", meta:get_float("stime") + 1)
				if not cooked.item:is_empty() then
					--print("Ctime "..cooked.time)
					--print("Stime "..meta:get_float("stime"))
				end
				if meta:get_float("stime")>=20*speed*cooked.time then
					meta:set_float("stime",0)
					if inv:room_for_item("dst",cooked.item) then
						inv:add_item("dst", cooked.item)
						inv:set_stack("src", 1, aftercooked.items[1])
					else
						meta:set_float("stime",20*speed*cooked.time)
					end
				end
			else
				state = false
			end
		end
		if inv:is_empty("src") then state = false end
		if state then
			hacky_swap_node(pos,"itest:iron_furnace_active")
		else
			hacky_swap_node(pos,"itest:iron_furnace")
		end
		meta:set_string("formspec", iron_furnace.get_formspec(pos))
	end,
})
