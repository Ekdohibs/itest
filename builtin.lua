function minetest.node_dig(pos, node, digger)
	minetest.debug("node_dig")

	local def = ItemStack({name=node.name}):get_definition()
	-- Check if def ~= 0 because we always want to be able to remove unknown nodes
	if #def ~= 0 and not def.diggable or (def.can_dig and not def.can_dig(pos,digger)) then
		minetest.debug("not diggable")
		minetest.log("info", digger:get_player_name() .. " tried to dig "
			.. node.name .. " which is not diggable "
			.. minetest.pos_to_string(pos))
		return
	end

	minetest.log('action', digger:get_player_name() .. " digs "
		.. node.name .. " at " .. minetest.pos_to_string(pos))

	local wielded = digger:get_wielded_item()
	local drops = minetest.get_node_drops(node.name, wielded:get_name())

	local wdef = wielded:get_definition()
	local tp = wielded:get_tool_capabilities()
	local dp = minetest.get_dig_params(def.groups, tp)
	if wdef and wdef.after_use then
		wielded = wdef.after_use(wielded, digger, node) or wielded
	else
		-- Wear out tool
		wielded:add_wear(dp.wear)
	end
	digger:set_wielded_item(wielded)
	
	-- Handle drops
	minetest.handle_node_drops(pos, drops, digger)

	local oldmetadata = nil
	if def.after_dig_node then
		oldmetadata = minetest.env:get_meta(pos):to_table()
	end

	-- Remove node and update
	minetest.env:remove_node(pos)
	
	-- Run callback
	if def.after_dig_node then
		-- Copy pos and node because callback can modify them
		local pos_copy = {x=pos.x, y=pos.y, z=pos.z}
		local node_copy = {name=node.name, param1=node.param1, param2=node.param2}
		def.after_dig_node(pos_copy, node_copy, oldmetadata, digger)
	end

	-- Run script hook
	local _, callback
	for _, callback in ipairs(minetest.registered_on_dignodes) do
		-- Copy pos and node because callback can modify them
		local pos_copy = {x=pos.x, y=pos.y, z=pos.z}
		local node_copy = {name=node.name, param1=node.param1, param2=node.param2}
		callback(pos_copy, node_copy, digger)
	end
end
