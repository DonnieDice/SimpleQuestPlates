--=====================================================================================
-- RGX | Simple Quest Plates! - options_quest_icons.lua

-- Author: DonnieDice
-- Description: Task icon options tab (visibility, animation, offsets)
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

    -- ── Helper: offset slider with inline reset ───────────────────────────────
    local function MakeOffsetSlider(parent, labelText, key, defaultVal, yOff, previewMode)
        local val = SQPSettings[key] ~= nil and SQPSettings[key] or defaultVal
        local lbl = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        lbl:SetPoint("TOPLEFT", 20, yOff)
        lbl:SetText(string.format("%s: %d", labelText, val))
        SQP.optionControls[key .. "Label"] = lbl

        local sl = SQP:CreateStyledSlider(parent, -30, 30, 1, 160)
        sl:SetPoint("TOPLEFT", lbl, "BOTTOMLEFT", 0, -4)
        sl:SetValue(val)
        SQP.optionControls[key] = sl

        local resetBtn = SQP:CreateInlineResetButton(parent, function()
            SQP:SetSetting(key, defaultVal)
            sl:SetValue(defaultVal)
            lbl:SetText(string.format("%s: %d", labelText, defaultVal))
            SQP:RefreshAllNameplates()
        end)
        resetBtn:SetPoint("LEFT", sl, "RIGHT", 5, 0)

        sl:SetScript("OnValueChanged", function(self, newVal)
            newVal = math.floor(newVal + 0.5)
            SQP:SetSetting(key, newVal)
            lbl:SetText(string.format("%s: %d", labelText, newVal))
            -- Auto-switch preview to relevant quest type
            if previewMode and SQP.previewFrame then
                if previewMode == "kill" and SQP.previewFrame.activateKillMode then
                    SQP.previewFrame.activateKillMode()
                elseif previewMode == "loot" and SQP.previewFrame.activateLootMode then
                    SQP.previewFrame.activateLootMode()
                elseif previewMode == "percent" and SQP.previewFrame.activatePercentMode then
                    if SQP.previewFrame.questType ~= "percent" then
                        SQP.previewFrame.activatePercentMode()
                    end
                end
            end
            SQP:RefreshAllNameplates()
        end)
        return yOff - 36
    end

    -- ── LEFT COLUMN: Toggles + Kill offsets ──────────────────────────────────
    local yOffset = -15

    local toggleHeader = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    toggleHeader:SetPoint("TOPLEFT", 20, yOffset)
    toggleHeader:SetText("|cff58be81Task Icons|r")
    yOffset = yOffset - 22

    local showKillFrame = self:CreateStyledCheckbox(leftColumn, "Show Kill Icon")
    showKillFrame:SetPoint("TOPLEFT", 20, yOffset)
    showKillFrame.checkbox:SetChecked(SQPSettings.showKillIcon ~= false)
    self.optionControls.showKillIcon = showKillFrame.checkbox
    showKillFrame.checkbox:SetScript("OnClick", function(self)
        SQP:SetSetting('showKillIcon', self:GetChecked())
        if SQP.previewFrame and SQP.previewFrame.activateKillMode then
            SQP.previewFrame.activateKillMode()
        end
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 26

    local showLootFrame = self:CreateStyledCheckbox(leftColumn, "Show Loot Icon")
    showLootFrame:SetPoint("TOPLEFT", 20, yOffset)
    showLootFrame.checkbox:SetChecked(SQPSettings.showLootIcon ~= false)
    self.optionControls.showLootIcon = showLootFrame.checkbox
    showLootFrame.checkbox:SetScript("OnClick", function(self)
        SQP:SetSetting('showLootIcon', self:GetChecked())
        if SQP.previewFrame and SQP.previewFrame.activateLootMode then
            SQP.previewFrame.activateLootMode()
        end
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 26

    local animateQIFrame = self:CreateStyledCheckbox(leftColumn, "Animate Task Icons")
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

    yOffset = MakeOffsetSlider(leftColumn, "Kill X", "killIconOffsetX", 12,  yOffset, "kill")
    yOffset = MakeOffsetSlider(leftColumn, "Kill Y", "killIconOffsetY", 12,  yOffset, "kill")

    -- ── RIGHT COLUMN: Loot + Percent offsets ─────────────────────────────────
    local rightYOffset = -15

    local lootHeader = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    lootHeader:SetPoint("TOPLEFT", 20, rightYOffset)
    lootHeader:SetText("|cff58be81Loot Icon Position|r")
    rightYOffset = rightYOffset - 18

    rightYOffset = MakeOffsetSlider(rightColumn, "Loot X", "lootIconOffsetX", -12, rightYOffset, "loot")
    rightYOffset = MakeOffsetSlider(rightColumn, "Loot Y", "lootIconOffsetY",  12, rightYOffset, "loot")
    rightYOffset = rightYOffset - 6

    local percentHeader = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    percentHeader:SetPoint("TOPLEFT", 20, rightYOffset)
    percentHeader:SetText("|cff58be81Percent Icon Position|r")
    rightYOffset = rightYOffset - 18

    rightYOffset = MakeOffsetSlider(rightColumn, "Offset X", "percentIconOffsetX", 0, rightYOffset, "percent")
    rightYOffset = MakeOffsetSlider(rightColumn, "Offset Y", "percentIconOffsetY", 0, rightYOffset, "percent")
end
