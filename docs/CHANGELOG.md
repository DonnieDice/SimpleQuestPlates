# Changelog

## v1.9.6
- Fixed slash command robustness issues:
  - Replaced unsafe input trimming with safe string normalization.
  - Added explicit `/sqp version` handling.
  - Added missing debug handlers for `debug target` and `debug nameplates`.
  - Added resilient localization fallbacks for command/status output.
- Expanded `enUS` baseline localization with missing runtime keys used by commands/options.
- Removed legacy option modules that were no longer loaded by `SimpleQuestPlates.xml`:
  - `data/options_colors.lua`
  - `data/options_font.lua`
  - `data/options_quest_icons.lua`
  - `data/options_rgx.lua`
- Cleaned and synchronized repository documentation (root README, directory READMEs, roadmap, assistant docs).
- Updated release workflow support link to `discord.gg/rgxmods`.
