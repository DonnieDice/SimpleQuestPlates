# SimpleQuestPlates

SimpleQuestPlates is a World of Warcraft addon that displays quest objective progress directly on enemy nameplates.

## Highlights

- Real-time quest objective indicators on visible nameplates
- Separate handling for kill, loot, and percent-style objectives
- Item objectives are prioritized when a unit supports both item and kill progress
- Live preview in the options panel for position, scale, text, and icon behavior
- Runtime-safe settings with SavedVariables defaults and migration logic
- Retail and Classic-client compatibility via `compat.lua` and `compat_mop.lua`

## Installation

1. Download the latest release from GitHub, CurseForge, Wago, or WoWInterface.
2. Extract `SimpleQuestPlates` into your WoW `Interface/AddOns` directory.
3. Restart WoW or run `/reload`.

## Slash Commands

- `/sqp` or `/sqp options` - Open options
- `/sqp help` - Show command list
- `/sqp on` / `/sqp off` - Enable or disable addon
- `/sqp status` - Print current settings summary
- `/sqp version` - Print addon version
- `/sqp test` - Scan visible nameplates for quest matches
- `/sqp scale <0.5-2.0>` - Set global icon scale
- `/sqp offset <x> <y>` - Set icon offsets
- `/sqp anchor <LEFT|RIGHT>` - Set anchor side
- `/sqp reset` - Reset settings to defaults
- `/sqp debug` - Toggle debug mode

## Development

No build step is required. The addon is loaded directly by WoW from Lua/XML/TOC files.

Manual in-game checks:

- `/sqp test`
- `/sqp status`
- `/sqp help`

## Release Checklist

1. Update version in `SimpleQuestPlates.toc` and `data/core.lua`.
2. Update `docs/CHANGELOG.md` and `docs/CHANGES.md`.
   - Keep a single section for the current release only.
3. Commit changes.
4. Tag release (example: `v1.9.6`) and push branch + tag.

## Repository Layout

- `data/` - Runtime addon modules
- `locales/` - Localization files (`enUS`, `deDE`, `esES`, `frFR`, `ruRU`, `zhCN`)
- `images/` - Addon icons, logo, and screenshots
- `docs/` - Changelog, release notes, roadmap, and repo docs
- `.github/workflows/` - Release automation

## License

MIT. See `LICENSE`.
