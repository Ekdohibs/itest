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

function consumers.on_construct(pos, upgrades)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("discharge", 1)
	if upgrades ~= nil then
		inv:set_size("upgrades", 4)
	end
end

local maxcurrents = {32, 128, 512, 1000000000}

function consumers.update_upgrades(pos, mchr, tier)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	local speed = 1
	local cmp = 1
	for i = 1,3 do
		local stack = inv:get_stack("upgrades", i)
		local n = stack:get_count()
		local name = stack:get_name()
		if name == "itest:overclocker_upgrade" then
			speed = speed * math.pow(0.7, n)
			cmp = cmp * math.pow(1.6, n)
		elseif name == "itest:transformer_upgrade" then
			tier = tier + n
		elseif name == "itest:storage_upgrade" then
			mchr = mchr + n*10000
		end
	end
	meta:set_float("speed", speed)
	meta:set_float("consumption", cmp)
	meta:set_int("max_psize", maxcurrents[tier])
	meta:set_int("max_energy", mchr)
end

function consumers.can_dig(pos,player, upgrades)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	if upgrades~=nil and not inv:is_empty("upgrades") then return false end
	return inv:is_empty("discharge")
end

function consumers.inventory(pos, listname, stack, tier)
	if listname=="discharge" then
		local chr = get_item_field(stack:get_name(),"charge_tier")
		if chr > 0 and chr <= tier then
			return stack:get_count()
		end
		return 0
	elseif listname=="upgrades" then
		local name = stack:get_name()
		if name == "itest:overclocker_upgrade" or name == "itest:storage_upgrade" or name == "itest:transformer_upgrade" then
			return stack:get_count()
		end
		return 0
	end
end

function consumers.get_formspec(pos, upgrades)
	formspec = "size[8,9]"..
	"list[current_name;discharge;2,3;1,1;]"..
	"list[current_player;main;0,5;8,4;]"
	if upgrades ~= nil then
		formspec = formspec.."list[current_name;upgrades;7,0;1,3;]"
	end
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

dofile(modpath.."/miner.lua")
