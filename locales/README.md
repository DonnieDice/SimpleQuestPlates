# /locales

Localization files for SimpleQuestPlates.

## Available Locales

- `enUS.lua` - English baseline/fallback strings
- `deDE.lua` - German overrides
- `esES.lua` - Spanish overrides (also used for `esMX`)
- `frFR.lua` - French overrides
- `ruRU.lua` - Russian overrides
- `zhCN.lua` - Simplified Chinese overrides

## Guidance

- Add new keys to `enUS.lua` first.
- Other locale files can override only keys that are translated.
- Keep key names stable to avoid runtime string lookup issues.
