-- 1. KILL NATURAL ORE SPAWNING
minetest.register_on_mods_loaded(function()
    for _, ore in pairs(minetest.registered_ores) do
        -- Only check the mods currently in your repo
        if ore.ore:find("abismal:") or 
           ore.ore:find("adamantita:") or 
           ore.ore:find("clorofita:") or 
           ore.ore:find("cobalto:") or 
           ore.ore:find("obsidiana:") or 
           ore.ore:find("titanio:") or 
           ore.ore:find("tugsteno:") then
           
            -- Make them impossible to spawn
            ore.y_min = 31000
            ore.y_max = 31000
        end
    end
end)

-- 2. UNIVERSAL PLACEHOLDER
minetest.register_node("z_ore_manager:empty", {
    description = "Regenerating...",
    tiles = {"default_cobble.png^[brighten"},
    groups = {not_in_creative_inventory = 1, cracky = 3},
    on_timer = function(pos)
        local meta = minetest.get_meta(pos)
        local original = meta:get_string("ore")
        if original ~= "" then
            minetest.set_node(pos, {name = original})
            -- Optional: Add a little "pop" sound here if you want that Hypixel vibe
        end
        return false 
    end,
})

-- 3. APPLY TO REMAINING MODS
minetest.register_on_mods_loaded(function()
    local target_prefixes = {
        "abismal:", "adamantita:", "clorofita:", "cobalto:", 
        "obsidiana:", "titanio:", "tugsteno:"
    }

    for name, def in pairs(minetest.registered_nodes) do
        for _, prefix in ipairs(target_prefixes) do
            if name:find(prefix) and (name:find("ore") or name:find("stone_with")) then
                minetest.override_item(name, {
                    after_dig_node = function(pos, oldnode)
                        minetest.set_node(pos, {name = "z_ore_manager:empty"})
                        local meta = minetest.get_meta(pos)
                        meta:set_string("ore", oldnode.name)
                        minetest.get_node_timer(pos):start(20)
                    end,
                })
            end
        end
    end
end)
