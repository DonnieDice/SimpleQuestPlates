--=====================================================================================
-- SQP | Simple Quest Plates - quest.lua
-- Version: 1.0.0
-- Author: DonnieDice
-- Description: Quest detection and progress tracking
--=====================================================================================

local addonName, SQP = ...

-- Cache frequently used globals
local C_TaskQuest = C_TaskQuest
local C_Scenario = C_Scenario
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
    
    if SQP.Compat.GetQuestObjectives then
        local objectives = SQP.Compat.GetQuestObjectives(questID)
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
    if not unitID or not SQP.Compat.UnitIsRelatedToActiveQuest(unitID) then 
        return 
    end
    
    local tooltipData = SQP.Compat.GetTooltipData(unitID)
    if not tooltipData then return end
    
    local progressGlob = nil
    local questType = nil
    local objectiveCount = 0
    local questLogIndex = nil
    local questID = nil
    
    -- For Classic/MoP, use simpler parsing
    if SQP.isClassic then
        -- Scan tooltip lines for quest text
        for i = 1, #tooltipData.lines do
            local line = tooltipData.lines[i]
            local text = line.leftText or (line.type == 17 and line.leftText)
            
            if text then
                -- Look for quest progress patterns
                local x, y = strmatch(text, '(%d+)/(%d+)')
                if x and y then
                    -- Found kill/collect quest
                    local numLeft = tonumber(y) - tonumber(x)
                    if numLeft > 0 then
                        questType = 1  -- Kill quest
                        objectiveCount = numLeft
                        progressGlob = text
                        break
                    end
                else
                    -- Check for percentage
                    local progress = tonumber(strmatch(text, '([%d%.]+)%%'))
                    if progress and progress < 100 then
                        questType = 3  -- Percent quest
                        objectiveCount = ceil(100 - progress)
                        progressGlob = text
                        break
                    end
                end
            end
        end
        
        return progressGlob, questType, objectiveCount, questID
    end
    
    -- Original retail code
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
                local progress = C_TaskQuest and C_TaskQuest.GetQuestProgressBarInfo and C_TaskQuest.GetQuestProgressBarInfo(questID)
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
    
    -- Hide in mythic+ (only for retail)
    if C_Scenario and C_Scenario.GetInfo then
        local scenarioName, currentStage, numStages, flags, _, _, _, xp, money, scenarioType = C_Scenario.GetInfo()
        if scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE then
            Q:Hide()
            return
        end
    end
    
    local progressGlob, questType, objectiveCount, questLogIndex, questID = self:GetQuestProgress(unitID)

    -- Decide if there is a relevant objective for this unit
    local showIcon = false
    local displayText = "?"
    local displayColor = {1, 1, 1} -- Default white

    if progressGlob and questType ~= 2 then
        local hasItemObjective = false
        local itemsNeeded = 0

        -- Check for item objectives that drop from this unit
        local tooltipData = SQP.Compat.GetTooltipData(unitID)
        if (questLogIndex or questID) and tooltipData then
            local questIdForItems = questID or (C_QuestLog.GetInfo and C_QuestLog.GetInfo(questLogIndex) and C_QuestLog.GetInfo(questLogIndex).questID)
            if questIdForItems then
                for i = 1, 10 do
                    local text, objectiveType, finished = GetQuestObjectiveInfo(questIdForItems, i, false)
                    if not text then break end
                    if not finished and (objectiveType == 'item' or objectiveType == 'object') then
                        local itemName = text:match("([^:]+):") or text:match("(.+)/(.+)") or text
                        local unitDropsItem = false
                        for _, line in ipairs(tooltipData.lines) do
                            if line.leftText and line.leftText:find(itemName, 1, true) then
                                unitDropsItem = true
                                break
                            end
                        end
                        if unitDropsItem then
                            hasItemObjective = true
                            local x, y = text:match('(%d+)/(%d+)')
                            if x and y then
                                local numLeft = tonumber(y) - tonumber(x)
                                if numLeft > itemsNeeded then itemsNeeded = numLeft end
                            end
                        end
                    end
                end
            end
        end

        -- Priority: Item > Kill > Percent
        if hasItemObjective and itemsNeeded > 0 then
            showIcon = true
            displayText = itemsNeeded
            displayColor = SQPSettings.itemColor or {0.2, 1, 0.2}
            Q.hasItem = true
            Q.lootIcon:Show()
        elseif objectiveCount > 0 then
            showIcon = true
            displayText = objectiveCount
            if questType == 1 then
                displayColor = SQPSettings.killColor or {1, 0.82, 0}
            elseif questType == 3 then
                 displayColor = SQPSettings.percentColor or {0.2, 1, 1}
            end
            Q.hasItem = false
            Q.lootIcon:Hide()
        elseif questType == 3 then -- Percent quest without a specific kill count
            showIcon = true
            displayText = objectiveCount > 0 and objectiveCount or '?'
            displayColor = SQPSettings.percentColor or {0.2, 1, 1}
            Q.hasItem = false
            Q.lootIcon:Hide()
        end
    end

    if showIcon then
        -- Update and show the icon
        Q.iconText:SetText(displayText)
        Q.iconText:SetTextColor(unpack(displayColor))
        Q.icon:SetDesaturated(false)

        if not Q:IsVisible() then
            Q.ani:Stop()
            Q:Show()
            Q.ani:Play()
            if SQPSettings.iconTint and SQPSettings.iconTintColor and Q.icon then
                Q.icon:SetVertexColor(unpack(SQPSettings.iconTintColor))
            else
                Q.icon:SetVertexColor(1, 1, 1, 1)
            end
            if SQPSettings.debug then
                self:PrintMessage(format("Showing quest plate for %s", UnitName(unitID) or "Unknown"))
            end
        end
    else
        -- Hide the icon
        Q:Hide()
    end
end

-- Cache quest indexes for faster lookups
function SQP:CacheQuestIndexes()
    wipe(self.QuestLogIndex)
    
    -- Use compatibility layer for quest log
    if SQP.Compat.GetNumQuestLogEntries then
        local numQuests = SQP.Compat.GetNumQuestLogEntries()
        for i = 1, numQuests do
            local info = SQP.Compat.GetInfo(i)
            if info and not info.isHeader then
                self.QuestLogIndex[info.title] = i
            end
        end
    end
    
    -- Update all visible nameplates
    for plate, frame in pairs(self.ActiveNameplates) do
        self:UpdateQuestIcon(plate, frame._unitID)
    end
end

-- Load world quests for current zone
function SQP:LoadWorldQuests()
    -- World quests don't exist in MoP Classic
    if not C_TaskQuest or not C_TaskQuest.GetQuestsForPlayerByMapID then
        return
    end
    
    local uiMapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit('player')
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