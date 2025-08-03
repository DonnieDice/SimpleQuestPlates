--=====================================================================================
-- SQP | Simple Quest Plates - quest.lua
-- Version: 1.0.0
-- Author: DonnieDice
-- Description: Quest detection and progress tracking
--=====================================================================================

local addonName, SQP = ...

-- Cache frequently used globals
local C_QuestLog = C_QuestLog
local C_TaskQuest = C_TaskQuest
local C_Scenario = C_Scenario
local GetQuestObjectiveInfo = GetQuestObjectiveInfo or C_QuestLog.GetQuestObjectiveInfo
local strmatch = string.match
local tonumber = tonumber
local ceil = math.ceil

-- Quest storage
SQP.ActiveWorldQuests = {}
SQP.QuestLogIndex = {}
local OurName = UnitName('player')

-- Constants
local LE_SCENARIO_TYPE_CHALLENGE_MODE = LE_SCENARIO_TYPE_CHALLENGE_MODE or 2

-- Helper function for quest objectives
local function GetQuestObjectiveInfo(questID, index, isComplete)
    if not questID then return end
    
    if C_QuestLog.GetQuestObjectives then
        local objectives = C_QuestLog.GetQuestObjectives(questID)
        if objectives and objectives[index] then
            local obj = objectives[index]
            return obj.text, obj.type, obj.finished
        end
    else
        -- Fallback for older API
        local text, objectiveType, finished = GetQuestLogLeaderBoard(index, questID)
        return text, objectiveType, finished
    end
end

-- Get quest progress from unit tooltip
function SQP:GetQuestProgress(unitID)
    if not unitID or not C_QuestLog.UnitIsRelatedToActiveQuest(unitID) then 
        return 
    end
    
    local tooltipData = C_TooltipInfo.GetUnit(unitID)
    if not tooltipData then return end
    
    local progressGlob = nil
    local questType = nil
    local objectiveCount = 0
    local questLogIndex = nil
    local questID = nil
    
    for i = 3, #tooltipData.lines do
        local line = tooltipData.lines[i]
        
        -- Surface args if available
        if TooltipUtil and TooltipUtil.SurfaceArgs then
            TooltipUtil.SurfaceArgs(line)
        end
        
        if line.type == 17 and line.id then
            local text, objectiveType, finished = GetQuestObjectiveInfo(line.id, 1, false)
            questID = questID or line.id or (text and self.ActiveWorldQuests[text])
            local progressText = text
            
            if progressText then
                local x, y = strmatch(progressText, '(%d+)/(%d+)')
                if x and y then
                    local numLeft = y - x
                    if numLeft > objectiveCount then
                        objectiveCount = numLeft
                    end
                else
                    local progress = tonumber(strmatch(progressText, '([%d%.]+)%%'))
                    if progress and progress <= 100 then
                        questType = 3
                        return text, questType, ceil(100 - progress), questID
                    end
                end
                
                if not x or (x and y and x ~= y) then
                    progressGlob = progressGlob and progressGlob .. '\n' .. progressText or progressText
                end
            elseif self.ActiveWorldQuests[text] then
                local progress = C_TaskQuest.GetQuestProgressBarInfo(questID)
                if progress then
                    questType = 3
                    return text, questType, ceil(100 - progress), questID
                end
            elseif self.QuestLogIndex[text] then
                questLogIndex = self.QuestLogIndex[text]
            end
        end
    end
    
    return progressGlob, progressGlob and 1 or questType, objectiveCount, questLogIndex, questID
end

-- Update quest icon on nameplate
function SQP:UpdateQuestIcon(plate, unitID)
    if not SQPSettings.enabled then return end
    
    local Q = self.QuestPlates[plate]
    if not Q then return end
    
    unitID = unitID or plate._unitID
    if not unitID then return end
    
    -- Check if should hide in combat
    if SQPSettings.hideInCombat and InCombatLockdown() then
        Q:Hide()
        return
    end
    
    -- Check if should hide in instance
    if SQPSettings.hideInInstance then
        local inInstance, instanceType = IsInInstance()
        if inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario" or instanceType == "pvp" or instanceType == "arena") then
            Q:Hide()
            return
        end
    end
    
    -- Hide in mythic+
    local scenarioName, currentStage, numStages, flags, _, _, _, xp, money, scenarioType = C_Scenario.GetInfo()
    if scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE then
        Q:Hide()
        return
    end
    
    local progressGlob, questType, objectiveCount, questLogIndex, questID = self:GetQuestProgress(unitID)
    if progressGlob and questType ~= 2 then
        -- Update icon text (check if it exists first)
        if not Q.iconText then
            return
        end
        
        if questType == 3 then
            Q.iconText:SetText(objectiveCount > 0 and objectiveCount or '?')
        else
            Q.iconText:SetText(objectiveCount > 0 and objectiveCount or '?')
        end
        
        -- Color based on quest type
        if questType == 1 then
            Q.icon:SetDesaturated(false)
            Q.iconText:SetTextColor(unpack(SQPSettings.killColor or {1, 0.82, 0}))
        elseif questType == 2 then
            Q.icon:SetDesaturated(true)
            Q.iconText:SetTextColor(1, 1, 1)
        elseif questType == 3 then
            Q.icon:SetDesaturated(false)
            Q.iconText:SetTextColor(unpack(SQPSettings.percentColor or {0.2, 1, 1}))
        end
        
        -- Check for loot items and adjust display priority
        Q.itemTexture:Hide()
        Q.lootIcon:Hide()
        
        local hasItemObjective = false
        local itemsNeeded = 0
        
        if questLogIndex or questID then
            if questID then
                for i = 1, 10 do
                    local text, objectiveType, finished = GetQuestObjectiveInfo(questID, i, false)
                    if not text then break end
                    
                    if not finished and (objectiveType == 'item' or objectiveType == 'object') then
                        Q.lootIcon:Show()
                        hasItemObjective = true
                        
                        -- Try to extract item count from text
                        local x, y = text:match('(%d+)/(%d+)')
                        if x and y then
                            local numLeft = tonumber(y) - tonumber(x)
                            if numLeft > itemsNeeded then
                                itemsNeeded = numLeft
                            end
                        end
                    end
                end
            else
                local info = C_QuestLog.GetInfo(questLogIndex)
                if info then
                    for i = 1, GetNumQuestLeaderBoards(questLogIndex) or 0 do
                        local text, objectiveType, finished = GetQuestObjectiveInfo(info.questID, i, false)
                        if not finished and (objectiveType == 'item' or objectiveType == 'object') then
                            Q.lootIcon:Show()
                            hasItemObjective = true
                            
                            -- Try to extract item count from text
                            local x, y = text:match('(%d+)/(%d+)')
                            if x and y then
                                local numLeft = tonumber(y) - tonumber(x)
                                if numLeft > itemsNeeded then
                                    itemsNeeded = numLeft
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- Update text display based on priority
        if hasItemObjective and itemsNeeded > 0 then
            -- Prioritize item count display
            Q.iconText:SetText(itemsNeeded)
            Q.iconText:SetTextColor(unpack(SQPSettings.itemColor or {0.2, 1, 0.2}))
            Q.hasItem = true
        elseif objectiveCount > 0 then
            -- Show kill count
            Q.iconText:SetText(objectiveCount)
            -- Keep existing color based on quest type
        else
            Q.iconText:SetText('?')
        end
        
        if not Q:IsVisible() then
            Q.ani:Stop()
            Q:Show()
            Q.ani:Play()
            
            -- Apply icon tinting if enabled
            if SQPSettings.iconTint and SQPSettings.iconTintColor and Q.icon then
                Q.icon:SetVertexColor(unpack(SQPSettings.iconTintColor))
            else
                Q.icon:SetVertexColor(1, 1, 1, 1)
            end
            
            -- Debug: Print when showing quest plate
            if SQPSettings.debug then
                self:PrintMessage(format("Showing quest plate for %s", UnitName(unitID) or "Unknown"))
            end
        end
    else
        Q:Hide()
    end
end

-- Cache quest indexes for faster lookups
function SQP:CacheQuestIndexes()
    wipe(self.QuestLogIndex)
    for i = 1, C_QuestLog.GetNumQuestLogEntries() do
        local info = C_QuestLog.GetInfo(i)
        if info and not info.isHeader then
            self.QuestLogIndex[info.title] = i
        end
    end
    
    -- Update all visible nameplates
    for plate, frame in pairs(self.ActiveNameplates) do
        self:UpdateQuestIcon(plate, frame._unitID)
    end
end

-- Load world quests for current zone
function SQP:LoadWorldQuests()
    local uiMapID = C_Map.GetBestMapForUnit('player')
    if uiMapID then
        for _, task in pairs(C_TaskQuest.GetQuestsForPlayerByMapID(uiMapID) or {}) do
            if task.inProgress then
                local questID = task.questID or task.questId  -- Handle both cases
                if questID then
                    local questName = C_TaskQuest.GetQuestInfoByQuestID(questID)
                    if questName then
                        self.ActiveWorldQuests[questName] = questID
                    end
                end
            end
        end
    end
end