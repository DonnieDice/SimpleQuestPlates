--=====================================================================================
-- SQP | Simple Quest Plates - core.lua
-- Version: 1.0.8
-- Author: DonnieDice
-- Description: Main initialization and core functions
--=====================================================================================

-- Get addon namespace
local addonName, SQP = ...
_G.SQP = SQP
SQP.L = SQP.L or {}
SQP.VERSION = "1.0.8"

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
    debug = false,
    -- Font settings
    fontSize = 12,
    fontOutline = "",
    outlineWidth = 1,
    -- Color settings
    killColor = {1, 0.82, 0},      -- Yellow/gold
    itemColor = {0.2, 1, 0.2},     -- Green
    percentColor = {0.2, 1, 1},    -- Cyan
    customColors = false,
    -- Icon tinting
    iconTint = false,
    iconTintColor = {1, 1, 1},      -- White (no tint by default)
    -- Text outline color
    outlineColor = {0, 0, 0},        -- Black outline by default
    -- Additional settings
    showMessages = true,
    hideInCombat = false,
    hideInInstance = false
}

-- Load settings from saved variables
function SQP:LoadSettings()
    -- Ensure we're using the global saved variable
    if not _G.SQPSettings then
        _G.SQPSettings = {}
    end
    
    -- Deep copy defaults for nested tables
    local function deepCopy(orig)
        local copy
        if type(orig) == 'table' then
            copy = {}
            for k, v in pairs(orig) do
                copy[k] = deepCopy(v)
            end
        else
            copy = orig
        end
        return copy
    end
    
    -- Apply defaults for missing values
    for key, value in pairs(DEFAULTS) do
        if _G.SQPSettings[key] == nil then
            _G.SQPSettings[key] = deepCopy(value)
        elseif type(value) == "table" and type(_G.SQPSettings[key]) == "table" then
            -- Ensure color tables have all required fields
            for k, v in pairs(value) do
                if _G.SQPSettings[key][k] == nil then
                    _G.SQPSettings[key][k] = v
                end
            end
        end
    end
    
    -- Create a reference for easier access
    SQPSettings = _G.SQPSettings
end

-- Save settings (automatic via SavedVariables)
function SQP:SaveSettings()
    -- Settings are automatically saved by WoW
end

-- Helper function to update a setting value
function SQP:SetSetting(key, value)
    _G.SQPSettings[key] = value
    SQPSettings[key] = value
end

-- Reset settings to defaults
function SQP:ResetSettings()
    -- Deep copy defaults for nested tables
    local function deepCopy(orig)
        local copy
        if type(orig) == 'table' then
            copy = {}
            for k, v in pairs(orig) do
                copy[k] = deepCopy(v)
            end
        else
            copy = orig
        end
        return copy
    end
    
    _G.SQPSettings = {}
    for key, value in pairs(DEFAULTS) do
        _G.SQPSettings[key] = deepCopy(value)
    end
    SQPSettings = _G.SQPSettings
    self:PrintMessage(self.L["CMD_RESET"])
    self:RefreshAllNameplates()
end

-- Print formatted message to chat
function SQP:PrintMessage(message)
    if message then
        print(format("%s %s %s", ADDON_ICON, ADDON_PREFIX, message))
    end
end

-- Enable addon
function SQP:Enable()
    _G.SQPSettings.enabled = true
    SQPSettings.enabled = true
    self:SaveSettings()
    self:PrintMessage(self.L["CMD_ENABLED"])
    self:RefreshAllNameplates()
end

-- Disable addon
function SQP:Disable()
    _G.SQPSettings.enabled = false
    SQPSettings.enabled = false
    self:SaveSettings()
    self:PrintMessage(self.L["CMD_DISABLED"])
    
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