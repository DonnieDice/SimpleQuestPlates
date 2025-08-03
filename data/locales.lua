--=====================================================================================
-- SQP | Simple Quest Plates - locales.lua
-- Version: 1.0.0
-- Author: DonnieDice
-- Description: Multi-language localization system for Simple Quest Plates
--=====================================================================================

-- Get addon namespace
local addonName, SQP = ...
_G.SQP = _G.SQP or SQP

-- Initialize localization table
SQP.L = SQP.L or {}

-- Get current WoW client locale
local locale = GetLocale()

-- Default English strings (always loaded as fallback)
local L = {
    -- Status Messages
    ["ADDON_ENABLED"] = "Addon |cff00ff00enabled|r",
    ["ADDON_DISABLED"] = "Addon |cffff0000disabled|r",
    ["QUEST_TRACKING_ENABLED"] = "Quest tracking |cff00ff00enabled|r",
    ["QUEST_TRACKING_DISABLED"] = "Quest tracking |cffff0000disabled|r",
    ["WELCOME_MESSAGE"] = "|cff58be81S|r|cffffffffimple|r |cff58be81Q|r|cffffffffuest|r |cff58be81P|r|cfffffffflates|r |cff58be81Loaded!|r Type |cffffffff/sqp|r to open options",
    
    -- Error Messages
    ["ERROR_PREFIX"] = "|cffff0000SQP Error:|r",
    ["ERROR_UNKNOWN_COMMAND"] = "Unknown command. Type |cffffffff/sqp help|r for available commands",
    ["ERROR_INVALID_SCALE"] = "Invalid scale value. Use a number between 0.5 and 2.0",
    ["ERROR_INVALID_OFFSET"] = "Invalid offset values. Use numbers for X and Y",
    
    -- Help System
    ["HELP_HEADER"] = "|cff58be81=== Simple Quest Plates Commands ===|r",
    ["HELP_TEST"] = "|cffffffff/sqp test|r - Test quest detection",
    ["HELP_ENABLE"] = "|cffffffff/sqp on|r - Enable addon",
    ["HELP_DISABLE"] = "|cffffffff/sqp off|r - Disable addon",
    ["HELP_STATUS"] = "|cffffffff/sqp status|r - Show current settings",
    ["HELP_SCALE"] = "|cffffffff/sqp scale <0.5-2.0>|r - Set icon scale",
    ["HELP_OFFSET"] = "|cffffffff/sqp offset <x> <y>|r - Set icon position",
    ["HELP_ANCHOR"] = "|cffffffff/sqp anchor <left/right>|r - Set anchor side",
    ["HELP_RESET"] = "|cffffffff/sqp reset|r - Reset all settings",
    ["HELP_OPTIONS"] = "|cffffffff/sqp options|r - Open the options panel",
    
    -- Status Display
    ["STATUS_HEADER"] = "|cff58be81=== SQP Status ===|r",
    ["STATUS_STATUS"] = "Status:",
    ["STATUS_VERSION"] = "Version: |cffffffff%s|r",
    ["STATUS_SCALE"] = "Icon Scale: |cffffffff%.1f|r",
    ["STATUS_OFFSET"] = "Icon Offset: |cffffffff%d, %d|r",
    ["STATUS_ANCHOR"] = "Anchor Side: |cffffffff%s|r",
    ["STATUS_QUESTS_TRACKED"] = "Quests Tracked: |cffffffff%d|r",
    
    -- General Status
    ["ENABLED_STATUS"] = "|cff00ff00Enabled|r",
    ["DISABLED_STATUS"] = "|cffff0000Disabled|r",
    ["TYPE_HELP"] = "Type |cffffffff/sqp help|r for commands",
    
    -- Test Messages
    ["TEST_SCANNING"] = "Scanning for quest objectives...",
    ["TEST_FOUND_QUESTS"] = "Found |cffffffff%d|r quest objectives",
    ["TEST_NO_QUESTS"] = "No quest objectives found nearby",
    
    -- Settings Messages
    ["SETTINGS_SCALE_SET"] = "Icon scale set to: |cffffffff%.1f|r",
    ["SETTINGS_OFFSET_SET"] = "Icon offset set to: |cffffffff%d, %d|r",
    ["SETTINGS_ANCHOR_SET"] = "Anchor side set to: |cffffffff%s|r",
    ["SETTINGS_RESET"] = "All settings reset to defaults",
    
    -- RGX Mods Branding
    ["RGX_MODS_PREFIX"] = "|cff58be81RGX Mods|r",
    ["COMMUNITY_MESSAGE"] = "Part of the RealmGX Community - join us at discord.gg/N7kdKAHVVF",
    
    -- Options Panel
    ["OPTIONS_SUBTITLE"] = "Quest tracking overlay for enemy nameplates",
    ["OPTIONS_ENABLE"] = "Enable Simple Quest Plates",
    ["OPTIONS_ENABLE_DESC"] = "Toggle quest icon display on enemy nameplates",
    ["OPTIONS_SCALE"] = "Icon Scale",
    ["OPTIONS_OFFSET_X"] = "Horizontal Offset",
    ["OPTIONS_OFFSET_Y"] = "Vertical Offset",
    ["OPTIONS_ANCHOR"] = "Anchor Side",
    ["OPTIONS_TEST"] = "Test Detection",
    ["OPTIONS_RESET"] = "Reset Settings",
    ["OPTIONS_COMMUNITY"] = "RGX Mods Community",
    ["OPTIONS_GENERAL"] = "General Settings",
    ["OPTIONS_DISPLAY"] = "Display Settings",
    ["OPTIONS_POSITION"] = "Position Settings",
    ["OPTIONS_ACTIONS"] = "Actions"
}

-- Russian localization by ZamestoTV (Hubbotu)
if locale == "ruRU" then
    L["ADDON_ENABLED"] = "Аддон |cff00ff00включен|r"
    L["ADDON_DISABLED"] = "Аддон |cffff0000отключен|r"
    L["QUEST_TRACKING_ENABLED"] = "Отслеживание заданий |cff00ff00включено|r"
    L["QUEST_TRACKING_DISABLED"] = "Отслеживание заданий |cffff0000отключено|r"
    L["WELCOME_MESSAGE"] = "Добро пожаловать в Simple Quest Plates! Введите |cffffffff/sqp help|r для команд"
    
    L["ERROR_PREFIX"] = "|cffff0000Ошибка SQP:|r"
    L["ERROR_UNKNOWN_COMMAND"] = "Неизвестная команда. Введите |cffffffff/sqp help|r для доступных команд"
    L["ERROR_INVALID_SCALE"] = "Неверное значение масштаба. Используйте число от 0.5 до 2.0"
    L["ERROR_INVALID_OFFSET"] = "Неверные значения смещения. Используйте числа для X и Y"
    
    L["HELP_HEADER"] = "|cff58be81=== Команды Simple Quest Plates ===|r"
    L["HELP_TEST"] = "|cffffffff/sqp test|r - Тест обнаружения заданий"
    L["HELP_ENABLE"] = "|cffffffff/sqp on|r - Включить аддон"
    L["HELP_DISABLE"] = "|cffffffff/sqp off|r - Отключить аддон"
    L["HELP_STATUS"] = "|cffffffff/sqp status|r - Показать текущие настройки"
    L["HELP_SCALE"] = "|cffffffff/sqp scale <0.5-2.0>|r - Установить масштаб иконки"
    L["HELP_OFFSET"] = "|cffffffff/sqp offset <x> <y>|r - Установить позицию иконки"
    L["HELP_ANCHOR"] = "|cffffffff/sqp anchor <left/right>|r - Установить сторону привязки"
    L["HELP_RESET"] = "|cffffffff/sqp reset|r - Сбросить все настройки"
    
    L["STATUS_HEADER"] = "|cff58be81=== Статус SQP ===|r"
    L["STATUS_STATUS"] = "Статус:"
    L["STATUS_VERSION"] = "Версия: |cffffffff%s|r"
    L["STATUS_SCALE"] = "Масштаб иконки: |cffffffff%.1f|r"
    L["STATUS_OFFSET"] = "Смещение иконки: |cffffffff%d, %d|r"
    L["STATUS_ANCHOR"] = "Сторона привязки: |cffffffff%s|r"
    L["STATUS_QUESTS_TRACKED"] = "Отслеживаемые задания: |cffffffff%d|r"
    
    L["ENABLED_STATUS"] = "|cff00ff00Включен|r"
    L["DISABLED_STATUS"] = "|cffff0000Отключен|r"
    L["TYPE_HELP"] = "Введите |cffffffff/sqp help|r для команд"
    
    L["TEST_SCANNING"] = "Поиск целей заданий..."
    L["TEST_FOUND_QUESTS"] = "Найдено |cffffffff%d|r целей заданий"
    L["TEST_NO_QUESTS"] = "Цели заданий не найдены поблизости"
    
    L["SETTINGS_SCALE_SET"] = "Масштаб иконки установлен на: |cffffffff%.1f|r"
    L["SETTINGS_OFFSET_SET"] = "Смещение иконки установлено на: |cffffffff%d, %d|r"
    L["SETTINGS_ANCHOR_SET"] = "Сторона привязки установлена на: |cffffffff%s|r"
    L["SETTINGS_RESET"] = "Все настройки сброшены на значения по умолчанию"
    
    L["COMMUNITY_MESSAGE"] = "Часть сообщества RealmGX - присоединяйтесь к нам на discord.gg/N7kdKAHVVF"

-- German localization
elseif locale == "deDE" then
    L["ADDON_ENABLED"] = "Addon |cff00ff00aktiviert|r"
    L["ADDON_DISABLED"] = "Addon |cffff0000deaktiviert|r"
    L["QUEST_TRACKING_ENABLED"] = "Questverfolgung |cff00ff00aktiviert|r"
    L["QUEST_TRACKING_DISABLED"] = "Questverfolgung |cffff0000deaktiviert|r"
    L["WELCOME_MESSAGE"] = "Willkommen bei Simple Quest Plates! Tippe |cffffffff/sqp help|r für Befehle"
    
    L["ERROR_PREFIX"] = "|cffff0000SQP Fehler:|r"
    L["ERROR_UNKNOWN_COMMAND"] = "Unbekannter Befehl. Tippe |cffffffff/sqp help|r für verfügbare Befehle"
    L["ERROR_INVALID_SCALE"] = "Ungültiger Skalierungswert. Verwende eine Zahl zwischen 0,5 und 2,0"
    L["ERROR_INVALID_OFFSET"] = "Ungültige Versatzwerte. Verwende Zahlen für X und Y"
    
    L["HELP_HEADER"] = "|cff58be81=== Simple Quest Plates Befehle ===|r"
    L["HELP_TEST"] = "|cffffffff/sqp test|r - Questerkennung testen"
    L["HELP_ENABLE"] = "|cffffffff/sqp on|r - Addon aktivieren"
    L["HELP_DISABLE"] = "|cffffffff/sqp off|r - Addon deaktivieren"
    L["HELP_STATUS"] = "|cffffffff/sqp status|r - Aktuelle Einstellungen anzeigen"
    L["HELP_SCALE"] = "|cffffffff/sqp scale <0.5-2.0>|r - Symbolgröße einstellen"
    L["HELP_OFFSET"] = "|cffffffff/sqp offset <x> <y>|r - Symbolposition einstellen"
    L["HELP_ANCHOR"] = "|cffffffff/sqp anchor <left/right>|r - Ankerseite einstellen"
    L["HELP_RESET"] = "|cffffffff/sqp reset|r - Alle Einstellungen zurücksetzen"
    
    L["STATUS_HEADER"] = "|cff58be81=== SQP Status ===|r"
    L["STATUS_STATUS"] = "Status:"
    L["STATUS_VERSION"] = "Version: |cffffffff%s|r"
    L["STATUS_SCALE"] = "Symbolgröße: |cffffffff%.1f|r"
    L["STATUS_OFFSET"] = "Symbolversatz: |cffffffff%d, %d|r"
    L["STATUS_ANCHOR"] = "Ankerseite: |cffffffff%s|r"
    L["STATUS_QUESTS_TRACKED"] = "Verfolgte Quests: |cffffffff%d|r"
    
    L["ENABLED_STATUS"] = "|cff00ff00Aktiviert|r"
    L["DISABLED_STATUS"] = "|cffff0000Deaktiviert|r"
    L["TYPE_HELP"] = "Tippe |cffffffff/sqp help|r für Befehle"
    
    L["TEST_SCANNING"] = "Suche nach Questzielen..."
    L["TEST_FOUND_QUESTS"] = "|cffffffff%d|r Questziele gefunden"
    L["TEST_NO_QUESTS"] = "Keine Questziele in der Nähe gefunden"
    
    L["SETTINGS_SCALE_SET"] = "Symbolgröße eingestellt auf: |cffffffff%.1f|r"
    L["SETTINGS_OFFSET_SET"] = "Symbolversatz eingestellt auf: |cffffffff%d, %d|r"
    L["SETTINGS_ANCHOR_SET"] = "Ankerseite eingestellt auf: |cffffffff%s|r"
    L["SETTINGS_RESET"] = "Alle Einstellungen auf Standardwerte zurückgesetzt"
    
    L["COMMUNITY_MESSAGE"] = "Teil der RealmGX Community - tritt uns bei: discord.gg/N7kdKAHVVF"

-- French localization
elseif locale == "frFR" then
    L["ADDON_ENABLED"] = "Addon |cff00ff00activé|r"
    L["ADDON_DISABLED"] = "Addon |cffff0000désactivé|r"
    L["QUEST_TRACKING_ENABLED"] = "Suivi des quêtes |cff00ff00activé|r"
    L["QUEST_TRACKING_DISABLED"] = "Suivi des quêtes |cffff0000désactivé|r"
    L["WELCOME_MESSAGE"] = "Bienvenue dans Simple Quest Plates ! Tapez |cffffffff/sqp help|r pour les commandes"
    
    L["ERROR_PREFIX"] = "|cffff0000Erreur SQP:|r"
    L["ERROR_UNKNOWN_COMMAND"] = "Commande inconnue. Tapez |cffffffff/sqp help|r pour les commandes disponibles"
    L["ERROR_INVALID_SCALE"] = "Valeur d'échelle invalide. Utilisez un nombre entre 0,5 et 2,0"
    L["ERROR_INVALID_OFFSET"] = "Valeurs de décalage invalides. Utilisez des nombres pour X et Y"
    
    L["HELP_HEADER"] = "|cff58be81=== Commandes Simple Quest Plates ===|r"
    L["HELP_TEST"] = "|cffffffff/sqp test|r - Tester la détection de quête"
    L["HELP_ENABLE"] = "|cffffffff/sqp on|r - Activer l'addon"
    L["HELP_DISABLE"] = "|cffffffff/sqp off|r - Désactiver l'addon"
    L["HELP_STATUS"] = "|cffffffff/sqp status|r - Afficher les paramètres actuels"
    L["HELP_SCALE"] = "|cffffffff/sqp scale <0.5-2.0>|r - Définir l'échelle de l'icône"
    L["HELP_OFFSET"] = "|cffffffff/sqp offset <x> <y>|r - Définir la position de l'icône"
    L["HELP_ANCHOR"] = "|cffffffff/sqp anchor <left/right>|r - Définir le côté d'ancrage"
    L["HELP_RESET"] = "|cffffffff/sqp reset|r - Réinitialiser tous les paramètres"
    
    L["STATUS_HEADER"] = "|cff58be81=== Statut SQP ===|r"
    L["STATUS_STATUS"] = "Statut :"
    L["STATUS_VERSION"] = "Version : |cffffffff%s|r"
    L["STATUS_SCALE"] = "Échelle de l'icône : |cffffffff%.1f|r"
    L["STATUS_OFFSET"] = "Décalage de l'icône : |cffffffff%d, %d|r"
    L["STATUS_ANCHOR"] = "Côté d'ancrage : |cffffffff%s|r"
    L["STATUS_QUESTS_TRACKED"] = "Quêtes suivies : |cffffffff%d|r"
    
    L["ENABLED_STATUS"] = "|cff00ff00Activé|r"
    L["DISABLED_STATUS"] = "|cffff0000Désactivé|r"
    L["TYPE_HELP"] = "Tapez |cffffffff/sqp help|r pour les commandes"
    
    L["TEST_SCANNING"] = "Recherche d'objectifs de quête..."
    L["TEST_FOUND_QUESTS"] = "|cffffffff%d|r objectifs de quête trouvés"
    L["TEST_NO_QUESTS"] = "Aucun objectif de quête trouvé à proximité"
    
    L["SETTINGS_SCALE_SET"] = "Échelle de l'icône définie sur : |cffffffff%.1f|r"
    L["SETTINGS_OFFSET_SET"] = "Décalage de l'icône défini sur : |cffffffff%d, %d|r"
    L["SETTINGS_ANCHOR_SET"] = "Côté d'ancrage défini sur : |cffffffff%s|r"
    L["SETTINGS_RESET"] = "Tous les paramètres réinitialisés aux valeurs par défaut"
    
    L["COMMUNITY_MESSAGE"] = "Partie de la communauté RealmGX - rejoignez-nous sur discord.gg/N7kdKAHVVF"

-- Spanish localization
elseif locale == "esES" or locale == "esMX" then
    L["ADDON_ENABLED"] = "Addon |cff00ff00habilitado|r"
    L["ADDON_DISABLED"] = "Addon |cffff0000deshabilitado|r"
    L["QUEST_TRACKING_ENABLED"] = "Seguimiento de misiones |cff00ff00habilitado|r"
    L["QUEST_TRACKING_DISABLED"] = "Seguimiento de misiones |cffff0000deshabilitado|r"
    L["WELCOME_MESSAGE"] = "¡Bienvenido a Simple Quest Plates! Escribe |cffffffff/sqp help|r para comandos"
    
    L["ERROR_PREFIX"] = "|cffff0000Error SQP:|r"
    L["ERROR_UNKNOWN_COMMAND"] = "Comando desconocido. Escribe |cffffffff/sqp help|r para comandos disponibles"
    L["ERROR_INVALID_SCALE"] = "Valor de escala inválido. Usa un número entre 0.5 y 2.0"
    L["ERROR_INVALID_OFFSET"] = "Valores de desplazamiento inválidos. Usa números para X e Y"
    
    L["HELP_HEADER"] = "|cff58be81=== Comandos Simple Quest Plates ===|r"
    L["HELP_TEST"] = "|cffffffff/sqp test|r - Probar detección de misiones"
    L["HELP_ENABLE"] = "|cffffffff/sqp on|r - Habilitar el addon"
    L["HELP_DISABLE"] = "|cffffffff/sqp off|r - Deshabilitar el addon"
    L["HELP_STATUS"] = "|cffffffff/sqp status|r - Mostrar configuración actual"
    L["HELP_SCALE"] = "|cffffffff/sqp scale <0.5-2.0>|r - Establecer escala del icono"
    L["HELP_OFFSET"] = "|cffffffff/sqp offset <x> <y>|r - Establecer posición del icono"
    L["HELP_ANCHOR"] = "|cffffffff/sqp anchor <left/right>|r - Establecer lado de anclaje"
    L["HELP_RESET"] = "|cffffffff/sqp reset|r - Restablecer toda la configuración"
    
    L["STATUS_HEADER"] = "|cff58be81=== Estado SQP ===|r"
    L["STATUS_STATUS"] = "Estado:"
    L["STATUS_VERSION"] = "Versión: |cffffffff%s|r"
    L["STATUS_SCALE"] = "Escala del icono: |cffffffff%.1f|r"
    L["STATUS_OFFSET"] = "Desplazamiento del icono: |cffffffff%d, %d|r"
    L["STATUS_ANCHOR"] = "Lado de anclaje: |cffffffff%s|r"
    L["STATUS_QUESTS_TRACKED"] = "Misiones rastreadas: |cffffffff%d|r"
    
    L["ENABLED_STATUS"] = "|cff00ff00Habilitado|r"
    L["DISABLED_STATUS"] = "|cffff0000Deshabilitado|r"
    L["TYPE_HELP"] = "Escribe |cffffffff/sqp help|r para comandos"
    
    L["TEST_SCANNING"] = "Buscando objetivos de misión..."
    L["TEST_FOUND_QUESTS"] = "|cffffffff%d|r objetivos de misión encontrados"
    L["TEST_NO_QUESTS"] = "No se encontraron objetivos de misión cercanos"
    
    L["SETTINGS_SCALE_SET"] = "Escala del icono establecida en: |cffffffff%.1f|r"
    L["SETTINGS_OFFSET_SET"] = "Desplazamiento del icono establecido en: |cffffffff%d, %d|r"
    L["SETTINGS_ANCHOR_SET"] = "Lado de anclaje establecido en: |cffffffff%s|r"
    L["SETTINGS_RESET"] = "Toda la configuración restablecida a valores predeterminados"
    
    L["COMMUNITY_MESSAGE"] = "Parte de la comunidad RealmGX - únete a nosotros en discord.gg/N7kdKAHVVF"
end

-- Assign localization table to global addon namespace
SQP.L = L

-- Provide fallback function for missing translations
function SQP:GetLocalizedString(key)
    if self.L and self.L[key] then
        return self.L[key]
    end
    
    -- Return the key itself if no translation found (for debugging)
    return key
end