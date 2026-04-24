
local LootLoggerFrame = CreateFrame("Frame", "LootLoggerMainFrame", UIParent, "BackdropTemplate") -- main frame

LootLoggerFrame:SetSize(400, 300) -- størrelse
LootLoggerFrame:SetPoint("CENTER") -- posisjon

LootLoggerFrame:SetBackdrop({ -- utseende
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
})

LootLoggerFrame:SetBackdropColor(0, 0, 0, 0.8) -- gjør bakgrunn litt gjennomsiktig

LootLoggerFrame:Hide()


local titleText = LootLoggerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge") -- tekst

titleText:SetPoint("TOP", LootLoggerFrame, "TOP", 0, -20) -- plassering
titleText:SetText("Loot History")
titleText:SetJustifyH("CENTER")

titleText:SetWidth(300)
titleText:SetWordWrap(true)

tinsert(UISpecialFrames, "LootLoggerMainFrame") -- lukker frame på "esc"

local closeButton = CreateFrame("Button", nil, LootLoggerMainFrame, "UIPanelCloseButton") -- lukke knapp

closeButton:SetSize(32, 32)
closeButton:SetPoint("TOPRIGHT", LootLoggerFrame, "TOPRIGHT", -5, -5)

local scrollFrame = CreateFrame("ScrollFrame", nil, LootLoggerFrame, "UIPanelScrollFrameTemplate") -- lager skrollbar meny med innebygd funksjon i spillfilene
scrollFrame:SetPoint("TOPLEFT", LootLoggerFrame, "TOPLEFT", 10, -50)
scrollFrame:SetPoint("BOTTOMRIGHT", LootLoggerFrame, "BOTTOMRIGHT", -30, 10)


local content = CreateFrame("Frame", nil, scrollFrame) -- child til scrollFrame, det er denne som skroller
content:SetSize(1, 1)

scrollFrame:SetScrollChild(content)


function UpdateLootList()

    -- Rydd gamle entries
    for i, child in ipairs({content:GetChildren()}) do -- for alle items inne i scroll området
        child:Hide() -- sletter gamle UI rows
    end

    local yOffset = -10 -- starter litt under toppen

    for i, entry in ipairs(LootLoggerClassicDB.loot) do -- for alle ting "i rekkefølge"

        local row = CreateFrame("Button", nil, content) -- lager en usynlig knapp, denne brukes for å kunne trykke på items
        row:SetSize(320, 20)
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 10, yOffset)
        
        local text = row:CreateFontString(nil, "OVERLAY", "GameFontNormal") -- lager tekst inni den usynlige knappen
        text:SetPoint("LEFT")
        
        local _, _, itemQuality = GetItemInfo(entry.item) -- henter informasjon om item "rarity"
        local color = ITEM_QUALITY_COLORS[itemQuality or 1]
        
        text:SetText( -- setter tekst til informasjonen vi hentet fra game server
            entry.time .. " - " ..
            (color.hex or "|cffffffff") ..
            entry.item ..
            "|r x" .. entry.quantity
        )
        
        row:SetScript("OnClick", function()
            local itemName = string.match(entry.item, "%[(.-)%]") -- henter item name
            local itemLink = select(2, GetItemInfo(itemName)) -- henter klikkbar link for item til game server
        
            if itemLink then -- viser tooltip
                GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
                GameTooltip:SetHyperlink(itemLink)
                GameTooltip:Show()
            else
                print("Item not cached yet:", itemName)
            end
        end)

        row:SetScript("OnLeave", function() -- gjemmer tooltip når mus forlater item
            GameTooltip:Hide()
        end)

        yOffset = yOffset - 22 -- mellomrom mellom radene
    end

    content:SetHeight(-yOffset) -- høyden til listen basert på høyden til items

end