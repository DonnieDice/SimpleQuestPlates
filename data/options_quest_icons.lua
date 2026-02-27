--=====================================================================================
-- RGX | Simple Quest Plates! - options_quest_icons.lua

-- Author: DonnieDice
-- Description: Quest type icon options tab (visibility, animation, offsets)
--=====================================================================================

local addonName, SQP = ...

function SQP:CreateQuestIconOptions(content)
    if not self.optionControls then self.optionControls = {} end

    local leftColumn = CreateFrame("Frame", nil, content)
    leftColumn:SetPoint("TOPLEFT")
    leftColumn:SetPoint("BOTTOMLEFT")
    leftColumn:SetWidth(300)

    local rightColumn = CreateFrame("Frame", nil, content)
    rightColumn:SetPoint("TOPRIGHT")
    rightColumn:SetPoint("BOTTOMRIGHT")
    rightColumn:SetPoint("LEFT", leftColumn, "RIGHT", 20, 0)

    -- ── LEFT COLUMN: Toggles + Kill offsets ──────────────────────────────────
    local yOffset = -15

    local toggleHeader = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    toggleHeader:SetPoint("TOPLEFT", 20, yOffset)
    toggleHeader:SetText("|cff58be81" .. (self.L["OPTIONS_QUEST_TYPE_ICONS"] or "Quest Type Icons") .. "|r")
    yOffset = yOffset - 22

    local showKillFrame = self:CreateStyledCheckbox(leftColumn,
        self.L["OPTIONS_SHOW_KILL_ICON"] or "Show Kill Icon")
    showKillFrame:SetPoint("TOPLEFT", 20, yOffset)
    showKillFrame.checkbox:SetChecked(SQPSettings.showKillIcon ~= false)
    self.optionControls.showKillIcon = showKillFrame.checkbox
    showKillFrame.checkbox:SetScript("OnClick", function(self)
        SQP:SetSetting('showKillIcon', self:GetChecked())
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 26

    local showLootFrame = self:CreateStyledCheckbox(leftColumn,
        self.L["OPTIONS_SHOW_LOOT_ICON"] or "Show Loot Icon")
    showLootFrame:SetPoint("TOPLEFT", 20, yOffset)
    showLootFrame.checkbox:SetChecked(SQPSettings.showLootIcon ~= false)
    self.optionControls.showLootIcon = showLootFrame.checkbox
    showLootFrame.checkbox:SetScript("OnClick", function(self)
        SQP:SetSetting('showLootIcon', self:GetChecked())
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 26

    local animateQIFrame = self:CreateStyledCheckbox(leftColumn,
        "Animate Quest Icons")
    animateQIFrame:SetPoint("TOPLEFT", 20, yOffset)
    animateQIFrame.checkbox:SetChecked(SQPSettings.animateQuestIcons == true)
    self.optionControls.animateQuestIcons = animateQIFrame.checkbox
    animateQIFrame.checkbox:SetScript("OnClick", function(self)
        SQP:SetSetting('animateQuestIcons', self:GetChecked())
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 34

    -- Kill Icon offsets
    local killHeader = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    killHeader:SetPoint("TOPLEFT", 20, yOffset)
    killHeader:SetText("|cff58be81Kill Icon Position|r")
    yOffset = yOffset - 18

    local function MakeOffsetSlider(parent, labelText, key, defaultVal, yOff)
        local val = SQPSettings[key] ~= nil and SQPSettings[key] or defaultVal
        local lbl = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        lbl:SetPoint("TOPLEFT", 20, yOff)
        lbl:SetText(string.format("%s: %d", labelText, val))
        SQP.optionControls[key .. "Label"] = lbl

        local sl = SQP:CreateStyledSlider(parent, -30, 30, 1, 190)
        sl:SetPoint("TOPLEFT", lbl, "BOTTOMLEFT", 0, -4)
        sl:SetValue(val)
        SQP.optionControls[key] = sl

        sl:SetScript("OnValueChanged", function(self, newVal)
            newVal = math.floor(newVal + 0.5)
            SQP:SetSetting(key, newVal)
            lbl:SetText(string.format("%s: %d", labelText, newVal))
            SQP:RefreshAllNameplates()
        end)
        return yOff - 36
    end

    yOffset = MakeOffsetSlider(leftColumn, "Kill X",  "killIconOffsetX",  12,  yOffset)
    yOffset = MakeOffsetSlider(leftColumn, "Kill Y",  "killIconOffsetY",  12,  yOffset)
    yOffset = yOffset - 6

    -- Reset button at bottom of left column
    local resetBtn = self:CreateStyledButton(leftColumn,
        self.L["OPTIONS_RESET_QUEST_ICONS"] or "Reset Quest Icons", 160, 26)
    resetBtn:SetPoint("TOPLEFT", 20, yOffset)
    resetBtn:SetAlpha(0.8)
    resetBtn:SetScript("OnClick", function()
        SQP:SetSetting('showKillIcon', true)
        SQP:SetSetting('showLootIcon', true)
        SQP:SetSetting('animateQuestIcons', false)
        SQP:SetSetting('killIconOffsetX', 12)
        SQP:SetSetting('killIconOffsetY', 12)
        SQP:SetSetting('lootIconOffsetX', -12)
        SQP:SetSetting('lootIconOffsetY', 12)
        SQP:SetSetting('percentIconOffsetX', 0)
        SQP:SetSetting('percentIconOffsetY', 0)

        if self.optionControls.showKillIcon then self.optionControls.showKillIcon:SetChecked(true) end
        if self.optionControls.showLootIcon then self.optionControls.showLootIcon:SetChecked(true) end
        if self.optionControls.animateQuestIcons then self.optionControls.animateQuestIcons:SetChecked(false) end
        if self.optionControls.killIconOffsetX  then self.optionControls.killIconOffsetX:SetValue(12)  end
        if self.optionControls.killIconOffsetY  then self.optionControls.killIconOffsetY:SetValue(12)  end
        if self.optionControls.lootIconOffsetX  then self.optionControls.lootIconOffsetX:SetValue(-12) end
        if self.optionControls.lootIconOffsetY  then self.optionControls.lootIconOffsetY:SetValue(12)  end
        if self.optionControls.percentIconOffsetX then self.optionControls.percentIconOffsetX:SetValue(0) end
        if self.optionControls.percentIconOffsetY then self.optionControls.percentIconOffsetY:SetValue(0) end

        local function RL(key, val)
            local lbl = self.optionControls[key .. "Label"]
            if lbl then lbl:SetText(string.format("%s: %d", key:match("(%a+)Icon(%a+)$") and
                (key:match("kill") and "Kill" or key:match("loot") and "Loot" or "Pct") .. " " ..
                (key:match("OffsetX$") and "X" or "Y") or key, val)) end
        end
        -- simpler: just refresh, labels update via slider callbacks
        SQP:RefreshAllNameplates()
    end)

    -- ── RIGHT COLUMN: Loot + Percent offsets ─────────────────────────────────
    local rightYOffset = -15

    local lootHeader = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    lootHeader:SetPoint("TOPLEFT", 20, rightYOffset)
    lootHeader:SetText("|cff58be81Loot Icon Position|r")
    rightYOffset = rightYOffset - 18

    local function MakeOffsetSliderR(parent, labelText, key, defaultVal, yOff)
        local val = SQPSettings[key] ~= nil and SQPSettings[key] or defaultVal
        local lbl = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        lbl:SetPoint("TOPLEFT", 20, yOff)
        lbl:SetText(string.format("%s: %d", labelText, val))
        SQP.optionControls[key .. "Label"] = lbl

        local sl = SQP:CreateStyledSlider(parent, -30, 30, 1, 190)
        sl:SetPoint("TOPLEFT", lbl, "BOTTOMLEFT", 0, -4)
        sl:SetValue(val)
        SQP.optionControls[key] = sl

        sl:SetScript("OnValueChanged", function(self, newVal)
            newVal = math.floor(newVal + 0.5)
            SQP:SetSetting(key, newVal)
            lbl:SetText(string.format("%s: %d", labelText, newVal))
            SQP:RefreshAllNameplates()
        end)
        return yOff - 36
    end

    rightYOffset = MakeOffsetSliderR(rightColumn, "Loot X", "lootIconOffsetX", -12, rightYOffset)
    rightYOffset = MakeOffsetSliderR(rightColumn, "Loot Y", "lootIconOffsetY",  12, rightYOffset)
    rightYOffset = rightYOffset - 6

    local percentHeader = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    percentHeader:SetPoint("TOPLEFT", 20, rightYOffset)
    percentHeader:SetText("|cff58be81Percent Icon Position|r")
    rightYOffset = rightYOffset - 18

    local pxVal = SQPSettings.percentIconOffsetX or 0
    local pxLabel = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    pxLabel:SetPoint("TOPLEFT", 20, rightYOffset)
    pxLabel:SetText(string.format("Offset X: %d", pxVal))
    self.optionControls.percentIconOffsetXLabel = pxLabel

    local pxSlider = self:CreateStyledSlider(rightColumn, -30, 30, 1, 190)
    pxSlider:SetPoint("TOPLEFT", pxLabel, "BOTTOMLEFT", 0, -4)
    pxSlider:SetValue(pxVal)
    self.optionControls.percentIconOffsetX = pxSlider
    pxSlider:SetScript("OnValueChanged", function(self, newVal)
        newVal = math.floor(newVal + 0.5)
        SQP:SetSetting('percentIconOffsetX', newVal)
        pxLabel:SetText(string.format("Offset X: %d", newVal))
        if SQP.previewFrame and SQP.previewFrame.questType ~= "percent" and SQP.previewFrame.activatePercentMode then
            SQP.previewFrame.activatePercentMode()
        end
        SQP:RefreshAllNameplates()
    end)
    rightYOffset = rightYOffset - 36

    local pyVal = SQPSettings.percentIconOffsetY or 0
    local pyLabel = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    pyLabel:SetPoint("TOPLEFT", 20, rightYOffset)
    pyLabel:SetText(string.format("Offset Y: %d", pyVal))
    self.optionControls.percentIconOffsetYLabel = pyLabel

    local pySlider = self:CreateStyledSlider(rightColumn, -30, 30, 1, 190)
    pySlider:SetPoint("TOPLEFT", pyLabel, "BOTTOMLEFT", 0, -4)
    pySlider:SetValue(pyVal)
    self.optionControls.percentIconOffsetY = pySlider
    pySlider:SetScript("OnValueChanged", function(self, newVal)
        newVal = math.floor(newVal + 0.5)
        SQP:SetSetting('percentIconOffsetY', newVal)
        pyLabel:SetText(string.format("Offset Y: %d", newVal))
        if SQP.previewFrame and SQP.previewFrame.questType ~= "percent" and SQP.previewFrame.activatePercentMode then
            SQP.previewFrame.activatePercentMode()
        end
        SQP:RefreshAllNameplates()
    end)
end
