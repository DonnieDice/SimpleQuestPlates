# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SQP (Simple Quest Plates) is a professional World of Warcraft addon that displays quest progress icons on enemy nameplates. As of v1.0.0, it features a streamlined architecture, persistent settings, multi-language support, and extensive error handling as part of the RGX Mods collection.

## Project Structure

- **data/core.lua**: Main initialization and settings management
- **data/nameplates.lua**: Nameplate creation and tracking system
- **data/quest.lua**: Quest detection and progress tracking logic
- **data/events.lua**: Event handling and registration
- **data/commands.lua**: Slash commands and chat interface
- **data/options.lua**: Narcissus-style options panel interface
- **data/locales.lua**: Multi-language support (English, Russian, German, French, Spanish)
- **images/icon.tga**: Addon icon displayed in all output
- **SimpleQuestPlates.toc**: TOC file for retail WoW (The War Within)

## Commands

Use `/sqp` followed by various commands for full functionality:

- `/sqp help` - Show all available commands
- `/sqp on/off` - Enable/disable addon
- `/sqp test` - Test functionality
- `/sqp status` - Show current settings
- `/sqp scale <0.5-2.0>` - Set icon scale
- `/sqp offset <x> <y>` - Set icon offset

## Architecture Overview

**SavedVariables**: `SQPSettings` automatically managed with fallback defaults

The addon uses a modular architecture split across multiple files:

1. **Nameplate Management**: Tracks all nameplates with GUID mapping for efficient updates
2. **Quest Detection**: Uses `C_QuestLog.UnitIsRelatedToActiveQuest` for accurate tracking
3. **Event System**: Centralized event handling with proper registration/unregistration
4. **Settings System**: Complete configuration management with type validation
5. **Slash Commands**: Complete `/sqp` interface in dedicated commands module
6. **Options Panel**: Beautiful Narcissus-style interface using only built-in textures
7. **Localization**: Multi-language support with automatic locale detection

## RGX Mods Standards

This addon follows RGX Mods community standards with Discord integration and professional error handling.

## Key Features

- **Retail-Only Support**: Designed specifically for The War Within
- **Settings Validation**: All user inputs are type-checked and validated
- **Error Resilience**: Addon continues functioning even with errors
- **Performance**: Optimized for minimal memory and CPU usage
- **Maintainability**: Clean, documented code with clear separation of concerns
- **User Experience**: Consistent RGX Mods branding with icons and professional messaging
- **Community Integration**: RealmGX Discord integration throughout the addon

## Development Notes

- Version centralized in `SQP.VERSION` in `core.lua`
- Settings persist automatically via SavedVariables
- Multi-language support with automatic locale detection
- Nameplate tracking inspired by QuestPlates' semlib approach
- Quest progress detection using modern WoW APIs (C_QuestLog, C_TooltipInfo)
- No external dependencies - built entirely with native WoW APIs
- Code split into logical modules for maintainability