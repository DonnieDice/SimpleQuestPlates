--=====================================================================================
-- SQP | Simple Quest Plates - options_font.lua
-- Version: 1.0.0
-- Author: DonnieDice
-- Description: Font options tab content
--=====================================================================================

local addonName, SQP = ...

-- Create font settings section
function SQP:CreateFontOptions(content)
    -- Create two-column layout
    local leftColumn = CreateFrame("Frame", nil, content)
    leftColumn:SetPoint("TOPLEFT")
    leftColumn:SetPoint("BOTTOMLEFT")
    leftColumn:SetWidth(320)
    
    local rightColumn = CreateFrame("Frame", nil, content)
    rightColumn:SetPoint("TOPRIGHT")
    rightColumn:SetPoint("BOTTOMRIGHT")
    rightColumn:SetPoint("LEFT", leftColumn, "RIGHT", 20, 0)
    
    -- LEFT COLUMN - Font Settings
    local yOffset = -20
    
    -- Font section title
    local fontTitle = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    fontTitle:SetPoint("TOPLEFT", 20, yOffset)
    fontTitle:SetText("|cff58be81" .. (self.L["OPTIONS_FONT_SETTINGS"] or "Font Settings") .. "|r")
    yOffset = yOffset - 25
    
    -- Font Size
    local fontLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    fontLabel:SetPoint("TOPLEFT", 20, yOffset)
    fontLabel:SetText(self.L["OPTIONS_FONT_SIZE"] or "Font Size")
    
    local fontSlider = self:CreateStyledSlider(leftColumn, 8, 20, 1, 200)
    fontSlider:SetPoint("TOPLEFT", fontLabel, "BOTTOMLEFT", 0, -5)
    fontSlider:SetValue(SQPSettings.fontSize or 12)
    
    local fontValue = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    fontValue:SetPoint("LEFT", fontSlider, "RIGHT", 10, 0)
    fontValue:SetText(tostring(SQPSettings.fontSize or 12))
    
    fontSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        SQP:SetSetting('fontSize', value)
        fontValue:SetText(tostring(value))
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 60
    
    -- Outline Width
    local outlineLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    outlineLabel:SetPoint("TOPLEFT", 20, yOffset)
    outlineLabel:SetText(self.L["OPTIONS_OUTLINE_WIDTH"] or "Outline Width")
    yOffset = yOffset - 25
    
    -- Create outline buttons (only 3 options in WoW)
    local thinButton = self:CreateStyledButton(leftColumn, "None", 80, 25)
    thinButton:SetPoint("TOPLEFT", 20, yOffset)
    
    local normalButton = self:CreateStyledButton(leftColumn, "Normal", 80, 25)
    normalButton:SetPoint("LEFT", thinButton, "RIGHT", 5, 0)
    
    local thickButton = self:CreateStyledButton(leftColumn, "Thick", 80, 25)
    thickButton:SetPoint("LEFT", normalButton, "RIGHT", 5, 0)
    
    -- Create button state update function
    local function UpdateOutlineButtons()
        local width = SQPSettings.outlineWidth or 1
        thinButton:SetAlpha(width == 1 and 1 or 0.6)
        normalButton:SetAlpha(width == 2 and 1 or 0.6)
        thickButton:SetAlpha(width == 3 and 1 or 0.6)
    end
    
    -- Set button scripts
    
    thinButton:SetScript("OnClick", function()
        SQP:SetSetting('outlineWidth', 1)
        SQP:SetSetting('fontOutline', "")
        UpdateOutlineButtons()
        SQP:RefreshAllNameplates()
    end)
    
    normalButton:SetScript("OnClick", function()
        SQP:SetSetting('outlineWidth', 2)
        SQP:SetSetting('fontOutline', "OUTLINE")
        UpdateOutlineButtons()
        SQP:RefreshAllNameplates()
    end)
    
    thickButton:SetScript("OnClick", function()
        SQP:SetSetting('outlineWidth', 3)
        SQP:SetSetting('fontOutline', "THICKOUTLINE")
        UpdateOutlineButtons()
        SQP:RefreshAllNameplates()
    end)
    
    -- Set initial button states
    UpdateOutlineButtons()
    yOffset = yOffset - 40
    
    -- Reset All Font Settings button
    local resetAllBtn = self:CreateStyledButton(leftColumn, "Reset All Font Settings", 160, 25)
    resetAllBtn:SetPoint("TOPLEFT", 20, yOffset)
    resetAllBtn:SetAlpha(0.8)
    resetAllBtn:SetScript("OnClick", function()
        -- Reset all font settings
        SQP:SetSetting('fontSize', 12)
        SQP:SetSetting('fontOutline', "")
        SQP:SetSetting('outlineWidth', 1)
        SQP:SetSetting('killColor', {1, 0.82, 0})
        SQP:SetSetting('itemColor', {0.2, 1, 0.2})
        SQP:SetSetting('percentColor', {0.2, 1, 1})
        
        -- Update UI elements
        fontSlider:SetValue(12)
        fontValue:SetText("12")
        UpdateOutlineButtons()
        
        -- Refresh all nameplates
        SQP:RefreshAllNameplates()
    end)
    
    -- RIGHT COLUMN - Color Settings
    local rightYOffset = -20
    
    -- Color section title
    local colorTitle = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    colorTitle:SetPoint("TOPLEFT", 20, rightYOffset)
    colorTitle:SetText("|cff58be81" .. (self.L["OPTIONS_TEXT_COLORS"] or "Text Colors") .. "|r")
    rightYOffset = rightYOffset - 25
    
    -- Note: Custom colors always enabled
    
    -- Color pickers with reset buttons
    local function CreateColorPicker(parent, label, colorKey, x, y)
        local container = CreateFrame("Frame", nil, parent)
        container:SetSize(250, 25)
        container:SetPoint("TOPLEFT", x, y)
        
        local frame = CreateFrame("Button", nil, container)
        frame:SetSize(20, 20)
        frame:SetPoint("LEFT", 0, 0)
        
        local bg = frame:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetColorTexture(0, 0, 0, 1)
        
        local swatch = frame:CreateTexture(nil, "ARTWORK")
        swatch:SetSize(16, 16)
        swatch:SetPoint("CENTER")
        local defaultColors = {
            killColor = {1, 0.82, 0},
            itemColor = {0.2, 1, 0.2},
            percentColor = {0.2, 1, 1}
        }
        local color = SQPSettings[colorKey] or defaultColors[colorKey]
        swatch:SetColorTexture(unpack(color))
        
        local text = container:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        text:SetPoint("LEFT", frame, "RIGHT", 5, 0)
        text:SetText(label)
        
        -- Reset button
        local resetBtn = self:CreateStyledButton(container, "Reset", 50, 20)
        resetBtn:SetPoint("RIGHT", container, "RIGHT", 0, 0)
        resetBtn:SetAlpha(0.8)
        resetBtn:SetScript("OnClick", function()
            _G.SQPSettings[colorKey] = defaultColors[colorKey]
            SQPSettings[colorKey] = defaultColors[colorKey]
            swatch:SetColorTexture(unpack(defaultColors[colorKey]))
            SQP:RefreshAllNameplates()
        end)
        
        frame:SetScript("OnClick", function()
            local r, g, b = unpack(SQPSettings[colorKey] or defaultColors[colorKey])
            
            local info = {}
            info.r = r
            info.g = g
            info.b = b
            info.hasOpacity = false
            info.swatchFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB()
                _G.SQPSettings[colorKey] = {r, g, b}
                SQPSettings[colorKey] = {r, g, b}
                swatch:SetColorTexture(r, g, b)
                SQP:RefreshAllNameplates()
            end
            info.cancelFunc = function()
                local prevR, prevG, prevB = r, g, b
                _G.SQPSettings[colorKey] = {prevR, prevG, prevB}
                SQPSettings[colorKey] = {prevR, prevG, prevB}
                swatch:SetColorTexture(prevR, prevG, prevB)
                SQP:RefreshAllNameplates()
            end
            
            ColorPickerFrame:SetupColorPickerAndShow(info)
        end)
        
        return container
    end
    
    -- Quest type colors
    CreateColorPicker(rightColumn, self.L["OPTIONS_COLOR_KILL"] or "Kill Quests", "killColor", 20, rightYOffset)
    CreateColorPicker(rightColumn, self.L["OPTIONS_COLOR_ITEM"] or "Item Quests", "itemColor", 20, rightYOffset - 30)
    CreateColorPicker(rightColumn, self.L["OPTIONS_COLOR_PERCENT"] or "Progress Quests", "percentColor", 20, rightYOffset - 60)
    -- Outline color removed - WoW outlines are always black
end