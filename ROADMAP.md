# Simple Quest Plates - Development Roadmap

<p align="center">
  <img src="images/icon.tga" alt="SQP Icon" width="128" height="128">
</p>

## 🎯 Project Scope

Simple Quest Plates provides visual quest tracking indicators on enemy nameplates in World of Warcraft, showing remaining objectives without external dependencies.

---

## ✅ Completed Features (v1.1.0)

### Core Features
- Quest progress icons with kill count display on nameplates
- Item drop tracking with priority display (items show before kills)
- World quest support with automatic zone detection
- Multi-language support (EN, RU, DE, FR, ES)
- Customizable icon scale, position, and anchor
- RGX Mods branding and integration

### Architecture Improvements
- Complete rewrite using proper nameplate API (like QuestPlates)
- Split monolithic code into logical modules:
  - `core.lua` - Main initialization
  - `nameplates.lua` - Nameplate tracking
  - `quest.lua` - Quest detection logic
  - `events.lua` - Event handling
  - `commands.lua` - Slash commands
  - `options_*.lua` - Modular options panel
- Implemented simplified event system without external dependencies
- Fixed quest detection using C_QuestLog.UnitIsRelatedToActiveQuest
- Created Narcissus-style options panel with built-in textures
- Added proper event handling for quest updates

### User Requests Implemented
- ✅ Converted logo to icon.tga format
- ✅ Added proper coloring to addon title (colored first letters)
- ✅ Integrated icon throughout addon (chat, menu, options)
- ✅ Quest item drop indicators
- ✅ Item priority display (shows item count over kill count)
- ✅ Split code into manageable files
- ✅ Split options panel into logical components
- ✅ Added debug mode (/sqp debug)

---

## 🔧 Current Tasks

- [ ] Test addon functionality in-game
- [ ] Verify quest icon display on nameplates
- [ ] Test item drop priority system
- [ ] Ensure compatibility with latest WoW retail patch

---

## 🚀 Future Enhancements

Based on user feedback and requests:
- Custom texture generation for options panel
- Integration with other RGX Mods addons
- Performance optimizations for high-density areas
- Additional customization options

---

## 📝 Known Issues

- Quest objectives are being detected but icons may not display properly
- Awaiting in-game testing to identify any remaining issues

---

## 🛠️ Technical Notes

- No external libraries used (built entirely with native WoW APIs)
- Follows QuestPlates architecture patterns
- Curse Project ID: 1319776
- Compatible with The War Within expansion

---

<p align="center">
  <strong>Simple Quest Plates</strong><br>
  Part of the RGX Mods Collection<br>
  <em>Discord: discord.gg/N7kdKAHVVF</em>
</p>