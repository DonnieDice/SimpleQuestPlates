--=====================================================================================
-- RGX | Simple Quest Plates! - options_preview.lua

-- Author: DonnieDice
-- Description: Preview nameplate for options panel
--=====================================================================================

local addonName, SQP = ...
local CreateFrame = CreateFrame

-- Create preview nameplate section
function SQP:CreatePreviewSection(parent)
    -- Create preview container
    local previewFrame = CreateFrame("Frame", nil, parent)
    previewFrame:SetSize(parent:GetWidth() - 40, 140)
    previewFrame:SetPoint("CENTER", parent, "CENTER", 0, 0)
    
    -- Preview title
    local previewTitle = previewFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    previewTitle:SetPoint("TOP", previewFrame, "TOP", 0, -5)
    previewTitle:SetText("|cff58be81Live Preview|r")
    
    -- Create fake nameplate
    local nameplate = CreateFrame("Frame", nil, previewFrame)
    nameplate:SetSize(200, 40)
    nameplate:SetPoint("CENTER", previewFrame, "CENTER", 0, 0)
    
    -- Nameplate background
    local nameplateBackground = nameplate:CreateTexture(nil, "BACKGROUND")
    nameplateBackground:SetAllPoints()
    nameplateBackground:SetColorTexture(0.2, 0.2, 0.2, 0.8)
    
    -- Health bar
    local healthBar = CreateFrame("StatusBar", nil, nameplate)
    healthBar:SetSize(180, 12)
    healthBar:SetPoint("CENTER", nameplate, "CENTER", 0, 0)
    healthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    healthBar:SetStatusBarColor(1, 0.2, 0.2)
    healthBar:SetMinMaxValues(0, 100)
    healthBar:SetValue(75)
    
    -- Health bar background
    local healthBackground = healthBar:CreateTexture(nil, "BACKGROUND")
    healthBackground:SetAllPoints()
    healthBackground:SetColorTexture(0.1, 0.1, 0.1, 0.8)
    
    -- Name text
    local nameText = nameplate:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameText:SetPoint("BOTTOM", healthBar, "TOP", 0, 2)
    nameText:SetText("Murloc Warrior")
    nameText:SetTextColor(1, 0.82, 0)
    
    -- Level text
    local levelText = nameplate:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    levelText:SetPoint("TOPLEFT", healthBar, "BOTTOMLEFT", 0, -2)
    levelText:SetText("Level 15")
    levelText:SetTextColor(0.8, 0.8, 0.8)
    
    -- Create preview quest icon
    local questFrame = CreateFrame("Frame", nil, nameplate)
    questFrame:SetAllPoints()
    
    -- Quest icon
    local icon = questFrame:CreateTexture(nil, "OVERLAY", nil, 7)
    icon:SetSize(28, 22)
    icon:SetTexture('Interface/QuestFrame/AutoQuest-Parts')
    icon:SetTexCoord(0.30273438, 0.41992188, 0.015625, 0.953125)
    
    -- Quest count text
    local iconText = questFrame:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
    if iconText.SetDrawLayer then
        iconText:SetDrawLayer("OVERLAY", 2)
    end
    iconText:SetPoint("CENTER", icon, 0.8, 0)
    iconText:SetShadowOffset(1, -1)
    iconText:SetTextColor(1, 0.82, 0)

    -- Outline text (separate layer for custom outline color)
    local iconTextOutline = questFrame:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
    if iconTextOutline.SetDrawLayer then
        iconTextOutline:SetDrawLayer("OVERLAY", 1)
    end
    iconTextOutline:SetPoint("CENTER", icon, 0.8, 0)
    iconTextOutline:SetShadowOffset(0, 0)
    iconTextOutline:SetTextColor(0, 0, 0, 1)
    
    -- Percent icon (used for percentage quests)
    local percentIcon = questFrame:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
    if percentIcon.SetDrawLayer then
        percentIcon:SetDrawLayer("OVERLAY", 2)
    end
    percentIcon:SetPoint("CENTER", icon, 0, 0)
    percentIcon:SetText("%")
    percentIcon:SetTextColor(0.2, 1, 1)
    percentIcon:Hide()

    local percentIconOutline = questFrame:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
    if percentIconOutline.SetDrawLayer then
        percentIconOutline:SetDrawLayer("OVERLAY", 1)
    end
    percentIconOutline:SetPoint("CENTER", icon, 0, 0)
    percentIconOutline:SetText("%")
    percentIconOutline:SetTextColor(0, 0, 0, 1)
    percentIconOutline:Hide()

    local function CreatePulse(region)
        local pulse = region:CreateAnimationGroup()
        pulse:SetLooping("REPEAT")
        local fadeOut = pulse:CreateAnimation("Alpha")
        fadeOut:SetOrder(1)
        fadeOut:SetFromAlpha(1)
        fadeOut:SetToAlpha(0.6)
        fadeOut:SetDuration(0.6)
        fadeOut:SetSmoothing("IN_OUT")
        local fadeIn = pulse:CreateAnimation("Alpha")
        fadeIn:SetOrder(2)
        fadeIn:SetFromAlpha(0.6)
        fadeIn:SetToAlpha(1)
        fadeIn:SetDuration(0.6)
        fadeIn:SetSmoothing("IN_OUT")
        return pulse
    end

    -- Apply font settings first, then set text
    SQP:UpdateQuestFont(iconText, iconTextOutline, percentIcon, percentIconOutline)
    iconText:SetText("3")
    iconTextOutline:SetText("3")
    
    -- Default to showing kill quest type
    if SQPSettings.customColors then
        iconText:SetTextColor(unpack(SQPSettings.killColor or {1, 0.82, 0}))
    else
        iconText:SetTextColor(1, 0.82, 0)
    end
    
    -- Loot icon
    local lootIcon = questFrame:CreateTexture(nil, "OVERLAY", nil, 7)
    if lootIcon.SetAtlas then
        lootIcon:SetAtlas('Banker')
    else
        lootIcon:SetTexture('Interface/Icons/INV_Misc_Bag_10')
        lootIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    end
    lootIcon:SetSize(16, 16)
    lootIcon:SetPoint('TOPLEFT', icon, 'BOTTOMRIGHT', -12, 12)
    lootIcon:Hide()

    -- Kill icon (hostile cursor knife/sword)
    local killIcon = questFrame:CreateTexture(nil, "OVERLAY", nil, 7)
    killIcon:SetTexture('Interface/Cursor/Attack')
    if not killIcon:GetTexture() then
        killIcon:SetTexture('Interface/Icons/INV_Sword_04')
        killIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    end
    killIcon:SetSize(16, 16)
    killIcon:SetPoint('TOPRIGHT', icon, 'BOTTOMLEFT', 12, 12)
    killIcon:Hide()
    
    -- Store references
    previewFrame.nameplate = nameplate
    previewFrame.questFrame = questFrame
    previewFrame.icon = icon
    previewFrame.iconText = iconText
    previewFrame.iconTextOutline = iconTextOutline
    previewFrame.percentIcon = percentIcon
    previewFrame.percentIconOutline = percentIconOutline
    previewFrame.iconPulse = CreatePulse(icon)
    previewFrame.percentPulse = CreatePulse(percentIcon)
    previewFrame.percentOutlinePulse = CreatePulse(percentIconOutline)
    previewFrame.lootIcon = lootIcon
    previewFrame.killIcon = killIcon
    previewFrame.questType = "kill"
    
    -- Update function
    function previewFrame:UpdatePreview()
        -- Update icon position
        icon:ClearAllPoints()
        icon:SetPoint(
            SQPSettings.anchor or 'RIGHT',
            nameplate,
            SQPSettings.relativeTo or 'LEFT',
            SQPSettings.offsetX or 0,
            SQPSettings.offsetY or 0
        )

        if self.killIcon then
            self.killIcon:ClearAllPoints()
            self.killIcon:SetPoint(
                'TOPRIGHT',
                icon,
                'BOTTOMLEFT',
                SQPSettings.killIconOffsetX or 12,
                SQPSettings.killIconOffsetY or 12
            )
        end
        if self.lootIcon then
            self.lootIcon:ClearAllPoints()
            self.lootIcon:SetPoint(
                'TOPLEFT',
                icon,
                'BOTTOMRIGHT',
                SQPSettings.lootIconOffsetX or -12,
                SQPSettings.lootIconOffsetY or 12
            )
        end
        
        -- Update scale
        questFrame:SetScale(SQPSettings.scale or 1)
        
        -- Update font
        SQP:UpdateQuestFont(iconText, iconTextOutline, percentIcon, percentIconOutline)
        
        -- Update icon tinting
        local mainTintEnabled = SQPSettings.iconTintMain and SQPSettings.iconTintMainColor
        local mainTintR, mainTintG, mainTintB, mainTintA = 1, 1, 1, 1
        if mainTintEnabled then
            mainTintR, mainTintG, mainTintB, mainTintA = unpack(SQPSettings.iconTintMainColor)
            icon:SetVertexColor(mainTintR, mainTintG, mainTintB, mainTintA)
        else
            icon:SetVertexColor(1, 1, 1, 1)
        end
        local questTintEnabled = SQPSettings.iconTintQuest and SQPSettings.iconTintQuestColor
        local questTintR, questTintG, questTintB, questTintA = 1, 1, 1, 1
        if questTintEnabled then
            questTintR, questTintG, questTintB, questTintA = unpack(SQPSettings.iconTintQuestColor)
        end
        if self.killIcon then
            if questTintEnabled then
                self.killIcon:SetVertexColor(questTintR, questTintG, questTintB, questTintA)
            else
                self.killIcon:SetVertexColor(1, 1, 1, 1)
            end
        end
        if self.lootIcon then
            if questTintEnabled then
                self.lootIcon:SetVertexColor(questTintR, questTintG, questTintB, questTintA)
            else
                self.lootIcon:SetVertexColor(1, 1, 1, 1)
            end
        end

        -- Update quest type icons
        if self.questType == "loot" then
            icon:Show()
            if self.percentIcon then self.percentIcon:Hide() end
            if self.percentIconOutline then self.percentIconOutline:Hide() end
            if self.lootIcon then
                if SQPSettings.showLootIcon ~= false then
                    self.lootIcon:Show()
                else
                    self.lootIcon:Hide()
                end
            end
            if self.killIcon then
                self.killIcon:Hide()
            end
        elseif self.questType == "kill" then
            icon:Show()
            if self.percentIcon then self.percentIcon:Hide() end
            if self.percentIconOutline then self.percentIconOutline:Hide() end
            if self.lootIcon then
                self.lootIcon:Hide()
            end
            if self.killIcon then
                if SQPSettings.showKillIcon ~= false then
                    self.killIcon:Show()
                else
                    self.killIcon:Hide()
                end
            end
        else
            icon:Hide()
            if self.percentIcon then
                self.percentIcon:SetText("%")
                if mainTintEnabled then
                    self.percentIcon:SetTextColor(mainTintR, mainTintG, mainTintB, mainTintA or 1)
                else
                    self.percentIcon:SetTextColor(unpack(SQPSettings.percentColor or {0.2, 1, 1}))
                end
                self.percentIcon:Show()
            end
            if self.percentIconOutline then
                self.percentIconOutline:SetText("%")
                local outlineWidth = SQP:GetOutlineInfo()
                if outlineWidth and outlineWidth > 0 then
                    self.percentIconOutline:Show()
                else
                    self.percentIconOutline:Hide()
                end
            end
            if self.lootIcon then
                self.lootIcon:Hide()
            end
            if self.killIcon then
                self.killIcon:Hide()
            end
        end

        if SQPSettings.animateQuestIcon then
            if self.questType == "percent" then
                if self.iconPulse and self.iconPulse:IsPlaying() then self.iconPulse:Stop() end
                if self.percentPulse and not self.percentPulse:IsPlaying() then self.percentPulse:Play() end
                if self.percentOutlinePulse then
                    if self.percentIconOutline and self.percentIconOutline:IsShown() then
                        if not self.percentOutlinePulse:IsPlaying() then self.percentOutlinePulse:Play() end
                    elseif self.percentOutlinePulse:IsPlaying() then
                        self.percentOutlinePulse:Stop()
                    end
                end
            else
                if self.percentPulse and self.percentPulse:IsPlaying() then self.percentPulse:Stop() end
                if self.percentOutlinePulse and self.percentOutlinePulse:IsPlaying() then self.percentOutlinePulse:Stop() end
                if self.iconPulse and not self.iconPulse:IsPlaying() then self.iconPulse:Play() end
            end
        else
            if self.iconPulse and self.iconPulse:IsPlaying() then self.iconPulse:Stop() end
            if self.percentPulse and self.percentPulse:IsPlaying() then self.percentPulse:Stop() end
            if self.percentOutlinePulse and self.percentOutlinePulse:IsPlaying() then self.percentOutlinePulse:Stop() end
        end
    end
    
    -- Initial update
    previewFrame:UpdatePreview()
    
    -- Track active button
    local activeButton = nil
    
    -- Declare button variables
    local killButton, lootButton, percentButton
    
    -- Function to update button states
    local function SetActiveButton(button)
        -- Reset all buttons
        killButton:SetAlpha(0.6)
        lootButton:SetAlpha(0.6)
        percentButton:SetAlpha(0.6)
        
        -- Highlight active button
        if button then
            button:SetAlpha(1)
            activeButton = button
        end
    end
    
    -- Example toggle buttons
    killButton = self:CreateStyledButton(previewFrame, "Kill Quest", 80, 25)
    killButton:SetPoint("BOTTOM", previewFrame, "BOTTOM", -90, 5)
    killButton:SetScript("OnClick", function(self)
        iconText:SetText("5")
        iconTextOutline:SetText("5")
        iconText:SetTextColor(unpack(SQPSettings.killColor or {1, 0.82, 0}))
        lootIcon:Hide()
        killIcon:Hide()
        previewFrame.questType = "kill"
        previewFrame:UpdatePreview()
        SetActiveButton(self)
    end)
    
    lootButton = self:CreateStyledButton(previewFrame, "Loot Quest", 80, 25)
    lootButton:SetPoint("BOTTOM", previewFrame, "BOTTOM", 0, 5)
    lootButton:SetScript("OnClick", function(self)
        iconText:SetText("2")
        iconTextOutline:SetText("2")
        iconText:SetTextColor(unpack(SQPSettings.itemColor or {0.2, 1, 0.2}))
        lootIcon:Show()
        killIcon:Hide()
        previewFrame.questType = "loot"
        previewFrame:UpdatePreview()
        SetActiveButton(self)
    end)
    
    percentButton = self:CreateStyledButton(previewFrame, "% Quest", 80, 25)
    percentButton:SetPoint("BOTTOM", previewFrame, "BOTTOM", 90, 5)
    percentButton:SetScript("OnClick", function(self)
        iconText:SetText("75")
        iconTextOutline:SetText("75")
        iconText:SetTextColor(unpack(SQPSettings.percentColor or {0.2, 1, 1}))
        lootIcon:Hide()
        killIcon:Hide()
        previewFrame.questType = "percent"
        previewFrame:UpdatePreview()
        SetActiveButton(self)
    end)
    
    -- Set initial active button and trigger its click
    SetActiveButton(killButton)
    killButton:GetScript("OnClick")(killButton)
    
    -- Store additional references for color updates
    previewFrame.buttons = {killButton, lootButton, percentButton}
    
    return previewFrame
end

-- Hook into refresh function
local oldRefresh = SQP.RefreshAllNameplates
function SQP:RefreshAllNameplates()
    -- Call original function
    if oldRefresh then
        oldRefresh(self)
    end
    
    -- Update preview if it exists
    if self.previewFrame then
        self.previewFrame:UpdatePreview()
        
        -- Re-apply current quest type colors
        if self.previewFrame.iconText then
            local text = self.previewFrame.iconText:GetText()
            if text then
                if text == "5" then
                    -- Kill quest
                    self.previewFrame.iconText:SetTextColor(unpack(SQPSettings.killColor or {1, 0.82, 0}))
                elseif text == "2" then
                    -- Item quest
                    self.previewFrame.iconText:SetTextColor(unpack(SQPSettings.itemColor or {0.2, 1, 0.2}))
                elseif text == "75" then
                    -- Progress quest
                    self.previewFrame.iconText:SetTextColor(unpack(SQPSettings.percentColor or {0.2, 1, 1}))
                end
            end
        end
    end
end
