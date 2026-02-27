--=====================================================================================
-- RGX | Simple Quest Plates! - options_font.lua

-- Author: DonnieDice
-- Description: Font options tab content
--=====================================================================================

local addonName, SQP = ...
local format = string.format

function SQP:CreateFontOptions(content)
    local leftColumn = CreateFrame("Frame", nil, content)
    leftColumn:SetPoint("TOPLEFT")
    leftColumn:SetPoint("BOTTOMLEFT")
    leftColumn:SetWidth(300)

    local rightColumn = CreateFrame("Frame", nil, content)
    rightColumn:SetPoint("TOPRIGHT")
    rightColumn:SetPoint("BOTTOMRIGHT")
    rightColumn:SetPoint("LEFT", leftColumn, "RIGHT", 20, 0)

    -- ── LEFT COLUMN: Font controls ───────────────────────────────────────────
    local yOffset = -15

    local fontTitle = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    fontTitle:SetPoint("TOPLEFT", 20, yOffset)
    fontTitle:SetText("|cff58be81" .. (self.L["OPTIONS_FONT_SETTINGS"] or "Font Settings") .. "|r")
    yOffset = yOffset - 22

    -- Font Size
    local fontSizeLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    fontSizeLabel:SetPoint("TOPLEFT", 20, yOffset)
    fontSizeLabel:SetText(self.L["OPTIONS_FONT_SIZE"] or "Font Size")

    local fontSlider = self:CreateStyledSlider(leftColumn, 8, 20, 1, 190)
    fontSlider:SetPoint("TOPLEFT", fontSizeLabel, "BOTTOMLEFT", 0, -5)
    fontSlider:SetValue(SQPSettings.fontSize or 12)

    local fontValue = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    fontValue:SetPoint("LEFT", fontSlider, "RIGHT", 8, 0)
    fontValue:SetText(tostring(SQPSettings.fontSize or 12))

    fontSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        SQP:SetSetting('fontSize', value)
        fontValue:SetText(tostring(value))
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 48

    -- Font Family
    local fontFamilyLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    fontFamilyLabel:SetPoint("TOPLEFT", 20, yOffset)
    fontFamilyLabel:SetText(self.L["OPTIONS_FONT_FAMILY"] or "Font Family")
    yOffset = yOffset - 22

    local fontDropdown = CreateFrame("Frame", "SQPFontDropdown", leftColumn, "UIDropDownMenuTemplate")
    fontDropdown:SetPoint("TOPLEFT", 5, yOffset)
    UIDropDownMenu_SetWidth(fontDropdown, 180)
    self.optionControls.fontFamily = fontDropdown

    local fontOptions = {
        {text = "Default (Friz Quadrata)", font = "Fonts\\FRIZQT__.TTF"},
        {text = "Arial Narrow",            font = "Fonts\\ARIALN.TTF"},
        {text = "Skurri",                  font = "Fonts\\SKURRI.TTF"},
        {text = "Morpheus",                font = "Fonts\\MORPHEUS.TTF"},
        {text = "2002 (Pixel)",            font = "Fonts\\2002.TTF"},
        {text = "2002 Bold (Pixel)",       font = "Fonts\\2002B.TTF"},
        {text = "Nimrod MT",               font = "Fonts\\NIM_____.ttf"},
    }

    UIDropDownMenu_Initialize(fontDropdown, function(self, level)
        for _, opt in ipairs(fontOptions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = opt.text
            info.func = function()
                SQP:SetSetting('fontFamily', opt.font)
                UIDropDownMenu_SetText(fontDropdown, opt.text)
                SQP:RefreshAllNameplates()
            end
            info.checked = (SQPSettings.fontFamily == opt.font)
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    local currentFont = SQPSettings.fontFamily or "Fonts\\FRIZQT__.TTF"
    for _, opt in ipairs(fontOptions) do
        if opt.font == currentFont then
            UIDropDownMenu_SetText(fontDropdown, opt.text)
            break
        end
    end
    yOffset = yOffset - 38

    -- Outline Width slider (0=None, 1=Normal, 2=Thick)
    local outlineLabel = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    outlineLabel:SetPoint("TOPLEFT", 20, yOffset)
    outlineLabel:SetText(self.L["OPTIONS_OUTLINE_WIDTH"] or "Outline Width")

    local outlineNames = {"None", "Normal", "Thick"}

    local function GetSliderVal()
        local w = SQP:GetOutlineInfo()
        if w >= 3 then return 2 elseif w >= 2 then return 1 else return 0 end
    end

    local outlineSlider = self:CreateStyledSlider(leftColumn, 0, 2, 1, 190)
    outlineSlider:SetPoint("TOPLEFT", outlineLabel, "BOTTOMLEFT", 0, -5)
    local initVal = GetSliderVal()
    outlineSlider:SetValue(initVal)
    self.optionControls.outlineSlider = outlineSlider

    local outlineValueText = leftColumn:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    outlineValueText:SetPoint("LEFT", outlineSlider, "RIGHT", 8, 0)
    outlineValueText:SetText(outlineNames[initVal + 1])
    self.optionControls.outlineValueText = outlineValueText

    outlineSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        if value == 0 then
            SQP:SetSetting('outlineWidth', 0)
            SQP:SetSetting('fontOutline', "")
        elseif value == 1 then
            SQP:SetSetting('outlineWidth', 2)
            SQP:SetSetting('fontOutline', "OUTLINE")
        else
            SQP:SetSetting('outlineWidth', 3)
            SQP:SetSetting('fontOutline', "THICKOUTLINE")
        end
        outlineValueText:SetText(outlineNames[value + 1])
        SQP:RefreshAllNameplates()
    end)
    yOffset = yOffset - 48

    -- Reset Font button
    local resetFontBtn = self:CreateStyledButton(leftColumn, "Reset Font Settings", 160, 26)
    resetFontBtn:SetPoint("TOPLEFT", 20, yOffset)
    resetFontBtn:SetAlpha(0.8)
    resetFontBtn:SetScript("OnClick", function()
        SQP:SetSetting('fontSize', 12)
        SQP:SetSetting('fontFamily', "Fonts\\FRIZQT__.TTF")
        SQP:SetSetting('fontOutline', "OUTLINE")
        SQP:SetSetting('outlineWidth', 2)
        fontSlider:SetValue(12)
        fontValue:SetText("12")
        UIDropDownMenu_SetText(fontDropdown, "Default (Friz Quadrata)")
        outlineSlider:SetValue(1)
        outlineValueText:SetText("Normal")
        SQP:RefreshAllNameplates()
    end)

    -- ── RIGHT COLUMN: Outline color ──────────────────────────────────────────
    local rightYOffset = -15

    local outlineColorTitle = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    outlineColorTitle:SetPoint("TOPLEFT", 20, rightYOffset)
    outlineColorTitle:SetText("|cff58be81Outline Color|r")
    rightYOffset = rightYOffset - 22

    local colorNote = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    colorNote:SetPoint("TOPLEFT", 20, rightYOffset)
    colorNote:SetText("|cffaaaaaaApplied when outline width > None|r")
    rightYOffset = rightYOffset - 22

    local colorBtn = CreateFrame("Button", nil, rightColumn)
    colorBtn:SetSize(20, 20)
    colorBtn:SetPoint("TOPLEFT", 20, rightYOffset)
    local cbg = colorBtn:CreateTexture(nil, "BACKGROUND")
    cbg:SetAllPoints()
    cbg:SetColorTexture(0, 0, 0, 1)
    local sw = colorBtn:CreateTexture(nil, "ARTWORK")
    sw:SetSize(16, 16)
    sw:SetPoint("CENTER")
    sw:SetColorTexture(unpack(SQPSettings.outlineColor or {0,0,0}))

    local colorLbl = rightColumn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    colorLbl:SetPoint("LEFT", colorBtn, "RIGHT", 6, 0)
    colorLbl:SetText("Outline Color")

    local colorResetBtn = self:CreateStyledButton(rightColumn, "Reset", 50, 20)
    colorResetBtn:SetPoint("LEFT", colorLbl, "RIGHT", 8, 0)
    colorResetBtn:SetAlpha(0.8)
    colorResetBtn:SetScript("OnClick", function()
        SQP:SetSetting('outlineColor', {0,0,0})
        sw:SetColorTexture(0,0,0)
        SQP:RefreshAllNameplates()
    end)

    colorBtn:SetScript("OnClick", function()
        local r, g, b = unpack(SQPSettings.outlineColor or {0,0,0})
        local info = { r = r, g = g, b = b, hasOpacity = false }
        info.swatchFunc = function()
            local nr, ng, nb = ColorPickerFrame:GetColorRGB()
            SQP:SetSetting('outlineColor', {nr, ng, nb})
            sw:SetColorTexture(nr, ng, nb)
            SQP:RefreshAllNameplates()
        end
        info.cancelFunc = function()
            SQP:SetSetting('outlineColor', {r, g, b})
            sw:SetColorTexture(r, g, b)
            SQP:RefreshAllNameplates()
        end
        ColorPickerFrame:SetupColorPickerAndShow(info)
    end)
end
