compressor_recipes = {}
compressor = {}

function compressor.register_compressor_recipe(string1,string2)
	compressor_recipes[string1]=string2
end
function compressor.get_craft_result(c)
	local input = c.items[1]
	local output = compressor_recipes[input:get_name()]
	input:take_item()
	return {item = ItemStack(output), time = 20},{items = {input}}
end

minetest.register_node("itest:compressor", {
	description = "compressor",
	tiles = {"itest_compressor_side.png", "itest_compressor_side.png", "itest_compressor_side.png",
		"itest_compressor_side.png", "itest_compressor_side.png", "itest_compressor_front.png"},
	paramtype2 = "facedir",
	groups = {energy=1, energy_consumer=1, cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
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
					"itest_compressor_progress_bg.png",
					"itest_compressor_progress_fg.png"))
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

minetest.register_node("itest:compressor_active", {
	description = "compressor",
	tiles = {"itest_compressor_side.png", "itest_compressor_side.png", "itest_compressor_side.png",
		"itest_compressor_side.png", "itest_compressor_side.png", "itest_compressor_front_active.png"},
	paramtype2 = "facedir",
	drop = "itest:compressor",
	groups = {energy=1, energy_consumer=1, cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
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
	nodenames = {"itest:compressor","itest:compressor_active"},
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
			local compressed = nil
			local aftercompressed
		
			if srclist then
				compressed, aftercompressed = compressor.get_craft_result({method = "compressing",
					width = 1, items = srclist})
			end
			
			if compressed.item:is_empty() then
				state = false
				break
			end
		
			local energy = meta:get_int("energy")
			if energy >= 2 then
				if compressed and compressed.item then
					state = true
					meta:set_int("energy",energy-2)
					meta:set_float("stime", meta:get_float("stime") + 1)
					if meta:get_float("stime")>=20*speed*compressed.time then
						meta:set_float("stime",0)
						if inv:room_for_item("dst",compressed.item) then
							inv:add_item("dst", compressed.item)
							inv:set_stack("src", 1, aftercompressed.items[1])
						else
							meta:set_int("energy",energy) -- Don't waste energy
							meta:set_float("stime",20*speed*compressed.time)
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
		local compressed = nil
		local aftercompressed
	
		if srclist then
			compressed, aftercompressed = compressor.get_craft_result({method = "compressing",
				width = 1, items = srclist})
		end
		local progress = meta:get_float("stime")
		local maxprogress = 1
		if compressed and compressed.time then
			maxprogress = 20*speed*compressed.time
		end
		if inv:is_empty("src") then state = false end
		if state then
			hacky_swap_node(pos,"itest:compressor_active")
		else
			hacky_swap_node(pos,"itest:compressor")
		end
		meta:set_string("formspec", consumers.get_formspec(pos)..
				"list[current_name;src;2,1;1,1;]"..
				"list[current_name;dst;5,1;2,2;]"..
				consumers.get_progressbar(progress,maxprogress,
					"itest_compressor_progress_bg.png",
					"itest_compressor_progress_fg.png"))
	end,
})
