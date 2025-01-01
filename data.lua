local item_sounds = require("__base__.prototypes.item_sounds")

-- require("peashooter-turret.lua")

local function graphic(path)
    return "__high-powered-motor__/graphics/" .. path
end

local function icon_graphic(path)
    return graphic "icons/" .. path
end

local function entity_graphic(path)
    return graphic "entity/" .. path
end

local function tech_graphic(path)
    return graphic "technology/" .. path
end

local function rotated_positions(position)
    return {
        position, 
        {-position[2], position[1]}, 
        {-position[1], -position[2]}, 
        {position[2], -position[1]}
    }
end

local function defineHighPoweredMotor()
    local hpm = table.deepcopy(data.raw["item"]["electric-engine-unit"])
    hpm.name = "kp_hpm-high-powered-motor"
    hpm.icon = icon_graphic "high-powered-motor.png"
    hpm.order = "c[advanced-intermediates]-ba[high-powered-motor]"
    hpm.pick_sound = data.raw["item"]["engine-unit"].pick_sound
    hpm.weight = 5000
    return hpm
end

local function defineHyperiumResource()
    local hyperium = table.deepcopy(data.raw["resource"]["uranium-ore"])
    hyperium.name = "kp_hpm-hyperium-ore"
    hyperium.order = "a-c-a"
    hyperium.icon = icon_graphic "hyperium-ore-1.png"
    hyperium.map_color = {234, 62, 93}
    hyperium.mining_visualisation_tint = {234, 62, 93}
    hyperium.stages.sheet.filename = entity_graphic "hyperium-ore.png"
    hyperium.stages_effect.sheet.filename = entity_graphic "hyperium-ore-glow.png"
    hyperium.minable = {
        mining_time = 4,
        result = "kp_hpm-hyperium-ore"
    }
    hyperium.factoriopedia_simulation = {init = make_resource("kp_hpm-hyperium-ore")}
    return hyperium
end

local function defineZincResource()
    local zinc = table.deepcopy(data.raw["resource"]["iron-ore"])
    zinc.name = "kp_hpm-zinc-ore"
    zinc.order = "a-b-c"
    zinc.icon = icon_graphic "zinc-ore-3.png"
    zinc.map_color = {0.694, 0.824, 0.733}
    zinc.mining_visualisation_tint = {0.694, 0.824, 0.733}
    zinc.stages.sheet.filename = entity_graphic "zinc-ore.png"
    zinc.minable.result = "kp_hpm-zinc-ore"
    zinc.factoriopedia_simulation = {init = make_resource("kp_hpm-zinc-ore")}
    return zinc
end

local function defineAlloyFurnaceEntity()
    local alloyFurnace = table.deepcopy(data.raw["furnace"]["steel-furnace"])
    alloyFurnace.type = "assembling-machine"
    alloyFurnace.name = "kp_hpm-alloy-furnace"
    alloyFurnace.minable.result = "kp_hpm-alloy-furnace"
    alloyFurnace.crafting_categories = {"alloy-smelting"}
    alloyFurnace.source_inventory_size = 2

    return alloyFurnace
end

local function defineAlloyFurnaceItem()
    local alloyFurnace = table.deepcopy(data.raw["item"]["steel-furnace"])
    alloyFurnace.name = "kp_hpm-alloy-furnace"
    alloyFurnace.icons = {{icon = alloyFurnace.icon, icon_size = alloyFurnace.icon_size, tint = {0.77, 0.77, 0.77}}}
    alloyFurnace.order = "ca[alloy-furnace]"
    alloyFurnace.place_result = "kp_hpm-alloy-furnace"

    return alloyFurnace
end

-- Give assembling machine 3 a second fluid input and two fluid outputs
-- Copy output pipe
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[3] = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[2])
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[4] = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[2])

-- Set south pipe to input
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[2].production_type = "input"
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[2].pipe_connections[1].flow_direction = "input"

-- Set east and west pipes
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[3].pipe_connections = {{
    direction = defines.direction.east, 
    flow_direction = "output",
    positions = rotated_positions {1, 0}
}}
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[4].pipe_connections = {{
    direction = defines.direction.west, 
    flow_direction = "output",
    positions = rotated_positions {-1, 0}
}}

-- Replace sulfur with battery in chem science recipe
data.raw["recipe"]["chemical-science-pack"].ingredients = {
    {type = "item", name = "battery", amount = 1},
    {type = "item", name = "advanced-circuit", amount = 3},
    {type = "item", name = "engine-unit", amount = 2},
}

-- Change advanced circuit recipe
data.raw["recipe"]["advanced-circuit"].ingredients = {
    {type = "item", name = "electronic-circuit", amount = 2},
    {type = "item", name = "kp_hpm-insulated-cable", amount = 2}
}

data:extend {
    -- Gizmo item
    {
        type = "item",
        name = "kp_hpm-iron-gizmo",
        subgroup = "intermediate-product",
        order = data.raw["item"]["iron-gear-wheel"].order .. "-a",
        icon = icon_graphic "gizmo.png",
        icon_size = 64,
        stack_size = 100,
        weight = 1000,
    },
    -- Gizmo recipe
    {
        type = "recipe",
        name = "kp_hpm-iron-gizmo",
        category = "crafting-with-fluid",
        enabled = true,
        energy_required = 0.5,
        ingredients = {
            {type = "item", name = "iron-gear-wheel", amount = 2},
            {type = "item", name = "iron-stick", amount = 1},
            {type = "fluid", name = "lubricant", amount = 10}
        },
        results = {{type = "item", name = "kp_hpm-iron-gizmo", amount = 1}}
    },
    -- Copper tubing item
    {
        type = "item",
        name = "kp_hpm-copper-tubing",
        subgroup = "intermediate-product",
        order = "a[basic-intermediates]-ba[copper-tubing]",
        icon = icon_graphic "copper-tubing.png",
        icon_size = 64,
        stack_size = 100,
        weight = 1000,
    },
    {
        type = "recipe",
        name = "kp_hpm-copper-tubing",
        enabled = true,
        energy_required = 0.5,
        ingredients = {
            {type = "item", name = "copper-plate", amount = 2},
        },
        results = {{type = "item", name = "kp_hpm-copper-tubing", amount = 1}}
    },
    -- Gasoline fluid
    {
        type = "fluid",
        name = "kp_hpm-gasoline",
        subgroup = "fluid",
        order = "a[fluid]-b[oil]-ca[gasoline]",
        icon = icon_graphic "gasoline.png",
        icon_size = 64,
        default_temperature = 25,
        base_color = {0.44, 0.48, 0.27},
        flow_color = {0.73, 0.73, 0.42}
    },
    -- Gasoline recipe
    {
        type = "recipe",
        category = "chemistry",
        name = "kp_hpm-gasoline",
        subgroup = "fluid-recipes",
        order = "c[oil-products]-Z[gasoline]",
        crafting_machine_tint = {
            primary = {0.718, 0.733, 0.424},
            secondary = {0.624, 0.624, 0.384},
            tertiary = {0.894, 0.773, 0.596},
            quaternary = {0.812, 0.583, 0.202}
        },
        enabled = false,
        energy_required = 1,
        ingredients = {
            {type = "fluid", name = "light-oil", amount = 10}
        },
        results = {{type = "fluid", name = "kp_hpm-gasoline", amount = 10}}
    },
    -- Gasoline technology
    {
        type = "technology",
        name = "kp_hpm-gasoline",
        icon = tech_graphic "gasoline.png",
        icon_size = 64,
        prerequisites = {"advanced-oil-processing"},
        effects = {{
            type = "unlock-recipe",
            recipe = "kp_hpm-gasoline"
        }},
        unit = {
            count = 50,
            time = 30,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1},
            },
        }
    },
    -- Advanced processing subgroup
    {
        type = "item-subgroup",
        name = "advanced-processing",
        group = "intermediate-products",
        order = "ca"
    },
    -- Industrial diamond
    {
        type = "item",
        name = "kp_hpm-industrial-diamond",
        subgroup = "advanced-processing",
        order = "a[industrial-diamond]",
        icon = icon_graphic "industrial-diamond.png",
        icon_size = 64,
        pick_sound = item_sounds.coin_inventory_pickup,
        drop_sound = item_sounds.science_inventory_move,
        inventory_move_sound = item_sounds.science_inventory_move,
        stack_size = 100,
        weight = 2500,
    },
    -- Industrial diamond recipe
    {
        type = "recipe",
        name = "kp_hpm-industrial-diamond",
        category = "advanced-crafting",
        enabled = true,
        energy_required = 30,
        ingredients = {
            {type = "item", name = "coal", amount = 50},
        },
        results = {{type = "item", name = "kp_hpm-industrial-diamond", amount = 1}}
    },
    -- Sand
    {
        type = "item",
        name = "kp_hpm-sand",
        subgroup = "raw-material",
        -- order = "a[industrial-diamond]",
        icon = icon_graphic "sand-temp.png",
        icon_size = 64,
        -- pick_sound = item_sounds.coin_inventory_pickup,
        -- drop_sound = item_sounds.science_inventory_move,
        -- inventory_move_sound = item_sounds.science_inventory_move,
        stack_size = 500,
        weight = 250,
    },
    -- Sand recipe
    {
        type = "recipe",
        name = "kp_hpm-sand",
        enabled = true,
        energy_required = 0.5,
        ingredients = {
            {type = "item", name = "stone", amount = 1},
        },
        results = {{type = "item", name = "kp_hpm-sand", amount = 2}}
    },    
    -- Sand recipe
    {
        type = "recipe",
        name = "kp_hpm-sand",
        enabled = true,
        energy_required = 0.5,
        ingredients = {
            {type = "item", name = "stone", amount = 1},
        },
        results = {{type = "item", name = "kp_hpm-sand", amount = 2}}
    },
    -- Glass rod
    {
        type = "item",
        name = "kp_hpm-glass-rod",
        subgroup = "raw-material",
        -- order = "a[industrial-diamond]",
        icon = icon_graphic "glass-rod.png",
        icon_size = 64,
        pictures = {
            {filename = icon_graphic "glass-rod.png", size = 64, scale = 0.5, mipmap_count = 4},
            {filename = icon_graphic "glass-rod-1.png", size = 64, scale = 0.5, mipmap_count = 4},
            {filename = icon_graphic "glass-rod-2.png", size = 64, scale = 0.5, mipmap_count = 4},
            {filename = icon_graphic "glass-rod-3.png", size = 64, scale = 0.5, mipmap_count = 4},
        },
        -- pick_sound = item_sounds.coin_inventory_pickup,
        -- drop_sound = item_sounds.science_inventory_move,
        -- inventory_move_sound = item_sounds.science_inventory_move,
        stack_size = 100,
        weight = 500,
    },
    -- Glass rod recipe
    {
        type = "recipe",
        name = "kp_hpm-glass-rod",
        category = "smelting",
        enabled = true,
        energy_required = 3.2,
        ingredients = {
            {type = "item", name = "kp_hpm-sand", amount = 4},
        },
        results = {{type = "item", name = "kp_hpm-glass-rod", amount = 1}}
    },
    -- Glass plate
    {
        type = "item",
        name = "kp_hpm-glass-plate",
        subgroup = "raw-material",
        -- order = "a[industrial-diamond]",
        icon = icon_graphic "glass-plate.png",
        icon_size = 64,
        -- pick_sound = item_sounds.coin_inventory_pickup,
        -- drop_sound = item_sounds.science_inventory_move,
        -- inventory_move_sound = item_sounds.science_inventory_move,
        stack_size = 100,
        weight = 1000,
    },
    -- Glass plate recipe
    {
        type = "recipe",
        name = "kp_hpm-glass-plate",
        category = "smelting",
        enabled = true,
        energy_required = 16,
        ingredients = {
            {type = "item", name = "kp_hpm-glass-rod", amount = 5},
        },
        results = {{type = "item", name = "kp_hpm-glass-plate", amount = 1}}
    },
    -- Rubber
    {
        type = "item",
        name = "kp_hpm-rubber",
        subgroup = "raw-material",
        order = "b[chemistry]-ba[rubber]",
        icon = icon_graphic "rubber.png",
        icon_size = 64,
        pick_sound = item_sounds.plastic_inventory_pickup,
        drop_sound = item_sounds.plastic_inventory_move,
        inventory_move_sound = item_sounds.plastic_inventory_move,
        stack_size = 100,
        weight = 500,
    },
    -- Rubber recipe
    {
        type = "recipe",
        name = "kp_hpm-rubber",
        category = "chemistry",
        crafting_machine_tint = {
            primary = {0.282, 0.278, 0.286},
            secondary = {0.086, 0.086, 0.098},
            tertiary = {0.768, 0.665, 0.762},
            quaternary = {0, 0, 0}
        },
        enabled = true,
        energy_required = 4,
        ingredients = {
            {type = "fluid", name = "petroleum-gas", amount = 10},
            {type = "item", name = "kp_hpm-chemical-foam", amount = 10}
        },
        results = {{type = "item", name = "kp_hpm-rubber", amount = 1}}
    },
    -- Chemical foam
    {
        type = "item",
        name = "kp_hpm-chemical-foam",
        subgroup = "raw-material",
        order = "b[chemistry]-bb[chemical-foam]",
        icon = icon_graphic "foam.png",
        icon_size = 64,
        pick_sound = item_sounds.wire_inventory_pickup,
        drop_sound = item_sounds.wire_inventory_move,
        inventory_move_sound = item_sounds.wire_inventory_move,
        stack_size = 200,
        weight = 250,
    },
    -- Chemical foam recipe
    {
        type = "recipe",
        name = "kp_hpm-chemical-foam",
        category = "chemistry",
        crafting_machine_tint = {
            primary = {0.718, 0.773, 0.639},
            secondary = {0.475, 0.545, 0.412},
            tertiary = {0.768, 0.665, 0.762},
            quaternary = {0, 0, 0}
        },
        enabled = true,
        energy_required = 0.5,
        ingredients = {
            {type = "fluid", name = "petroleum-gas", amount = 1}
        },
        results = {{type = "item", name = "kp_hpm-chemical-foam", amount = 2}}
    },
    -- Insulated cable
    {
        type = "item",
        name = "kp_hpm-insulated-cable",
        subgroup = "intermediate-product",
        order = "a[basic-intermediates]-ca[insulated-cable]",
        icon = icon_graphic "cable.png",
        icon_size = 64,
        pick_sound = item_sounds.plastic_inventory_pickup,
        drop_sound = item_sounds.plastic_inventory_move,
        inventory_move_sound = item_sounds.plastic_inventory_move,
        stack_size = 100,
        weight = 500,
    },
    -- Insulated cable recipe
    {
        type = "recipe",
        name = "kp_hpm-insulated-cable",
        category = "electronics",
        enabled = true,
        energy_required = 2,
        ingredients = {
            {type = "item", name = "copper-cable", amount = 4},
            {type = "item", name = "kp_hpm-rubber", amount = 1}
        },
        results = {{type = "item", name = "kp_hpm-insulated-cable", amount = 1}}
    },
    -- Compound cable
    {
        type = "item",
        name = "kp_hpm-compound-cable",
        subgroup = "intermediate-product",
        order = "a[basic-intermediates]-cb[compound-cable]",
        icon = icon_graphic "large-cable.png",
        icon_size = 64,
        pick_sound = item_sounds.plastic_inventory_pickup,
        drop_sound = item_sounds.plastic_inventory_move,
        inventory_move_sound = item_sounds.plastic_inventory_move,
        stack_size = 50,
        weight = 1000,
    },
    -- Compound cable recipe
    {
        type = "recipe",
        name = "kp_hpm-compound-cable",
        category = "electronics",
        enabled = true,
        energy_required = 15,
        ingredients = {
            {type = "fluid", name = "lubricant", amount = 100},
            {type = "item", name = "kp_hpm-insulated-cable", amount = 6},
            {type = "item", name = "kp_hpm-rubber", amount = 20},
            {type = "item", name = "steel-plate", amount = 5},
        },
        results = {{type = "item", name = "kp_hpm-compound-cable", amount = 1}}
    },
    -- Zinc ore
    {
        type = "item",
        name = "kp_hpm-zinc-ore",
        subgroup = "raw-resource",
        order = "fa[zinc-ore]",
        icon = icon_graphic "zinc-ore-3.png",
        icon_size = 64,
        pictures = {
            {filename = icon_graphic "zinc-ore.png", size = 64, scale = 0.5, mipmap_count = 4},
            {filename = icon_graphic "zinc-ore-1.png", size = 64, scale = 0.5, mipmap_count = 4},
            {filename = icon_graphic "zinc-ore-2.png", size = 64, scale = 0.5, mipmap_count = 4},
            {filename = icon_graphic "zinc-ore-3.png", size = 64, scale = 0.5, mipmap_count = 4},
        },
        stack_size = 50,
        weight = 2000,
        pick_sound = item_sounds.resource_inventory_pickup,
        drop_sound = item_sounds.resource_inventory_move,
        inventory_move_sound = item_sounds.resource_inventory_move,
        random_tint_color = {0.93, 0.93, 0.93},
    },
    defineZincResource(),
    -- Alloy smelting recipe category
    {
        type = "recipe-category",
        name = "alloy-smelting"
    },
    -- Alloy furnace entity
    defineAlloyFurnaceEntity(),
    -- ALloy furnace item
    defineAlloyFurnaceItem(),
    -- Alloy furnace recipe
    {
        type = "recipe",
        name = "kp_hpm-alloy-furnace",
        enabled = true,
        energy_required = 5,
        ingredients = {
            {type = "item", name = "steel-plate", amount = 10},
            {type = "item", name = "stone-brick", amount = 10},
            {type = "item", name = "electronic-circuit", amount = 2},
        },
        results = {{type = "item", name = "kp_hpm-alloy-furnace", amount = 1}}
    },
    -- Brass plate
    {
        type = "item",
        name = "kp_hpm-brass-plate",
        subgroup = "raw-material",
        order = "ab[alloy-smelting]-a[brass-plate]",
        icon = icon_graphic "brass-plate.png",
        icon_size = 64,
        stack_size = 100,
        weight = 1000,
        pick_sound = item_sounds.metal_small_inventory_pickup,
        drop_sound = item_sounds.metal_small_inventory_move,
        inventory_move_sound = item_sounds.metal_small_inventory_move,
        random_tint_color = {0.93, 0.93, 0.93},
    },
    -- Brass plate recipe
    {
        type = "recipe",
        category = "alloy-smelting",
        name = "kp_hpm-brass-plate",
        enabled = true,
        energy_required = 3.2,
        ingredients = {
            {type = "item", name = "copper-ore", amount = 2},
            {type = "item", name = "kp_hpm-zinc-ore", amount = 1},
        },
        results = {{type = "item", name = "kp_hpm-brass-plate", amount = 1}}
    },
    -- High powered motor item
    defineHighPoweredMotor(), 
    -- High powered motor recipe
    {
        type = "recipe",
        category = "crafting-with-fluid",
        name = "kp_hpm-high-powered-motor",
        enabled = false,
        energy_required = 20,
        ingredients = {
            {type = "item", name = "electric-engine-unit", amount = 4},
            {type = "item", name = "advanced-circuit", amount = 1},
            {type = "item", name = "steel-plate", amount = 10},
            {type = "fluid", name = "lubricant", amount = 100},
            {type = "fluid", name = "kp_hpm-gasoline", amount = 100},
        },
        results = {{type = "item", name = "kp_hpm-high-powered-motor", amount = 1}}
    },
    -- High powered motor technology
    {
        type = "technology",
        name = "kp_hpm-high-powered-motor",
        icon = tech_graphic "high-powered-motor.png",
        icon_size = 256,
        prerequisites = {"kp_hpm-gasoline", "automation-3"},
        effects = {{
            type = "unlock-recipe",
            recipe = "kp_hpm-high-powered-motor"
        }},
        unit = {
            count = 100,
            time = 30,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1},
            },
        }
    },
    -- Hyperium processing item subgroup
    {
        type = "item-subgroup",
        name = "kp_hpm-hyperium-processes",
        group = "intermediate-products",
        order = "q"
    },
    -- Hyperium ore
    {
        type = "item",
        name = "kp_hpm-hyperium-ore",
        subgroup = "kp_hpm-hyperium-processes",
        order = "a[hyperium]-a[hyperium-ore]",
        icon = icon_graphic "hyperium-ore-1.png",
        icon_size = 64,
        pictures = {
            {filename = icon_graphic "hyperium-ore.png", size = 64, scale = 0.5, mipmap_count = 4},
            {filename = icon_graphic "hyperium-ore-1.png", size = 64, scale = 0.5, mipmap_count = 4},
            {filename = icon_graphic "hyperium-ore-2.png", size = 64, scale = 0.5, mipmap_count = 4},
            {filename = icon_graphic "hyperium-ore-3.png", size = 64, scale = 0.5, mipmap_count = 4},
        },
        stack_size = 50,
        weight = 5000,
        pick_sound = item_sounds.resource_inventory_pickup,
        drop_sound = item_sounds.resource_inventory_move,
        inventory_move_sound = item_sounds.resource_inventory_move,
        random_tint_color = {0.93, 0.93, 0.93},
        spoil_ticks = 18000,    -- 5 minutes
        spoil_result = "stone"
    },
    -- Hyperium ore (resource)
    defineHyperiumResource(),
    -- Empty canister
    {
        type = "item",
        name = "kp_hpm-empty-canister",
        subgroup = "kp_hpm-hyperium-processes",
        order = "a[hyperium]-b[empty-canister]",
        icon = icon_graphic "canister.png",
        icon_size = 64,
        pick_sound = data.raw["item"]["rocket-fuel"].pick_sound,
        drop_sound = data.raw["item"]["rocket-fuel"].drop_sound,
        inventory_move_sound = data.raw["item"]["rocket-fuel"].inventory_move_sound,
        stack_size = 5,
    },
    -- Empty canister recipe
    {
        type = "recipe",
        name = "kp_hpm-empty-canister",
        enabled = true,
        energy_required = 20,
        ingredients = {
            {type = "item", name = "steel-plate", amount = 30},
            {type = "item", name = "processing-unit", amount = 2},
        },
        results = {{type = "item", name = "kp_hpm-empty-canister", amount = 1}}
    },
    -- Hyperium canister
    {
        type = "item",
        name = "kp_hpm-hyperium-canister",
        subgroup = "kp_hpm-hyperium-processes",
        order = "a[hyperium]-c[hyperium-canister]",
        icon = icon_graphic "full-canister.png",
        icon_size = 64,
        pick_sound = item_sounds.fuel_cell_inventory_pickup,
        drop_sound = item_sounds.fuel_cell_inventory_move,
        inventory_move_sound = item_sounds.fuel_cell_inventory_move,
        stack_size = 5,
    },
    -- Hyperium canister recipe
    {
        type = "recipe",
        name = "kp_hpm-hyperium-canister",
        category = "advanced-crafting",
        enabled = true,
        energy_required = 5,
        ingredients = {
            {type = "item", name = "kp_hpm-hyperium-ore", amount = 10},
            {type = "item", name = "kp_hpm-empty-canister", amount = 1},
        },
        results = {{type = "item", name = "kp_hpm-hyperium-canister", amount = 1}}
    },
    -- Hydrogen
    {
        type = "fluid",
        name = "kp_hpm-hydrogen",
        subgroup = "fluid",
        order = "c[gas]-a[hydrogen]",
        icon = icon_graphic "hydrogen.png",
        icon_size = 64,
        default_temperature = 15,
        gas_temperature = 15,
        base_color = {0.706, 0.737, 0.784},
        flow_color = {0.922, 0.922, 0.929},
    },
    -- Helium
    {
        type = "fluid",
        name = "kp_hpm-helium",
        subgroup = "fluid",
        order = "c[gas]-b[helium]",
        icon = icon_graphic "helium.png",
        icon_size = 64,
        default_temperature = 15,
        gas_temperature = 15,
        base_color = {0.290, 0.675, 0.714},
        flow_color = {0.522, 0.882, 0.824}
    },
    -- Oxygen
    {
        type = "fluid",
        name = "kp_hpm-oxygen",
        subgroup = "fluid",
        order = "c[gas]-c[oxygen]",
        icon = icon_graphic "oxygen.png",
        icon_size = 64,
        default_temperature = 15,
        gas_temperature = 15,
        base_color = {0.675, 0.224, 0.243},
        flow_color = {0.855, 0.271, 0.227}
    },
    -- Nitrogen
    {
        type = "fluid",
        name = "kp_hpm-nitrogen",
        subgroup = "fluid",
        order = "c[gas]-d[nitrogen]",
        icon = icon_graphic "nitrogen.png",
        icon_size = 64,
        default_temperature = 15,
        gas_temperature = 15,
        base_color = {0.298, 0.310, 0.722},
        flow_color = {0.345, 0.424, 0.906}
    },
    -- Carbon dioxide
    {
        type = "fluid",
        name = "kp_hpm-carbon-dioxide",
        subgroup = "fluid",
        order = "c[gas]-e[carbon-dioxide]",
        icon = icon_graphic "carbon-dioxide.png",
        icon_size = 64,
        default_temperature = 15,
        gas_temperature = 15,
        base_color = {0.2, 0.2, 0.2},
        flow_color = {0.3, 0.3, 0.3}
    },
    -- Argon
    {
        type = "fluid",
        name = "kp_hpm-argon",
        subgroup = "fluid",
        order = "c[gas]-f[argon]",
        icon = icon_graphic "argon.png",
        icon_size = 64,
        default_temperature = 15,
        gas_temperature = 15,
        base_color = {0.490, 0.173, 0.545},
        flow_color = {0.663, 0.251, 0.671}
    },
    {
        type = "recipe-category",
        name = "gas-processing"
    },
    -- Gas machine item
    {
        type = "item",
        name = "kp_hpm-gas-machine",
        subgroup = "production-machine",
        order = "ea[gas-machine]",
        icon = icon_graphic "gas-machine.png",
        icon_size = 64,
        stack_size = 10,
        place_result = "kp_hpm-gas-machine"
    },
    -- Gas machine entity
    {
        type = "assembling-machine",
        name = "kp_hpm-gas-machine",
        order = "z-da[gas-machine]",
        icon = icon_graphic "gas-machine.png",
        icon_size = 64,
        collision_box = {{-2.4, -2.4}, {2.4, 2.4}},
        selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
        drawing_box_vertical_extension = 0.3,
        graphics_set = {
            animation = {
                filename = entity_graphic "gas-machine.png",
                size = 320,
                scale = 0.5,
            }
        },
        minable = {
            mining_time = 0.2,
            result = "kp_hpm-gas-machine",
        },
        flags = {"placeable-neutral", "player-creation"},
        max_health = 350,
        energy_usage = "200kW",
        crafting_speed = 1,
        crafting_categories = {"gas-processing"},
        energy_source = {
            type = "electric", 
            usage_priority = "secondary-input", 
            buffer_capacity = "7.5kW",
            drain = "0.23kW",
            emissions = {pollution = 6}
        },
        fluid_boxes = {
            {
                -- Top-left output
                volume = 1000,
                production_type = "output",
                pipe_connections = {{
                    flow_direction = "output",
                    direction = defines.direction.north,
                    positions = rotated_positions {-1, -2}
                }}
            },
            {
                -- Top-right output
                volume = 1000,
                production_type = "output",
                pipe_connections = {{
                    flow_direction = "output",
                    direction = defines.direction.north,
                    positions = rotated_positions {1, -2}
                }}
            },
            {
                -- Bottom-left output
                volume = 1000,
                production_type = "output",
                pipe_connections = {{
                    flow_direction = "output",
                    direction = defines.direction.south,
                    positions = rotated_positions {-1, 2}
                }}
            },
            {
                -- Bottom-right output
                volume = 1000,
                production_type = "output",
                pipe_connections = {{
                    flow_direction = "output",
                    direction = defines.direction.south,
                    positions = rotated_positions {1, 2}
                }}
            },
            {
                -- Left-top input
                volume = 1000,
                production_type = "input",
                pipe_connections = {{
                    flow_direction = "input",
                    direction = defines.direction.west,
                    positions = rotated_positions {-2, -1}
                }}
            },
            {
                -- Left-bottom input
                volume = 1000,
                production_type = "input",
                pipe_connections = {{
                    flow_direction = "input",
                    direction = defines.direction.west,
                    positions = rotated_positions {-2, 1}
                }}
            },
            {
                -- Right-top input
                volume = 1000,
                production_type = "input",
                pipe_connections = {{
                    flow_direction = "input",
                    direction = defines.direction.east,
                    positions = rotated_positions {2, -1}
                }}
            },
            {
                -- Right-bottom input
                volume = 1000,
                production_type = "input",
                pipe_connections = {{
                    flow_direction = "input",
                    direction = defines.direction.east,
                    positions = rotated_positions {2, 1}
                }}
            },
        }
    },
    -- Air capture recipe
    {
        type = "recipe",
        name = "kp_hpm-air-capture-recipe",
        order = "a[air-capture]",
        category = "gas-processing",
        icon = icon_graphic "nitrogen.png",
        icon_size = 64,
        enabled = true,
        energy_required = 1,
        results = {
            {type = "fluid", name = "kp_hpm-nitrogen", amount = 8},
            {type = "fluid", name = "kp_hpm-oxygen", amount = 2},
            {type = "fluid", name = "kp_hpm-carbon-dioxide", amount = 1},
            {type = "fluid", name = "kp_hpm-argon", amount = 1},
        }
    },
    -- Barrelling item group
    {
        type = "item-group",
        name = "barrelling",
        order = "ca",
        icon = graphic "item-group/barrelling.png",
        icon_size = 128,
    },
    -- Peashooter item
    {
        type = "item",
        name = "kp_hpm-peashooter-turret",
        subgroup = "turret",
        order = "b[turret]-aa[peashooter-turret]",
        icon = icon_graphic "peashooter-turret.png",
        icon_size = 64,
        stack_size = 50,
    },

}

