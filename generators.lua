generators={}

function generators.charge(pos,energy)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	local chr = inv:get_stack("charge",1)
	chr = chr:to_table()
	if chr == nil then return energy end
	if chr.count ~= 1 then return energy end -- Don't charge stacks
	local name = chr.name
	local max_charge = get_item_field(name, "max_charge")
	local max_speed = get_item_field(name, "max_speed")
	local c = charge.get_charge(chr)
	local u = math.min(max_charge-c,energy)
	charge.set_charge(chr,c+u)
	charge.set_wear(chr,c+u,max_charge)
	inv:set_stack("charge",1,ItemStack(chr))
	return energy-u
end

function generators.send(pos,energy)
	local sent = send_packet_alldirs(pos,energy)
	if sent==0 then
		local meta = minetest.env:get_meta(pos)
		local node = minetest.env:get_node(pos)
		local e = meta:get_int("energy")
		local m = get_node_field(node.name,meta,"max_energy")
		meta:set_int("energy",math.min(m,e+energy))
	end
end

function generators.produce(pos,energy)
	if energy <= 0 then return end
	local rem = generators.charge(pos,energy)
	if rem > 0 then
		generators.send(pos,energy)
	end
end

function generators.on_construct(pos)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("charge", 1)
end

function generators.can_dig(pos,player)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	return inv:is_empty("charge")
end

function generators.inventory(pos, listname, stack)
	if listname=="charge" then
		local chr = get_item_field(stack:get_name(),"charge_tier")
		if chr == 1 then
			return stack:get_count()
		end
		return 0
	end
end

function generators.get_formspec(pos)
	formspec = "size[8,9]"..
	"list[current_name;charge;2,1;1,1;]"..
	"list[current_player;main;0,5;8,4;]"
	local meta = minetest.env:get_meta(pos)
	local node = minetest.env:get_node(pos)
	local percent = meta:get_int("energy")/get_node_field(node.name,meta,"max_energy")*100
	local chrbar="image[3,2;2,1;itest_charge_bg.png^[lowpart:"..
			percent..":itest_charge_fg.png^[transformR270]"
	return formspec..chrbar
end

dofile(modpath.."/generator.lua")
dofile(modpath.."/solarpanel.lua")
dofile(modpath.."/windmill.lua")
dofile(modpath.."/watermill.lua")
