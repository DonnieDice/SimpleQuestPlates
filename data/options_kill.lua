--=====================================================================================
-- RGX | Simple Quest Plates! - options_kill.lua

-- Author: DonnieDice
-- Description: Kill icon tab (visibility, display style, animate, color, tinting, size, font)
--=====================================================================================

local addonName, SQP = ...

function SQP:CreateKillOptions(content)
    if not self.optionControls then self.optionControls = {} end

    local leftColumn = CreateFrame("Frame", nil, content)
    leftColumn:SetPoint("TOPLEFT")
    leftColumn:SetPoint("BOTTOMLEFT")
    leftColumn:SetWidth(300)

    local rightColumn = CreateFrame("Frame", nil, content)
    rightColumn:SetPoint("TOPRIGHT")
    rightColumn:SetPoint("BOTTOMRIGHT")
    rightColumn:SetPoint("LEFT", leftColumn, "RIGHT", 20, 0)

    -- ── Slider helper ─────────────────────────────────────────────────────────
    local function MakeSlider(parent, labelText, key, defaultVal, minVal, maxVal, yOff)
        local val = SQPSettings[key] ~= nil and SQPSettings[key] or defaultVal
        local lbl = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        lbl:SetPoint("TOPLEFT", 20, yOff)
        lbl:SetText(string.format("%s: %d", labelText, val))
        SQP.optionControls[key .. "Label"] = lbl

        local sl = SQP:CreateStyledSlider(parent, minVal, maxVal, 1, 160)
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
            if SQP.previewFrame and SQP.previewFrame.activateKillMode then
                SQP.previewFrame.activateKillMode()
            end
            SQP:RefreshAllNameplates()
        end)
        return yOff - 36
    end

    local function ActivateKill()
        if SQP.previewFrame and SQP.previewFrame.activateKillMode then
            SQP.previewFrame.activateKillMode()
        end
    end

    -- ── LEFT COLUMN ────────────────────────────────────────────────────────────
    local yOffset = -15

    local header = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    header:SetPoint("TOPLEFT", 20, yOffset)
    header:SetText("|cff58be81Kill Icon|r")
    yOffset = yOffset - 22

    -- Show Kill Icon
    local showFrame = self:CreateStyledCheckbox(leftColumn, "Show Kill Icon")
    showFrame:SetPoint("TOPLEFT", 20, yOffset)
    showFrame.checkbox:SetChecked(SQPSettings.showKillIcon ~= false)
    self.optionControls.showKillIcon = showFrame.checkbox
    showFrame.checkbox:SetScript("OnClick", function(self)
        SQP:SetSetting('showKillIcon', self:GetChecked())
        ActivateKill()
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 30

    -- Display Style
    yOffset = self:CreateDisplayStyleSection(leftColumn, ActivateKill, yOffset)

    -- Animate Task Icons (kill + loot mini icons)
    local animHeader = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    animHeader:SetPoint("TOPLEFT", 20, yOffset)
    animHeader:SetText("|cff58be81Animate|r")
    yOffset = yOffset - 20

    local animFrame = self:CreateStyledCheckbox(leftColumn, "Animate Task Icons")
    animFrame:SetPoint("TOPLEFT", 20, yOffset)
    animFrame.checkbox:SetChecked(SQPSettings.animateQuestIcons == true)
    self.optionControls.animateQuestIcons = animFrame.checkbox
    animFrame.checkbox:SetScript("OnClick", function(self)
        SQP:SetSetting('animateQuestIcons', self:GetChecked())
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 34

    -- Kill Color
    local colorHeader = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    colorHeader:SetPoint("TOPLEFT", 20, yOffset)
    colorHeader:SetText("|cff58be81Color|r")
    yOffset = yOffset - 20

    local killDefault = {1, 0.82, 0}
    local colorBtn = CreateFrame("Button", nil, leftColumn)
    colorBtn:SetSize(20, 20)
    colorBtn:SetPoint("TOPLEFT", 20, yOffset)
    local cbg = colorBtn:CreateTexture(nil, "BACKGROUND")
    cbg:SetAllPoints(); cbg:SetColorTexture(0, 0, 0, 1)
    local sw = colorBtn:CreateTexture(nil, "ARTWORK")
    sw:SetSize(16, 16); sw:SetPoint("CENTER")
    sw:SetColorTexture(unpack(SQPSettings.killColor or killDefault))

    local colorLbl = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    colorLbl:SetPoint("LEFT", colorBtn, "RIGHT", 6, 0)
    colorLbl:SetText("Kill Color")

    local colorReset = self:CreateInlineResetButton(leftColumn, function()
        SQP:SetSetting('killColor', {unpack(killDefault)})
        sw:SetColorTexture(unpack(killDefault)); SQP:RefreshAllNameplates()
    end)
    colorReset:SetPoint("LEFT", colorLbl, "RIGHT", 5, 0)

    colorBtn:SetScript("OnClick", function()
        ActivateKill()
        local r, g, b = unpack(SQPSettings.killColor or killDefault)
        local info = {r = r, g = g, b = b, hasOpacity = false}
        info.swatchFunc = function()
            local nr, ng, nb = ColorPickerFrame:GetColorRGB()
            SQP:SetSetting('killColor', {nr, ng, nb}); sw:SetColorTexture(nr, ng, nb)
            SQP:RefreshAllNameplates()
        end
        info.cancelFunc = function()
            SQP:SetSetting('killColor', {r, g, b}); sw:SetColorTexture(r, g, b)
            SQP:RefreshAllNameplates()
        end
        ColorPickerFrame:SetupColorPickerAndShow(info)
    end)
    yOffset = yOffset - 34

    -- Kill Icon Tinting (mini icon, compact inline row)
    yOffset = self:CreateMiniIconTintSection(leftColumn, "kill", ActivateKill, yOffset)
    yOffset = yOffset - 6

    -- Main Icon (jellybean) animate + tinting
    yOffset = self:CreateMainIconSection(leftColumn, "kill", ActivateKill, yOffset)

    -- ── RIGHT COLUMN ──────────────────────────────────────────────────────────
    local rightYOffset = -15

    local posHeader = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    posHeader:SetPoint("TOPLEFT", 20, rightYOffset)
    posHeader:SetText("|cff58be81Size & Position|r")
    rightYOffset = rightYOffset - 22

    rightYOffset = MakeSlider(rightColumn, "Size",     "killIconSize",    14,  8,   40, rightYOffset)
    rightYOffset = MakeSlider(rightColumn, "Offset X", "killIconOffsetX",  2, -80,  80, rightYOffset)
    rightYOffset = MakeSlider(rightColumn, "Offset Y", "killIconOffsetY", 15, -80,  80, rightYOffset)

    rightYOffset = self:CreateFontSection(rightColumn, "kill", rightYOffset, "SQPKillFontDropdown")
end
