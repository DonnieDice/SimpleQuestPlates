--=====================================================================================
-- RGX | Simple Quest Plates! - options_about.lua

-- Author: DonnieDice
-- Description: About tab (compact)
--=====================================================================================

local addonName, SQP = ...

function SQP:CreateAboutSection(content)
    local yOffset = -20

    -- Title
    local aboutTitle = content:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    aboutTitle:SetPoint("TOPLEFT", 20, yOffset)
    aboutTitle:SetText("|cff8B1538RGX |cff58be81Simple Quest Plates!|r")
    yOffset = yOffset - 26

    -- Version / Author / Contact box
    local infoFrame = CreateFrame("Frame", nil, content, "BackdropTemplate")
    infoFrame:SetHeight(70)
    infoFrame:SetPoint("TOPLEFT", 20, yOffset)
    infoFrame:SetPoint("TOPRIGHT", -20, yOffset)
    infoFrame:SetBackdrop(self.BACKDROP_DARK)
    infoFrame:SetBackdropColor(0.08, 0.08, 0.08, 0.8)
    infoFrame:SetBackdropBorderColor(0.3, 0.3, 0.3)

    local versionText = infoFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    versionText:SetPoint("TOPLEFT", infoFrame, "TOPLEFT", 12, -10)
    versionText:SetText("Version: |cff58be81" .. (SQP.VERSION or "1.0.0") .. "|r")

    local authorText = infoFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    authorText:SetPoint("TOPLEFT", versionText, "BOTTOMLEFT", 0, -4)
    authorText:SetText("Author: |cff58be81DonnieDice|r   Contact: |cff888888donniedice@protonmail.com|r")
    yOffset = yOffset - 80

    -- Discord box
    local discordFrame = CreateFrame("Frame", nil, content, "BackdropTemplate")
    discordFrame:SetHeight(60)
    discordFrame:SetPoint("TOPLEFT", 20, yOffset)
    discordFrame:SetPoint("TOPRIGHT", -20, yOffset)
    discordFrame:SetBackdrop(self.BACKDROP_DARK)
    discordFrame:SetBackdropColor(0.08, 0.08, 0.12, 0.9)
    discordFrame:SetBackdropBorderColor(unpack(self.SECTION_COLOR))

    local discordIcon = discordFrame:CreateTexture(nil, "ARTWORK")
    discordIcon:SetSize(36, 36)
    discordIcon:SetPoint("LEFT", 12, 0)
    discordIcon:SetTexture("Interface\\AddOns\\SimpleQuestPlates\\images\\icon")

    local discordTitle = discordFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    discordTitle:SetPoint("TOPLEFT", discordIcon, "TOPRIGHT", 10, -4)
    discordTitle:SetText("|cff58be81RGX Mods Community|r")

    local discordLink = discordFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    discordLink:SetPoint("TOPLEFT", discordTitle, "BOTTOMLEFT", 0, -4)
    discordLink:SetText("|cffffffffdiscord.gg/N7kdKAHVVF|r")
end
