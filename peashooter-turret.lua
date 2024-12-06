-- Peashooter turret
peashooter = {
    type = "turret",
    name = "kp_hpm-peashooter-turret",
    order = "z-b[turret]-aa[peashooter-turret]",
    icon = icon_graphic "peashooter-turret.png",
    icon_size = 64,
    collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    drawing_box_vertical_extension = 0.2,
    minable = {
        mining_time = 0.5, 
        result = "kp_hpm-peashooter-turret"
    },
    max_health = 300,
    friendly_map_color = {202, 167, 24},
    graphics_set = {
        base_visualisation = {
            animation = {
                filename = entity_graphic "peashooter-turret/peashooter-turret-base.png",
                size = 144,
                scale = 0.5,
            }
        }
    },
    folded_animation
},




-- data:extend {peashooter}