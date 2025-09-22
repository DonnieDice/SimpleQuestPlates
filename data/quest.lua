--=====================================================================================
-- RGX | Simple Quest Plates! - quest.lua
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
    if not unitID or not UnitExists(unitID) then return end

    local unitName = UnitName(unitID)
    if not unitName or unitName == "" then return end

    local itemsNeeded, objectiveCount, progressGlob, questType, questIdForItems = 0, 0, nil, nil, nil

    local function processObjectives(questID)
        if not questID then return end
        local objectives = SQP.Compat.GetQuestObjectives(questID)
        for _, obj in ipairs(objectives) do
            if obj.text and obj.text:find(unitName, 1, true) then
                local x, y = strmatch(obj.text, '(%d+)/(%d+)')
                if x and y then
                    local numLeft = tonumber(y) - tonumber(x)
                    if numLeft > 0 then
                        if obj.type == 'item' or obj.type == 'object' then
                            if numLeft > itemsNeeded then itemsNeeded = numLeft end
                        else -- kill or other
                            if numLeft > objectiveCount then objectiveCount = numLeft end
                        end
                        progressGlob = obj.text
                        questIdForItems = questID
                    end
                else
                    -- Handle percentage-based objectives
                    local progress = tonumber(strmatch(obj.text, '([%d%.]+)%%'))
                    if progress and progress < 100 then
                        objectiveCount = ceil(100 - progress)
                        questType = 3
                        progressGlob = obj.text
                        questIdForItems = questID
                    end
                end
            end
        end
    end

    -- Process regular quests
    if SQP.Compat.GetNumQuestLogEntries then
        for i = 1, SQP.Compat.GetNumQuestLogEntries() do
            local info = SQP.Compat.GetInfo(i)
            if info and info.questID and not info.isHeader and (not info.isComplete or info.isComplete == 0) then
                processObjectives(info.questID)
            end
        end
    end

    -- Process world quests (retail only)
    if C_TaskQuest then
        for questName, questID in pairs(self.ActiveWorldQuests) do
            if questID then
                processObjectives(questID)
            end
        end
    end

    return progressGlob, progressGlob and (questType or 1) or nil, objectiveCount, itemsNeeded, questIdForItems
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
    
    local progressGlob, questType, objectiveCount, itemsNeeded, questID = self:GetQuestProgress(unitID)

    -- Decide if there is a relevant objective for this unit
    local showIcon = false
    local displayText = "?"
    local displayColor = {1, 1, 1} -- Default white

    if progressGlob and questType ~= 2 then
        -- Priority: Item > Kill > Percent
        if itemsNeeded > 0 then
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