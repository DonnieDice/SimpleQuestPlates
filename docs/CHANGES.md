# Simple Quest Plates - Change Log

<p align="center">
  <img src="https://raw.githubusercontent.com/donniedice/SimpleQuestPlates/main/images/logo.png" alt="SQP Icon" width="128" height="128">
</p>

## Version 1.1.0-alpha - 2025-08-15

### Added
- Unified nameplate detection system that works across all WoW versions
- Dynamic version detection for Retail, Classic Era, Wrath, Cata, and MoP
- Compatibility layer with low resource usage
- Modern event-based detection for Legion+ clients
- Classic OnUpdate scanning with throttling for pre-Legion clients
- Debug command `/sqpnameplates` to check nameplate system status

### Changed
- Replaced multiple MoP-specific detection files with single unified system
- Improved nameplate detection reliability across all WoW versions
- Optimized CPU usage with throttled scanning for Classic versions
- Better unit tracking with cached nameplate lookups

### Fixed
- Quest icons not automatically appearing on nameplates in MoP Classic
- Nameplate detection failing in various Classic WoW versions
- Lua syntax errors in debug files
- Performance issues from unthrottled nameplate scanning

### Removed
- Old debug files (mop_test.lua, debug_mop.lua, debug_icons.lua, force_icons.lua)
- Redundant compatibility files (compat_mop.lua, compat_mop_v2.lua, compat_mop_final.lua)

---

<p align="center">
  <strong>Simple Quest Plates</strong><br>
  Part of the RGX Mods Collection<br>
  <em>Discord: discord.gg/N7kdKAHVVF</em>
</p>