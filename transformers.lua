function send_alldirs_except(pos,dir,power)
	local meta=minetest.env:get_meta(pos)
	if meta:get_int("energy")<power then return end
	for _,dir in ipairs(meseadjlist) do
		if dir.x~=dir.x or dir.y~=dir.y or dir.z~=dir.z then
			local s=send_packet(pos,dir)
			if s~= nil then
				meta:set_int("energy",meta:get_int("energy")-power)
				return
			end
		end
	end
end

minetest.register_node("itest:lv_transformer",{description="LV Transformer",
	groups={energy=1,cracky=2,energy_consumer=1},
	tiles={"itest_lv_transformer_lv.png", "itest_lv_transformer_lv.png", "itest_lv_transformer_mv.png", "itest_lv_transformer_lv.png", "itest_lv_transformer_lv.png", "itest_lv_transformer_lv.png"},
	itest = {max_energy=2560,max_psize=128},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("send_lv",0)
	end,
	mesecons = {effector = {
		action_on = function (pos, node)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("send_lv",1)
		end,
		action_off = function (pos, node)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("send_lv",0)
		end}}
})

minetest.register_abm({
	nodenames={"itest:lv_transformer"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local senddir = param22dir(node.param2)
		local meta = minetest.env:get_meta(pos)
		if meta:get_int("send_lv") == 1 then
			for i=1,80 do
				storage.send(pos,32,senddir)
			end
		else
			for i=1,20 do
				send_alldirs_except(pos,senddir,128)
			end
		end
	end
})

minetest.register_node("itest:mv_transformer",{description="MV Transformer",
	groups={energy=1,cracky=2,energy_consumer=1},
	tiles={"itest_mv_transformer_mv.png", "itest_mv_transformer_mv.png", "itest_mv_transformer_hv.png", "itest_mv_transformer_mv.png", "itest_mv_transformer_mv.png", "itest_mv_transformer_mv.png"},
	itest = {max_energy=10240,max_psize=512},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("send_mv",0)
	end,
	mesecons = {effector = {
		action_on = function (pos, node)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("send_mv",1)
		end,
		action_off = function (pos, node)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("send_mv",0)
		end}}
})

minetest.register_abm({
	nodenames={"itest:mv_transformer"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local senddir = param22dir(node.param2)
		local meta = minetest.env:get_meta(pos)
		if meta:get_int("send_mv") == 1 then
			for i=1,80 do
				storage.send(pos,128,senddir)
			end
		else
			for i=1,20 do
				send_alldirs_except(pos,senddir,512)
			end
		end
	end
})

minetest.register_node("itest:hv_transformer",{description="HV Transformer",
	groups={energy=1,cracky=2,energy_consumer=1},
	tiles={"itest_hv_transformer_hv.png", "itest_hv_transformer_hv.png", "itest_hv_transformer_ev.png", "itest_hv_transformer_hv.png", "itest_hv_transformer_hv.png", "itest_hv_transformer_hv.png"},
	itest = {max_energy=40960,max_psize=128},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("energy",0)
		meta:set_int("send_hv",0)
	end,
	mesecons = {effector = {
		action_on = function (pos, node)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("send_hv",1)
		end,
		action_off = function (pos, node)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("send_hv",0)
		end}}
})

minetest.register_abm({
	nodenames={"itest:hv_transformer"},
	interval=1.0,
	chance=1,
	action = function(pos, node, active_object_count, active_objects_wider)
		local senddir = param22dir(node.param2)
		local meta = minetest.env:get_meta(pos)
		if meta:get_int("send_hv") == 0 then
			for i=1,80 do
				storage.send(pos,512,senddir)
			end
		else
			for i=1,20 do
				send_alldirs_except(pos,senddir,2048)
			end
		end
	end
})
	
