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
	return get_item_field(stack:get_name(),"single_use")
end

minetest.register_tool("itest:re_battery",{
	description = "RE Battery",
	inventory_image = "technic_battery.png",
	itest = {max_charge = 10000,
		max_speed = 100,
		charge_tier = 1},
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={fleshy={times={}, uses=1, maxlevel=0}}}
}) 

mcon = clone_node("mesecons:wire_00000000_off")
mcon.itest = {single_use = 1, singleuse_energy = 500}
minetest.register_node(":mesecons:wire_00000000_off",mcon)
