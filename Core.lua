
SLASH_LOOTLOGGER1 = "/lootlogger"
SlashCmdList["LOOTLOGGER"] = function()
    -- toggler hovedvinduet av/på
    if LootLoggerMainFrame:IsShown() then
        LootLoggerMainFrame:Hide()
    else
        LootLoggerMainFrame:Show()
        UpdateLootList()
    end
end
