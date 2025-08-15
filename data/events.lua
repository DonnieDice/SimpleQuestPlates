--=====================================================================================
-- SQP | Simple Quest Plates - events.lua
-- Version: 1.0.0
-- Author: DonnieDice
-- Description: Event handling and management
--=====================================================================================

local addonName, SQP = ...

-- Create main event frame
SQP.eventFrame = CreateFrame("Frame", "SQPEventFrame", UIParent)

-- Event handler function
local function OnEvent(self, event, ...)
    if SQP[event] then
        SQP[event](SQP, ...)
    end
end

-- ADDON_LOADED: Initialize saved variables and settings
function SQP:ADDON_LOADED(addon)
    if addon ~= addonName then return end
    
    self:LoadSettings()
    
    -- Reanchor existing plates after settings load
    for plate, questFrame in pairs(self.QuestPlates) do
        if questFrame then
            questFrame.icon:ClearAllPoints()
            questFrame.icon:SetPoint(
                SQPSettings.anchor or 'RIGHT',
                questFrame,
                SQPSettings.relativeTo or 'LEFT',
                (SQPSettings.offsetX or 0) / (SQPSettings.scale or 1),
                (SQPSettings.offsetY or 0) / (SQPSettings.scale or 1)
            )
            questFrame:SetScale(SQPSettings.scale or 1)
        end
    end
    
    self.eventFrame:UnregisterEvent("ADDON_LOADED")
end

-- PLAYER_LOGIN: Initialize addon systems
function SQP:PLAYER_LOGIN()
    -- Welcome message
    self:PrintMessage(self.L["MSG_LOADED"])
    
    -- Create options panel
    self:CreateOptionsPanel()
    
    -- Load world quests
    self:LoadWorldQuests()
    
    -- Cache quest indexes
    self:CacheQuestIndexes()
end

-- Nameplate events
function SQP:NAME_PLATE_CREATED(plate)
    self:CreateQuestPlate(plate)
end

function SQP:NAME_PLATE_UNIT_ADDED(unitID)
    local plate = SQP.Compat.GetNamePlateForUnit(unitID)
    if plate then
        self:OnPlateShow(plate, unitID)
    end
end

function SQP:NAME_PLATE_UNIT_REMOVED(unitID)
    local plate = SQP.Compat.GetNamePlateForUnit(unitID)
    if plate then
        self:OnPlateHide(plate, unitID)
    end
end

-- Quest events
function SQP:UNIT_QUEST_LOG_CHANGED(unitID)
    if unitID == "player" then
        self:CacheQuestIndexes()
    else
        -- Update all plates since we don't know which unit changed
        for plate in pairs(self.ActiveNameplates) do
            self:UpdateQuestIcon(plate)
        end
    end
end

function SQP:QUEST_LOG_UPDATE()
    self:CacheQuestIndexes()
end

function SQP:QUEST_ACCEPTED(questLogIndex, questID)
    if questID and C_QuestLog and C_QuestLog.IsQuestTask and C_QuestLog.IsQuestTask(questID) then
        local questName = C_TaskQuest and C_TaskQuest.GetQuestInfoByQuestID and C_TaskQuest.GetQuestInfoByQuestID(questID)
        if questName then
            self.ActiveWorldQuests[questName] = questID
        end
    end
    self:UNIT_QUEST_LOG_CHANGED('player')
end

function SQP:QUEST_REMOVED(questID)
    if C_TaskQuest and C_TaskQuest.GetQuestInfoByQuestID then
        local questName = C_TaskQuest.GetQuestInfoByQuestID(questID)
        if questName and self.ActiveWorldQuests[questName] then
            self.ActiveWorldQuests[questName] = nil
        end
    end
    self:UNIT_QUEST_LOG_CHANGED('player')
end

function SQP:QUEST_WATCH_LIST_CHANGED(questID, added)
    self:QUEST_ACCEPTED(nil, questID)
end

-- World state events
function SQP:PLAYER_LEAVING_WORLD()
    self.eventFrame:UnregisterEvent("QUEST_LOG_UPDATE")
end

function SQP:PLAYER_ENTERING_WORLD()
    self.eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
    -- Refresh all nameplates when entering world
    self:RefreshAllNameplates()
end

-- Combat state changes
function SQP:PLAYER_REGEN_DISABLED()
    -- Entered combat
    if SQPSettings.hideInCombat then
        self:RefreshAllNameplates()
    end
end

function SQP:PLAYER_REGEN_ENABLED()
    -- Left combat
    if SQPSettings.hideInCombat then
        self:RefreshAllNameplates()
    end
end

-- Register all events
SQP.eventFrame:SetScript("OnEvent", OnEvent)
SQP.eventFrame:RegisterEvent("ADDON_LOADED")
SQP.eventFrame:RegisterEvent("PLAYER_LOGIN")

-- Register nameplate events based on version
if C_NamePlate and C_NamePlate.GetNamePlateForUnit then
    -- Modern nameplate API is available
    SQP.eventFrame:RegisterEvent("NAME_PLATE_CREATED")
    SQP.eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    SQP.eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
end
-- MoP and older versions use the OnUpdate script in compat_mop.lua

SQP.eventFrame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
SQP.eventFrame:RegisterEvent("QUEST_ACCEPTED")
SQP.eventFrame:RegisterEvent("QUEST_REMOVED")
SQP.eventFrame:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
SQP.eventFrame:RegisterEvent("PLAYER_LEAVING_WORLD")
SQP.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
SQP.eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
SQP.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")