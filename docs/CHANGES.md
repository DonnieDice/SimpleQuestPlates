# Simple Quest Plates - Change Log

<p align="center">
  <img src="../images/icon.tga" alt="SQP Icon" width="128" height="128">
</p>

## Version 1.1.0 (In Development)

### 🎯 Major Improvements
- **Complete Architecture Rewrite**: Implemented proper nameplate tracking system inspired by QuestPlates
- **Code Organization**: Split monolithic core.lua into logical modules:
  - `core.lua`: Main initialization and settings management
  - `nameplates.lua`: Nameplate creation and management
  - `quest.lua`: Quest detection and progress tracking
  - `events.lua`: Event handling and registration
  - `commands.lua`: Slash commands and chat interface
  - `options.lua`: Narcissus-style options panel

### ✨ New Features
- Proper nameplate unit tracking with GUID management
- Enhanced quest detection using `C_QuestLog.UnitIsRelatedToActiveQuest`
- World quest support with automatic zone loading
- Quest log caching for improved performance
- Beautiful options panel with built-in WoW textures

### 🐛 Bug Fixes
- Fixed quest numbers not displaying on nameplates
- Resolved nameplate attachment issues
- Corrected event handling for quest updates
- Fixed options panel anchor settings

### 🔧 Technical Changes
- Removed dependency on external libraries
- Implemented simplified event system
- Added proper entering/leaving world handlers
- Improved memory management with plate recycling

---

## Version 1.0.0 (Initial Release)

### ✨ Features
- Quest progress icons on enemy nameplates
- Kill count display for quest objectives
- Item drop indicators for loot quests
- Customizable icon scale and position
- Multi-language support (EN, RU, DE, FR, ES)
- Native Blizzard options panel
- RGX Mods integration and branding

### 📝 Commands
- `/sqp` - Open options panel
- `/sqp help` - Show all commands
- `/sqp on/off` - Enable/disable addon
- `/sqp test` - Test quest detection
- `/sqp status` - Show current settings
- `/sqp scale <0.5-2.0>` - Set icon scale
- `/sqp offset <x> <y>` - Set icon position
- `/sqp reset` - Reset to defaults

---

<p align="center">
  <strong>Simple Quest Plates</strong><br>
  Part of the RGX Mods Collection<br>
  <em>Discord: discord.gg/N7kdKAHVVF</em>
</p>