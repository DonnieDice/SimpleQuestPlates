# Simple Quest Plates - Change Log

<p align="center">
  <img src="https://raw.githubusercontent.com/donniedice/SimpleQuestPlates/main/images/logo.png" alt="SQP Icon" width="128" height="128">
</p>

## Version 1.0.3 - 2025-08-15

### Added
- WoWInterface distributor description file (wowinterface.txt)
- Wago.io distributor description file (wago.md)
- Helper function `SetSetting()` for proper settings management

### Changed
- Updated TOC file with WoWInterface ID (26957) and Wago ID (ANz0AwK4)
- Improved settings persistence system to properly use global SavedVariables
- All options panels now use centralized SetSetting function for consistency

### Fixed
- Settings not persisting across character logout/login, game restarts, and reloads
- Settings now properly save account-wide and sync across all characters
- Color picker settings in options panels now properly save to global variables
- Fixed deep copy issues with nested table settings (colors)

---

<p align="center">
  <strong>Simple Quest Plates</strong><br>
  Part of the RGX Mods Collection<br>
  <em>Discord: discord.gg/N7kdKAHVVF</em>
</p>