
local eventFrame = CreateFrame("Frame") -- egen event-frame for loot-detektering
eventFrame:RegisterEvent("CHAT_MSG_LOOT") -- trigges når loot-melding kommer i chat

eventFrame:SetScript("OnEvent", function(self, event, message) -- hovedlogikk for parsing av loot

    local playerName = UnitName("player") -- brukes for å sjekke meldinger i party/raid-format

    -- Sjekk om loot tilhører spilleren
    if not (string.find(message, "You receive loot") or string.find(message, playerName .. " receives loot")) then
        return
    end

    -- Få item-link og quantity
    -- Classic chat-loot har ofte format som:
    --  - "You receive loot: [Item] (x3)"
    --  - "You receive loot: [Item] x3"
    local itemLink = string.match(message, "(%b[])")
    local quantityStr =
        string.match(message, "%(x(%d+)%)") -- (x3)
        or string.match(message, "x(%d+)") -- x3
        or nil
    if not itemLink then
        return
    end
    local quantity = tonumber(quantityStr) or 1

    -- Logg for debug
    print("Loot detected:", itemLink, "x"..quantity)

    -- Legg inn i database
    

    -- Oppdater UI-tall mens vinduet er åpent
    if LootLoggerMainFrame and LootLoggerMainFrame:IsShown() and UpdateLootList then
        UpdateLootList()
    end

end)