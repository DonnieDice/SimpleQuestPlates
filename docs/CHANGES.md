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
