minetest.register_craftitem( "itest:refined_iron_ingot", {
	description = "Refined iron ingot",
	inventory_image = "itest_refined_iron_ingot.png",
})

minetest.register_craftitem( "itest:iron_dust", {
	description = "Iron dust",
	inventory_image = "itest_iron_dust.png",
})

minetest.register_craftitem( "itest:coal_dust", {
	description = "Coal dust",
	inventory_image = "itest_coal_dust.png",
})

minetest.register_craftitem( "itest:gold_dust", {
	description = "Gold dust",
	inventory_image = "itest_gold_dust.png",
})

minetest.register_craftitem( "itest:bronze_dust", {
	description = "Bronze dust",
	inventory_image = "itest_bronze_dust.png",
})

minetest.register_craftitem( "itest:tin_dust", {
	description = "Tin dust",
	inventory_image = "itest_tin_dust.png",
})

minetest.register_craftitem( "itest:copper_dust", {
	description = "Copper dust",
	inventory_image = "itest_copper_dust.png",
})

minetest.register_node("itest:machine",{description="Machine",
	groups={cracky=2},
	tiles={"itest_machine.png"},
})

minetest.register_craftitem( "itest:rubber", {
	description = "Rubber",
	inventory_image = "itest_rubber.png",
})

minetest.register_craftitem( "itest:circuit", {
	description = "Electronic circuit",
	inventory_image = "itest_circuit.png",
})

minetest.register_craftitem( "itest:scrap", {
	description = "Scrap",
	inventory_image = "itest_scrap.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:bronze_dust 2",
	recipe = {"itest:copper_dust","itest:copper_dust",
		"itest:copper_dust","itest:tin_dust"}
})

minetest.register_craft({
	output = "itest:treetap",
	recipe = {{"","default:wood",""},
		{"default:wood","default:wood","default:wood"},
		{"","","default:wood"}}
})

minetest.register_craft({
	output = "default:wood 3",
	recipe = {{"itest:rubber_tree"}}
})

minetest.register_craft({
	output = "itest:copper_cable0_000000 6",
	recipe = {{"default:copper_ingot","default:copper_ingot","default:copper_ingot"}}
})

minetest.register_craft({
	output = "itest:copper_cable1_000000 6",
	recipe = {{"itest:rubber","itest:rubber","itest:rubber"},
		{"default:copper_ingot","default:copper_ingot","default:copper_ingot"},
		{"itest:rubber","itest:rubber","itest:rubber"}}
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:copper_cable1_000000",
	recipe = {"itest:copper_cable0_000000","itest:rubber"}
})

minetest.register_craft({
	output = "itest:gold_cable0_000000 12",
	recipe = {{"default:gold_ingot","default:gold_ingot","default:gold_ingot"}}
})

minetest.register_craft({
	output = "itest:gold_cable1_000000 4",
	recipe = {{"","itest:rubber",""},
		{"itest:rubber","default:gold_ingot","itest:rubber"},
		{"","itest:rubber",""}}
})

minetest.register_craft({
	output = "itest:gold_cable2_000000 4",
	recipe = {{"itest:rubber","itest:rubber","itest:rubber"},
		{"itest:rubber","default:gold_ingot","itest:rubber"},
		{"itest:rubber","itest:rubber","itest:rubber"}}
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:gold_cable1_000000",
	recipe = {"itest:gold_cable0_000000","itest:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:gold_cable2_000000",
	recipe = {"itest:gold_cable1_000000","itest:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:gold_cable2_000000",
	recipe = {"itest:gold_cable0_000000","itest:rubber","itest:rubber"}
})

minetest.register_craft({
	output = "itest:tin_cable0_000000 9",
	recipe = {{"itest:tin_ingot","itest:tin_ingot","itest:tin_ingot"}}
})

minetest.register_craft({
	output = "itest:hv_cable0_000000 12",
	recipe = {{"itest:refined_iron_ingot","itest:refined_iron_ingot","itest:refined_iron_ingot"}}
})

minetest.register_craft({
	output = "itest:hv_cable1_000000 4",
	recipe = {{"","itest:rubber",""},
		{"itest:rubber","itest:refined_iron_ingot","itest:rubber"},
		{"","itest:rubber",""}}
})

minetest.register_craft({
	output = "itest:hv_cable2_000000 4",
	recipe = {{"itest:rubber","itest:rubber","itest:rubber"},
		{"itest:rubber","itest:refined_iron_ingot","itest:rubber"},
		{"itest:rubber","itest:rubber","itest:rubber"}}
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:hv_cable1_000000",
	recipe = {"itest:hv_cable0_000000","itest:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:hv_cable2_000000",
	recipe = {"itest:hv_cable1_000000","itest:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:hv_cable3_000000",
	recipe = {"itest:hv_cable2_000000","itest:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:hv_cable2_000000",
	recipe = {"itest:hv_cable0_000000","itest:rubber","itest:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:hv_cable3_000000",
	recipe = {"itest:hv_cable1_000000","itest:rubber","itest:rubber"}
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:hv_cable3_000000",
	recipe = {"itest:hv_cable0_000000","itest:rubber","itest:rubber","itest:rubber"}
})

minetest.register_craft({
	output = "itest:re_battery",
	recipe = {{"","itest:copper_cable1_000000",""},
		{"itest:tin_ingot","mesecons:mesecon","itest:tin_ingot"},
		{"itest:tin_ingot","mesecons:mesecon","itest:tin_ingot"}}
})

minetest.register_craft({
	output = "itest:batbox",
	recipe = {{"default:wood","itest:copper_cable1_000000","default:wood"},
		{"itest:re_battery","itest:re_battery","itest:re_battery"},
		{"default:wood","default:wood","default:wood"}}
})

minetest.register_craft({
	output = "itest:iron_furnace",
	recipe = {{"default:steel_ingot","default:steel_ingot","default:steel_ingot"},
		{"default:steel_ingot","","default:steel_ingot"},
		{"default:steel_ingot","default:steel_ingot","default:steel_ingot"}}
})

minetest.register_craft({
	output = "itest:iron_furnace",
	recipe = {{"","default:steel_ingot",""},
		{"default:steel_ingot","","default:steel_ingot"},
		{"default:steel_ingot","default:furnace","default:steel_ingot"}}
})

minetest.register_craft({
	output = "itest:machine",
	recipe = {{"itest:refined_iron_ingot","itest:refined_iron_ingot","itest:refined_iron_ingot"},
		{"itest:refined_iron_ingot","","itest:refined_iron_ingot"},
		{"itest:refined_iron_ingot","itest:refined_iron_ingot","itest:refined_iron_ingot"}}
})

minetest.register_craft({
	output = "itest:generator",
	recipe = {{"","itest:re_battery",""},
		{"itest:refined_iron_ingot","itest:refined_iron_ingot","itest:refined_iron_ingot"},
		{"","itest:iron_furnace",""}}
})

minetest.register_craft({
	output = "itest:generator",
	recipe = {{"itest:re_battery"},
		{"itest:machine"},
		{"default:furnace"}}
})

minetest.register_craft({
	output = "itest:circuit",
	recipe = {{"itest:copper_cable0_00000","itest:copper_cable0_00000","itest:copper_cable0_00000"},
		{"mesecons:mesecon","itest:refined_iron_ingot","mesecons:mesecon"},
		{"itest:copper_cable0_00000","itest:copper_cable0_00000","itest:copper_cable0_00000"}}
})

minetest.register_craft({
	output = "itest:circuit",
	recipe = {{"itest:copper_cable0_00000","mesecons:mesecon","itest:copper_cable0_00000"},
		{"itest:copper_cable0_000000","itest:refined_iron_ingot","itest:copper_cable0_000000"},
		{"itest:copper_cable0_00000","mesecons:mesecon","itest:copper_cable0_00000"}}
})

minetest.register_craft({
	output = "itest:electric_furnace",
	recipe = {{"","itest:circuit",""},
		{"mesecons:mesecon","itest:iron_furnace","mesecons:mesecon"}}
})

minetest.register_craft({
	output = "itest:extractor",
	recipe = {{"itest:treetap","itest:machine","itest:treetap"},
		{"itest:treetap","itest:circuit","itest:treetap"}}
})

minetest.register_craft({
	output = "itest:macerator",
	recipe = {{"default:obsidian_shard","default:obsidian_shard","default:obsidian_shard"},
		{"default:cobble","itest:machine","default:cobble"},
		{"","itest:circuit",""}}
})

minetest.register_craft({
	output = "itest:solar_panel",
	recipe = {{"itest:coal_dust","default:glass","itest:coal_dust"},
		{"default:glass","itest:coal_dust","default:glass"},
		{"itest:circuit","itest:generator","itest:circuit"}}
})

minetest.register_craft({
	output = "itest:refined_iron_ingot 8",
	recipe = {{"itest:machine"}}
})

minetest.register_craft({
	type = "cooking",
	output = "itest:rubber",
	recipe = "itest:sticky_resin"
})

minetest.register_craft({
	type = "cooking",
	output = "itest:refined_iron_ingot",
	recipe = "default:steel_ingot"
})

minetest.register_craft({
	type = "cooking",
	output = "default:steel_ingot",
	recipe = "itest:iron_dust"
})

minetest.register_craft({
	type = "cooking",
	output = "default:copper_ingot",
	recipe = "itest:copper_dust"
})

minetest.register_craft({
	type = "cooking",
	output = "default:bronze_ingot",
	recipe = "itest:bronze_dust"
})

minetest.register_craft({
	type = "cooking",
	output = "itest:tin_ingot",
	recipe = "itest:tin_dust"
})

minetest.register_craft({
	type = "cooking",
	output = "default:gold_ingot",
	recipe = "itest:gold_dust"
})

macerator.register_macerator_recipe("default:iron_lump","itest:iron_dust 2")
macerator.register_macerator_recipe("default:gold_lump","itest:gold_dust 2")
macerator.register_macerator_recipe("default:coal_lump","itest:coal_dust")
macerator.register_macerator_recipe("default:copper_lump","itest:copper_dust 2")
macerator.register_macerator_recipe("itest:tin_lump","itest:tin_dust 2")
macerator.register_macerator_recipe("itest:tin_ingot","itest:tin_dust")
macerator.register_macerator_recipe("default:steel_ingot","itest:iron_dust")
macerator.register_macerator_recipe("itest:refined_iron_ingot","itest:iron_dust")
macerator.register_macerator_recipe("default:gold_ingot","itest:gold_dust")
macerator.register_macerator_recipe("default:copper_ingot","itest:copper_dust")
macerator.register_macerator_recipe("default:bronze_ingot","itest:bronze_dust")

macerator.register_macerator_recipe("moreores:bronze_ingot","itest:bronze_dust")
macerator.register_macerator_recipe("moreores:copper_ingot","itest:copper_dust")
macerator.register_macerator_recipe("moreores:tin_ingot","itest:tin_dust")
macerator.register_macerator_recipe("moreores:tin_lump","itest:tin_dust 2")
macerator.register_macerator_recipe("moreores:copper_lump","itest:copper_dust 2")

extractor.register_extractor_recipe("itest:sticky_resin","itest:rubber 3")
extractor.register_extractor_recipe("itest:rubber_tree","itest:rubber")
extractor.register_extractor_recipe("itest:rubber_sapling","itest:rubber")
extractor.register_extractor_recipe("default:mese_crystal","mesecons:mesecon 32")
