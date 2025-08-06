# README Formatting Guide for Simple Quest Plates

This document provides comprehensive details about the formatting, color scheme, and structure of the Simple Quest Plates README.md file for recreation purposes.

## Color Scheme & Branding

### Primary Brand Colors
- **SQP (Simple Quest Plates)**: `#58be81` (Green)
- **RGX Letters**: `#8B1538` (Burgundy/Raspberry)
- **"ealm" in RealmGX**: `#7598b6` (Blue)
- **"Mods"**: `#4ecdc4` (Teal)
- **Pipe separator (|)**: `#3598db` (Blue)
- **General text**: `#e67e23` (Orange)
- **White text**: `#fff` (White)
- **Accent colors**:
  - Red/Pink: `#ff6b6b`
  - Purple: `#b96ad9`
  - Green: `#2dc26b`
  - WoW Blue: `#06c`
  - GitHub Dark: `#24292e`

### Color Application Rules
1. **SQP** - Always S, Q, P letters in green (#58be81)
2. **Exclamation mark (!)** - Always green (#58be81) when following SQP
3. **RGX** - Always R, G, X letters in burgundy (#8B1538)
4. **RealmGX** - R, G, X in burgundy, "ealm" in blue (#7598b6)
5. **Mods** - Always in teal (#4ecdc4)
6. **Pipe separators** - Always blue (#3598db)

## Structure & Sections

### 1. Header
```markdown
# <span style="color:#58be81">🎯 </span> <span style="color:#58be81">S</span><span style="color:#58be81">Q</span><span style="color:#58be81">P</span> <span style="color:#3598db">|</span> <span style="color:#58be81">S</span><span style="color:#fff">imple </span> <span style="color:#58be81">Q</span><span style="color:#fff">uest </span> <span style="color:#58be81">P</span><span style="color:#fff">lates</span><span style="color:#58be81">!</span>
## <span style="color:#4ecdc4">🎮 </span> <span style="color:#8B1538">R</span><span style="color:#8B1538">G</span><span style="color:#8B1538">X</span> <span style="color:#4ecdc4">Mods</span> <span style="color:#3598db">-</span> [<span style="color:#8B1538">R</span><span style="color:#7598b6">ealm</span><span style="color:#8B1538">G</span><span style="color:#8B1538">X</span>](https://realmgx.com) <span style="color:#ff6b6b">Community Project</span>
```

### 2. Badges Section
- Two custom badges in green and burgundy
- GitHub stats badges in flat-square style
- Platform badges for CurseForge, Wago, WoWInterface
- WoW compatibility badge

### 3. Community Section
- Formatted headers with brand colors
- Discord badge and links
- Bullet points with colored icons and mixed color text

### 4. Support Section
**Multi-column table layout:**
```html
<table align="center" width="100%">
<tr>
<td align="center" width="50%">
[Donation badges column 1]
</td>
<td align="center" width="50%">
[Donation badges column 2]
</td>
</tr>
</table>
```

### 5. Features Section
- Table format with centered alignment
- Emoji icons with bold feature names
- Plain descriptions without color spans

### 6. Customization Options
**Two-column layout:**
```html
<table width="100%">
<tr>
<td width="50%" valign="top">
[Position & Color settings]
</td>
<td width="50%" valign="top">
[Font & Behavior settings]
</td>
</tr>
</table>
```

### 7. Footer Section
**Three-column layout:**
```html
<table width="100%">
<tr>
<td align="center" width="33%">
[Discord link]
</td>
<td align="center" width="34%">
[RealmGX.com link]
</td>
<td align="center" width="33%">
[Support link]
</td>
</tr>
</table>
```

## HTML/Markdown Formatting Details

### Color Spans
Every piece of text uses HTML span tags with inline styles:
```html
<span style="color:#58be81">Green Text</span>
```

### Links with Colors
Links containing colored spans:
```markdown
[<span style="color:#8B1538">R</span><span style="color:#7598b6">ealm</span><span style="color:#8B1538">G</span><span style="color:#8B1538">X</span>](https://realmgx.com)
```

### Section Headers
All section headers follow this pattern:
```markdown
## <span style="color:#ff6b6b">🎯 Section Name</span>
```

### Subsection Headers
Subsections use colored spans:
```markdown
### <span style="color:#4ecdc4">Subsection Name</span>
```

### Lists with Colors
Bullet points with mixed colors:
```markdown
- <span style="color:#2dc26b">🛠️ <strong>Feature</strong></span> <span style="color:#e67e23">description text</span>
```

### Multi-column Layouts

#### Two-column (50/50):
```html
<table width="100%">
<tr>
<td width="50%" valign="top">
[Left content]
</td>
<td width="50%" valign="top">
[Right content]
</td>
</tr>
</table>
```

#### Three-column (33/34/33):
```html
<table width="100%">
<tr>
<td align="center" width="33%">
[Column 1]
</td>
<td align="center" width="34%">
[Column 2]
</td>
<td align="center" width="33%">
[Column 3]
</td>
</tr>
</table>
```

## Special Formatting Rules

1. **Emojis**: Always outside color spans or at the beginning
2. **Bold text**: Use `<strong>` tags inside spans
3. **Italic text**: Use underscore `_` outside spans
4. **Code blocks**: Use backticks without color spans
5. **Separators**: Triple dash `---` for section breaks

## Badge Formats

### Custom brand badges:
```markdown
[![SQP Icon](https://img.shields.io/badge/SQP-Simple%20Quest%20Plates!-58be81?style=for-the-badge&logo=github&logoColor=white)](URL)
[![RGX Mods](https://img.shields.io/badge/RGX-Mods%20Collection-8B1538?style=for-the-badge&logo=github&logoColor=white)](URL)
```

### GitHub stats badges:
```markdown
![Badge Name](https://img.shields.io/github/[metric]/donniedice/SimpleQuestPlates?style=flat-square)
```

## Links Throughout Document

RealmGX.com links appear in:
1. Main subtitle
2. "Realm Gamers eXtreme" description
3. Troubleshooting section
4. Localization section
5. Thank you section (2 places)
6. Footer three-column layout

## Important Notes

1. **No plain text**: Almost all text is wrapped in color spans
2. **Consistent coloring**: Brand elements always use same colors
3. **HTML support**: README uses extensive HTML for layout
4. **Table layouts**: Used for multi-column sections
5. **Centered content**: Most sections use `<div align="center">`
6. **Mixed markdown/HTML**: Combines both for optimal rendering

## File Dependencies

- Logo image: `/images/logo.png`
- Options panel screenshot: `/images/in-game-options.png`
- GitHub profile stats and activity graphs
- External badge services (shields.io, contrib.rocks)

This formatting creates a visually striking README with consistent branding, though note that GitHub's markdown renderer doesn't support the color styling (it will display as plain text on GitHub).