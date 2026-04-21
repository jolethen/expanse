-- 1. KILL NATURAL ORE SPAWNING
minetest.register_on_mods_loaded(function()
    for _, ore in pairs(minetest.registered_ores) do
        -- Check if the ore belongs to any of your mineral mods
        if ore.ore:find("abismal:") or 
           ore.ore:find("adamantita:") or 
           ore.ore:find("clorofita:") or 
           ore.ore:find("cobalto:") or 
           ore.ore:find("esmralda:") or 
           ore.ore:find("obsidiana:") or 
           ore.ore:find("titanio:") or 
           ore.ore:find("tugsteno:") then
           
            -- Move spawn range to a place that doesn't exist
            ore.y_min = 31000
            ore.y_max = 31000
        end
    end
end)

-- 2. RESPONDER LOGIC
-- Register a universal placeholder node
minetest.register_node("z_ore_manager:empty", {
    description = "Regenerating...",
    tiles = {"default_cobble.png^[brighten"},
    groups = {not_in_creative_inventory = 1, cracky = 3},
    on_timer = function(pos)
        local meta = minetest.get_meta(pos)
        local original = meta:get_string("ore")
        if original ~= "" then
            minetest.set_node(pos, {name = original})
        end
        return false -- Stop timer
    end,
})

-- Override all nodes in those mods to use the timer
minetest.register_on_mods_loaded(function()
    local target_prefixes = {
        "abismal:", "adamantita:", "clorofita:", "cobalto:", 
        "esmralda:", "obsidiana:", "titanio:", "tugsteno:"
    }

    for name, def in pairs(minetest.registered_nodes) do
        for _, prefix in ipairs(target_prefixes) do
            if name:find(prefix) and (name:find("ore") or name:find("stone_with")) then
                minetest.override_item(name, {
                    after_dig_node = function(pos, oldnode)
                        minetest.set_node(pos, {name = "z_ore_manager:empty"})
                        local meta = minetest.get_meta(pos)
                        meta:set_string("ore", oldnode.name)
                        minetest.get_node_timer(pos):start(20) -- Set your time here
                    end,
                })
            end
        end
    end
end)
