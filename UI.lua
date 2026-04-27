
local LootLoggerFrame = CreateFrame("Frame", "LootLoggerMainFrame", UIParent, "BackdropTemplate") -- main frame

LootLoggerFrame:SetSize(700, 400) -- størrelse
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


-- Item header
local itemHeader = LootLoggerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
itemHeader:SetPoint("TOPLEFT", LootLoggerFrame, "TOPLEFT", 40, -35)
itemHeader:SetText("Item")

-- Time header
local timeHeader = LootLoggerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
timeHeader:SetPoint("TOPLEFT", LootLoggerFrame, "TOPLEFT", 350, -35)
timeHeader:SetText("Time")

-- Zone header
local zoneHeader = LootLoggerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
zoneHeader:SetPoint("TOPLEFT", LootLoggerFrame, "TOPLEFT", 450, -35)
zoneHeader:SetText("Zone")

local totalText = LootLoggerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
totalText:SetPoint("TOPRIGHT", LootLoggerFrame, "TOPRIGHT", -40, -20)


function UpdateLootList()

    -- Rydd gamle entries
    for i, child in ipairs({content:GetChildren()}) do
        child:Hide()
    end

    local yOffset = -10 -- mellomrom fra toppen

    for i = #LootLoggerClassicDB.loot, 1, -1 do -- for alle items, baklengs
        local entry = LootLoggerClassicDB.loot[i]

        local row = CreateFrame("Button", nil, content)
        row:SetSize(600, 25)
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 10, yOffset)

        local itemName = string.match(entry.item, "%[(.-)%]")
        local itemLink = select(2, GetItemInfo(itemName))
        local texture = select(10, GetItemInfo(itemName))

        local itemQuality = itemLink and select(3, GetItemInfo(itemLink)) or 1
        local color = ITEM_QUALITY_COLORS[itemQuality or 1]

        local icon = row:CreateTexture(nil, "ARTWORK")
        icon:SetSize(18, 18)
        icon:SetPoint("LEFT", row, "LEFT", 5, 0)

        if texture then
            icon:SetTexture(texture)
        end

        local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameText:SetPoint("LEFT", row, "LEFT", 30, 0)
        nameText:SetWidth(300)

        nameText:SetText(
            (color.hex or "|cffffffff") ..
            itemName ..
            "|r x" .. entry.quantity
        )

        local timeText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        timeText:SetPoint("LEFT", row, "LEFT", 350, 0)
        timeText:SetText(entry.time)

        local zoneText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        zoneText:SetPoint("LEFT", row, "LEFT", 450, 0)
        zoneText:SetText(entry.zone or "Unknown")

        row.bg = row:CreateTexture(nil, "BACKGROUND")
        row.bg:SetAllPoints()

        row.bg:SetColorTexture(color.r, color.g, color.b, 0.1)

        row.border = CreateFrame("Frame", nil, row, "BackdropTemplate")
        row.border:SetPoint("TOPLEFT", -1, 1)
        row.border:SetPoint("BOTTOMRIGHT", 1, -1)

        row.border:SetBackdrop({
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
        })

        row.border:SetBackdropBorderColor(color.r, color.g, color.b, 0.5)

        row:SetScript("OnClick", function()
            if itemLink then
                GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
                GameTooltip:SetHyperlink(itemLink)
                GameTooltip:Show()
            end
        end)

        row:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
        

        yOffset = yOffset - 28
    end

    content:SetHeight(-yOffset)

    local total = GetTotalItemsLooted()
    totalText:SetText("Total items: " .. total)
end