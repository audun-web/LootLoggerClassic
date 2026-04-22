
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

tinsert(UISpecialFrames, "LootLoggerMainFrame")

local closeButton = CreateFrame("Button", nil, LootLoggerMainFrame, "UIPanelCloseButton")

closeButton:SetSize(32, 32)
closeButton:SetPoint("TOPRIGHT", LootLoggerFrame, "TOPRIGHT", -5, -5)