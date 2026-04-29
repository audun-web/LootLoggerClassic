
local LootLoggerFrame = CreateFrame("Frame", "LootLoggerMainFrame", UIParent, "BackdropTemplate") -- main frame


local currentFilter = "ALL"

local itemSearchQuery = "" -- tekst i søkefeltet (matcher mot itemnavn)
local ITEM_SEARCH_PLACEHOLDER = "Search item..." -- vises når søket er tomt

function PassesFilter(itemQuality) -- funksjon som sjekker rarity

    if currentFilter == "ALL" then
        return true
    end

    if currentFilter == "COMMON" and itemQuality == 1 then
        return true
    end

    if currentFilter == "UNCOMMON" and itemQuality == 2 then
        return true
    end

    if currentFilter == "RARE" and itemQuality == 3 then
        return true
    end

    if currentFilter == "EPIC" and itemQuality == 4 then
        return true
    end

    return false
end

function PassesSearch(itemName) -- funksjon som sjekker itemnavn mot søketekst
    if not itemSearchQuery or itemSearchQuery == "" then
        return true
    end

    if not itemName then
        return false
    end

    local queryLower = string.lower(itemSearchQuery)
    local nameLower = string.lower(itemName)
    return string.find(nameLower, queryLower, 1, true) ~= nil -- substring-match (ikke regex)
end

LootLoggerFrame:SetSize(700, 450) -- størrelse
LootLoggerFrame:SetPoint("CENTER") -- posisjon

LootLoggerFrame:SetBackdrop({ -- utseende
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
})

LootLoggerFrame:SetBackdropColor(0, 0, 0, 0.95) -- gjør bakgrunn litt gjennomsiktig

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
scrollFrame:SetPoint("TOPLEFT", LootLoggerFrame, "TOPLEFT", 10, -70)
scrollFrame:SetPoint("BOTTOMRIGHT", LootLoggerFrame, "BOTTOMRIGHT", -30, 10)


local content = CreateFrame("Frame", nil, scrollFrame) -- child til scrollFrame, det er denne som skroller
content:SetSize(1, 1)

scrollFrame:SetScrollChild(content)


-- Time header
local timeHeader = LootLoggerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
timeHeader:SetPoint("TOPLEFT", LootLoggerFrame, "TOPLEFT", 370, -55)
timeHeader:SetText("Time")

-- Zone header
local zoneHeader = LootLoggerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
zoneHeader:SetPoint("TOPLEFT", LootLoggerFrame, "TOPLEFT", 470, -55)
zoneHeader:SetText("Zone")

-- Item search bar (over item row'ene)
local searchBox = CreateFrame("EditBox", nil, LootLoggerFrame, "InputBoxTemplate")
searchBox:SetSize(290, 18) -- størrelse på søkefeltet
searchBox:SetPoint("TOPLEFT", LootLoggerFrame, "TOPLEFT", 40, -52) -- plasserer søkefeltet over item-radene
searchBox:SetAutoFocus(false) -- auto-focus av
searchBox:SetMultiLine(false) -- kun én linje
searchBox:SetMaxLetters(64) -- maks antall tegn
searchBox:SetText(ITEM_SEARCH_PLACEHOLDER) -- viser placeholder når søket er tomt
searchBox:SetTextColor(0.5, 0.5, 0.5) -- grå farge for placeholder

searchBox:SetScript("OnEditFocusGained", function(self)
    -- når brukeren klikker i feltet: fjern placeholder
    if self:GetText() == ITEM_SEARCH_PLACEHOLDER then
        self:SetText("")
        self:SetTextColor(1, 1, 1)
        itemSearchQuery = ""
        UpdateLootList()
    end
end)

searchBox:SetScript("OnEditFocusLost", function(self)
    -- hvis feltet blir tomt: sett placeholder tilbake
    if self:GetText() == "" then
        self:SetText(ITEM_SEARCH_PLACEHOLDER)
        self:SetTextColor(0.5, 0.5, 0.5)
        itemSearchQuery = ""
        UpdateLootList()
    end
end)

searchBox:SetScript("OnTextChanged", function(self)
    -- mens brukeren skriver: lagre query og oppdater liste
    local text = self:GetText()
    if not text or text == "" or text == ITEM_SEARCH_PLACEHOLDER then
        itemSearchQuery = ""
    else
        itemSearchQuery = text
    end
    UpdateLootList()
end)

searchBox:SetScript("OnEscapePressed", function(self)
    -- ESC: tøm søket og bruk placeholder igjen
    if self:GetText() ~= ITEM_SEARCH_PLACEHOLDER then
        self:SetText(ITEM_SEARCH_PLACEHOLDER)
        self:SetTextColor(0.5, 0.5, 0.5)
        itemSearchQuery = ""
        self:ClearFocus()
        UpdateLootList()
    else
        self:ClearFocus()
    end
end)

local totalText = LootLoggerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
totalText:SetPoint("TOPRIGHT", LootLoggerFrame, "TOPRIGHT", -40, -20)

local dropdown = CreateFrame("Frame", "LootLoggerFilterDropdown", LootLoggerFrame, "UIDropDownMenuTemplate") -- lager filter dropdown
dropdown:SetPoint("TOPLEFT", LootLoggerFrame, "TOPLEFT", 10, -6)

UIDropDownMenu_SetWidth(dropdown, 120) -- setter bredde
UIDropDownMenu_SetText(dropdown, "Filter: All") -- standard tekst når vinduet åpnes

UIDropDownMenu_Initialize(dropdown, function(self, level) -- fyller dropdown med valg

    local function CreateOption(text, value) -- helper for å lage ett valg i menyen
        local info = UIDropDownMenu_CreateInfo()
        info.text = text
        info.func = function() -- hva som skjer når brukeren velger filter
            currentFilter = value -- lagrer aktivt filter
            UIDropDownMenu_SetText(dropdown, "Filter: " .. text) -- oppdaterer teksten i dropdown
            UpdateLootList() -- tegner lista på nytt med valgt filter
        end
        UIDropDownMenu_AddButton(info) -- legger valget inn i menyen
    end

    CreateOption("All", "ALL") 
    CreateOption("Common", "COMMON") 
    CreateOption("Uncommon", "UNCOMMON")
    CreateOption("Rare", "RARE") 
    CreateOption("Epic", "EPIC")

end)


function UpdateLootList() -- bygger opp loot-lista i UI på nytt

    -- skjuler gamle rader før nye bygges
    for _, child in ipairs({content:GetChildren()}) do
        child:Hide()
    end

    local yOffset = -10 -- startposisjon for første rad

    for i = #LootLoggerClassicDB.loot, 1, -1 do -- looper baklengs så nyeste loot vises øverst
        local entry = LootLoggerClassicDB.loot[i]

        local itemName = string.match(entry.item, "%[(.-)%]") or "" -- henter itemnavn uten [] fra loggstrengen
        local itemLink = select(2, GetItemInfo(itemName)) -- prøver å hente item link
        local texture = select(10, GetItemInfo(itemName)) -- prøver å hente item ikon

        local itemQuality = itemLink and select(3, GetItemInfo(itemLink)) or 1 -- fallback til common hvis info mangler

        -- sjekker om item passer valgt filter og søk før rad bygges
        if PassesFilter(itemQuality) and PassesSearch(itemName) then

            local color = ITEM_QUALITY_COLORS[itemQuality or 1] -- farge basert på rarity

            local row = CreateFrame("Button", nil, content) -- en klikkbar rad per item
            row:SetSize(600, 25)
            row:SetPoint("TOPLEFT", content, "TOPLEFT", 10, yOffset)

            -- ikon på venstre side av raden
            local icon = row:CreateTexture(nil, "ARTWORK")
            icon:SetSize(18, 18)
            icon:SetPoint("LEFT", row, "LEFT", 5, 0)

            if texture then
                icon:SetTexture(texture) -- setter item-ikon hvis vi fant et
            end

            -- itemnavn + antall
            local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            nameText:SetPoint("LEFT", row, "LEFT", 30, 0)
            nameText:SetWidth(300)

            nameText:SetText(
                (color.hex or "|cffffffff") ..
                itemName ..
                "|r x" .. entry.quantity
            )

            -- tidspunkt for loot
            local timeText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            timeText:SetPoint("LEFT", row, "LEFT", 350, 0)
            timeText:SetText(entry.time)

            -- sone der looten skjedde
            local zoneText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            zoneText:SetPoint("LEFT", row, "LEFT", 450, 0)
            zoneText:SetText(entry.zone or "Unknown")

            -- svak bakgrunnsfarge etter rarity
            row.bg = row:CreateTexture(nil, "BACKGROUND")
            row.bg:SetAllPoints()
            row.bg:SetColorTexture(color.r, color.g, color.b, 0.1)

            -- tynn border med samme rarity-farge
            row.border = CreateFrame("Frame", nil, row, "BackdropTemplate")
            row.border:SetPoint("TOPLEFT", -1, 1)
            row.border:SetPoint("BOTTOMRIGHT", 1, -1)

            row.border:SetBackdrop({
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                edgeSize = 8,
            })

            row.border:SetBackdropBorderColor(color.r, color.g, color.b, 0.5)

            -- viser item tooltip når raden klikkes
            row:SetScript("OnClick", function()
                if itemLink then
                    GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
                    GameTooltip:SetHyperlink(itemLink)
                    GameTooltip:Show()
                end
            end)

            row:SetScript("OnLeave", function() -- skjuler tooltip når musen forlater raden
                GameTooltip:Hide()
            end)

            yOffset = yOffset - 28 -- flytter neste rad nedover
        end
    end

    content:SetHeight(-yOffset) -- setter høyde på scroll-innholdet basert på antall rader

    totalText:SetText("Total items: " .. GetTotalItemsLooted()) -- oppdaterer total antall loota items
end