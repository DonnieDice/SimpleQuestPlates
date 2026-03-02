# Changelog

## v1.9.2
- Percent tab now fully matches Kill and Loot tab structure: dedicated Animate section (header + "Animate Main Icon" checkbox controlling `percentAnimateMain`) appears before the Color section, consistent with the Animate sections on Kill and Loot tabs.
- Main Icon tint section on Percent tab no longer duplicates the Animate checkbox (it now uses `skipAnimate=true`).
- Preview type-switcher buttons (Kill / Loot / %) moved from top-right of preview frame to centered bottom, below the nameplate preview.
- Preview title "Live Preview" moved back to centered top of the preview frame.

## v1.9.1
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

## v1.9.0
- Per-type granular controls: Kill, Loot, and Percent tabs now each have Display Style (Icon/Text), Animate Main Icon, and Main Icon Tinting — fully independent per quest type.
- Per-type mini icon tinting: Kill and Loot icon tinting are now separate settings (killTintIcon/lootTintIcon), replacing the previously shared iconTintQuest.
- Per-type jellybean tinting (killTintMain, lootTintMain, percentTintMain) replaces the global iconTintMain setting.
- Per-type main icon animation (killAnimateMain, lootAnimateMain, percentAnimateMain) replaces the global animateQuestIcon.
- Preview auto-switches quest type when you click a tab (Kill → kill preview, Loot → loot preview, Percent → percent preview).
- All option controls on Kill/Loot/Percent tabs now immediately switch the preview to the relevant quest type when interacted with.
- Removed Kill/Loot/Percent quest type buttons from beneath the preview — tab selection handles switching instead.
- Preview container height reduced from 148px to 108px, gaining more space for tab body content.
- Font settings simplified: outline width, opacity, and color controls removed from per-type font sections; font size and family remain.
- Loot tab now also exposes Animate Task Icons (was only on Kill tab).
- About tab redesigned with two-column layout (info/features on left, commands/tab guide on right) to fit all content without overflow.
- General tab note updated to reflect that font, tinting, and animation are all per quest type.

## v1.8.4
- Tab reorganization: Font settings moved into General tab (right column); Colors and Task Icons tabs dissolved; Kill, Loot, Percent each get their own tab with all relevant controls (visibility, color, tint, size, offsets).
- Add "Show Percent Icon" toggle to Percent tab, parity with Kill and Loot.
- Fix: percentIconSize slider now actually controls the font size of the "%" (and "75%") text — was hardcoded to fontSize+4.
- Fix: preview animation (Animate Main Icon) no longer blocked by IsShown guard — tickers now fire unconditionally and are cleaned up by OnHide; OnShow restarts the animation when the panel becomes visible.
- Update defaults to tuned in-game values: offsetX=12, offsetY=3, scale=1.1, no outline, killIconOffsetX=2, killIconOffsetY=15, lootIconOffsetX=-38, lootIconOffsetY=16, percentIconOffsetX=-17, killIconSize/lootIconSize=14, percentIconSize=8, animateQuestIcons=true.
- Restore About tab content: description box, key features list, slash commands reference, RGX community link.
- Main Icon tab now includes tinting controls in the right column.

## v1.8.3
- Shrink options panel header (60px, smaller logo/title) and preview container (148px) to free ~90px of body space, preventing tab content from overflowing the bottom of the panel.
- Reduce tab bar height and inter-section gaps to further maximise body content area.
- Fix default percent icon offset to X=8, Y=3 (was X=10, Y=0).

## v1.8.2
- Fix percent quest preview: now correctly shows jellybean + number + "%" in icon mode, and floating "75%" in text mode.
- Fix preview animation: replace unreliable AnimationGroup with C_Timer ticker so "Animate Main Icon" visibly pulses in the options panel preview.
- Add individual size sliders for Kill, Loot, and Percent task icons (8–40px each) in the Task Icons tab — no longer tied to global scale.
- Extend task icon offset range from ±30 to ±80 to allow positioning further from the nameplate.
- Restyle icon display mode toggle: replace "Show Icon Background" checkbox with explicit "Icon" / "Text" style buttons.
- Fix percent quest not respecting icon/text style toggle — jellybean now shows/hides correctly for percent quests.
- Fix default percent icon X offset overlapping the progress value — default shifted to +10.
- Reduce outline layer opacity default to 70% and use a narrower font size (fontSize−2) to prevent thick black bleed obscuring text.
- Preview reflects individual task icon sizes and updated offsets in real time.

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

## v1.7.9
- Fix "Enable" button label in General tab was showing full addon name instead of just "Enable".

## v1.7.8
- Redesign options panel into 6 tabs: General, Font, Colors (new), Main Icon, Quest Icons, About.
- Move all color/tinting settings into dedicated Colors tab — clears overflow from Main Icon and Quest Icons tabs.
- Change font outline selector from three buttons to a slider (None / Normal / Thick); default changed from Thick to Normal.
- Add "Animate Quest Icons" toggle in Quest Icons tab (pulsing animation on kill/loot mini-icons).
- Fix Reset buttons overflowing the panel frame across all tabs.
- Fix quest-icon offset sliders overflowing right edge of panel.

## v1.7.6
- Fix "Show Icon Background" preview: toggling back on now correctly restores the sample number text (was stuck showing "5/8"/"2/5").
- Merge RGX Mods content into About tab; remove standalone RGX Mods tab.

## v1.7.5
- Add "Show Icon Background" toggle in Main Icon settings: when disabled, hides the jellybean icon and shows fraction text (e.g. "4/8" for kill quests, "2/5" for item quests) matching the percent quest style.
- Mini quest-type icons (sword/bag) also hide when icon background is disabled.

## v1.7.4
- Fix quest icon texture sublevel (7→1) so count text always renders on top in all WoW builds.
- Fix quest-complete animation (qmark) sublevel (0→7) so it flashes visibly on top of the icon.
- Fix options preview: kill/loot mini-icon sublevels now match in-game nameplate rendering (sublevel 1).
- Add Enable/Disable toggle to General options tab.
- Add missing defaults for showMessages, fontFamily, outlineWidth — Reset All Settings no longer breaks these.
- Remove dead fontColor default (was never applied to any rendered element).

## v1.7.3
- Fix percent icon live preview not switching to "% Quest" mode when offset sliders are moved — the preview now auto-switches so the "%" position updates are visible in real time.

## v1.7.2
- Fix percent icon X/Y offset sliders not moving the "%" text in the live preview.

## v1.7.1
- Fix `/sqp` slash command causing an error when typed during combat (combat lockdown).
- Fix percentage quest display showing "%" stacked on top of the number — now shows combined (e.g. "37%").
- Add X/Y offset controls for the percent icon in the Quest Icons settings tab.

## v1.7.0
- Add outline color setting for quest text (nameplates + preview).
- Fix settings reset to fully restore defaults and refresh classic nameplate scans.
- Improve classic tooltip matching for quest objectives (Questie formatting).
- Add toggles for kill/loot quest type icons.
- Fix outline color to apply with normal/thick outline widths.
- Make DEBUG prefix brackets white in chat messages.
- Fix outline color so "no outline" doesn't show colored shadows and thick outlines don't show black shadowing.
- Split icon options into Main Icon and Quest Icons tabs (removed advanced toggle).
- Separate icon tinting for main icon vs quest type icons.
- Fix outline rendering so outline color no longer bleeds into font color.
- Improve classic quest matching when quest IDs are missing in the log.
- Add classic-safe fallbacks for kill/loot icons.
- Use the hostile cursor attack icon for kill quests.
- Improve classic tooltip parsing by checking all objective lines.
- Simplify classic detection: tooltip objective lines + quest log matching (no item caching).
- Use quest-related unit flags as a fallback when objective text matching fails.
- Refresh quest plates on target/mouseover and add a short delayed rescan after plate show.
- Refine retail tooltip parsing to use quest line types and ignore non-player objectives.
- Make tooltip count parsing tolerant of whitespace and reuse objective parsing helper.
- Use C_TooltipInfo when available (including Classic modern clients) and scan both tooltip columns.
- Make chat prefix brackets white.
- Add kill/loot icon offset settings and percent icon for progress quests.
- Apply icon tinting to kill/loot icons and percent symbol.
- Compact quest type icon offset controls to save space in options.
- Add optional quest icon pulse animation toggle.
- Fix outline color visibility by moving outline text above the icon layer.
