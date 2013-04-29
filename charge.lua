charge = {}

function charge.set_wear(stack,charge,max_charge)
	local n = 65536 - math.floor(charge/max_charge*65535)
	stack.wear = n
end

function charge.get_charge(stack)
	if tonumber(stack.metadata) == nil then return 0 end
	return tonumber(stack.metadata)
end

function charge.set_charge(stack,charge)
	stack.metadata = tostring(charge)
	if minetest.registered_items[stack.name] and minetest.registered_items[stack.name].itest and minetest.registered_items[stack.name].itest.cnames then
		local cn = minetest.registered_items[stack.name].itest.cnames
		local m = -1
		local n = stack.name
		for _,i in ipairs(cn) do
			if i[1] <= charge and i[1] > m then
				m = i[1]
				n = i[2]
			end
		end
		stack.name = n
	end
end

function charge.single_use(stack)
	return get_item_field(stack:get_name(),"single_use")>0
end

minetest.register_tool("itest:re_battery",{
	description = "RE Battery",
	inventory_image = "itest_re_battery.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 1},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={fleshy={times={}, uses=1, maxlevel=0}}}
})

minetest.register_tool("itest:energy_crystal",{
	description = "Energy crystal",
	inventory_image = "itest_energy_crystal.png",
	itest = {max_charge = 100000,
		max_speed = 250,
		charge_tier = 2},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={fleshy={times={}, uses=1, maxlevel=0}}}
}) 

minetest.register_tool("itest:lapotron_crystal",{
	description = "Lapotron crystal",
	inventory_image = "itest_lapotron_crystal.png",
	itest = {max_charge = 1000000,
		max_speed = 600,
		charge_tier = 3},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={fleshy={times={}, uses=1, maxlevel=0}}}
}) 

minetest.register_craftitem("itest:single_use_battery",{
	description = "Single use battery",
	inventory_image = "itest_single_use_battery.png",
	itest = {single_use = 1,
		singleuse_energy = 1000}
})

minetest.register_tool("itest:mining_drill",{
	description = "Mining drill",
	inventory_image = "itest_mining_drill.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 1,
		cnames = {{0,"itest:mining_drill_discharged"},
			{50,"itest:mining_drill"}}},
	tool_capabilities =
		{max_drop_level=0,
		-- Uses are specified, but not used since there is a after_use function
		groupcaps={cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=22, maxlevel=2}}},
	after_use = function (itemstack, user, pointed_thing)
		local stack = itemstack:to_table()
		local chr = charge.get_charge(stack)
		local max_charge = get_item_field(stack.name, "max_charge")
		nchr = math.max(0,chr-50)
		charge.set_charge(stack,nchr)
		charge.set_wear(stack,nchr,max_charge)
		return ItemStack(stack)
	end
})

-- Used to prevent digging when discharged
minetest.register_tool("itest:mining_drill_discharged",{
	description = "Mining drill",
	inventory_image = "itest_mining_drill.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 1,
		cnames = {{0,"itest:mining_drill_discharged"},
			{50,"itest:mining_drill"}}},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={}},
})

minetest.register_tool("itest:diamond_drill",{
	description = "Diamond drill",
	inventory_image = "itest_diamond_drill.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 1,
		cnames = {{0,"itest:diamond_drill_discharged"},
			{84,"itest:diamond_drill"}}},
	tool_capabilities =
		{max_drop_level=0,
		-- Uses are specified, but not used since there is a after_use function
		groupcaps={cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=4, maxlevel=3}}},
	after_use = function (itemstack, user, pointed_thing)
		local stack = itemstack:to_table()
		local chr = charge.get_charge(stack)
		local max_charge = get_item_field(stack.name, "max_charge")
		nchr = math.max(0,chr-84)
		charge.set_charge(stack,nchr)
		charge.set_wear(stack,nchr,max_charge)
		return ItemStack(stack)
	end
})

-- Used to prevent digging when discharged
minetest.register_tool("itest:diamond_drill_discharged",{
	description = "Diamond drill",
	inventory_image = "itest_diamond_drill.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 1,
		cnames = {{0,"itest:diamond_drill_discharged"},
			{84,"itest:diamond_drill"}}},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={}},
})

minetest.register_tool("itest:od_scanner",{
	description = "OD Scanner",
	inventory_image = "itest_od_scanner.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 1},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={}},
	on_place = function(itemstack, user, pointed_thing)
		local stack = itemstack:to_table()
		if charge.get_charge(stack) < 48 then return itemstack end -- Not enough energy
		local chr = charge.get_charge(stack)
		local max_charge = get_item_field(stack.name, "max_charge")
		charge.set_charge(stack, chr - 48)
		charge.set_wear(stack, chr - 48, max_charge)
		local pos = user:getpos()
		local y = 0
		local nnodes = 0
		local total_ores = 0
		local shall_break = false
		while true do
			for x = -2, 2 do
			for z = -2, 2 do
				local npos = {x=pos.x+x, y=pos.y+y, z=pos.z+z}
				local nnode = minetest.env:get_node(npos)
				if nnode.name == "ignore" then
					shall_break = true
				else
					nnodes = nnodes + 1 -- Number of nodes scanned
					if itest.registered_ores[nnode.name] then
						total_ores = total_ores + 1
					end
				end
			end
			end
			if shall_break then break end
			y = y - 1 -- Look the next level down
		end
		minetest.chat_send_player(user:get_player_name(), "Ore density: "..math.floor(total_ores / nnodes * 1000), false)
		return Itemtack(stack)
	end
})

minetest.register_tool("itest:ov_scanner",{
	description = "OV Scanner",
	inventory_image = "itest_ov_scanner.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 2},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={}},
	on_place = function(itemstack, user, pointed_thing)
		local stack = itemstack:to_table()
		if charge.get_charge(stack) < 250 then return itemstack end -- Not enough energy
		local chr = charge.get_charge(stack)
		local max_charge = get_item_field(stack.name, "max_charge")
		charge.set_charge(stack, chr - 250)
		charge.set_wear(stack, chr - 250, max_charge)
		local pos = user:getpos()
		local y = 0
		local nnodes = 0
		local total_value = 0
		local shall_break = false
		while true do
			for x = -4, 4 do
			for z = -4, 4 do
				local npos = {x=pos.x+x, y=pos.y+y, z=pos.z+z}
				local nnode = minetest.env:get_node(npos)
				if nnode.name == "ignore" then
					shall_break = true
				else
					nnodes = nnodes + 1 -- Number of nodes scanned
					if itest.registered_ores[nnode.name] then
						total_value = total_value + itest.registered_ores[nnode.name]
					end
				end
			end
			end
			if shall_break then break end
			y = y - 1 -- Look the next level down
		end
		minetest.chat_send_player(user:get_player_name(), "Ore value: "..math.floor(total_value / nnodes * 1000), false)
		return Itemtack(stack)
	end
})

-- Add power to mesecons
mcon = clone_node("mesecons:wire_00000000_off")
mcon.itest = {single_use = 1, singleuse_energy = 500}
minetest.register_node(":mesecons:wire_00000000_off",mcon)
