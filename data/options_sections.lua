--=====================================================================================
-- SQP | Simple Quest Plates - options_sections.lua
-- Version: 1.0.0
-- Author: DonnieDice
-- Description: Options panel sections and layout
--=====================================================================================

local addonName, SQP = ...
local format = string.format

-- Create panel header section
function SQP:CreatePanelHeader(container)
    local header = CreateFrame("Frame", nil, container, "BackdropTemplate")
    header:SetHeight(100)
    header:SetPoint("TOPLEFT", 10, -10)
    header:SetPoint("TOPRIGHT", -10, -10)
    header:SetBackdrop(self.BACKDROP_DARK)
    header:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    header:SetBackdropBorderColor(unpack(self.SECTION_COLOR))
    
    -- Logo
    local logo = header:CreateTexture(nil, "ARTWORK")
    logo:SetSize(80, 80)
    logo:SetPoint("LEFT", 15, 0)
    logo:SetTexture("Interface\\AddOns\\SimpleQuestPlates\\images\\icon")
    
    -- Title
    local title = header:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("LEFT", logo, "RIGHT", 15, 15)
    title:SetText("|cff58be81S|r|cffffffffimple |cff58be81Q|r|cffffffffuest |cff58be81P|r|cfffffffflates")
    
    -- Set custom font size
    local fontFile, _, fontFlags = title:GetFont()
    title:SetFont(fontFile, 24, fontFlags)
    
    -- Subtitle
    local subtitle = header:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -5)
    subtitle:SetText("Quest tracking overlay for enemy nameplates")
    subtitle:SetTextColor(0.7, 0.7, 0.7)
    
    -- Version
    local version = header:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    version:SetPoint("TOPRIGHT", header, "TOPRIGHT", -15, -15)
    version:SetText("v" .. (SQP.VERSION or "1.0.0"))
    version:SetTextColor(0.5, 0.5, 0.5)
    
    return header
end

-- Create content area
function SQP:CreateContentArea(container)
    local header = container:GetChildren() -- Get the header we just created
    
    local content = CreateFrame("Frame", nil, container, "BackdropTemplate")
    content:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)
    content:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -10, 10)
    content:SetBackdrop(self.BACKDROP_DARK)
    content:SetBackdropColor(0.08, 0.08, 0.08, 0.8)
    content:SetBackdropBorderColor(0.2, 0.2, 0.2)
    
    return content
end

-- Create display settings section
function SQP:CreateDisplayOptions(content)
    local yOffset = -20
    
    -- Enable checkbox
    local enableFrame = self:CreateStyledCheckbox(content, self.L["OPTIONS_ENABLE"] or "Enable Simple Quest Plates")
    enableFrame:SetPoint("TOPLEFT", 20, yOffset)
    enableFrame.checkbox:SetChecked(SQPSettings.enabled)
    enableFrame.checkbox:SetScript("OnClick", function(self)
        SQPSettings.enabled = self:GetChecked()
        if SQPSettings.enabled then
            SQP:Enable()
        else
            SQP:Disable()
        end
    end)
    yOffset = yOffset - 40
    
    -- Section: Display Settings
    local displaySection = content:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    displaySection:SetPoint("TOPLEFT", 20, yOffset)
    displaySection:SetText("|cff58be81" .. (self.L["OPTIONS_DISPLAY"] or "Display Settings") .. "|r")
    yOffset = yOffset - 30
    
    -- Scale setting
    local scaleLabel = content:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    scaleLabel:SetPoint("TOPLEFT", 30, yOffset)
    scaleLabel:SetText(self.L["OPTIONS_SCALE"] or "Icon Scale")
    
    local scaleSlider = self:CreateStyledSlider(content, 0.5, 2.0, 0.1, 200)
    scaleSlider:SetPoint("TOPLEFT", scaleLabel, "BOTTOMLEFT", 0, -5)
    scaleSlider:SetValue(SQPSettings.scale)
    
    local scaleValue = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    scaleValue:SetPoint("LEFT", scaleSlider, "RIGHT", 10, 0)
    scaleValue:SetText(format("%.1f", SQPSettings.scale))
    
    scaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value * 10 + 0.5) / 10
        SQPSettings.scale = value
        scaleValue:SetText(format("%.1f", value))
        SQP:RefreshAllNameplates()
    end)
    
    return yOffset - 60
end

-- Create position settings section
function SQP:CreatePositionOptions(content)
    local yOffset = self:CreateDisplayOptions(content)
    
    -- Section: Position Settings
    local positionSection = content:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    positionSection:SetPoint("TOPLEFT", 20, yOffset)
    positionSection:SetText("|cff58be81" .. (self.L["OPTIONS_POSITION"] or "Position Settings") .. "|r")
    yOffset = yOffset - 30
    
    -- X Offset
    local xLabel = content:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    xLabel:SetPoint("TOPLEFT", 30, yOffset)
    xLabel:SetText(self.L["OPTIONS_OFFSET_X"] or "Horizontal Offset")
    
    local xSlider = self:CreateStyledSlider(content, -50, 50, 1, 200)
    xSlider:SetPoint("TOPLEFT", xLabel, "BOTTOMLEFT", 0, -5)
    xSlider:SetValue(SQPSettings.offsetX)
    
    local xValue = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    xValue:SetPoint("LEFT", xSlider, "RIGHT", 10, 0)
    xValue:SetText(tostring(SQPSettings.offsetX))
    
    xSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        SQPSettings.offsetX = value
        xValue:SetText(tostring(value))
        SQP:RefreshAllNameplates()
    end)
    
    -- Y Offset
    local yLabel = content:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    yLabel:SetPoint("TOPLEFT", xSlider, "BOTTOMLEFT", 0, -20)
    yLabel:SetText(self.L["OPTIONS_OFFSET_Y"] or "Vertical Offset")
    
    local ySlider = self:CreateStyledSlider(content, -50, 50, 1, 200)
    ySlider:SetPoint("TOPLEFT", yLabel, "BOTTOMLEFT", 0, -5)
    ySlider:SetValue(SQPSettings.offsetY)
    
    local yValue = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    yValue:SetPoint("LEFT", ySlider, "RIGHT", 10, 0)
    yValue:SetText(tostring(SQPSettings.offsetY))
    
    ySlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        SQPSettings.offsetY = value
        yValue:SetText(tostring(value))
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 100
    
    -- Anchor selection
    local anchorLabel = content:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    anchorLabel:SetPoint("TOPLEFT", 30, yOffset)
    anchorLabel:SetText(self.L["OPTIONS_ANCHOR"] or "Icon Position")
    yOffset = yOffset - 25
    
    local leftButton = self:CreateStyledButton(content, "Left Side", 90, 25)
    leftButton:SetPoint("TOPLEFT", 30, yOffset)
    leftButton:SetScript("OnClick", function()
        SQPSettings.anchor = "LEFT"
        SQPSettings.relativeTo = "RIGHT"
        SQP:RefreshAllNameplates()
    end)
    
    local rightButton = self:CreateStyledButton(content, "Right Side", 90, 25)
    rightButton:SetPoint("LEFT", leftButton, "RIGHT", 10, 0)
    rightButton:SetScript("OnClick", function()
        SQPSettings.anchor = "RIGHT"
        SQPSettings.relativeTo = "LEFT"
        SQP:RefreshAllNameplates()
    end)
    
    return yOffset - 50
end

-- Create action buttons
function SQP:CreateActionButtons(content)
    local testButton = self:CreateStyledButton(content, self.L["OPTIONS_TEST"] or "Test Detection", 140, 30)
    testButton:SetPoint("BOTTOMLEFT", content, "BOTTOMLEFT", 20, 20)
    testButton:SetScript("OnClick", function()
        SQP:TestQuestDetection()
    end)
    
    local resetButton = self:CreateStyledButton(content, self.L["OPTIONS_RESET"] or "Reset Settings", 140, 30)
    resetButton:SetPoint("LEFT", testButton, "RIGHT", 10, 0)
    resetButton:SetScript("OnClick", function()
        StaticPopup_Show("SQP_RESET_CONFIRM")
    end)
end

-- Create Discord section
function SQP:CreateDiscordSection(content)
    local discordFrame = CreateFrame("Frame", nil, content, "BackdropTemplate")
    discordFrame:SetHeight(60)
    discordFrame:SetPoint("BOTTOMLEFT", content, "BOTTOMLEFT", 20, 60)
    discordFrame:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -20, 60)
    discordFrame:SetBackdrop(self.BACKDROP_DARK)
    discordFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    discordFrame:SetBackdropBorderColor(unpack(self.SECTION_COLOR))
    
    local discordIcon = discordFrame:CreateTexture(nil, "ARTWORK")
    discordIcon:SetSize(40, 40)
    discordIcon:SetPoint("LEFT", 10, 0)
    discordIcon:SetTexture("Interface\\AddOns\\SimpleQuestPlates\\images\\icon")
    discordIcon:SetDesaturated(true)
    
    local discordText = discordFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    discordText:SetPoint("LEFT", discordIcon, "RIGHT", 10, 0)
    discordText:SetText("|cff58be81RGX Mods Community|r\nJoin us at: |cffffffffdiscord.gg/N7kdKAHVVF|r")
    discordText:SetJustifyH("LEFT")
end