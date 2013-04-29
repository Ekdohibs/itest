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
	if minetest.registered_items[stack.name] and minetest.registered_items[stack.name].itest then
		local it = minetest.registered_items[stack.name].itest
		if charge > 0 and it.chargedname then
			stack.name = it.chargedname
		end
		if charge == 0 and it.dischargedname then
			stack.name = it.dischargedname
		end
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
		dischargedname = "itest:mining_drill_discharged"},
	tool_capabilities =
		{max_drop_level=0,
		-- Uses are specified, but not used since there is a after_use function
		groupcaps={cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=22, maxlevel=2}}},
	after_use = function (itemstack, user, pointed_thing)
		local stack = itemstack:to_table()
		local chr = charge.get_charge(stack)
		local max_charge = minetest.registered_items[stack.name].itest.max_charge
		nchr = math.max(0,chr-50)
		charge.set_charge(stack,nchr)
		charge.set_wear(stack,nchr,max_charge)
		return ItemStack(stack)
	end
})

minetest.register_tool("itest:mining_drill_discharged",{
	description = "Mining drill",
	inventory_image = "itest_mining_drill.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 1,
		chargedname = "itest:mining_drill"},
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
		dischargedname = "itest:diamond_drill_discharged"},
	tool_capabilities =
		{max_drop_level=0,
		-- Uses are specified, but not used since there is a after_use function
		groupcaps={cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=4, maxlevel=3}}},
	after_use = function (itemstack, user, pointed_thing)
		local stack = itemstack:to_table()
		local chr = charge.get_charge(stack)
		local max_charge = minetest.registered_items[stack.name].itest.max_charge
		nchr = math.max(0,chr-84)
		charge.set_charge(stack,nchr)
		charge.set_wear(stack,nchr,max_charge)
		return ItemStack(stack)
	end
})

minetest.register_tool("itest:diamond_drill_discharged",{
	description = "Diamond drill",
	inventory_image = "itest_diamond_drill.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 1,
		chargedname = "itest:diamond_drill"},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={}},
})

minetest.register_tool("itest:od_scanner",{
	description = "OD Scanner -- Warning: Does not work yet",
	inventory_image = "itest_od_scanner.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 1},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={}}
})

minetest.register_tool("itest:ov_scanner",{
	description = "OV Scanner -- Warning: Does not work yet",
	inventory_image = "itest_ov_scanner.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 2},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={}}
})

-- Add power to mesecons
mcon = clone_node("mesecons:wire_00000000_off")
mcon.itest = {single_use = 1, singleuse_energy = 500}
minetest.register_node(":mesecons:wire_00000000_off",mcon)
