# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SQP (Simple Quest Plates) is a professional World of Warcraft addon that displays quest progress icons on enemy nameplates. As of v1.0.0, it features a streamlined architecture, persistent settings, multi-language support, and extensive error handling as part of the RGX Mods collection.

## Project Structure

- **data/core.lua**: Main addon functionality with quest tracking
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

## Settings Architecture

**SavedVariables**: `SQPSettings` automatically managed with fallback defaults

The addon uses an optimized, professional architecture:

1. **Constants Management**: Performance-optimized with cached local constants
2. **Global Namespace**: `SQP` table with proper initialization and namespacing
3. **Settings System**: Complete configuration management with type validation
4. **Event System**: Optimized event handling with early returns
5. **Slash Commands**: Complete `/sqp` interface with comprehensive validation
6. **Error Handling**: Enterprise-grade protection with `pcall` protection
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

- Version centralized in `ADDON_VERSION` constant in `core.lua`
- Settings persist automatically via SavedVariables
- Multi-language support with automatic locale detection
- Professional error handling with pcall protection
- Quest progress detection using modern WoW APIs