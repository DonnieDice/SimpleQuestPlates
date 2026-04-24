# v1.9.9 - 2026-04-24

## Changes
- Rebuilt options panel on `RGXUI:CreateOptionsPanel` (RGX-Framework v1.2.0).
- Flattened tab structure: General / Kill / Loot / Percent / About (removed nested Objectives container).
- Live preview section wired as options panel banner — sits between header and tabs, switches mode automatically when Kill/Loot/Percent tabs are selected.
- Deleted `options_tabs.lua` and `options_header.lua`; all tab/header layout now handled by the framework.
