Config = {}

Config.Locale = 'en'

Config.Components = {
    pistons = {
        {name = 'Original Piston', item = 'original_piston', durability = 100, torqueModifier = 1.0, maxPressure = 1.0},
        {name = 'Forged Light Piston', item = 'forged_light_piston', durability = 150, torqueModifier = 1.2, maxPressure = 1.2},
        {name = 'Titanium High Compression Piston', item = 'titanium_piston', durability = 200, torqueModifier = 1.5, maxPressure = 1.5}
    },
    conrods = {
        {name = 'Original Conrod', item = 'original_conrod', durability = 100, rpmModifier = 1.0},
        {name = 'H-Beam Reinforced Conrod', item = 'hbeam_conrod', durability = 150, rpmModifier = 1.2},
        {name = 'Titanium Forged Conrod', item = 'titanium_conrod', durability = 200, rpmModifier = 1.5}
    },
    head = {
        {name = 'Original Head', item = 'original_head', durability = 100, speedModifier = 1.0},
        {name = 'Cross Flow Head', item = 'cross_flow_head', durability = 150, speedModifier = 1.2},
        {name = 'Double Overhead Cam Head', item = 'double_cam_head', durability = 200, speedModifier = 1.5}
    },
    valves = {
        {name = 'Original Valve Command', item = 'original_valve', durability = 100, lowEndModifier = 1.0},
        {name = 'Stage 2 Race Valve Command', item = 'stage2_valve', durability = 150, lowEndModifier = 1.2},
        {name = 'Competition 312° Valve Command', item = 'competition_valve', durability = 200, lowEndModifier = 1.5}
    },
    radiator = {
        {name = 'Original Radiator', item = 'original_radiator', durability = 100, heatModifier = 1.0},
        {name = 'Expanded Aluminum Radiator', item = 'expanded_radiator', durability = 150, heatModifier = 0.8},
        {name = 'Triple Core Gel Radiator', item = 'gel_radiator', durability = 200, heatModifier = 0.6}
    },
    turbo = {
        {name = 'T2 Small Turbo', item = 't2_turbo', durability = 100, spoolRate = 0.5, turboLag = 0.8, maxBoost = 0.8},
        {name = 'T3/T4 Hybrid Turbo', item = 't3_turbo', durability = 150, spoolRate = 0.7, turboLag = 0.6, maxBoost = 1.2},
        {name = 'Rolled Flow Turbo', item = 'rolled_turbo', durability = 200, spoolRate = 0.9, turboLag = 0.4, maxBoost = 1.5},
        {name = 'Hot Flow .70 Turbo', item = 'hot_turbo', durability = 250, spoolRate = 1.1, turboLag = 0.3, maxBoost = 2.0},
        {name = 'Bi-Turbo Sequential', item = 'bi_turbo', durability = 300, spoolRate = 1.3, turboLag = 0.2, maxBoost = 2.5},
        {name = 'Pro-Mod Turbo', item = 'pro_turbo', durability = 350, spoolRate = 1.5, turboLag = 0.1, maxBoost = 3.5}
    }
}

Config.Weights = {
    pistons = 1.0,
    conrods = 0.8,
    head = 1.2,
    valves = 0.7,
    radiator = 1.5,
    turbo = 2.0
}

Config.DamageRates = {
    pistons = 0.1,
    conrods = 0.08,
    head = 0.05,
    valves = 0.07,
    radiator = 0.03,
    turbo = 0.15
}

Config.Locales = {
    en = {
        engine_menu = 'Engine Menu',
        install_component = 'Install Component',
        remove_component = 'Remove Component',
        boost_controller = 'Boost Controller',
        set_target_boost = 'Set Target Boost',
        current_boost = 'Current Boost: %.1f BAR',
        max_boost = 'Max Boost: %.1f BAR',
        engine_damage = 'Engine Damage: %.1f%%',
        component_durability = '%s Durability: %.1f%%'
    }
}