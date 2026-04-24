SLASH_LLTEST1 = "/lltest" -- command for å printe 5 nyeste iemsa i databasen
SlashCmdList["LLTEST"] = function()
    print("=== Loot Database ===")

    local total = #LootLoggerClassicDB.loot
    local startIndex = math.max(total - 4, 1) -- Start fra siste 5 eller 1 hvis det er færre enn 5

    for i = startIndex, total do -- for loop som henter de 5 nyeste itemsa
        local entry = LootLoggerClassicDB.loot[i]
        local itemName = string.match(entry.item, "%[(.-)%]") -- hent navn
        local realLink = select(2, GetItemInfo(itemName)) or entry.item
        print(i .. ": " .. realLink .. " x" .. entry.quantity .. " | " .. entry.time .. " | " .. entry.date .. " | " .. entry.zone)
    end

    print("=====================")
end




SLASH_LLHISTORY1 = "/llhistory" -- chat command for å printe alt
SlashCmdList["LLHISTORY"] = function()

    print("=== Loot Database ===")

    for i, entry in ipairs(LootLoggerClassicDB.loot) do local itemName = string.match(entry.item, "%[(.-)%]") -- hent navn 
        local realLink = select(2, GetItemInfo(itemName)) or entry.item print(i .. ": " .. realLink .. " x" .. entry.quantity .. " | " .. entry.time .. " | " .. entry.date .. " | " .. entry.zone) 
    end

    print("=====================")
end
    

SLASH_LLCLEAR1 = "/llclear"
SlashCmdList["LLCLEAR"] = function()
    if LootLoggerClassicDB and LootLoggerClassicDB.loot then
        LootLoggerClassicDB.loot = {}
        print("Loot database cleared!")
    else
        print("No loot database found!")
    end
end


SLASH_LOOTLOGGER1 = "/lootlogger"
SlashCmdList["LOOTLOGGER"] = function()
    if LootLoggerMainFrame:IsShown() then
        LootLoggerMainFrame:Hide()
    else
        LootLoggerMainFrame:Show()
        UpdateLootList()
    end
end