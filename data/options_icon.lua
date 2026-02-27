--=====================================================================================
-- RGX | Simple Quest Plates! - options_icon.lua

-- Author: DonnieDice
-- Description: Main icon options tab (position + style)
--=====================================================================================

local addonName, SQP = ...
local format = string.format

function SQP:CreateIconOptions(content)
    if not self.optionControls then self.optionControls = {} end

    local leftColumn = CreateFrame("Frame", nil, content)
    leftColumn:SetPoint("TOPLEFT")
    leftColumn:SetPoint("BOTTOMLEFT")
    leftColumn:SetWidth(300)

    local rightColumn = CreateFrame("Frame", nil, content)
    rightColumn:SetPoint("TOPRIGHT")
    rightColumn:SetPoint("BOTTOMRIGHT")
    rightColumn:SetPoint("LEFT", leftColumn, "RIGHT", 20, 0)

    -- ── LEFT COLUMN: Position ────────────────────────────────────────────────
    local yOffset = -15

    local posLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    posLabel:SetPoint("TOPLEFT", 20, yOffset)
    posLabel:SetText("|cff58be81" .. (self.L["OPTIONS_ICON_POSITION"] or "Icon Position") .. "|r")
    yOffset = yOffset - 22

    -- X Offset
    local xLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    xLabel:SetPoint("TOPLEFT", 20, yOffset)
    xLabel:SetText(self.L["OPTIONS_OFFSET_X"] or "Horizontal Offset")

    local xSlider = self:CreateStyledSlider(leftColumn, -50, 50, 1, 190)
    xSlider:SetPoint("TOPLEFT", xLabel, "BOTTOMLEFT", 0, -5)
    xSlider:SetValue(SQPSettings.offsetX)
    self.optionControls.offsetX = xSlider

    local xValue = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    xValue:SetPoint("LEFT", xSlider, "RIGHT", 8, 0)
    xValue:SetText(tostring(SQPSettings.offsetX))

    xSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        SQP:SetSetting('offsetX', value)
        xValue:SetText(tostring(value))
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 48

    -- Y Offset
    local yLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    yLabel:SetPoint("TOPLEFT", 20, yOffset)
    yLabel:SetText(self.L["OPTIONS_OFFSET_Y"] or "Vertical Offset")

    local ySlider = self:CreateStyledSlider(leftColumn, -50, 50, 1, 190)
    ySlider:SetPoint("TOPLEFT", yLabel, "BOTTOMLEFT", 0, -5)
    ySlider:SetValue(SQPSettings.offsetY)
    self.optionControls.offsetY = ySlider

    local yValue = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    yValue:SetPoint("LEFT", ySlider, "RIGHT", 8, 0)
    yValue:SetText(tostring(SQPSettings.offsetY))

    ySlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        SQP:SetSetting('offsetY', value)
        yValue:SetText(tostring(value))
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 48

    -- Nameplate side
    local anchorLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    anchorLabel:SetPoint("TOPLEFT", 20, yOffset)
    anchorLabel:SetText(self.L["OPTIONS_ANCHOR"] or "Nameplate Side")
    yOffset = yOffset - 22

    local leftBtn  = self:CreateStyledButton(leftColumn, "Left Side",  90, 25)
    local rightBtn = self:CreateStyledButton(leftColumn, "Right Side", 90, 25)
    leftBtn:SetPoint("TOPLEFT", 20, yOffset)
    rightBtn:SetPoint("LEFT", leftBtn, "RIGHT", 8, 0)
    self.optionControls.anchorButtons = {left = leftBtn, right = rightBtn}

    local function UpdateAnchorButtons()
        leftBtn:SetAlpha( SQPSettings.anchor == "RIGHT" and 1 or 0.6)
        rightBtn:SetAlpha(SQPSettings.anchor == "LEFT"  and 1 or 0.6)
    end
    self.optionControls.updateAnchorButtons = UpdateAnchorButtons
    UpdateAnchorButtons()

    leftBtn:SetScript("OnClick", function()
        SQP:SetSetting('anchor', "RIGHT")
        SQP:SetSetting('relativeTo', "LEFT")
        UpdateAnchorButtons()
        SQP:RefreshAllNameplates()
    end)
    rightBtn:SetScript("OnClick", function()
        SQP:SetSetting('anchor', "LEFT")
        SQP:SetSetting('relativeTo', "RIGHT")
        UpdateAnchorButtons()
        SQP:RefreshAllNameplates()
    end)

    -- ── RIGHT COLUMN: Style ──────────────────────────────────────────────────
    local rightYOffset = -15

    local styleLabel = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    styleLabel:SetPoint("TOPLEFT", 20, rightYOffset)
    styleLabel:SetText("|cff58be81" .. (self.L["OPTIONS_ICON_STYLE"] or "Icon Style") .. "|r")
    rightYOffset = rightYOffset - 22

    -- Global Scale
    local scaleLabel = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    scaleLabel:SetPoint("TOPLEFT", 20, rightYOffset)
    scaleLabel:SetText(self.L["OPTIONS_GLOBAL_SCALE"] or "Global Scale")

    local scaleSlider = self:CreateStyledSlider(rightColumn, 0.5, 3.0, 0.1, 190)
    scaleSlider:SetPoint("TOPLEFT", scaleLabel, "BOTTOMLEFT", 0, -5)
    scaleSlider:SetValue(SQPSettings.scale)
    self.optionControls.scale = scaleSlider

    local scaleValue = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    scaleValue:SetPoint("LEFT", scaleSlider, "RIGHT", 8, 0)
    scaleValue:SetText(format("%.1f", SQPSettings.scale))

    scaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value * 10 + 0.5) / 10
        SQP:SetSetting('scale', value)
        scaleValue:SetText(format("%.1f", value))
        SQP:RefreshAllNameplates()
    end)
    rightYOffset = rightYOffset - 48

    -- Show Icon Background
    local bgFrame = self:CreateStyledCheckbox(rightColumn,
        self.L["OPTIONS_SHOW_ICON_BG"] or "Show Icon Background")
    bgFrame:SetPoint("TOPLEFT", 20, rightYOffset)
    bgFrame.checkbox:SetChecked(SQPSettings.showIconBackground ~= false)
    self.optionControls.showIconBackground = bgFrame.checkbox
    bgFrame.checkbox:SetScript("OnClick", function(self)
        SQP:SetSetting('showIconBackground', self:GetChecked())
        SQP:RefreshAllNameplates()
    end)
    rightYOffset = rightYOffset - 28

    -- Animate Main Icon
    local animateFrame = self:CreateStyledCheckbox(rightColumn,
        self.L["OPTIONS_ANIMATE_ICON"] or "Animate Main Icon")
    animateFrame:SetPoint("TOPLEFT", 20, rightYOffset)
    animateFrame.checkbox:SetChecked(SQPSettings.animateQuestIcon == true)
    self.optionControls.animateQuestIcon = animateFrame.checkbox
    animateFrame.checkbox:SetScript("OnClick", function(self)
        SQP:SetSetting('animateQuestIcon', self:GetChecked())
        SQP:RefreshAllNameplates()
    end)
    rightYOffset = rightYOffset - 36

    -- Reset Main Icon Settings
    local resetBtn = self:CreateStyledButton(rightColumn,
        self.L["OPTIONS_RESET_MAIN_ICON"] or "Reset Main Icon", 150, 26)
    resetBtn:SetPoint("TOPLEFT", 20, rightYOffset)
    resetBtn:SetAlpha(0.8)
    resetBtn:SetScript("OnClick", function()
        SQP:SetSetting('offsetX', 0)
        SQP:SetSetting('offsetY', 0)
        SQP:SetSetting('anchor', "RIGHT")
        SQP:SetSetting('relativeTo', "LEFT")
        SQP:SetSetting('scale', 1.0)
        SQP:SetSetting('showIconBackground', true)
        SQP:SetSetting('animateQuestIcon', false)

        xSlider:SetValue(0) ; xValue:SetText("0")
        ySlider:SetValue(0) ; yValue:SetText("0")
        scaleSlider:SetValue(1.0) ; scaleValue:SetText("1.0")
        if self.optionControls.showIconBackground then
            self.optionControls.showIconBackground:SetChecked(true)
        end
        if self.optionControls.animateQuestIcon then
            self.optionControls.animateQuestIcon:SetChecked(false)
        end
        UpdateAnchorButtons()
        SQP:RefreshAllNameplates()
    end)
end
