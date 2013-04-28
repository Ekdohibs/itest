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
		charge_tier = 1},
	tool_capabilities =
		{max_drop_level=0,
		--groupcaps={cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=22, maxlevel=2}}}
		groupcaps={fleshy={times={}, uses=1, maxlevel=0}}}
})

minetest.register_tool("itest:diamond_drill",{
	description = "Diamond drill",
	inventory_image = "itest_diamond_drill.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 1},
	tool_capabilities =
		{max_drop_level=0,
		--groupcaps={cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=4, maxlevel=3}}}
		groupcaps={fleshy={times={}, uses=1, maxlevel=0}}}
})

minetest.register_tool("itest:od_scanner",{
	description = "OD Scanner",
	inventory_image = "itest_od_scanner.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 1},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={fleshy={times={}, uses=1, maxlevel=0}}}
})

minetest.register_tool("itest:ov_scanner",{
	description = "OV Scanner",
	inventory_image = "itest_ov_scanner.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 2},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={fleshy={times={}, uses=1, maxlevel=0}}}
})




mcon = clone_node("mesecons:wire_00000000_off")
mcon.itest = {single_use = 1, singleuse_energy = 500}
minetest.register_node(":mesecons:wire_00000000_off",mcon)
