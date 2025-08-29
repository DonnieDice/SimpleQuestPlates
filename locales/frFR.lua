--=====================================================================================
-- RGX | Simple Quest Plates! - frFR.lua
-- Version: 1.0.0
-- Author: DonnieDice
-- Description: French localization
--=====================================================================================

local addonName, SQP = ...
local locale = GetLocale()

if locale ~= "frFR" then return end

local L = SQP.L or {}

-- French translations
L["OPTIONS_ENABLE"] = "Activer Simple Quest Plates"
L["OPTIONS_DISPLAY"] = "Paramètres d'affichage"
L["OPTIONS_SCALE"] = "Taille de l'icône"
L["OPTIONS_OFFSET_X"] = "Décalage horizontal"
L["OPTIONS_OFFSET_Y"] = "Décalage vertical"
L["OPTIONS_ANCHOR"] = "Position de l'icône"
L["OPTIONS_TEST"] = "Test de détection"
L["OPTIONS_RESET"] = "Réinitialiser tous les paramètres"

L["CMD_ENABLED"] = "Simple Quest Plates est maintenant |cff00ff00ACTIVÉ|r"
L["CMD_DISABLED"] = "Simple Quest Plates est maintenant |cffff0000DÉSACTIVÉ|r"
L["CMD_VERSION"] = "Version de Simple Quest Plates: |cff58be81%s|r"
L["CMD_HELP_HEADER"] = "|cff58be81Commandes RGX | Simple Quest Plates!:|r"

L["MSG_LOADED"] = "|cff58be81Simple Quest Plates!|r chargé avec succès. Tapez |cfffff569/sqp help|r pour les commandes."