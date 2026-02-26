# Changelog

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
