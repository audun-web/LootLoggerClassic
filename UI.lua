
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
LootLoggerFrame:SetMovable(true) -- gjør vinduet flyttbart
LootLoggerFrame:EnableMouse(true) -- lar musen starte drag
LootLoggerFrame:RegisterForDrag("LeftButton") -- venstreklikk for dragging

LootLoggerFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)

LootLoggerFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

LootLoggerFrame:SetBackdrop({ -- utseende
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
})

LootLoggerFrame:SetBackdropColor(0, 0, 0, 0.95) -- gjør bakgrunn litt gjennomsiktig

LootLoggerFrame:Hide()

-- minimap button
-- denne knappen festes til Minimap og kan dras rundt kanten
local minimapButton = CreateFrame("Button", "LootLoggerMinimapButton", Minimap)
minimapButton:SetSize(31, 31)
minimapButton:SetFrameStrata("HIGH")
minimapButton:SetFrameLevel(Minimap:GetFrameLevel() + 5)
minimapButton:SetMovable(true)
minimapButton:EnableMouse(true)
minimapButton:RegisterForClicks("LeftButtonUp")
minimapButton:RegisterForDrag("LeftButton")

minimapButton:SetNormalTexture("Interface/ICONS/INV_Misc_Coin_01") -- ikon som vises i knappen
local icon = minimapButton:GetNormalTexture()
icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
icon:ClearAllPoints()
-- klassisk minimap-knapp-offset (matcher tracking-border best visuelt)
icon:SetPoint("TOPLEFT", minimapButton, "TOPLEFT", 7, -5)
icon:SetPoint("BOTTOMRIGHT", minimapButton, "BOTTOMRIGHT", -5, 7)

local border = minimapButton:CreateTexture(nil, "OVERLAY")
border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder") -- gull-ring rundt knappen
border:SetPoint("TOPLEFT", minimapButton, "TOPLEFT", 0, 0)
border:SetSize(53, 53)

minimapButton:SetHighlightTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight") -- blå hover-glow

local function SetMinimapButtonPosition(angleDegrees)
    local angle = math.rad(angleDegrees or 225)
    local radius = 80
    local x = math.cos(angle) * radius
    local y = math.sin(angle) * radius
    minimapButton:ClearAllPoints()
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- lagrer vinkel i SavedVariables så posisjon huskes mellom sessions/reload
if LootLoggerClassicDB.minimapAngle == nil then
    LootLoggerClassicDB.minimapAngle = 225
end
SetMinimapButtonPosition(LootLoggerClassicDB.minimapAngle)

minimapButton:SetScript("OnClick", function()
    if LootLoggerMainFrame:IsShown() then
        LootLoggerMainFrame:Hide()
    else
        LootLoggerMainFrame:Show()
        UpdateLootList()
    end
end)

minimapButton:SetScript("OnMouseDown", function()
    -- liten "pressed" effekt når knappen trykkes inn
    icon:ClearAllPoints()
    icon:SetPoint("TOPLEFT", minimapButton, "TOPLEFT", 8, -6)
    icon:SetPoint("BOTTOMRIGHT", minimapButton, "BOTTOMRIGHT", -6, 8)
end)

minimapButton:SetScript("OnMouseUp", function()
    icon:ClearAllPoints()
    icon:SetPoint("TOPLEFT", minimapButton, "TOPLEFT", 7, -5)
    icon:SetPoint("BOTTOMRIGHT", minimapButton, "BOTTOMRIGHT", -5, 7)
end)

minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText("LootLoggerClassic")
    GameTooltip:AddLine("Left-click: Open/Close loot history", 1, 1, 1)
    GameTooltip:Show()
end)

minimapButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

minimapButton:SetScript("OnDragStart", function(self)
    -- oppdaterer knapp-posisjon kontinuerlig mens venstre museknapp holdes inne
    self:SetScript("OnUpdate", function(btn)
        local mx, my = Minimap:GetCenter()
        local cx, cy = GetCursorPosition()
        local scale = UIParent:GetEffectiveScale()
        cx = cx / scale
        cy = cy / scale

        local angle = math.deg(math.atan2(cy - my, cx - mx))
        if angle < 0 then
            angle = angle + 360
        end

        -- lagre ny vinkel + flytt knapp visuelt
        LootLoggerClassicDB.minimapAngle = angle
        SetMinimapButtonPosition(angle)
    end)
end)

minimapButton:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
end)


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

local sessionText = LootLoggerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
sessionText:SetPoint("TOPRIGHT", LootLoggerFrame, "TOPRIGHT", -40, -38)

-- henter addon-versjon direkte fra .toc
local addonVersion = GetAddOnMetadata("LootLoggerClassic", "Version") or "1.0"
local versionText = LootLoggerFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
versionText:SetPoint("BOTTOMLEFT", LootLoggerFrame, "BOTTOMLEFT", 12, 12)
versionText:SetText("Version: " .. addonVersion)

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