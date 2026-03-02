--=====================================================================================
-- RGX | Simple Quest Plates! - options_about.lua

-- Author: DonnieDice
-- Description: About tab — two-column layout for description, features, commands, community
--=====================================================================================

local addonName, SQP = ...

function SQP:CreateAboutSection(content)
    -- Two-column layout
    local leftColumn = CreateFrame("Frame", nil, content)
    leftColumn:SetPoint("TOPLEFT")
    leftColumn:SetPoint("BOTTOMLEFT")
    leftColumn:SetWidth(310)

    local rightColumn = CreateFrame("Frame", nil, content)
    rightColumn:SetPoint("TOPRIGHT")
    rightColumn:SetPoint("BOTTOMRIGHT")
    rightColumn:SetPoint("LEFT", leftColumn, "RIGHT", 20, 0)

    -- ── LEFT COLUMN ───────────────────────────────────────────────────────────
    local yOffset = -15

    -- Title
    local aboutTitle = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    aboutTitle:SetPoint("TOPLEFT", 20, yOffset)
    aboutTitle:SetText("|cff8B1538RGX |cff58be81Simple Quest Plates!|r")
    yOffset = yOffset - 26

    -- Version / Author info box
    local infoFrame = CreateFrame("Frame", nil, leftColumn, "BackdropTemplate")
    infoFrame:SetHeight(55)
    infoFrame:SetPoint("TOPLEFT", 20, yOffset)
    infoFrame:SetPoint("TOPRIGHT", -5, yOffset)
    infoFrame:SetBackdrop(self.BACKDROP_DARK)
    infoFrame:SetBackdropColor(0.08, 0.08, 0.08, 0.8)
    infoFrame:SetBackdropBorderColor(0.3, 0.3, 0.3)

    local versionText = infoFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    versionText:SetPoint("TOPLEFT", infoFrame, "TOPLEFT", 10, -10)
    versionText:SetText("Version: |cff58be81" .. (SQP.VERSION or "1.0.0") .. "|r   |cffaaaaaaRetail — The War Within|r")

    local authorText = infoFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    authorText:SetPoint("TOPLEFT", versionText, "BOTTOMLEFT", 0, -4)
    authorText:SetText("Author: |cff58be81DonnieDice|r   |cff888888donniedice@protonmail.com|r")
    yOffset = yOffset - 65

    -- Description box
    local descFrame = CreateFrame("Frame", nil, leftColumn, "BackdropTemplate")
    descFrame:SetHeight(58)
    descFrame:SetPoint("TOPLEFT", 20, yOffset)
    descFrame:SetPoint("TOPRIGHT", -5, yOffset)
    descFrame:SetBackdrop(self.BACKDROP_DARK)
    descFrame:SetBackdropColor(0.06, 0.06, 0.06, 0.8)
    descFrame:SetBackdropBorderColor(0.25, 0.25, 0.25)

    local descText = descFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    descText:SetPoint("TOPLEFT", descFrame, "TOPLEFT", 10, -10)
    descText:SetPoint("TOPRIGHT", descFrame, "TOPRIGHT", -10, -10)
    descText:SetJustifyH("LEFT")
    descText:SetText("Displays quest progress icons on enemy nameplates. Supports kill, item, and percentage quest types with per-type colors, tinting, font, and live preview.")
    yOffset = yOffset - 68

    -- Key Features box
    local featFrame = CreateFrame("Frame", nil, leftColumn, "BackdropTemplate")
    featFrame:SetHeight(106)
    featFrame:SetPoint("TOPLEFT", 20, yOffset)
    featFrame:SetPoint("TOPRIGHT", -5, yOffset)
    featFrame:SetBackdrop(self.BACKDROP_DARK)
    featFrame:SetBackdropColor(0.06, 0.06, 0.06, 0.8)
    featFrame:SetBackdropBorderColor(0.25, 0.25, 0.25)

    local featTitle = featFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    featTitle:SetPoint("TOPLEFT", featFrame, "TOPLEFT", 10, -8)
    featTitle:SetText("|cff58be81Key Features|r")

    local featList = featFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    featList:SetPoint("TOPLEFT", featTitle, "BOTTOMLEFT", 0, -4)
    featList:SetPoint("TOPRIGHT", featFrame, "TOPRIGHT", -10, 0)
    featList:SetJustifyH("LEFT")
    featList:SetText(
        "• Kill / item / percent quest tracking — per-type colors\n" ..
        "• Mini kill & loot icons with size, offset, and per-type tinting\n" ..
        "• Icon mode (jellybean) or Text mode (fraction/percent)\n" ..
        "• Per-type font family & size — per-type animate & tint\n" ..
        "• Live preview auto-switches when you change tabs"
    )
    yOffset = yOffset - 116

    -- RGX Community box
    local communityFrame = CreateFrame("Frame", nil, leftColumn, "BackdropTemplate")
    communityFrame:SetHeight(72)
    communityFrame:SetPoint("TOPLEFT", 20, yOffset)
    communityFrame:SetPoint("TOPRIGHT", -5, yOffset)
    communityFrame:SetBackdrop(self.BACKDROP_DARK)
    communityFrame:SetBackdropColor(0.08, 0.08, 0.12, 0.9)
    communityFrame:SetBackdropBorderColor(unpack(self.SECTION_COLOR))

    local discordIcon = communityFrame:CreateTexture(nil, "ARTWORK")
    discordIcon:SetSize(34, 34)
    discordIcon:SetPoint("LEFT", 10, 0)
    discordIcon:SetTexture("Interface\\AddOns\\SimpleQuestPlates\\images\\icon")

    local discordTitle = communityFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    discordTitle:SetPoint("TOPLEFT", discordIcon, "TOPRIGHT", 8, -4)
    discordTitle:SetText("|cff58be81RGX Mods Community|r")

    local discordDesc = communityFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    discordDesc:SetPoint("TOPLEFT", discordTitle, "BOTTOMLEFT", 0, -3)
    discordDesc:SetPoint("TOPRIGHT", communityFrame, "TOPRIGHT", -8, 0)
    discordDesc:SetJustifyH("LEFT")
    discordDesc:SetText("High-quality WoW addons. Join our Discord for\nsupport, feedback, and more!")
    -- Note: community text added to avoid overlap
    local discordLink = communityFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    discordLink:SetPoint("TOPLEFT", discordDesc, "BOTTOMLEFT", 0, -3)
    discordLink:SetText("|cffffffdadiscord.gg/N7kdKAHVVF|r")

    -- ── RIGHT COLUMN ──────────────────────────────────────────────────────────
    local rightYOffset = -15

    -- Slash Commands box
    local cmdFrame = CreateFrame("Frame", nil, rightColumn, "BackdropTemplate")
    cmdFrame:SetHeight(148)
    cmdFrame:SetPoint("TOPLEFT", 0, rightYOffset)
    cmdFrame:SetPoint("TOPRIGHT", -10, rightYOffset)
    cmdFrame:SetBackdrop(self.BACKDROP_DARK)
    cmdFrame:SetBackdropColor(0.06, 0.06, 0.06, 0.8)
    cmdFrame:SetBackdropBorderColor(0.25, 0.25, 0.25)

    local cmdTitle = cmdFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    cmdTitle:SetPoint("TOPLEFT", cmdFrame, "TOPLEFT", 12, -10)
    cmdTitle:SetText("|cff58be81Slash Commands  |cffaaaaaa/sqp|r")

    local cmdList = cmdFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    cmdList:SetPoint("TOPLEFT", cmdTitle, "BOTTOMLEFT", 0, -6)
    cmdList:SetJustifyH("LEFT")
    cmdList:SetText(
        "|cff58be81/sqp|r               Open options panel\n" ..
        "|cff58be81/sqp on|r / |cff58be81off|r   Enable or disable\n" ..
        "|cff58be81/sqp test|r          Test quest detection\n" ..
        "|cff58be81/sqp reset|r         Reset all settings\n" ..
        "|cff58be81/sqp status|r        Show current settings\n" ..
        "|cff58be81/sqp scale 1.2|r     Set icon scale\n" ..
        "|cff58be81/sqp offset 12 3|r   Set X / Y offset"
    )
    rightYOffset = rightYOffset - 158

    -- Tab guide box
    local tabFrame = CreateFrame("Frame", nil, rightColumn, "BackdropTemplate")
    tabFrame:SetHeight(180)
    tabFrame:SetPoint("TOPLEFT", 0, rightYOffset)
    tabFrame:SetPoint("TOPRIGHT", -10, rightYOffset)
    tabFrame:SetBackdrop(self.BACKDROP_DARK)
    tabFrame:SetBackdropColor(0.06, 0.06, 0.06, 0.8)
    tabFrame:SetBackdropBorderColor(0.25, 0.25, 0.25)

    local tabTitle = tabFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    tabTitle:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 12, -10)
    tabTitle:SetText("|cff58be81Options Tabs|r")

    local tabList = tabFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    tabList:SetPoint("TOPLEFT", tabTitle, "BOTTOMLEFT", 0, -6)
    tabList:SetJustifyH("LEFT")
    tabList:SetText(
        "|cff58be81General|r      Enable/disable, combat, chat options\n" ..
        "|cff58be81Main Icon|r   Position, scale, anchor, display style\n" ..
        "|cff58be81Kill|r           Kill icon — color, tint, font, animate\n" ..
        "|cff58be81Loot|r           Loot icon — color, tint, font, animate\n" ..
        "|cff58be81Percent|r     Percent icon — color, tint, font, animate\n\n" ..
        "|cffaaaaaaThe preview auto-switches when you click a tab.\n" ..
        "Per-type tinting and animation are independent\n" ..
        "for each quest type.|r"
    )
end
