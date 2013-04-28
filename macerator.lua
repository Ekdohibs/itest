macerator_recipes = {}
macerator = {}

function macerator.register_macerator_recipe(string1,string2)
	macerator_recipes[string1]=string2
end
function macerator.get_craft_result(c)
	local input = c.items[1]
	local output = macerator_recipes[input:get_name()]
	input:take_item()
	return {item = ItemStack(output), time = 20},{items = {input}}
end

minetest.register_node("itest:macerator", {
	description = "Macerator",
	tiles = {"itest_macerator_side.png", "itest_macerator_side.png", "itest_macerator_side.png",
		"itest_macerator_side.png", "itest_macerator_side.png", "itest_macerator_front.png"},
	paramtype2 = "facedir",
	groups = {energy=1, energy_consumer=1, cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	tube={insert_object=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:add_item("src",stack)
		end,
		can_insert=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:room_for_item("src",stack)

		end,
		input_inventory="dst"},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("max_energy",800)
		meta:set_int("max_psize",32)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		meta:set_string("formspec", consumers.get_formspec(pos)..
				"list[current_name;src;2,1;1,1;]"..
				"list[current_name;dst;5,1;2,2;]"..
				consumers.get_progressbar(0,1,
					"itest_macerator_progress_bg.png",
					"itest_macerator_progress_fg.png"))
		consumers.on_construct(pos)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("src") and inv:is_empty("dst") and
			consumers.can_dig(pos,player)
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "dst" then
			return 0
		elseif listname == "src" then
			return stack:get_count()
		end
		return consumers.inventory(pos, listname, stack, 1)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "dst" then
			return 0
		elseif to_list == "src" then
			return stack:get_count()
		end
		return consumers.inventory(pos, to_list, stack, 1)
	end,
})

minetest.register_node("itest:macerator_active", {
	description = "Macerator",
	tiles = {"itest_macerator_side.png", "itest_macerator_side.png", "itest_macerator_side.png",
		"itest_macerator_side.png", "itest_macerator_side.png", "itest_macerator_front_active.png"},
	paramtype2 = "facedir",
	drop = "itest:macerator",
	groups = {energy=1, energy_consumer=1, cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	tube={insert_object=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:add_item("src",stack)
		end,
		can_insert=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:room_for_item("src",stack)

		end,
		input_inventory="dst"},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("max_energy",800)
		meta:set_int("max_psize",32)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		meta:set_string("formspec", consumers.get_formspec(pos)..
				"list[current_name;src;2,1;1,1;]"..
				"list[current_name;dst;5,1;2,2;]")
		consumers.on_construct(pos)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("src") and inv:is_empty("dst") and
			consumers.can_dig(pos,player)
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "dst" then
			return 0
		elseif listname == "src" then
			return stack:get_count()
		end
		return consumers.inventory(pos, listname, stack, 1)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "dst" then
			return 0
		elseif to_list == "src" then
			return stack:get_count()
		end
		return consumers.inventory(pos, to_list, stack, 1)
	end,
})

minetest.register_abm({
	nodenames = {"itest:macerator","itest:macerator_active"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		
		local speed = 1
		
		if meta:get_string("stime") == "" then
			meta:set_float("stime", 0.0)
		end
		
		local state = false
		
		for i = 1,20 do
			local srclist = inv:get_list("src")
			local ground = nil
			local afterground
		
			if srclist then
				ground, afterground = macerator.get_craft_result({method = "grinding",
					width = 1, items = srclist})
			end
			
			if ground.item:is_empty() then
				state = false
				break
			end
		
			local energy = meta:get_int("energy")
			if energy >= 2 then
				if ground and ground.item then
					state = true
					meta:set_int("energy",energy-2)
					meta:set_float("stime", meta:get_float("stime") + 1)
					if meta:get_float("stime")>=20*speed*ground.time then
						meta:set_float("stime",0)
						if inv:room_for_item("dst",ground.item) then
							inv:add_item("dst", ground.item)
							inv:set_stack("src", 1, afterground.items[1])
						else
							meta:set_int("energy",energy) -- Don't waste energy
							meta:set_float("stime",20*speed*ground.time)
							state = false
						end
					end
				else
					state = false
				end
			end
			consumers.discharge(pos)
		end
		local srclist = inv:get_list("src")
		local ground = nil
		local afterground
	
		if srclist then
			ground, afterground = macerator.get_craft_result({method = "grinding",
				width = 1, items = srclist})
		end
		local progress = meta:get_float("stime")
		local maxprogress = 1
		if ground and ground.time then
			maxprogress = 20*speed*ground.time
		end
		if inv:is_empty("src") then state = false end
		if state then
			hacky_swap_node(pos,"itest:macerator_active")
		else
			hacky_swap_node(pos,"itest:macerator")
		end
		meta:set_string("formspec", consumers.get_formspec(pos)..
				"list[current_name;src;2,1;1,1;]"..
				"list[current_name;dst;5,1;2,2;]"..
				consumers.get_progressbar(progress,maxprogress,
					"itest_macerator_progress_bg.png",
					"itest_macerator_progress_fg.png"))
	end,
})
