consumers={}

function consumers.discharge(pos)
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

function consumers.get_progressbar(v,mv,bg,fg)
	local percent = v/mv*100
	local bar="image[3,2;2,1;"..bg.."^[lowpart:"..
			percent..":"..fg.."^[transformR270]"
	return bar
end

function consumers.on_construct(pos)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("discharge", 1)
end

function consumers.can_dig(pos,player)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	return inv:is_empty("discharge")
end

function consumers.inventory(pos, listname, stack, tier)
	if listname=="discharge" then
		local chr = get_item_field(stack:get_name(),"charge_tier")
		if chr > 0 and chr <= tier then
			return stack:get_count()
		end
		return 0
	end
end

function consumers.get_formspec(pos)
	formspec = "size[8,9]"..
	"list[current_name;discharge;2,3;1,1;]"..
	"list[current_player;main;0,5;8,4;]"
	local meta = minetest.env:get_meta(pos)
	local node = minetest.env:get_node(pos)
	local percent = meta:get_int("energy")/get_node_field(node.name,meta,"max_energy")*100
	local chrbar="image[2,2;1,1;itest_charge_bg.png^[lowpart:"..
			percent..":itest_charge_fg.png]"
	return formspec..chrbar
end

dofile(modpath.."/electric_furnace.lua")
dofile(modpath.."/macerator.lua")
dofile(modpath.."/extractor.lua")
dofile(modpath.."/compressor.lua")
dofile(modpath.."/recycler.lua")
