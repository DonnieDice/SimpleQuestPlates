## v1.8.1
- Fix ghost quests on old characters causing fake nameplate objectives: skip hidden quest log entries (isHidden) in all quest scanning loops.

## v1.8.0
- Add inline ↺ reset buttons next to every slider and color control; remove large section-level reset buttons.
- Decouple "Show Icon Background" from task icons — kill/loot mini icons now show/hide independently via their own toggles.
- Add "Outline Opacity" slider (0–100%) for granular outline intensity control without changing the outline mode.
- Rename "Quest Icons" tab to "Task Icons" throughout the options panel.
- Preview auto-switches to the relevant quest type when adjusting kill/loot/percent color or offset settings.
- Fix animate main icon in preview — now uses a more dramatic fade (1.0→0.15) so it's clearly visible.
- Add activateKillMode / activateLootMode helpers on preview frame for consistent mode switching.
- Compact About tab — removed verbose description box and standalone community section.
