## v1.9.3
- Display Style (Icon/Text) is now truly per-tab: Kill, Loot, and Percent each use independent settings (`killShowIconBackground`, `lootShowIconBackground`, `percentShowIconBackground`) with migration from legacy `showIconBackground`.
- Added tab-scoped reset buttons with clearer wording: `Reset Kill Settings`, `Reset Loot Settings`, and `Reset Percent Settings`.
- Removed redundant Main Icon tint behavior from runtime and preview (main icon now uses color controls instead of duplicate tint toggles).
- Percent tab parity improvements: added compact `Tint Percent Sign` section so Percent layout/options align more closely with Kill/Loot structure.
- Login message now uses a two-line format with BLU/CCU-style coloring (loaded line + separate version line).
- Fixed checkbox persistence for boolean settings so `Animate Task Icons` and other true-default toggles reliably save OFF states.

## v1.9.2
- Percent tab now fully matches Kill and Loot tab structure: dedicated Animate section (header + "Animate Main Icon" checkbox controlling `percentAnimateMain`) appears before the Color section, consistent with the Animate sections on Kill and Loot tabs.
- Main Icon tint section on Percent tab no longer duplicates the Animate checkbox (it now uses `skipAnimate=true`).
- Preview type-switcher buttons (Kill / Loot / %) moved from top-right of preview frame to centered bottom, below the nameplate preview.
- Preview title "Live Preview" moved back to centered top of the preview frame.
- Merged General and Main Icon tabs into a single Global tab (position, scale, anchor, addon state, combat toggles).
- Main Icon tinting and animation moved from right column to left column on Kill, Loot, and Percent tabs — no more overflow.
- Tint sections redesigned as compact inline rows (color swatch + checkbox on one line) — saves ~30px per section.
- Percent tab now matches Kill and Loot tab structure: Show icon, Display Style, Color, Main Icon animate/tint on left; Position and Font on right.
- Removed per-tab scroll — all tabs now fit content without scrolling.
- Re-added small Kill / Loot / % preview type switcher buttons in the preview header for use when adjusting Global settings.
- Default global horizontal offset changed to 0 (was 12).
- Default percent icon X offset changed to 18 (was -17).
- Removed informational text block from General tab (now Global tab).
- About tab drastically simplified — title, version, description, community link, and slash commands only.
- Fix: Icons no longer shown on mobs that are no longer quest requirements — QUEST_COMPLETE event now immediately refreshes nameplates, and the questRelatedOnly fallback verifies at least one incomplete quest exists before showing "?".
- Fix: QUEST_REMOVED now immediately refreshes nameplates instead of waiting for the throttled QUEST_LOG_UPDATE.
