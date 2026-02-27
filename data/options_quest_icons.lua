--=====================================================================================
-- RGX | Simple Quest Plates! - options_quest_icons.lua
--
-- Author: DonnieDice
-- Description: Quest type icon options tab content
--=====================================================================================

local addonName, SQP = ...

-- Create quest icon settings section
function SQP:CreateQuestIconOptions(content)
    if not self.optionControls then
        self.optionControls = {}
    end

    -- Create two-column layout
    local leftColumn = CreateFrame("Frame", nil, content)
    leftColumn:SetPoint("TOPLEFT")
    leftColumn:SetPoint("BOTTOMLEFT")
    leftColumn:SetWidth(320)

    local rightColumn = CreateFrame("Frame", nil, content)
    rightColumn:SetPoint("TOPRIGHT")
    rightColumn:SetPoint("BOTTOMRIGHT")
    rightColumn:SetPoint("LEFT", leftColumn, "RIGHT", 20, 0)

    -- LEFT COLUMN - Toggles
    local yOffset = -20
    local sectionLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    sectionLabel:SetPoint("TOPLEFT", 20, yOffset)
    sectionLabel:SetText("|cff58be81" .. (self.L["OPTIONS_QUEST_TYPE_ICONS"] or "Quest Type Icons") .. "|r")
    yOffset = yOffset - 20

    local showKillFrame = self:CreateStyledCheckbox(leftColumn, self.L["OPTIONS_SHOW_KILL_ICON"] or "Show Kill Icon")
    showKillFrame:SetPoint("TOPLEFT", 20, yOffset)
    showKillFrame.checkbox:SetChecked(SQPSettings.showKillIcon ~= false)
    self.optionControls.showKillIcon = showKillFrame.checkbox
    showKillFrame.checkbox:SetScript("OnClick", function(self)
        SQP:SetSetting('showKillIcon', self:GetChecked())
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 30

    local showLootFrame = self:CreateStyledCheckbox(leftColumn, self.L["OPTIONS_SHOW_LOOT_ICON"] or "Show Loot Icon")
    showLootFrame:SetPoint("TOPLEFT", 20, yOffset)
    showLootFrame.checkbox:SetChecked(SQPSettings.showLootIcon ~= false)
    self.optionControls.showLootIcon = showLootFrame.checkbox
    showLootFrame.checkbox:SetScript("OnClick", function(self)
        SQP:SetSetting('showLootIcon', self:GetChecked())
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 38

    -- Percent Icon Offset Section
    local percentOffsetHeader = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    percentOffsetHeader:SetPoint("TOPLEFT", 20, yOffset)
    percentOffsetHeader:SetText("|cff58be81" .. (self.L["OPTIONS_PERCENT_ICON_OFFSETS"] or "Percent Icon Offset") .. "|r")
    yOffset = yOffset - 18

    local pxVal = SQPSettings.percentIconOffsetX or 0
    local pxLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    pxLabel:SetPoint("TOPLEFT", 20, yOffset)
    pxLabel:SetText(string.format("%s: %d", self.L["OPTIONS_PERCENT_OFFSET_X"] or "Offset X", pxVal))
    self.optionControls.percentIconOffsetXLabel = pxLabel

    local pxSlider = self:CreateStyledSlider(leftColumn, -30, 30, 1, 200)
    pxSlider:SetPoint("TOPLEFT", pxLabel, "BOTTOMLEFT", 0, -4)
    pxSlider:SetValue(pxVal)
    self.optionControls.percentIconOffsetX = pxSlider
    pxSlider:SetScript("OnValueChanged", function(self, newValue)
        newValue = math.floor(newValue + 0.5)
        SQP:SetSetting('percentIconOffsetX', newValue)
        pxLabel:SetText(string.format("%s: %d", SQP.L["OPTIONS_PERCENT_OFFSET_X"] or "Offset X", newValue))
        if SQP.previewFrame and SQP.previewFrame.questType ~= "percent" and SQP.previewFrame.activatePercentMode then
            SQP.previewFrame.activatePercentMode()
        end
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 36

    local pyVal = SQPSettings.percentIconOffsetY or 0
    local pyLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    pyLabel:SetPoint("TOPLEFT", 20, yOffset)
    pyLabel:SetText(string.format("%s: %d", self.L["OPTIONS_PERCENT_OFFSET_Y"] or "Offset Y", pyVal))
    self.optionControls.percentIconOffsetYLabel = pyLabel

    local pySlider = self:CreateStyledSlider(leftColumn, -30, 30, 1, 200)
    pySlider:SetPoint("TOPLEFT", pyLabel, "BOTTOMLEFT", 0, -4)
    pySlider:SetValue(pyVal)
    self.optionControls.percentIconOffsetY = pySlider
    pySlider:SetScript("OnValueChanged", function(self, newValue)
        newValue = math.floor(newValue + 0.5)
        SQP:SetSetting('percentIconOffsetY', newValue)
        pyLabel:SetText(string.format("%s: %d", SQP.L["OPTIONS_PERCENT_OFFSET_Y"] or "Offset Y", newValue))
        if SQP.previewFrame and SQP.previewFrame.questType ~= "percent" and SQP.previewFrame.activatePercentMode then
            SQP.previewFrame.activatePercentMode()
        end
        SQP:RefreshAllNameplates()
    end)

    -- RIGHT COLUMN - Tint + Offsets
    local rightYOffset = -20

    local tintFrame = self:CreateStyledCheckbox(rightColumn, self.L["OPTIONS_ICON_TINT_QUEST"] or "Enable Quest Icon Tinting")
    tintFrame:SetPoint("TOPLEFT", 20, rightYOffset)
    tintFrame.checkbox:SetChecked(SQPSettings.iconTintQuest == true)
    self.optionControls.iconTintQuest = tintFrame.checkbox
    rightYOffset = rightYOffset - 30

    local iconColorBtn = CreateFrame("Button", nil, rightColumn)
    iconColorBtn:SetSize(20, 20)
    iconColorBtn:SetPoint("TOPLEFT", 30, rightYOffset)

    local iconBg = iconColorBtn:CreateTexture(nil, "BACKGROUND")
    iconBg:SetAllPoints()
    iconBg:SetColorTexture(0, 0, 0, 1)

    local iconSwatch = iconColorBtn:CreateTexture(nil, "ARTWORK")
    iconSwatch:SetSize(16, 16)
    iconSwatch:SetPoint("CENTER")
    local iconColor = SQPSettings.iconTintQuestColor or {1, 1, 1}
    iconSwatch:SetColorTexture(unpack(iconColor))

    local iconColorText = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    iconColorText:SetPoint("LEFT", iconColorBtn, "RIGHT", 5, 0)
    iconColorText:SetText(self.L["OPTIONS_ICON_COLOR_QUEST"] or "Quest Icon Tint Color")

    local iconResetBtn = self:CreateStyledButton(rightColumn, "Reset", 50, 20)
    iconResetBtn:SetPoint("LEFT", iconColorText, "RIGHT", 10, 0)
    iconResetBtn:SetAlpha(0.8)
    iconResetBtn:SetScript("OnClick", function()
        if not SQPSettings.iconTintQuest then return end
        SQP:SetSetting('iconTintQuestColor', {1, 1, 1})
        iconSwatch:SetColorTexture(1, 1, 1)
        SQP:RefreshAllNameplates()
    end)

    local function UpdateTintControls()
        local enabled = SQPSettings.iconTintQuest == true
        local alpha = enabled and 1 or 0.4
        iconColorBtn:SetAlpha(alpha)
        iconColorText:SetAlpha(alpha)
        iconResetBtn:SetAlpha(alpha)
    end

    tintFrame.checkbox:SetScript("OnClick", function(self)
        SQP:SetSetting('iconTintQuest', self:GetChecked())
        UpdateTintControls()
        SQP:RefreshAllNameplates()
    end)

    iconColorBtn:SetScript("OnClick", function()
        if not SQPSettings.iconTintQuest then return end
        local r, g, b = unpack(SQPSettings.iconTintQuestColor or {1, 1, 1})

        local info = {}
        info.r = r
        info.g = g
        info.b = b
        info.hasOpacity = false
        info.swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB()
            SQP:SetSetting('iconTintQuestColor', {r, g, b})
            iconSwatch:SetColorTexture(r, g, b)
            SQP:RefreshAllNameplates()
        end
        info.cancelFunc = function()
            SQP:SetSetting('iconTintQuestColor', {r, g, b})
            iconSwatch:SetColorTexture(r, g, b)
            SQP:RefreshAllNameplates()
        end

        ColorPickerFrame:SetupColorPickerAndShow(info)
    end)

    UpdateTintControls()
    rightYOffset = rightYOffset - 40
    local offsetsHeader = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    offsetsHeader:SetPoint("TOPLEFT", 20, rightYOffset)
    offsetsHeader:SetText(self.L["OPTIONS_ICON_OFFSETS"] or "Quest Type Icon Offsets")
    rightYOffset = rightYOffset - 18

    local offsetFrame = CreateFrame("Frame", nil, rightColumn)
    offsetFrame:SetPoint("TOPLEFT", 20, rightYOffset)
    local offsetFrameHeight = 80
    offsetFrame:SetSize(320, offsetFrameHeight)

    local colWidth = 150
    local sliderWidth = 120
    local rowStep = -36

    local function CreateOffsetControl(labelText, x, y, settingKey, defaultValue)
        local value = SQPSettings[settingKey]
        if value == nil then
            value = defaultValue
        end
        local label = offsetFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        label:SetPoint("TOPLEFT", x, y)
        label:SetText(string.format("%s: %d", labelText, value))

        local slider = self:CreateStyledSlider(offsetFrame, -30, 30, 1, sliderWidth)
        slider:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -4)
        slider:SetValue(value)
        self.optionControls[settingKey] = slider

        slider:SetScript("OnValueChanged", function(self, newValue)
            newValue = math.floor(newValue + 0.5)
            SQP:SetSetting(settingKey, newValue)
            label:SetText(string.format("%s: %d", labelText, newValue))
            SQP:RefreshAllNameplates()
        end)

        return label, slider
    end

    local killOffsetXText = self.L["OPTIONS_KILL_ICON_OFFSET_X"] or "Kill X"
    local killOffsetYText = self.L["OPTIONS_KILL_ICON_OFFSET_Y"] or "Kill Y"
    local lootOffsetXText = self.L["OPTIONS_LOOT_ICON_OFFSET_X"] or "Loot X"
    local lootOffsetYText = self.L["OPTIONS_LOOT_ICON_OFFSET_Y"] or "Loot Y"

    local killOffsetXLabel = CreateOffsetControl(killOffsetXText, 0, 0, "killIconOffsetX", 12)
    local killOffsetYLabel = CreateOffsetControl(killOffsetYText, colWidth, 0, "killIconOffsetY", 12)
    local lootOffsetXLabel = CreateOffsetControl(lootOffsetXText, 0, rowStep, "lootIconOffsetX", -12)
    local lootOffsetYLabel = CreateOffsetControl(lootOffsetYText, colWidth, rowStep, "lootIconOffsetY", 12)

    rightYOffset = rightYOffset - offsetFrameHeight - 10

    local resetBtn = self:CreateStyledButton(rightColumn, self.L["OPTIONS_RESET_QUEST_ICONS"] or "Reset Quest Icon Settings", 180, 30)
    resetBtn:SetPoint("TOPLEFT", 20, rightYOffset)
    resetBtn:SetAlpha(0.8)
    resetBtn:SetScript("OnClick", function()
        SQP:SetSetting('showKillIcon', true)
        SQP:SetSetting('showLootIcon', true)
        SQP:SetSetting('killIconOffsetX', 12)
        SQP:SetSetting('killIconOffsetY', 12)
        SQP:SetSetting('lootIconOffsetX', -12)
        SQP:SetSetting('lootIconOffsetY', 12)
        SQP:SetSetting('percentIconOffsetX', 0)
        SQP:SetSetting('percentIconOffsetY', 0)
        SQP:SetSetting('iconTintQuest', false)
        SQP:SetSetting('iconTintQuestColor', {1, 1, 1})

        if self.optionControls.showKillIcon then
            self.optionControls.showKillIcon:SetChecked(true)
        end
        if self.optionControls.showLootIcon then
            self.optionControls.showLootIcon:SetChecked(true)
        end
        if self.optionControls.killIconOffsetX then
            self.optionControls.killIconOffsetX:SetValue(12)
        end
        if self.optionControls.killIconOffsetY then
            self.optionControls.killIconOffsetY:SetValue(12)
        end
        if self.optionControls.lootIconOffsetX then
            self.optionControls.lootIconOffsetX:SetValue(-12)
        end
        if self.optionControls.lootIconOffsetY then
            self.optionControls.lootIconOffsetY:SetValue(12)
        end
        if self.optionControls.percentIconOffsetX then
            self.optionControls.percentIconOffsetX:SetValue(0)
        end
        if self.optionControls.percentIconOffsetY then
            self.optionControls.percentIconOffsetY:SetValue(0)
        end
        if self.optionControls.percentIconOffsetXLabel then
            self.optionControls.percentIconOffsetXLabel:SetText(string.format("%s: %d", SQP.L["OPTIONS_PERCENT_OFFSET_X"] or "Offset X", 0))
        end
        if self.optionControls.percentIconOffsetYLabel then
            self.optionControls.percentIconOffsetYLabel:SetText(string.format("%s: %d", SQP.L["OPTIONS_PERCENT_OFFSET_Y"] or "Offset Y", 0))
        end
        if self.optionControls.iconTintQuest then
            self.optionControls.iconTintQuest:SetChecked(false)
        end
        if killOffsetXLabel then killOffsetXLabel:SetText(string.format("%s: %d", killOffsetXText, 12)) end
        if killOffsetYLabel then killOffsetYLabel:SetText(string.format("%s: %d", killOffsetYText, 12)) end
        if lootOffsetXLabel then lootOffsetXLabel:SetText(string.format("%s: %d", lootOffsetXText, -12)) end
        if lootOffsetYLabel then lootOffsetYLabel:SetText(string.format("%s: %d", lootOffsetYText, 12)) end
        iconSwatch:SetColorTexture(1, 1, 1)
        UpdateTintControls()

        SQP:RefreshAllNameplates()
    end)
end
