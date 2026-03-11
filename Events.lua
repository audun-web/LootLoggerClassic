local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("CHAT_MSG_LOOT")

eventFrame:SetScript("OnEvent", function(self, event, message)

    local playerName = UnitName("player")

    -- Sjekk om loot tilhører spilleren
    if not (string.find(message, "You receive loot") or string.find(message, playerName .. " receives loot")) then
        return
    end

    -- Få item-link og quantity
    local itemLink, quantity = string.match(message, ".*(%b[]).*x?(%d*)")
    quantity = tonumber(quantity) or 1

    -- Logg for debug
    print("Loot detected:", itemLink, "x"..quantity)

    -- Legg inn i database
    LootLoggerClassic_AddLootEntry(itemLink, quantity)

end)