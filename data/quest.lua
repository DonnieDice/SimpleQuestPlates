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
    local itemsNeeded = 0

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
                        -- In classic, we can't easily distinguish item from kill, but we can assume if it's not a kill, it's an item.
                        -- This part is tricky without more info. We'll stick to the original logic for now.
                        -- A simple heuristic could be to check for item-related keywords if needed in the future.
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
        
        -- In Classic, we can't reliably get questID from tooltip, so we pass nil.
        -- The item check logic is primarily for retail where we have better APIs.
        return progressGlob, questType, objectiveCount, 0, nil
    end
    
    -- New, more accurate retail code
    local objectives_found = {}
    local questIdForItems = nil

    for i = 3, #tooltipData.lines do
        local line = tooltipData.lines[i]
        if TooltipUtil and TooltipUtil.SurfaceArgs then TooltipUtil.SurfaceArgs(line) end
        if line.type == 17 and line.id and line.leftText then
            table.insert(objectives_found, { text = line.leftText, questID = line.id })
        end
    end

    if #objectives_found == 0 then return end

    for _, data in ipairs(objectives_found) do
        local progressText = data.text
        local currentQuestID = data.questID

        local x, y = strmatch(progressText, '(%d+)/(%d+)')
        if x and y then
            local numLeft = tonumber(y) - tonumber(x)
            if numLeft > 0 then -- THE FIX IS HERE
                local isItem = false
                local objectives_from_api = SQP.Compat.GetQuestObjectives(currentQuestID)
                for _, api_obj in ipairs(objectives_from_api) do
                    local objectiveName = api_obj.text:match("([^:]+)")
                    if objectiveName and progressText:find(objectiveName, 1, true) then
                        if api_obj.type == 'item' or api_obj.type == 'object' then
                            isItem = true
                        end
                        break
                    end
                end

                if isItem then
                    if numLeft > itemsNeeded then itemsNeeded = numLeft end
                else
                    if numLeft > objectiveCount then objectiveCount = numLeft end
                end
                progressGlob = (progressGlob or "") .. progressText .. "\n"
                questIdForItems = currentQuestID
            end
        else
            local progress = tonumber(strmatch(progressText, '([%d%.]+)%%'))
            if progress and progress < 100 then
                questType = 3
                objectiveCount = ceil(100 - progress)
                progressGlob = progressText
                questIdForItems = currentQuestID
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