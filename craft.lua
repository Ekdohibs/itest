local function reverse_recipe(r)
	return {{r[1][1],r[2][1],r[3][1]},{r[1][2],r[2][2],r[3][2]},{r[1][3],r[2][3],r[3][3]}}
end

local function register_craft2(t)
	minetest.register_craft(t)
	t.recipe = reverse_recipe(t.recipe)
	minetest.register_craft(t)
end

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

minetest.register_node("itest:advanced_machine",{description="Advanced machine",
	groups={cracky=2},
	tiles={"itest_advanced_machine.png"},
})

minetest.register_craftitem( "itest:rubber", {
	description = "Rubber",
	inventory_image = "itest_rubber.png",
})

minetest.register_craftitem( "itest:circuit", {
	description = "Electronic circuit",
	inventory_image = "itest_circuit.png",
})

minetest.register_craftitem( "itest:advanced_circuit", {
	description = "Advanced circuit",
	inventory_image = "itest_advanced_circuit.png",
})

minetest.register_craftitem( "itest:scrap", {
	description = "Scrap",
	inventory_image = "itest_scrap.png",
})

minetest.register_craftitem( "itest:silicon_mesecon", {
	description = "Silicon-doped mesecon",
	inventory_image = "itest_silicon_mesecon.png",
})

minetest.register_node("itest:silicon_mese_block",{description="Silicon-doped mese block",
	groups={cracky=2},
	tiles={"itest_silicon_mese_block.png"},
})

minetest.register_craftitem( "itest:mixed_metal_ingot", {
	description = "Mixed metal ingot",
	inventory_image = "itest_mixed_metal_ingot.png",
})

minetest.register_craftitem( "itest:advanced_alloy", {
	description = "Advanced alloy",
	inventory_image = "itest_advanced_alloy.png",
})

minetest.register_craftitem( "itest:carbon_fibers", {
	description = "Carbon fibers",
	inventory_image = "itest_carbon_fibers.png",
})

minetest.register_craftitem( "itest:combined_carbon_fibers", {
	description = "Combined carbon fibers",
	inventory_image = "itest_combined_carbon_fibers.png",
})

minetest.register_craftitem( "itest:carbon_plate", {
	description = "Carbon plate",
	inventory_image = "itest_carbon_plate.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:silicon_mesecon",
	recipe = {"mesecons:mesecon","mesecons_resources:silicon","itest:copper_dust"}
})

minetest.register_craft({
	output = "itest:silicon_mesecon 9",
	recipe = {{"itest:silicon_mese_block"}}
})

minetest.register_craft({
	output = "itest:silicon_mese_block",
	recipe = 	{{"itest:silicon_mesecon","itest:silicon_mesecon","itest:silicon_mesecon"},
	{"itest:silicon_mesecon","itest:silicon_mesecon","itest:silicon_mesecon"},
	{"itest:silicon_mesecon","itest:silicon_mesecon","itest:silicon_mesecon"}}
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

register_craft2({
	output = "itest:glass_fiber_000000 4",
	recipe = {{"default:glass","default:glass","default:glass"},
		{"mesecons:wire_00000000_off","default:diamond","mesecons:wire_00000000_off"},
		{"default:glass","default:glass","default:glass"}}
})

minetest.register_craft({
	output = "itest:detector_cable_off_000000",
	recipe = {{"","itest:circuit",""},
		{"mesecon:mesecon","itest:hv_cable3_000000","mesecons:wire_00000000_off"},
		{"","mesecons:wire_00000000_off",""}}
})

minetest.register_craft({
	output = "itest:splitter_cable_000000",
	recipe = {{"","mesecons:wire_00000000_off",""},
		{"itest:hv_cable3_000000","mesecons_walllever:wall_lever_off","itest:hv_cable3_000000"},
		{"","mesecons:wire_00000000_off",""}}
})

minetest.register_craft({
	output = "itest:re_battery",
	recipe = {{"","itest:copper_cable1_000000",""},
		{"itest:tin_ingot","mesecons:wire_00000000_off","itest:tin_ingot"},
		{"itest:tin_ingot","mesecons:wire_00000000_off","itest:tin_ingot"}}
})

minetest.register_craft({
	output = "itest:energy_crystal",
	recipe = {{"mesecons:wire_00000000_off","mesecons:wire_00000000_off","mesecons:wire_00000000_off"},
		{"mesecons:wire_00000000_off","default:diamond","mesecons:wire_00000000_off"},
		{"mesecons:wire_00000000_off","mesecons:wire_00000000_off","mesecons:wire_00000000_off"}}
})

minetest.register_craft({
	output = "itest:lapotron_crystal",
	recipe = {{"itest:silicon_mesecon","itest:circuit","itest:silicon_mesecon"},
		{"itest:silicon_mesecon","itest:energy_crystal","itest:silicon_mesecon"},
		{"itest:silicon_mesecon","itest:circuit","itest:silicon_mesecon"}}
})

minetest.register_craft({
	output = "itest:batbox",
	recipe = {{"default:wood","itest:copper_cable1_000000","default:wood"},
		{"itest:re_battery","itest:re_battery","itest:re_battery"},
		{"default:wood","default:wood","default:wood"}}
})

minetest.register_craft({
	output = "itest:mfe_unit",
	recipe = {{"itest:gold_cable2_000000","itest:energy_crystal","itest:gold_cable2_000000"},
		{"itest:energy_crystal","itest:machine","itest:energy_crystal"},
		{"itest:gold_cable2_000000","itest:energy_crystal","itest:gold_cable2_000000"}}
})

minetest.register_craft({
	output = "itest:mfs_unit",
	recipe = {{"itest:lapotron_crystal","itest:advanced_circuit","itest:lapotron_crystal"},
		{"itest:lapotron_crystal","itest:mfe_unit","itest:lapotron_crystal"},
		{"itest:lapotron_crystal","itest:advanced_machine","itest:lapotron_crystal"}}
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

register_craft2({
	output = "itest:advanced_machine",
	recipe = {{"","itest:advanced_alloy",""},
		{"itest:carbon_plate","itest:machine","itest:carbon_plate"},
		{"","itest:advanced_alloy",""}}
})

minetest.register_craft({
	output = "itest:mixed_metal_ingot 2",
	recipe = {{"itest:refined_iron_ingot","itest:refined_iron_ingot","itest:refined_iron_ingot"},
		{"default:bronze_ingot","default:bronze_ingot","default:bronze_ingot"},
		{"itest:tin_ingot","itest:tin_ingot","itest:tin_ingot"}}
})

minetest.register_craft({
	output = "itest:carbon_fibers",
	recipe = {{"itest:coal_dust","itest:coal_dust"},
		{"itest:coal_dust","itest:coal_dust"}}
})

minetest.register_craft({
	type = "shapeless",
	output = "itest:combined_carbon_fibers",
	recipe = {"itest:carbon_fibers","itest:carbon_fibers"}
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

register_craft2({
	output = "itest:circuit",
	recipe = {{"itest:copper_cable1_000000","itest:copper_cable1_000000","itest:copper_cable1_000000"},
		{"mesecons:wire_00000000_off","itest:refined_iron_ingot","mesecons:wire_00000000_off"},
		{"itest:copper_cable1_000000","itest:copper_cable1_000000","itest:copper_cable1_000000"}}
})

register_craft2({
	output = "itest:advanced_circuit",
	recipe = {{"mesecons:wire_00000000_off","itest:gold_dust","mesecons:wire_00000000_off"},
		{"itest:silicon_mesecon","itest:circuit","itest:silicon_mesecon"},
		{"mesecons:wire_00000000_off","itest:gold_dust","mesecons:wire_00000000_off"}}
})

minetest.register_craft({
	output = "itest:lv_transformer",
	recipe = {{"default:wood","itest:copper_cable1_000000","default:wood"},
		{"default:copper_ingot","default:copper_ingot","default:copper_ingot"},
		{"default:wood","itest:copper_cable1_000000","default:wood"}}
})

minetest.register_craft({
	output = "itest:mv_transformer",
	recipe = {{"itest:gold_cable2_000000"},
		{"itest:machine"},
		{"itest:gold_cable2_000000"}}
})

minetest.register_craft({
	output = "itest:hv_transformer",
	recipe = {{"","itest:hv_cable3_000000",""},
		{"itest:circuit","itest:mv_transformer","itest:energy_crystal"},
		{"","itest:hv_cable3_000000",""}}
})

minetest.register_craft({
	output = "itest:electric_furnace",
	recipe = {{"","itest:circuit",""},
		{"mesecons:wire_00000000_off","itest:iron_furnace","mesecons:wire_00000000_off"}}
})

minetest.register_craft({
	output = "itest:extractor",
	recipe = {{"itest:treetap","itest:machine","itest:treetap"},
		{"itest:treetap","itest:circuit","itest:treetap"}}
})

minetest.register_craft({
	output = "itest:macerator",
	recipe = {{"default:desert_stone","default:desert_stone","default:desert_stone"},
		{"default:cobble","itest:machine","default:cobble"},
		{"","itest:circuit",""}}
})

minetest.register_craft({
	output = "itest:compressor",
	recipe = {{"default:stone","","default:stone"},
		{"default:stone","itest:machine","default:stone"},
		{"default:stone","itest:circuit","default:stone"}}
})

minetest.register_craft({
	output = "itest:recycler",
	recipe = {{"","itest:gold_dust",""},
		{"default:dirt","itest:compressor","default:dirt"},
		{"itest:refined_iron_ingot","default:dirt","itest:refined_iron_ingot"}}
})

minetest.register_craft({
	output = "itest:mining_pipe 8",
	recipe = {{"itest:refined_iron_ingot","","itest:refined_iron_ingot"},
		{"itest:refined_iron_ingot","","itest:refined_iron_ingot"},
		{"itest:refined_iron_ingot","itest:treetap","itest:refined_iron_ingot"}}
})

minetest.register_craft({
	output = "itest:miner",
	recipe = {{"itest:circuit","itest:machine","itest:circuit"},
		{"","itest:mining_pipe",""},
		{"","itest:mining_pipe",""}}
})

minetest.register_craft({
	output = "itest:solar_panel",
	recipe = {{"itest:coal_dust","default:glass","itest:coal_dust"},
		{"default:glass","itest:coal_dust","default:glass"},
		{"itest:circuit","itest:generator","itest:circuit"}}
})

minetest.register_craft({
	output = "itest:watermill 2",
	recipe = {{"default:stick","default:wood","default:stick"},
		{"default:wood","itest:generator","default:wood"},
		{"default:stick","default:wood","default:stick"}}
})

minetest.register_craft({
	output = "itest:windmill",
	recipe = {{"default:steel_ingot","","default:steel_ingot"},
		{"","itest:generator",""},
		{"default:steel_ingot","","default:steel_ingot"}}
})

minetest.register_craft({
	output = "itest:mining_drill_discharged",
	recipe = {{"","itest:refined_iron_ingot",""},
		{"itest:refined_iron_ingot","itest:circuit","itest:refined_iron_ingot"},
		{"itest:refined_iron_ingot","itest:re_battery","itest:refined_iron_ingot"}}
})

minetest.register_craft({
	output = "itest:diamond_drill_discharged",
	recipe = {{"","default:diamond",""},
		{"default:diamond","itest:mining_drill","default:diamond"}}
})

minetest.register_craft({
	output = "itest:od_scanner",
	recipe = {{"","itest:gold_dust",""},
		{"itest:circuit","itest:re_battery","itest:circuit"},
		{"itest:copper_cable1_000000","itest:copper_cable1_000000","itest:copper_cable1_000000"}}
})

minetest.register_craft({
	output = "itest:ov_scanner",
	recipe = {{"","itest:gold_dust",""},
		{"itest:gold_dust","itest:advanced_circuit","itest:gold_dust"},
		{"itest:gold_cable2_000000","itest:re_battery","itest:gold_cable2_000000"}}
})

minetest.register_craft({
	output = "itest:ov_scanner",
	recipe = {{"","itest:gold_dust",""},
		{"itest:gold_dust","itest:advanced_circuit","itest:gold_dust"},
		{"itest:gold_cable2_000000","itest:od_scanner","itest:gold_cable2_000000"}}
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
macerator.register_macerator_recipe("moreores:gold_ingot","itest:gold_dust")
macerator.register_macerator_recipe("moreores:gold_lump","itest:gold_dust 2")
macerator.register_macerator_recipe("moreores:copper_lump","itest:copper_dust 2")

extractor.register_extractor_recipe("itest:sticky_resin","itest:rubber 3")
extractor.register_extractor_recipe("itest:rubber_tree","itest:rubber")
extractor.register_extractor_recipe("itest:rubber_sapling","itest:rubber")
extractor.register_extractor_recipe("default:mese_crystal","mesecons:wire_00000000_off 32")
extractor.register_extractor_recipe("default:sand","mesecons_resources:silicon")

compressor.register_compressor_recipe("itest:mixed_metal_ingot","itest:advanced_alloy")
compressor.register_compressor_recipe("itest:combined_carbon_fibers","itest:carbon_plate")

