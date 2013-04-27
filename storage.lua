storage = {}

function storage.charge(pos)
	local meta = minetest.env:get_meta(pos)
	local energy = meta:get_int("energy")
	local inv = meta:get_inventory()
	local chr = inv:get_stack("charge",1)
	if chr:is_empty() then return end
	chr = chr:to_table()
	if chr == nil then return end
	if chr.count ~= 1 then return end -- Don't charge stacks
	local name = chr.name
	local max_charge = get_item_field(name, "max_charge")
	local max_speed = get_item_field(name, "max_speed")
	local c = charge.get_charge(chr)
	local u = math.min(max_charge-c,energy,max_speed)
	charge.set_charge(chr,c+u)
	charge.set_wear(chr,c+u,max_charge)
	inv:set_stack("charge",1,ItemStack(chr))
	meta:set_int("energy",energy-u)
end

function storage.discharge(pos)
	local meta = minetest.env:get_meta(pos)
	local node = minetest.env:get_node(pos)
	local energy = meta:get_int("energy")
	local max_energy = get_node_field(node.name,meta,"max_energy")
	local m = max_energy-energy
	local inv = meta:get_inventory()
	local discharge = inv:get_stack("discharge",1)
	if charge.single_use(discharge) then
		prod = get_item_field(discharge:get_name(), "singleuse_energy")
		if max_energy-energy>= prod then
			discharge:take_item()
			inv:set_stack("discharge",1,discharge)
			meta:set_int("energy",energy+prod)
		end
	end
	discharge = discharge:to_table()
	if discharge == nil then return end
	if discharge.count ~= 1 then return end -- Don't discharge stacks
	local name = discharge.name
	local max_speed = get_item_field(name, "max_speed")
	local max_charge = get_item_field(name, "max_charge")
	local c = charge.get_charge(discharge)
	local u = math.min(c,max_speed,m)
	charge.set_charge(discharge,c-u)
	charge.set_wear(discharge,c-u,max_charge)
	inv:set_stack("discharge",1,ItemStack(discharge))
	meta:set_int("energy",energy+u)
end

function storage.send(pos,energy,dir)
	local meta = minetest.env:get_meta(pos)
	local e = meta:get_int("energy")
	energy = math.min(e,energy)
	local sent = send_packet(pos,dir,energy)
	if sent~=nil then
		local meta = minetest.env:get_meta(pos)
		local e = meta:get_int("energy")
		meta:set_int("energy",e-energy)
	end
end

function storage.on_construct(pos)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("charge", 1)
	inv:set_size("discharge", 1)
end

function storage.can_dig(pos,player)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	return inv:is_empty("charge") and inv:is_empty("discharge")
end

function storage.inventory(pos, listname, stack, maxtier)
	if listname=="charge" or listname=="discharge" then
		local chr = get_item_field(stack:get_name(),"charge_tier")
		if chr>0 and chr<=maxtier then
			return stack:get_count()
		end
		return 0
	end
	return 0
end

function storage.get_formspec(pos)
	formspec = "size[8,9]"..
	"list[current_name;charge;2,1;1,1;]"..
	"list[current_name;discharge;2,3;1,1;]"..
	"list[current_player;main;0,5;8,4;]"
	local meta = minetest.env:get_meta(pos)
	local node = minetest.env:get_node(pos)
	local percent = meta:get_int("energy")/get_node_field(node.name,meta,"max_energy")*100
	local chrbar="image[3,2;2,1;itest_charge_bg.png^[lowpart:"..
			percent..":itest_charge_fg.png^[transformR270]"
	return formspec..chrbar
end

minetest.register_node("itest:batbox",{description="BatBox",
	groups={energy=1, cracky=2, energy_consumer=1},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	tiles={"itest_batbox_side.png", "itest_batbox_side.png", "itest_batbox_output.png", "itest_batbox_side.png", "itest_batbox_side.png", "itest_batbox_side.png"},
	itest = {max_energy = 40000,
		max_psize = 32},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_string("formspec", storage.get_formspec(pos))
		storage.on_construct(pos)
	end,
	can_dig = storage.can_dig,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return storage.inventory(pos, listname, stack, 1)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		return storage.inventory(pos, to_list, stack, 1)
	end,
})

minetest.register_abm({
	nodenames={"itest:batbox"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local senddir = param22dir(node.param2)
		for i=1,20 do
			storage.charge(pos)
			storage.send(pos,32,senddir)
			storage.discharge(pos)
		end
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",storage.get_formspec(pos))
	end
})

minetest.register_node("itest:mfe_unit",{description="MFE Unit",
	groups={energy=1, cracky=2, energy_consumer=1},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	tiles={"itest_mfe_side.png", "itest_mfe_side.png", "itest_mfe_side.png", "itest_mfe_output.png", "itest_mfe_side.png", "itest_mfe_side.png"},
	itest = {max_energy = 600000,
		max_psize = 128},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_string("formspec", storage.get_formspec(pos))
		storage.on_construct(pos)
	end,
	can_dig = storage.can_dig,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return storage.inventory(pos, listname, stack, 2)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		return storage.inventory(pos, to_list, stack, 2)
	end,
})

minetest.register_abm({
	nodenames={"itest:mfe_unit"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local senddir = param22dir(node.param2)
		for i=1,20 do
			storage.charge(pos)
			storage.send(pos,128,senddir)
			storage.discharge(pos)
		end
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",storage.get_formspec(pos))
	end
})

minetest.register_node("itest:mfs_unit",{description="MFS Unit",
	groups={energy=1, cracky=2, energy_consumer=1},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	tiles={"itest_mfsu_side.png", "itest_mfsu_side.png", "itest_mfsu_output.png", "itest_mfsu_side.png", "itest_mfsu_side.png", "itest_mfsu_side.png"},
	itest = {max_energy = 10000000,
		max_psize = 512},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_string("formspec", storage.get_formspec(pos))
		storage.on_construct(pos)
	end,
	can_dig = storage.can_dig,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return storage.inventory(pos, listname, stack, 3)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		return storage.inventory(pos, to_list, stack, 3)
	end,
})

minetest.register_abm({
	nodenames={"itest:mfs_unit"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local senddir = param22dir(node.param2)
		for i=1,20 do
			storage.charge(pos)
			storage.send(pos,512,senddir)
			storage.discharge(pos)
		end
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",storage.get_formspec(pos))
	end
})

dofile(modpath.."/transformers.lua")
