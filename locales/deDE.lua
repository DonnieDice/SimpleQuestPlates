--=====================================================================================
-- SQP | Simple Quest Plates - deDE.lua
-- Version: 1.0.0
-- Author: DonnieDice
-- Description: German localization
--=====================================================================================

local addonName, SQP = ...
local locale = GetLocale()

if locale ~= "deDE" then return end

local L = SQP.L or {}

-- German translations
L["OPTIONS_ENABLE"] = "Simple Quest Plates aktivieren"
L["OPTIONS_DISPLAY"] = "Anzeigeeinstellungen"
L["OPTIONS_SCALE"] = "Symbolgröße"
L["OPTIONS_OFFSET_X"] = "Horizontaler Versatz"
L["OPTIONS_OFFSET_Y"] = "Vertikaler Versatz"
L["OPTIONS_ANCHOR"] = "Symbolposition"
L["OPTIONS_TEST"] = "Erkennung testen"
L["OPTIONS_RESET"] = "Alle Einstellungen zurücksetzen"

L["CMD_ENABLED"] = "Simple Quest Plates ist jetzt |cff00ff00AKTIVIERT|r"
L["CMD_DISABLED"] = "Simple Quest Plates ist jetzt |cffff0000DEAKTIVIERT|r"
L["CMD_VERSION"] = "Simple Quest Plates Version: |cff58be81%s|r"
L["CMD_HELP_HEADER"] = "|cff58be81Simple Quest Plates Befehle:|r"

L["MSG_LOADED"] = "|cff58be81Simple Quest Plates!|r erfolgreich geladen. Gib |cfffff569/sqp help|r für Befehle ein."