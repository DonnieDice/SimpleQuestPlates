--=====================================================================================
-- SQP | Simple Quest Plates - core.lua
-- Version: 1.0.0
-- Author: DonnieDice
-- Description: Professional quest tracking overlay for enemy nameplates
--=====================================================================================

-- Initialize global addon namespace
SQP = SQP or {}
SQP.L = SQP.L or {}

-- Performance optimization: Cache frequently used globals
local pcall = pcall
local pairs = pairs
local ipairs = ipairs
local format = string.format
local tinsert = table.insert
local tremove = table.remove
local CreateFrame = CreateFrame
local GetQuestsForPlayerByMapID = C_TaskQuest.GetQuestsForPlayerByMapID
local GetMapID = C_Map.GetBestMapForUnit
local IsQuestComplete = C_QuestLog.IsQuestComplete
local GetQuestObjectives = C_QuestLog.GetQuestObjectives
local GetNumQuestObjectives = C_QuestLog.GetNumQuestObjectives
local GetQuestLogIndexByID = C_QuestLog.GetLogIndexForQuestID
local UnitIsEnemy = UnitIsEnemy
local UnitIsUnit = UnitIsUnit
local UnitCanAttack = UnitCanAttack

-- Constants
local ADDON_NAME = "Simple Quest Plates"
local ADDON_SHORT = "SQP"
local ADDON_VERSION = "1.0.0"
local ADDON_PREFIX = "|cff58be81SQP|r"
local ADDON_ICON = "|TInterface\\AddOns\\SimpleQuestPlates\\images\\icon:0|t"
local DISCORD_LINK = "discord.gg/N7kdKAHVVF"
local CHAT_COMMAND = "sqp"

-- Default settings
local DEFAULTS = {
    enabled = true,
    scale = 1.0,
    offsetX = 0,
    offsetY = 0,
    anchor = "LEFT",
    questCache = {},
    debug = false
}

-- Addon state
local questPlatePool = {}
local activeNameplates = {}
local questObjectiveCache = {}
local updateThrottle = 0
local THROTTLE_INTERVAL = 0.2

-- Create main frame
local eventFrame = CreateFrame("Frame", "SQPEventFrame", UIParent)
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if SQP[event] then
        local success, err = pcall(SQP[event], SQP, ...)
        if not success then
            SQP:ErrorHandler(err, event)
        end
    end
end)

-- Error handling function
function SQP:ErrorHandler(error, context)
    local message = format("%s %s in %s: %s", 
        self.L["ERROR_PREFIX"], 
        context or "Unknown", 
        ADDON_NAME, 
        error or "Unknown error"
    )
    print(message)
end

-- Settings management
function SQP:LoadSettings()
    -- Load saved variables or use defaults
    SQPSettings = SQPSettings or {}
    
    -- Merge with defaults
    for key, value in pairs(DEFAULTS) do
        if SQPSettings[key] == nil then
            SQPSettings[key] = value
        end
    end
    
    -- Clear quest cache on load
    SQPSettings.questCache = {}
end

function SQP:SaveSettings()
    -- Settings are automatically saved by WoW
end

function SQP:ResetSettings()
    SQPSettings = {}
    self:LoadSettings()
    self:PrintMessage(self.L["SETTINGS_RESET"])
    self:RefreshAllNameplates()
end

-- Print formatted message
function SQP:PrintMessage(message)
    print(format("%s %s %s", ADDON_ICON, ADDON_PREFIX, message))
end

-- Quest plate creation and management
function SQP:CreateQuestPlate()
    local plate = CreateFrame("Frame", nil, UIParent)
    plate:SetSize(20, 20)
    
    -- Create icon texture
    plate.icon = plate:CreateTexture(nil, "OVERLAY")
    plate.icon:SetAllPoints()
    plate.icon:SetTexture("Interface\\QuestFrame\\AutoQuest-Parts")
    plate.icon:SetTexCoord(0.30273438, 0.41992188, 0.015625, 0.953125)
    
    -- Create count text
    plate.text = plate:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    plate.text:SetPoint("CENTER", plate, "CENTER", 0, 0)
    plate.text:SetTextColor(1, 1, 1)
    
    plate:Hide()
    return plate
end

function SQP:GetQuestPlate()
    -- Get from pool or create new
    local plate = tremove(questPlatePool)
    if not plate then
        plate = self:CreateQuestPlate()
    end
    return plate
end

function SQP:ReleaseQuestPlate(plate)
    plate:Hide()
    plate:ClearAllPoints()
    plate:SetParent(UIParent)
    plate.nameplate = nil
    plate.questID = nil
    tinsert(questPlatePool, plate)
end

-- Quest detection and caching
function SQP:UpdateQuestCache()
    questObjectiveCache = {}
    
    local mapID = GetMapID("player")
    if not mapID then return end
    
    -- Get all quests on current map
    local quests = GetQuestsForPlayerByMapID(mapID)
    if not quests then return end
    
    for _, questInfo in ipairs(quests) do
        local questID = questInfo.questId
        if questID and not IsQuestComplete(questID) then
            local objectives = GetQuestObjectives(questID)
            if objectives then
                for _, objective in ipairs(objectives) do
                    if not objective.finished and objective.type == "monster" then
                        -- Extract NPC names from objective text
                        local npcName = objective.text:match("^(.-)%s*:%s*%d+/%d+$") or
                                       objective.text:match("^(.-)%s*slain%s*:%s*%d+/%d+$") or
                                       objective.text:match("^(.-)%s*killed%s*:%s*%d+/%d+$")
                        
                        if npcName then
                            questObjectiveCache[npcName] = {
                                questID = questID,
                                text = objective.text,
                                numFulfilled = objective.numFulfilled,
                                numRequired = objective.numRequired
                            }
                        end
                    end
                end
            end
        end
    end
end

-- Nameplate handling
function SQP:OnNamePlateAdded(nameplate)
    if not SQPSettings.enabled then return end
    if not nameplate.UnitFrame then return end
    
    local unit = nameplate.UnitFrame.unit
    if not unit then return end
    
    -- Only process enemy units
    if not UnitIsEnemy("player", unit) or not UnitCanAttack("player", unit) then
        return
    end
    
    -- Check if unit is quest objective
    local unitName = UnitName(unit)
    if unitName and questObjectiveCache[unitName] then
        self:AttachQuestPlate(nameplate, questObjectiveCache[unitName])
    end
    
    activeNameplates[nameplate] = true
end

function SQP:OnNamePlateRemoved(nameplate)
    if activeNameplates[nameplate] then
        local questPlate = nameplate.questPlate
        if questPlate then
            self:ReleaseQuestPlate(questPlate)
            nameplate.questPlate = nil
        end
        activeNameplates[nameplate] = nil
    end
end

function SQP:AttachQuestPlate(nameplate, questInfo)
    local questPlate = nameplate.questPlate
    if not questPlate then
        questPlate = self:GetQuestPlate()
        nameplate.questPlate = questPlate
    end
    
    -- Update appearance
    questPlate:SetScale(SQPSettings.scale)
    
    -- Calculate remaining
    local remaining = questInfo.numRequired - questInfo.numFulfilled
    if remaining > 0 then
        questPlate.text:SetText(remaining)
        questPlate.text:Show()
    else
        questPlate.text:Hide()
    end
    
    -- Attach to nameplate
    questPlate:SetParent(nameplate)
    questPlate:ClearAllPoints()
    
    local anchor = SQPSettings.anchor
    local relativeTo = anchor == "LEFT" and "RIGHT" or "LEFT"
    questPlate:SetPoint(anchor, nameplate, relativeTo, SQPSettings.offsetX, SQPSettings.offsetY)
    questPlate:Show()
end

function SQP:RefreshAllNameplates()
    -- Update quest cache first
    self:UpdateQuestCache()
    
    -- Refresh all active nameplates
    for nameplate in pairs(activeNameplates) do
        -- Remove existing quest plate
        if nameplate.questPlate then
            self:ReleaseQuestPlate(nameplate.questPlate)
            nameplate.questPlate = nil
        end
        
        -- Re-process nameplate
        self:OnNamePlateAdded(nameplate)
    end
end

-- Update handler
function SQP:OnUpdate(elapsed)
    updateThrottle = updateThrottle + elapsed
    if updateThrottle >= THROTTLE_INTERVAL then
        updateThrottle = 0
        
        -- Periodic quest cache update
        self:UpdateQuestCache()
    end
end

-- Slash command handler
function SQP:ProcessSlashCommand(input)
    input = input:trim():lower()
    
    if input == "" or input == "help" then
        self:ShowHelp()
    elseif input == "on" or input == "enable" then
        self:EnableAddon()
    elseif input == "off" or input == "disable" then
        self:DisableAddon()
    elseif input == "test" then
        self:TestQuestDetection()
    elseif input == "status" then
        self:ShowStatus()
    elseif input == "reset" then
        self:ResetSettings()
    elseif input:match("^scale%s+(.+)") then
        local scale = input:match("^scale%s+(.+)")
        self:SetScale(scale)
    elseif input:match("^offset%s+(-?%d+)%s+(-?%d+)") then
        local x, y = input:match("^offset%s+(-?%d+)%s+(-?%d+)")
        self:SetOffset(x, y)
    elseif input:match("^anchor%s+(.+)") then
        local anchor = input:match("^anchor%s+(.+)")
        self:SetAnchor(anchor)
    else
        self:PrintMessage(self.L["ERROR_UNKNOWN_COMMAND"])
    end
end

-- Command implementations
function SQP:ShowHelp()
    self:PrintMessage(self.L["HELP_HEADER"])
    print(self.L["HELP_TEST"])
    print(self.L["HELP_ENABLE"])
    print(self.L["HELP_DISABLE"])
    print(self.L["HELP_STATUS"])
    print(self.L["HELP_SCALE"])
    print(self.L["HELP_OFFSET"])
    print(self.L["HELP_ANCHOR"])
    print(self.L["HELP_RESET"])
    self:PrintMessage(self.L["COMMUNITY_MESSAGE"])
end

function SQP:EnableAddon()
    SQPSettings.enabled = true
    self:SaveSettings()
    self:PrintMessage(self.L["ADDON_ENABLED"])
    self:RefreshAllNameplates()
end

function SQP:DisableAddon()
    SQPSettings.enabled = false
    self:SaveSettings()
    self:PrintMessage(self.L["ADDON_DISABLED"])
    
    -- Hide all quest plates
    for nameplate in pairs(activeNameplates) do
        if nameplate.questPlate then
            self:ReleaseQuestPlate(nameplate.questPlate)
            nameplate.questPlate = nil
        end
    end
end

function SQP:TestQuestDetection()
    self:PrintMessage(self.L["TEST_SCANNING"])
    self:UpdateQuestCache()
    
    local count = 0
    for _ in pairs(questObjectiveCache) do
        count = count + 1
    end
    
    if count > 0 then
        self:PrintMessage(format(self.L["TEST_FOUND_QUESTS"], count))
    else
        self:PrintMessage(self.L["TEST_NO_QUESTS"])
    end
end

function SQP:ShowStatus()
    self:PrintMessage(self.L["STATUS_HEADER"])
    print(format("%s %s", self.L["STATUS_STATUS"], 
        SQPSettings.enabled and self.L["ENABLED_STATUS"] or self.L["DISABLED_STATUS"]))
    print(format(self.L["STATUS_VERSION"], ADDON_VERSION))
    print(format(self.L["STATUS_SCALE"], SQPSettings.scale))
    print(format(self.L["STATUS_OFFSET"], SQPSettings.offsetX, SQPSettings.offsetY))
    print(format(self.L["STATUS_ANCHOR"], SQPSettings.anchor))
    
    local count = 0
    for _ in pairs(questObjectiveCache) do
        count = count + 1
    end
    print(format(self.L["STATUS_QUESTS_TRACKED"], count))
end

function SQP:SetScale(scaleStr)
    local scale = tonumber(scaleStr)
    if not scale or scale < 0.5 or scale > 2.0 then
        self:PrintMessage(self.L["ERROR_INVALID_SCALE"])
        return
    end
    
    SQPSettings.scale = scale
    self:SaveSettings()
    self:PrintMessage(format(self.L["SETTINGS_SCALE_SET"], scale))
    self:RefreshAllNameplates()
end

function SQP:SetOffset(xStr, yStr)
    local x, y = tonumber(xStr), tonumber(yStr)
    if not x or not y then
        self:PrintMessage(self.L["ERROR_INVALID_OFFSET"])
        return
    end
    
    SQPSettings.offsetX = x
    SQPSettings.offsetY = y
    self:SaveSettings()
    self:PrintMessage(format(self.L["SETTINGS_OFFSET_SET"], x, y))
    self:RefreshAllNameplates()
end

function SQP:SetAnchor(anchor)
    anchor = anchor:upper()
    if anchor ~= "LEFT" and anchor ~= "RIGHT" then
        self:PrintMessage(self.L["ERROR_INVALID_ANCHOR"])
        return
    end
    
    SQPSettings.anchor = anchor
    self:SaveSettings()
    self:PrintMessage(format(self.L["SETTINGS_ANCHOR_SET"], anchor))
    self:RefreshAllNameplates()
end

-- Event handlers
function SQP:ADDON_LOADED(addonName)
    if addonName ~= "SimpleQuestPlates" then return end
    
    -- Load settings
    self:LoadSettings()
    
    -- Unregister this event
    eventFrame:UnregisterEvent("ADDON_LOADED")
end

function SQP:PLAYER_LOGIN()
    -- Welcome message
    self:PrintMessage(self.L["WELCOME_MESSAGE"])
    
    -- Register nameplate events
    eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
    eventFrame:RegisterEvent("QUEST_ACCEPTED")
    eventFrame:RegisterEvent("QUEST_REMOVED")
    eventFrame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
    
    -- Initial quest cache update
    self:UpdateQuestCache()
    
    -- Set up update handler
    eventFrame:SetScript("OnUpdate", function(self, elapsed)
        SQP:OnUpdate(elapsed)
    end)
end

function SQP:NAME_PLATE_UNIT_ADDED(unit)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
    if nameplate then
        self:OnNamePlateAdded(nameplate)
    end
end

function SQP:NAME_PLATE_UNIT_REMOVED(unit)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
    if nameplate then
        self:OnNamePlateRemoved(nameplate)
    end
end

function SQP:QUEST_LOG_UPDATE()
    self:RefreshAllNameplates()
end

function SQP:QUEST_ACCEPTED()
    self:RefreshAllNameplates()
end

function SQP:QUEST_REMOVED()
    self:RefreshAllNameplates()
end

function SQP:UNIT_QUEST_LOG_CHANGED()
    self:RefreshAllNameplates()
end

-- Initialize addon
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

-- Register slash commands
SLASH_SQP1 = "/" .. CHAT_COMMAND
SlashCmdList["SQP"] = function(input)
    SQP:ProcessSlashCommand(input)
end

-- Public API for debugging
_G["SimpleQuestPlates"] = SQP