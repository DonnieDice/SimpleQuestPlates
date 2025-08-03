--=====================================================================================
-- SQP | Simple Quest Plates - core.lua
-- Version: 1.0.0
-- Author: DonnieDice
-- Description: Main initialization and core functions
--=====================================================================================

-- Get addon namespace
local addonName, SQP = ...
_G.SQP = SQP
SQP.L = SQP.L or {}
SQP.VERSION = "1.0.0"

-- Constants
local ADDON_NAME = "Simple Quest Plates"
local ADDON_SHORT = "SQP"
local ADDON_PREFIX = "|cff58be81SQP|r"
local ADDON_ICON = "|TInterface\\AddOns\\SimpleQuestPlates\\images\\icon:0|t"
local DISCORD_LINK = "discord.gg/N7kdKAHVVF"
local CURSE_PROJECT_ID = "1319776"

-- Default settings
local DEFAULTS = {
    enabled = true,
    scale = 1.0,
    offsetX = 0,
    offsetY = 0,
    anchor = "RIGHT",
    relativeTo = "LEFT",
    debug = false
}

-- Load settings from saved variables
function SQP:LoadSettings()
    SQPSettings = SQPSettings or {}
    for key, value in pairs(DEFAULTS) do
        if SQPSettings[key] == nil then
            SQPSettings[key] = value
        end
    end
end

-- Save settings (automatic via SavedVariables)
function SQP:SaveSettings()
    -- Settings are automatically saved by WoW
end

-- Reset settings to defaults
function SQP:ResetSettings()
    SQPSettings = {}
    for key, value in pairs(DEFAULTS) do
        SQPSettings[key] = value
    end
    self:PrintMessage(self.L["SETTINGS_RESET"])
    self:RefreshAllNameplates()
end

-- Print formatted message to chat
function SQP:PrintMessage(message)
    print(format("%s %s %s", ADDON_ICON, ADDON_PREFIX, message))
end

-- Enable addon
function SQP:Enable()
    SQPSettings.enabled = true
    self:SaveSettings()
    self:PrintMessage(self.L["ADDON_ENABLED"])
    self:RefreshAllNameplates()
end

-- Disable addon
function SQP:Disable()
    SQPSettings.enabled = false
    self:SaveSettings()
    self:PrintMessage(self.L["ADDON_DISABLED"])
    
    -- Hide all quest plates
    for plate, frame in pairs(self.QuestPlates or {}) do
        frame:Hide()
    end
end

-- Wrapper functions for compatibility
function SQP:EnableAddon()
    self:Enable()
end

function SQP:DisableAddon()
    self:Disable()
end

-- Public API
_G["SimpleQuestPlates"] = SQP