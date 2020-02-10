local tnt_modpath = minetest.get_modpath("tnt")
local S = minetest.get_translator("tnt")

-- Default to enabled when in singleplayer
local enable_tnt = minetest.settings:get_bool("enable_tnt")
if enable_tnt == nil then
	enable_tnt = minetest.is_singleplayer()
end

local bomb_range = tonumber(minetest.settings:get("torch_bomb_max_range")) or 40

-- 12 torches (torch grenade? Not currently used)
local ico1 = {
	vector.new(0.000000,	-1.000000,	0.000000),
	vector.new(0.723600,	-0.447215,	0.525720),
	vector.new(-0.276385,	-0.447215,	0.850640),
	vector.new(-0.894425,	-0.447215,	0.000000),
	vector.new(-0.276385,	-0.447215,	-0.850640),
	vector.new(0.723600,	-0.447215,	-0.525720),
	vector.new(0.276385,	0.447215,	0.850640),
	vector.new(-0.723600,	0.447215,	0.525720),
	vector.new(-0.723600,	0.447215,	-0.525720),
	vector.new(0.276385,	0.447215,	-0.850640),
	vector.new(0.894425,	0.447215,	0.000000),
	vector.new(0.000000,	1.000000,	0.000000),
}

-- 42 torches, 1*bomb_range
local ico2 = {
	vector.new(0.000000,	-1.000000,	0.000000),
	vector.new(0.723607,	-0.447220,	0.525725),
	vector.new(-0.276388,	-0.447220,	0.850649),
	vector.new(-0.894426,	-0.447216,	0.000000),
	vector.new(-0.276388,	-0.447220,	-0.850649),
	vector.new(0.723607,	-0.447220,	-0.525725),
	vector.new(0.276388,	0.447220,	0.850649),
	vector.new(-0.723607,	0.447220,	0.525725),
	vector.new(-0.723607,	0.447220,	-0.525725),
	vector.new(0.276388,	0.447220,	-0.850649),
	vector.new(0.894426,	0.447216,	0.000000),
	vector.new(0.000000,	1.000000,	0.000000),
	vector.new(-0.162456,	-0.850654,	0.499995),
	vector.new(0.425323,	-0.850654,	0.309011),
	vector.new(0.262869,	-0.525738,	0.809012),
	vector.new(0.850648,	-0.525736,	0.000000),
	vector.new(0.425323,	-0.850654,	-0.309011),
	vector.new(-0.525730,	-0.850652,	0.000000),
	vector.new(-0.688189,	-0.525736,	0.499997),
	vector.new(-0.162456,	-0.850654,	-0.499995),
	vector.new(-0.688189,	-0.525736,	-0.499997),
	vector.new(0.262869,	-0.525738,	-0.809012),
	vector.new(0.951058,	0.000000,	0.309013),
	vector.new(0.951058,	0.000000,	-0.309013),
	vector.new(0.000000,	0.000000,	1.000000),
	vector.new(0.587786,	0.000000,	0.809017),
	vector.new(-0.951058,	0.000000,	0.309013),
	vector.new(-0.587786,	0.000000,	0.809017),
	vector.new(-0.587786,	0.000000,	-0.809017),
	vector.new(-0.951058,	0.000000,	-0.309013),
	vector.new(0.587786,	0.000000,	-0.809017),
	vector.new(0.000000,	0.000000,	-1.000000),
	vector.new(0.688189,	0.525736,	0.499997),
	vector.new(-0.262869,	0.525738,	0.809012),
	vector.new(-0.850648,	0.525736,	0.000000),
	vector.new(-0.262869,	0.525738,	-0.809012),
	vector.new(0.688189,	0.525736,	-0.499997),
	vector.new(0.162456,	0.850654,	0.499995),
	vector.new(0.525730,	0.850652,	0.000000),
	vector.new(-0.425323,	0.850654,	0.309011),
	vector.new(-0.425323,	0.850654,	-0.309011),
	vector.new(0.162456,	0.850654,	-0.499995),
}
-- Pre-multiply the range into these unit vectors
for i, pos in ipairs(ico2) do
	ico2[i] = vector.multiply(pos, bomb_range)
end

-- 162 torches, 3* bomb_range
local ico3 = {
	vector.new(0.000000,	-1.000000,	0.000000), 
	vector.new(0.723607,	-0.447220,	0.525725),
	vector.new(-0.276388,	-0.447220,	0.850649),
	vector.new(-0.894426,	-0.447216,	0.000000),
	vector.new(-0.276388,	-0.447220,	-0.850649),
	vector.new(0.723607,	-0.447220,	-0.525725),
	vector.new(0.276388,	0.447220,	0.850649),
	vector.new(-0.723607,	0.447220,	0.525725),
	vector.new(-0.723607,	0.447220,	-0.525725),
	vector.new(0.276388,	0.447220,	-0.850649),
	vector.new(0.894426,	0.447216,	0.000000),
	vector.new(0.000000,	1.000000,	0.000000),
	vector.new(-0.232822,	-0.657519,	0.716563),
	vector.new(-0.162456,	-0.850654,	0.499995),
	vector.new(-0.077607,	-0.967950,	0.238853),
	vector.new(0.203181,	-0.967950,	0.147618),
	vector.new(0.425323,	-0.850654,	0.309011),
	vector.new(0.609547,	-0.657519,	0.442856),
	vector.new(0.531941,	-0.502302,	0.681712),
	vector.new(0.262869,	-0.525738,	0.809012),
	vector.new(-0.029639,	-0.502302,	0.864184),
	vector.new(0.812729,	-0.502301,	-0.295238),
	vector.new(0.850648,	-0.525736,	0.000000),
	vector.new(0.812729,	-0.502301,	0.295238),
	vector.new(0.203181,	-0.967950,	-0.147618),
	vector.new(0.425323,	-0.850654,	-0.309011),
	vector.new(0.609547,	-0.657519,	-0.442856),
	vector.new(-0.753442,	-0.657515,	0.000000),
	vector.new(-0.525730,	-0.850652,	0.000000),
	vector.new(-0.251147,	-0.967949,	0.000000),
	vector.new(-0.483971,	-0.502302,	0.716565),
	vector.new(-0.688189,	-0.525736,	0.499997),
	vector.new(-0.831051,	-0.502299,	0.238853),
	vector.new(-0.232822,	-0.657519,	-0.716563),
	vector.new(-0.162456,	-0.850654,	-0.499995),
	vector.new(-0.077607,	-0.967950,	-0.238853),
	vector.new(-0.831051,	-0.502299,	-0.238853),
	vector.new(-0.688189,	-0.525736,	-0.499997),
	vector.new(-0.483971,	-0.502302,	-0.716565),
	vector.new(-0.029639,	-0.502302,	-0.864184),
	vector.new(0.262869,	-0.525738,	-0.809012),
	vector.new(0.531941,	-0.502302,	-0.681712),
	vector.new(0.956626,	0.251149,	0.147618),
	vector.new(0.951058,	-0.000000,	0.309013),
	vector.new(0.860698,	-0.251151,	0.442858),
	vector.new(0.860698,	-0.251151,	-0.442858),
	vector.new(0.951058,	0.000000,	-0.309013),
	vector.new(0.956626,	0.251149,	-0.147618),
	vector.new(0.155215,	0.251152,	0.955422),
	vector.new(0.000000,	-0.000000,	1.000000),
	vector.new(-0.155215,	-0.251152,	0.955422),
	vector.new(0.687159,	-0.251152,	0.681715),
	vector.new(0.587786,	0.000000,	0.809017),
	vector.new(0.436007,	0.251152,	0.864188),
	vector.new(-0.860698,	0.251151,	0.442858),
	vector.new(-0.951058,	-0.000000,	0.309013),
	vector.new(-0.956626,	-0.251149,	0.147618),
	vector.new(-0.436007,	-0.251152,	0.864188),
	vector.new(-0.587786,	0.000000,	0.809017),
	vector.new(-0.687159,	0.251152,	0.681715),
	vector.new(-0.687159,	0.251152,	-0.681715),
	vector.new(-0.587786,	-0.000000,	-0.809017),
	vector.new(-0.436007,	-0.251152,	-0.864188),
	vector.new(-0.956626,	-0.251149,	-0.147618),
	vector.new(-0.951058,	0.000000,	-0.309013),
	vector.new(-0.860698,	0.251151,	-0.442858),
	vector.new(0.436007,	0.251152,	-0.864188),
	vector.new(0.587786,	-0.000000,	-0.809017),
	vector.new(0.687159,	-0.251152,	-0.681715),
	vector.new(-0.155215,	-0.251152,	-0.955422),
	vector.new(0.000000,	0.000000,	-1.000000),
	vector.new(0.155215,	0.251152,	-0.955422),
	vector.new(0.831051,	0.502299,	0.238853),
	vector.new(0.688189,	0.525736,	0.499997),
	vector.new(0.483971,	0.502302,	0.716565),
	vector.new(0.029639,	0.502302,	0.864184),
	vector.new(-0.262869,	0.525738,	0.809012),
	vector.new(-0.531941,	0.502302,	0.681712),
	vector.new(-0.812729,	0.502301,	0.295238),
	vector.new(-0.850648,	0.525736,	0.000000),
	vector.new(-0.812729,	0.502301,	-0.295238),
	vector.new(-0.531941,	0.502302,	-0.681712),
	vector.new(-0.262869,	0.525738,	-0.809012),
	vector.new(0.029639,	0.502302,	-0.864184),
	vector.new(0.483971,	0.502302,	-0.716565),
	vector.new(0.688189,	0.525736,	-0.499997),
	vector.new(0.831051,	0.502299,	-0.238853),
	vector.new(0.077607,	0.967950,	0.238853),
	vector.new(0.162456,	0.850654,	0.499995),
	vector.new(0.232822,	0.657519,	0.716563),
	vector.new(0.753442,	0.657515,	0.000000),
	vector.new(0.525730,	0.850652,	0.000000),
	vector.new(0.251147,	0.967949,	0.000000),
	vector.new(-0.203181,	0.967950,	0.147618),
	vector.new(-0.425323,	0.850654,	0.309011),
	vector.new(-0.609547,	0.657519,	0.442856),
	vector.new(-0.203181,	0.967950,	-0.147618),
	vector.new(-0.425323,	0.850654,	-0.309011),
	vector.new(-0.609547,	0.657519,	-0.442856),
	vector.new(0.077607,	0.967950,	-0.238853),
	vector.new(0.162456,	0.850654,	-0.499995),
	vector.new(0.232822,	0.657519,	-0.716563),
	vector.new(0.361800,	0.894429,	-0.262863),
	vector.new(0.638194,	0.723610,	-0.262864),
	vector.new(0.447209,	0.723612,	-0.525728),
	vector.new(-0.138197,	0.894430,	-0.425319),
	vector.new(-0.052790,	0.723612,	-0.688185),
	vector.new(-0.361804,	0.723612,	-0.587778),
	vector.new(-0.447210,	0.894429,	0.000000),
	vector.new(-0.670817,	0.723611,	-0.162457),
	vector.new(-0.670817,	0.723611,	0.162457),
	vector.new(-0.138197,	0.894430,	0.425319),
	vector.new(-0.361804,	0.723612,	0.587778),
	vector.new(-0.052790,	0.723612,	0.688185),
	vector.new(0.361800,	0.894429,	0.262863),
	vector.new(0.447209,	0.723612,	0.525728),
	vector.new(0.638194,	0.723610,	0.262864),
	vector.new(0.861804,	0.276396,	-0.425322),
	vector.new(0.809019,	0.000000,	-0.587782),
	vector.new(0.670821,	0.276397,	-0.688189),
	vector.new(-0.138199,	0.276397,	-0.951055),
	vector.new(-0.309016,	-0.000000,	-0.951057),
	vector.new(-0.447215,	0.276397,	-0.850649),
	vector.new(-0.947213,	0.276396,	-0.162458),
	vector.new(-1.000000,	0.000001,	0.000000),
	vector.new(-0.947213,	0.276397,	0.162458),
	vector.new(-0.447216,	0.276397,	0.850648),
	vector.new(-0.309017,	-0.000001,	0.951056),
	vector.new(-0.138199,	0.276397,	0.951055),
	vector.new(0.670820,	0.276396,	0.688190),
	vector.new(0.809019,	-0.000002,	0.587783),
	vector.new(0.861804,	0.276394,	0.425323),
	vector.new(0.309017,	-0.000000,	-0.951056),
	vector.new(0.447216,	-0.276398,	-0.850648),
	vector.new(0.138199,	-0.276398,	-0.951055),
	vector.new(-0.809018,	-0.000000,	-0.587783),
	vector.new(-0.670819,	-0.276397,	-0.688191),
	vector.new(-0.861803,	-0.276396,	-0.425324),
	vector.new(-0.809018,	0.000000,	0.587783),
	vector.new(-0.861803,	-0.276396,	0.425324),
	vector.new(-0.670819,	-0.276397,	0.688191),
	vector.new(0.309017,	0.000000,	0.951056),
	vector.new(0.138199,	-0.276398,	0.951055),
	vector.new(0.447216,	-0.276398,	0.850648),
	vector.new(1.000000,	0.000000,	0.000000),
	vector.new(0.947213,	-0.276396,	0.162458),
	vector.new(0.947213,	-0.276396,	-0.162458),
	vector.new(0.361803,	-0.723612,	-0.587779),
	vector.new(0.138197,	-0.894429,	-0.425321),
	vector.new(0.052789,	-0.723611,	-0.688186),
	vector.new(-0.447211,	-0.723612,	-0.525727),
	vector.new(-0.361801,	-0.894429,	-0.262863),
	vector.new(-0.638195,	-0.723609,	-0.262863),
	vector.new(-0.638195,	-0.723609,	0.262864),
	vector.new(-0.361801,	-0.894428,	0.262864),
	vector.new(-0.447211,	-0.723610,	0.525729),
	vector.new(0.670817,	-0.723611,	-0.162457),
	vector.new(0.670818,	-0.723610,	0.162458),
	vector.new(0.447211,	-0.894428,	0.000001),
	vector.new(0.052790,	-0.723612,	0.688185),
	vector.new(0.138199,	-0.894429,	0.425321),
	vector.new(0.361805,	-0.723611,	0.587779),
}
-- Pre-multiply the range into these unit vectors
for i, pos in ipairs(ico3) do
	ico3[i] = vector.multiply(pos, bomb_range*3)
end

local function find_target(raycast)
	local next_pointed = raycast:next()
	while next_pointed do
		local under_pos = next_pointed.under
		local under_node = minetest.get_node(under_pos)
		local under_def = minetest.registered_nodes[under_node.name]
		local above_pos = next_pointed.above
		local above_node = minetest.get_node(above_pos)
		local above_def = minetest.registered_nodes[above_node.name]

		if above_def.buildable_to and under_def.walkable then
			return next_pointed
		end
		
		next_pointed  = raycast:next(next_pointed)
	end
end

local torch_def_on_place = minetest.registered_nodes["default:torch"].on_place

local function kerblam(pos, placer, dirs, min_range)
	local targets = {}
	for _, pos2 in ipairs(dirs) do
		local raycast = minetest.raycast(pos, vector.add(pos, pos2), false, true)
		local target_pointed = find_target(raycast)
		if target_pointed then
			if vector.distance(pos, target_pointed.above) > min_range then
				table.insert(targets, target_pointed)
			end
		end
	end

	for _, target in ipairs(targets) do
		if minetest.get_item_group(minetest.get_node(target.above).name, "torch") == 0 then -- TODO remove this check after culling close-together targets
			torch_def_on_place(ItemStack("default:torch"), placer, target)
			local target_pos = target.above
			local dir_back = vector.normalize(vector.subtract(pos, target_pos))
			local vel_back = vector.multiply(dir_back, 10)
			minetest.add_particlespawner({
				amount = math.random(1,6),
				time = 0.1,
				minpos = target_pos,
				maxpos = target_pos,
				minvel = vector.subtract(dir_back, 2),
				maxvel = vector.add(dir_back, 2),
				minacc = {x=0, y=-9, z=0},
				maxacc = {x=0, y=-9, z=0},
				minexptime = 1,
				maxexptime = 2,
				minsize = 1,
				maxsize = 2,
				collisiondetection = true,
				collision_removal = false,
				texture = "torch_bomb_shard.png",
			})
		end
	end	
end

local function register_torch_bomb(name, desc, dirs, min_range, blast_radius, texture)

	minetest.register_node("torch_bomb:" .. name, {
		description = desc,
		drawtype = "normal", 
		tiles = {"torch_bomb_top.png", "torch_bomb_bottom.png", "torch_bomb_side_base.png^"..texture},
		paramtype = "light",
		paramtype2 = "facedir",
		
		groups = {tnt = 1, oddly_breakable_by_hand = 1},
		
		on_punch = function(pos, node, puncher)
			if puncher:get_wielded_item():get_name() == "default:torch" then
				minetest.set_node(pos, {name = "torch_bomb:"..name.."_burning"})
				minetest.get_meta(pos):set_string("torch_bomb_ignitor", puncher:get_player_name())
				minetest.log("action", puncher:get_player_name() .. " ignites " .. node.name .. " at " ..
					minetest.pos_to_string(pos))
			end
		end,
	
		on_ignite = function(pos) -- used by TNT mod
			minetest.set_node(pos, {name = "torch_bomb:"..name.."_burning"})
		end,
	})
	
	minetest.register_node("torch_bomb:"..name.."_burning", {
		description = desc,
		drawtype = "normal",  -- See "Node drawtypes"
		tiles = {{
				name = "torch_bomb_top_burning_animated.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 1,
				}
			},
			"torch_bomb_bottom.png", "torch_bomb_side_base.png^"..texture},
		groups = {falling_node = 1, not_in_creative_inventory = 1},
		paramtype = "light",
		paramtype2 = "facedir",
		light_source = 6,
		
		on_construct = function(pos)
			if tnt_modpath then
				minetest.sound_play("tnt_ignite", {pos = pos})
			end
			minetest.get_node_timer(pos):start(3)
			minetest.check_for_falling(pos)
		end,
		
		on_timer = function(pos, elapsed)
			local ignitor_name = minetest.get_meta(pos):get("torch_bomb_ignitor")
			local puncher
			if ignitor_name then
				puncher = minetest.get_player_by_name(ignitor_name)
			end
			minetest.set_node(pos, {name="air"})
			if tnt_modpath then
				tnt.boom(pos, {radius=blast_radius, damage_radius=blast_radius+3})
			end
			kerblam(pos, puncher, dirs, min_range)
		end,
	})

end

register_torch_bomb("torch_bomb", S("Torch Bomb"), ico2, 5, 1, "torch_bomb_one_torch.png")
register_torch_bomb("mega_torch_bomb", S("Mega Torch Bomb"), ico3, 15, 3, "torch_bomb_three_torches.png")

if enable_tnt and tnt_modpath then
	minetest.register_craft({
		output = "torch_bomb:torch_bomb",
		recipe = {
			{'default:coalblock', 'tnt:tnt_stick', 'default:coalblock'},
			{'group:wood', 'tnt:tnt_stick', 'group:wood'},
			{'group:wood', 'tnt:tnt_stick', 'group:wood'},
		},
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = "torch_bomb:mega_torch_bomb",
		recipe = {"torch_bomb:torch_bomb", "torch_bomb:torch_bomb", "torch_bomb:torch_bomb"},
	})
	
		minetest.register_craft({
		type = "shapeless",
		output = "torch_bomb:torch_bomb 3",
		recipe = {"torch_bomb:mega_torch_bomb"},
	})

end
