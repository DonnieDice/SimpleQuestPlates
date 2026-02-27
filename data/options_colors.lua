--=====================================================================================
-- RGX | Simple Quest Plates! - options_colors.lua

-- Author: DonnieDice
-- Description: Colors & tinting options tab
--=====================================================================================

local addonName, SQP = ...

function SQP:CreateColorsOptions(content)
    if not self.optionControls then self.optionControls = {} end

    local leftColumn = CreateFrame("Frame", nil, content)
    leftColumn:SetPoint("TOPLEFT")
    leftColumn:SetPoint("BOTTOMLEFT")
    leftColumn:SetWidth(300)

    local rightColumn = CreateFrame("Frame", nil, content)
    rightColumn:SetPoint("TOPRIGHT")
    rightColumn:SetPoint("BOTTOMRIGHT")
    rightColumn:SetPoint("LEFT", leftColumn, "RIGHT", 20, 0)

    -- ── LEFT COLUMN: Quest text colors ──────────────────────────────────────
    local yOffset = -15

    local colorTitle = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    colorTitle:SetPoint("TOPLEFT", 20, yOffset)
    colorTitle:SetText("|cff58be81" .. (self.L["OPTIONS_TEXT_COLORS"] or "Quest Text Colors") .. "|r")
    yOffset = yOffset - 22

    local defaults = {
        killColor    = {1, 0.82, 0},
        itemColor    = {0.2, 1, 0.2},
        percentColor = {0.2, 1, 1},
        outlineColor = {0, 0, 0},
    }
    local swatches = {}

    local function MakeColorRow(parent, label, key, yOff)
        local btn = CreateFrame("Button", nil, parent)
        btn:SetSize(20, 20)
        btn:SetPoint("TOPLEFT", 20, yOff)

        local bg = btn:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetColorTexture(0, 0, 0, 1)

        local sw = btn:CreateTexture(nil, "ARTWORK")
        sw:SetSize(16, 16)
        sw:SetPoint("CENTER")
        sw:SetColorTexture(unpack(SQPSettings[key] or defaults[key]))
        swatches[key] = sw

        local lbl = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        lbl:SetPoint("LEFT", btn, "RIGHT", 6, 0)
        lbl:SetText(label)

        btn:SetScript("OnClick", function()
            local r, g, b = unpack(SQPSettings[key] or defaults[key])
            local info = { r = r, g = g, b = b, hasOpacity = false }
            info.swatchFunc = function()
                local nr, ng, nb = ColorPickerFrame:GetColorRGB()
                SQP:SetSetting(key, {nr, ng, nb})
                sw:SetColorTexture(nr, ng, nb)
                SQP:RefreshAllNameplates()
            end
            info.cancelFunc = function()
                SQP:SetSetting(key, {r, g, b})
                sw:SetColorTexture(r, g, b)
                SQP:RefreshAllNameplates()
            end
            ColorPickerFrame:SetupColorPickerAndShow(info)
        end)
    end

    MakeColorRow(leftColumn, self.L["OPTIONS_COLOR_KILL"]    or "Kill Quests",      "killColor",    yOffset) yOffset = yOffset - 26
    MakeColorRow(leftColumn, self.L["OPTIONS_COLOR_ITEM"]    or "Item Quests",      "itemColor",    yOffset) yOffset = yOffset - 26
    MakeColorRow(leftColumn, self.L["OPTIONS_COLOR_PERCENT"] or "Progress Quests",  "percentColor", yOffset) yOffset = yOffset - 26
    MakeColorRow(leftColumn, self.L["OPTIONS_COLOR_OUTLINE"] or "Text Outline",     "outlineColor", yOffset) yOffset = yOffset - 36

    local resetColorsBtn = self:CreateStyledButton(leftColumn, "Reset Text Colors", 160, 26)
    resetColorsBtn:SetPoint("TOPLEFT", 20, yOffset)
    resetColorsBtn:SetAlpha(0.8)
    resetColorsBtn:SetScript("OnClick", function()
        for key, val in pairs(defaults) do
            SQP:SetSetting(key, val)
            if swatches[key] then swatches[key]:SetColorTexture(unpack(val)) end
        end
        SQP:RefreshAllNameplates()
    end)

    -- ── RIGHT COLUMN: Icon tinting ───────────────────────────────────────────
    local rightYOffset = -15

    local tintTitle = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    tintTitle:SetPoint("TOPLEFT", 20, rightYOffset)
    tintTitle:SetText("|cff58be81Icon Tinting|r")
    rightYOffset = rightYOffset - 22

    -- Helper: tint row (checkbox + color picker)
    local function MakeTintSection(parent, header, tintKey, colorKey, yOff)
        local hdr = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        hdr:SetPoint("TOPLEFT", 20, yOff)
        hdr:SetText("|cffaaaaaa" .. header .. "|r")
        yOff = yOff - 20

        local cbFrame = SQP:CreateStyledCheckbox(parent, "Enable Tinting")
        cbFrame:SetPoint("TOPLEFT", 20, yOff)
        cbFrame.checkbox:SetChecked(SQPSettings[tintKey] == true)
        SQP.optionControls[tintKey] = cbFrame.checkbox
        yOff = yOff - 26

        local colorBtn = CreateFrame("Button", nil, parent)
        colorBtn:SetSize(20, 20)
        colorBtn:SetPoint("TOPLEFT", 30, yOff)
        local cbg = colorBtn:CreateTexture(nil, "BACKGROUND")
        cbg:SetAllPoints()
        cbg:SetColorTexture(0, 0, 0, 1)
        local sw = colorBtn:CreateTexture(nil, "ARTWORK")
        sw:SetSize(16, 16)
        sw:SetPoint("CENTER")
        sw:SetColorTexture(unpack(SQPSettings[colorKey] or {1,1,1}))

        local colorLbl = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        colorLbl:SetPoint("LEFT", colorBtn, "RIGHT", 6, 0)
        colorLbl:SetText("Tint Color")

        local resetBtn = SQP:CreateStyledButton(parent, "Reset", 50, 20)
        resetBtn:SetPoint("LEFT", colorLbl, "RIGHT", 8, 0)
        resetBtn:SetAlpha(0.8)

        local function UpdateAlpha()
            local a = SQPSettings[tintKey] == true and 1 or 0.4
            colorBtn:SetAlpha(a)
            colorLbl:SetAlpha(a)
            resetBtn:SetAlpha(a * 0.8)
        end

        cbFrame.checkbox:SetScript("OnClick", function(self)
            SQP:SetSetting(tintKey, self:GetChecked())
            UpdateAlpha()
            SQP:RefreshAllNameplates()
        end)

        colorBtn:SetScript("OnClick", function()
            if not SQPSettings[tintKey] then return end
            local r, g, b = unpack(SQPSettings[colorKey] or {1,1,1})
            local info = { r = r, g = g, b = b, hasOpacity = false }
            info.swatchFunc = function()
                local nr, ng, nb = ColorPickerFrame:GetColorRGB()
                SQP:SetSetting(colorKey, {nr, ng, nb})
                sw:SetColorTexture(nr, ng, nb)
                SQP:RefreshAllNameplates()
            end
            info.cancelFunc = function()
                SQP:SetSetting(colorKey, {r, g, b})
                sw:SetColorTexture(r, g, b)
                SQP:RefreshAllNameplates()
            end
            ColorPickerFrame:SetupColorPickerAndShow(info)
        end)

        resetBtn:SetScript("OnClick", function()
            if not SQPSettings[tintKey] then return end
            SQP:SetSetting(colorKey, {1,1,1})
            sw:SetColorTexture(1,1,1)
            SQP:RefreshAllNameplates()
        end)

        UpdateAlpha()
        return yOff - 36  -- return new Y after the color row
    end

    rightYOffset = MakeTintSection(rightColumn, "Main Icon", "iconTintMain", "iconTintMainColor", rightYOffset)
    rightYOffset = MakeTintSection(rightColumn, "Quest Icons (Kill/Loot)", "iconTintQuest", "iconTintQuestColor", rightYOffset)
end
