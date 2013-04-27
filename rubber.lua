rubber_tree_leaves_pos = {{x=0,y=8,z=0},{x=0,y=9,z=0},{x=0,y=10,z=0},
{x=1,y=7,z=0},{x=1,y=7,z=1},{x=1,y=7,z=-1},{x=0,y=7,z=-1},{x=0,y=7,z=1},
{x=-1,y=7,z=-1},{x=-1,y=7,z=0},{x=-1,y=7,z=1}}
for y=2,6 do
	for x=-2,2 do
		for z=-2,2 do
			if ((x~=-2 and x~=2) or (z~=-2 and z~=2)) and (x~=0 or z~=0) then
				table.insert(rubber_tree_leaves_pos,{x=x,y=y,z=z})
			end
		end
	end
end

rubber_tree_trunk_pos = {}
for y=0,7 do
	table.insert(rubber_tree_trunk_pos,{x=0,y=y,z=0})
end

function spawn_rubber_tree(pos)
	for _,tpos in ipairs(rubber_tree_trunk_pos) do
		local npos = addVect(pos,tpos)
		local node = {}
		if math.random(1,5) == 1 then
			local param2 = math.random(0,3)
			node.name = "itest:rubber_tree_full"
			node.param2 = param2
		else
			node.name = "itest:rubber_tree"
		end
		minetest.env:set_node(npos,node)
	end
	for _,lpos in ipairs(rubber_tree_leaves_pos) do
		local npos = addVect(pos,lpos)
		minetest.env:set_node(npos,{name="itest:rubber_leaves"})
	end
end

minetest.register_node("itest:rubber_sapling", {
	description = "Rubber Tree Sapling",
	drawtype = "plantlike",
	tiles = {"technic_rubber_sapling.png"},
	inventory_image = "technic_rubber_sapling.png",
	wield_image = "technic_rubber_sapling.png",
	paramtype = "light",
	walkable = false,
	groups = {dig_immediate=3,flammable=2},
	sounds = default.node_sound_defaults(),
})

minetest.register_node("itest:rubber_tree", {
	description = "Rubber Tree",
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	groups = {tree=1,snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	drop = "itest:rubber_tree",
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("itest:rubber_tree_full", {
	description = "Rubber Tree",
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png", "default_tree.png", "default_tree.png", "default_tree.png^itest_rubber_hole_full.png"},
	groups = {tree=1,snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2,not_in_creative_inventory=1},
	drop = {
		max_items = 2,
		items = {
			{
				items = {'itest:sticky_resin'},
				rarity = 10,
			},
			{
				items = {'itest:rubber_tree'},
			}
		}
	},
	sounds = default.node_sound_wood_defaults(),
})


minetest.register_node("itest:rubber_tree_empty", {
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png", "default_tree.png", "default_tree.png", "default_tree.png^itest_rubber_hole_empty.png"},
	groups = {tree=1,snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2, not_in_creative_inventory=1},
	drop = "itest:rubber_tree",
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_abm({
	nodenames = {"itest:rubber_tree_empty"},
	interval = 60,
	chance = 15,
	action = function(pos, node)
		node.name = "itest:rubber_tree_full"
		minetest.env:set_node(pos, node)
	end
})

minetest.register_node("itest:rubber_leaves", {
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"technic_rubber_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2, not_in_creative_inventory=1},
	drop = {
		max_items = 1,
		items = {
			{
				items = {"itest:rubber_sapling"},
				rarity = 40,
			},
			{
				items = {"itest:rubber_leaves"}
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_abm({
	nodenames = {"itest:rubber_sapling"},
	interval = 60,
	chance = 20,
	action = function(pos, node)
		spawn_rubber_tree(pos)
	end
})

minetest.register_on_generated(function(minp, maxp, blockseed)
	if math.random(1, 100) > 50 then
		return
	end
	local tmp = {x=(maxp.x-minp.x)/2+minp.x, y=(maxp.y-minp.y)/2+minp.y, z=(maxp.z-minp.z)/2+minp.z}
	local pos = minetest.env:find_node_near(tmp, maxp.x-minp.x, {"default:dirt_with_grass"})
	if pos ~= nil then
		spawn_rubber_tree(pos)
	end
end)

minetest.register_craftitem( "itest:sticky_resin", {
	description = "Sticky resin",
	inventory_image = "itest_sticky_resin.png",
})

function damage_treetap(itemstack)
	local wear = itemstack:get_wear()
	if wear >= 64239 then
		itemstack:clear()
		return itemstack
	end
	itemstack:add_wear(1311)
	return itemstack
end

minetest.register_tool("itest:treetap",{
	description = "Treetap",
	inventory_image = "itest_treetap.png",
	tool_capabilities =
		{max_drop_level=0,
		groupcaps={fleshy={times={}, uses=50, maxlevel=0}}},
	on_place = function (itemstack, user, pointed_thing)
		local npos = pointed_thing.under
		local node = minetest.env:get_node(npos)
		if node.name == "itest:rubber_tree_full" then
			node.name = "itest:rubber_tree_empty"
			local drop = math.random(1,3)
			minetest.env:set_node(npos,node)
			local dropstack = ItemStack(
				{name = "itest:sticky_resin", count = drop})
			if node.param2 == nil then node.param2 = 1 end
			local droppos = addVect(addVect(npos,param22dir((node.param2+1)%4)),
				{x=math.random()/2-0.25,y=0,z=math.random()/2-0.25})
			minetest.env:add_item(droppos,dropstack)
			itemstack = damage_treetap(itemstack)
		elseif node.name == "itest:rubber_tree_empty" then
		end
		return minetest.item_place(itemstack,user,pointed_thing)
	end,
})
