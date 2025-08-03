--=====================================================================================
-- SQP | Simple Quest Plates - options_position.lua
-- Version: 1.0.0
-- Author: DonnieDice
-- Description: Position options tab content
--=====================================================================================

local addonName, SQP = ...

-- Create position settings section
function SQP:CreatePositionOptions(content)
    local yOffset = -20
    
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
    
    -- Create buttons first
    local leftButton = self:CreateStyledButton(content, "Left Side", 90, 25)
    leftButton:SetPoint("TOPLEFT", 30, yOffset)
    
    local rightButton = self:CreateStyledButton(content, "Right Side", 90, 25)
    rightButton:SetPoint("LEFT", leftButton, "RIGHT", 10, 0)
    
    -- Create button state update function
    local function UpdateButtonStates()
        if SQPSettings.anchor == "RIGHT" then
            leftButton:SetAlpha(1)
            rightButton:SetAlpha(0.6)
        else
            leftButton:SetAlpha(0.6)
            rightButton:SetAlpha(1)
        end
    end
    
    -- Set button scripts
    leftButton:SetScript("OnClick", function()
        SQPSettings.anchor = "RIGHT"
        SQPSettings.relativeTo = "LEFT"
        SQP:RefreshAllNameplates()
        UpdateButtonStates()
    end)
    
    rightButton:SetScript("OnClick", function()
        SQPSettings.anchor = "LEFT"
        SQPSettings.relativeTo = "RIGHT"
        SQP:RefreshAllNameplates()
        UpdateButtonStates()
    end)
    
    -- Set initial button states
    UpdateButtonStates()
end