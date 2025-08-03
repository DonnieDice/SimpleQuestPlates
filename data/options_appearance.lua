--=====================================================================================
-- SQP | Simple Quest Plates - options_appearance.lua
-- Version: 1.0.0
-- Author: DonnieDice
-- Description: Appearance options tab content
--=====================================================================================

local addonName, SQP = ...

-- Create font and color settings section
function SQP:CreateAppearanceOptions(content)
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
    local fontTitle = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    fontTitle:SetPoint("TOPLEFT", 20, yOffset)
    fontTitle:SetText("|cff58be81" .. (self.L["OPTIONS_FONT_SETTINGS"] or "Font Settings") .. "|r")
    yOffset = yOffset - 30
    
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
        SQPSettings.fontSize = value
        fontValue:SetText(tostring(value))
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 60
    
    -- Font Outline Style
    local outlineLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    outlineLabel:SetPoint("TOPLEFT", 20, yOffset)
    outlineLabel:SetText(self.L["OPTIONS_FONT_OUTLINE"] or "Outline Style")
    yOffset = yOffset - 25
    
    local outlineOptions = {"NONE", "OUTLINE", "THICKOUTLINE"}
    local outlineButtons = {}
    
    for i, outline in ipairs(outlineOptions) do
        local btn = self:CreateStyledButton(leftColumn, outline, 80, 20)
        btn:SetPoint("TOPLEFT", 20 + ((i-1) * 85), yOffset)
        btn.outline = outline
        
        btn:SetScript("OnClick", function()
            SQPSettings.fontOutline = outline
            SQP:RefreshAllNameplates()
            -- Update button states
            for _, b in ipairs(outlineButtons) do
                b:SetAlpha(b.outline == outline and 1 or 0.6)
            end
        end)
        
        outlineButtons[i] = btn
        btn:SetAlpha(SQPSettings.fontOutline == outline and 1 or 0.6)
    end
    yOffset = yOffset - 35
    
    -- Outline Color
    local outlineColorLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    outlineColorLabel:SetPoint("TOPLEFT", 20, yOffset)
    outlineColorLabel:SetText(self.L["OPTIONS_OUTLINE_COLOR"] or "Outline Color")
    yOffset = yOffset - 25
    
    -- Create outline color picker inline
    local outlineColorBtn = CreateFrame("Button", nil, leftColumn)
    outlineColorBtn:SetSize(20, 20)
    outlineColorBtn:SetPoint("TOPLEFT", 30, yOffset)
    
    local outlineBg = outlineColorBtn:CreateTexture(nil, "BACKGROUND")
    outlineBg:SetAllPoints()
    outlineBg:SetColorTexture(0, 0, 0, 1)
    
    local outlineSwatch = outlineColorBtn:CreateTexture(nil, "ARTWORK")
    outlineSwatch:SetSize(16, 16)
    outlineSwatch:SetPoint("CENTER")
    local outlineColor = SQPSettings.outlineColor or {0, 0, 0}
    outlineSwatch:SetColorTexture(unpack(outlineColor))
    
    outlineColorBtn:SetScript("OnClick", function()
        local r, g, b = unpack(SQPSettings.outlineColor or {0, 0, 0})
        
        local info = {}
        info.r = r
        info.g = g
        info.b = b
        info.hasOpacity = false
        info.swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB()
            SQPSettings.outlineColor = {r, g, b}
            outlineSwatch:SetColorTexture(r, g, b)
            SQP:RefreshAllNameplates()
        end
        info.cancelFunc = function()
            SQPSettings.outlineColor = {r, g, b}
            outlineSwatch:SetColorTexture(r, g, b)
            SQP:RefreshAllNameplates()
        end
        
        ColorPickerFrame:SetupColorPickerAndShow(info)
    end)
    
    -- Outline color reset button
    local outlineResetBtn = self:CreateStyledButton(leftColumn, "Reset", 50, 20)
    outlineResetBtn:SetPoint("LEFT", outlineColorBtn, "RIGHT", 10, 0)
    outlineResetBtn:SetAlpha(0.8)
    outlineResetBtn:SetScript("OnClick", function()
        SQPSettings.outlineColor = {0, 0, 0}
        outlineSwatch:SetColorTexture(0, 0, 0)
        SQP:RefreshAllNameplates()
    end)
    
    yOffset = yOffset - 40
    
    -- Font reset all button
    local fontResetBtn = self:CreateStyledButton(leftColumn, "Reset All Font Settings", 160, 25)
    fontResetBtn:SetPoint("TOPLEFT", 20, yOffset)
    fontResetBtn:SetAlpha(0.8)
    fontResetBtn:SetScript("OnClick", function()
        SQPSettings.fontSize = 12
        SQPSettings.fontOutline = "OUTLINE"
        SQPSettings.outlineColor = {0, 0, 0}
        fontSlider:SetValue(12)
        fontValue:SetText("12")
        outlineSwatch:SetColorTexture(0, 0, 0)
        -- Update outline buttons
        for _, b in ipairs(outlineButtons) do
            b:SetAlpha(b.outline == "OUTLINE" and 1 or 0.6)
        end
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 40
    
    -- RIGHT COLUMN - Color Settings
    local rightYOffset = -20
    
    -- Color section title
    local colorTitle = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    colorTitle:SetPoint("TOPLEFT", 20, rightYOffset)
    colorTitle:SetText("|cff58be81" .. (self.L["OPTIONS_COLORS"] or "Colors") .. "|r")
    rightYOffset = rightYOffset - 30
    
    -- Enable custom colors checkbox
    local customColorFrame = self:CreateStyledCheckbox(rightColumn, self.L["OPTIONS_CUSTOM_COLORS"] or "Use Custom Colors")
    customColorFrame:SetPoint("TOPLEFT", 20, rightYOffset)
    customColorFrame.checkbox:SetChecked(SQPSettings.customColors)
    customColorFrame.checkbox:SetScript("OnClick", function(self)
        SQPSettings.customColors = self:GetChecked()
        SQP:RefreshAllNameplates()
    end)
    rightYOffset = rightYOffset - 35
    
    -- Color pickers function
    local function CreateColorPicker(parent, label, colorKey, x, y)
        local container = CreateFrame("Frame", nil, parent)
        container:SetSize(200, 25)
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
            percentColor = {0.2, 1, 1},
            iconTintColor = {1, 1, 1}
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
                SQPSettings[colorKey] = {r, g, b}
                swatch:SetColorTexture(r, g, b)
                SQP:RefreshAllNameplates()
            end
            info.cancelFunc = function()
                local prevR, prevG, prevB = r, g, b
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
    rightYOffset = rightYOffset - 90
    
    -- Icon style section in left column
    local iconLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    iconLabel:SetPoint("TOPLEFT", 20, yOffset)
    iconLabel:SetText("|cff58be81" .. (self.L["OPTIONS_ICON_STYLE"] or "Icon Style") .. "|r")
    yOffset = yOffset - 30
    
    -- Icon tint checkbox
    local iconTintFrame = self:CreateStyledCheckbox(leftColumn, self.L["OPTIONS_ICON_TINT"] or "Enable Icon Tinting")
    iconTintFrame:SetPoint("TOPLEFT", 20, yOffset)
    iconTintFrame.checkbox:SetChecked(SQPSettings.iconTint)
    iconTintFrame.checkbox:SetScript("OnClick", function(self)
        SQPSettings.iconTint = self:GetChecked()
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 35
    
    -- Icon tint color picker in right column
    CreateColorPicker(rightColumn, self.L["OPTIONS_ICON_COLOR"] or "Icon Tint Color", "iconTintColor", 20, rightYOffset)
end