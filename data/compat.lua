--=====================================================================================
-- SQP | Simple Quest Plates - compat.lua
-- Version: 1.1.0
-- Author: DonnieDice
-- Description: API compatibility layer for different WoW versions
--=====================================================================================

local addonName, SQP = ...

-- Get WoW version
local tocversion = select(4, GetBuildInfo())
local isRetail = tocversion >= 100000  -- Dragonflight and later
local isLegion = tocversion >= 70000   -- Legion+ has modern APIs
local isClassic = tocversion < 70000   -- Pre-Legion uses Classic APIs
local isMoP = tocversion >= 50400 and tocversion < 60000
local isCata = tocversion >= 40400 and tocversion < 50000
local isWrath = tocversion >= 30400 and tocversion < 40000
local isVanilla = tocversion < 20000

-- Store version info globally
SQP.isRetail = isRetail
SQP.isClassic = isClassic
SQP.isMoP = isMoP
SQP.tocversion = tocversion

-- Create compatibility namespace
SQP.Compat = {}

-- Quest API compatibility
if isRetail then
    -- Retail uses C_QuestLog
    SQP.Compat.GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
    SQP.Compat.GetInfo = C_QuestLog.GetInfo
    SQP.Compat.IsComplete = C_QuestLog.IsComplete
    SQP.Compat.IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
    SQP.Compat.GetQuestObjectives = C_QuestLog.GetQuestObjectives
    SQP.Compat.UnitIsRelatedToActiveQuest = C_QuestLog.UnitIsRelatedToActiveQuest
    
    -- Tooltip API
    SQP.Compat.GetTooltipData = function(unitID)
        return C_TooltipInfo and C_TooltipInfo.GetUnit(unitID)
    end
else
    -- Classic versions use older APIs
    SQP.Compat.GetNumQuestLogEntries = function()
        return GetNumQuestLogEntries()
    end
    
    SQP.Compat.GetInfo = function(index)
        local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(index)
        if not title then return nil end
        
        return {
            title = title,
            questID = questID,
            level = level,
            isHeader = isHeader,
            isCollapsed = isCollapsed,
            isComplete = isComplete,
            frequency = frequency,
            suggestedGroup = suggestedGroup
        }
    end
    
    SQP.Compat.IsComplete = function(questID)
        -- In Classic, we need to find the quest in the log first
        for i = 1, GetNumQuestLogEntries() do
            local _, _, _, _, _, isComplete, _, qID = GetQuestLogTitle(i)
            if qID == questID then
                return isComplete
            end
        end
        return false
    end
    
    SQP.Compat.IsQuestFlaggedCompleted = IsQuestFlaggedCompleted or function(questID)
        return IsQuestComplete(questID)
    end
    
    SQP.Compat.GetQuestObjectives = function(questID)
        local objectives = {}
        -- In Classic, we need to find the quest index first
        for i = 1, GetNumQuestLogEntries() do
            local _, _, _, _, _, _, _, qID = GetQuestLogTitle(i)
            if qID == questID then
                local numObjectives = GetNumQuestLeaderBoards(i)
                for j = 1, numObjectives do
                    local text, objectiveType, finished = GetQuestLogLeaderBoard(j, i)
                    table.insert(objectives, {
                        text = text,
                        type = objectiveType,
                        finished = finished
                    })
                end
                break
            end
        end
        return objectives
    end
    
    -- Classic tooltip scanning (fallback method)
    SQP.Compat.GetTooltipData = function(unitID)
        -- Classic doesn't have C_TooltipInfo, we'll need to scan GameTooltip
        local tooltip = CreateFrame("GameTooltip", "SQPScanTooltip", nil, "GameTooltipTemplate")
        tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        tooltip:SetUnit(unitID)
        
        local lines = {}
        for i = 1, tooltip:NumLines() do
            local textLeft = _G["SQPScanTooltipTextLeft"..i]
            if textLeft and textLeft:GetText() then
                -- In MoP/Classic, quest objectives are usually in gray text
                local text = textLeft:GetText()
                local r, g, b = textLeft:GetTextColor()
                
                -- Quest text is usually gray (around 0.7, 0.7, 0.7)
                local isQuestText = (r > 0.6 and r < 0.8) and (g > 0.6 and g < 0.8) and (b > 0.6 and b < 0.8)
                
                table.insert(lines, {
                    leftText = text,
                    type = isQuestText and 17 or 0,  -- Type 17 is quest in retail
                    id = nil  -- We don't have quest ID in classic tooltip
                })
            end
        end
        
        tooltip:Hide()
        return { lines = lines }
    end
    
    -- Classic quest relation check
    if isMoP then
        -- MoP has a different function name
        SQP.Compat.UnitIsRelatedToActiveQuest = function(unitID)
            -- Try the MoP function first
            if IsQuestLogUnit then
                return IsQuestLogUnit(unitID)
            end
            -- Fallback to tooltip scanning
            local tooltip = CreateFrame("GameTooltip", "SQPQuestTooltip", nil, "GameTooltipTemplate")
            tooltip:SetOwner(UIParent, "ANCHOR_NONE")
            tooltip:SetUnit(unitID)
            
            local isQuestUnit = false
            for i = 3, tooltip:NumLines() do
                local text = _G["SQPQuestTooltipTextLeft"..i]
                if text and text:GetText() then
                    local line = text:GetText()
                    -- Check for quest objective patterns
                    if string.find(line, "(%d+)/(%d+)") or string.find(line, "([%d%.]+)%%") then
                        isQuestUnit = true
                        break
                    end
                end
            end
            
            tooltip:Hide()
            return isQuestUnit
        end
    else
        SQP.Compat.UnitIsRelatedToActiveQuest = function(unitID)
            -- In Classic, we need to scan the tooltip
            local tooltip = CreateFrame("GameTooltip", "SQPQuestTooltip", nil, "GameTooltipTemplate")
            tooltip:SetOwner(UIParent, "ANCHOR_NONE")
            tooltip:SetUnit(unitID)
            
            local isQuestUnit = false
            for i = 3, tooltip:NumLines() do
                local text = _G["SQPQuestTooltipTextLeft"..i]
                if text and text:GetText() then
                    local line = text:GetText()
                    -- Check for quest objective patterns
                    if string.find(line, "(%d+)/(%d+)") or string.find(line, "([%d%.]+)%%") then
                        isQuestUnit = true
                        break
                    end
                end
            end
            
            tooltip:Hide()
            return isQuestUnit
        end
    end
end

-- Nameplate API compatibility
-- These will be overridden by nameplates_unified.lua with proper version detection
SQP.Compat.GetNamePlateForUnit = function(unitID)
    -- Placeholder - will be overridden by nameplates_unified.lua
    return nil
end

SQP.Compat.GetNamePlates = function()
    -- Placeholder - will be overridden by nameplates_unified.lua
    return {}
end

-- Color Picker compatibility
if not ColorPickerFrame.SetupColorPickerAndShow then
    ColorPickerFrame.SetupColorPickerAndShow = function(self, info)
        ColorPickerFrame:SetColorRGB(info.r or 1, info.g or 1, info.b or 1)
        ColorPickerFrame.hasOpacity = info.hasOpacity
        ColorPickerFrame.opacity = info.opacity or 1
        ColorPickerFrame.func = info.swatchFunc
        ColorPickerFrame.cancelFunc = info.cancelFunc
        ColorPickerFrame:Show()
    end
end

-- Instance type compatibility
if not IsInInstance then
    IsInInstance = function()
        local inInstance, instanceType = GetInstanceInfo()
        return inInstance, instanceType
    end
end