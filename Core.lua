SLASH_LLTEST1 = "/lltest"
SlashCmdList["LLTEST"] = function()
    print("=== Loot Database ===")
    for i, entry in ipairs(LootLoggerClassicDB.loot) do
        local itemName = string.match(entry.item, "%[(.-)%]") -- hent navn
        local realLink = select(2, GetItemInfo(itemName)) or entry.item
        print(i .. ": " .. realLink .. " x" .. entry.quantity .. " | " .. entry.time .. " | " .. entry.date .. " | " .. entry.zone)
    end
    print("=====================")
end