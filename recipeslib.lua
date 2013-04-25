minetest.register_can_register_craft(function(options)
	if options.type == "shapeless" and
		options.output == "default:bronze_ingot" and
		options.recipe[1] == "default:steel_ingot" then
				return false
	end
	return true
end)
