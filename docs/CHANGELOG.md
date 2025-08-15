# Changelog

All notable changes to Simple Quest Plates will be documented in this file.

## [1.0.6] - 2025-08-15

### Fixed
- Fixed Discord webhook changelog extraction to properly parse version from CHANGES.md
- Improved changelog content formatting for Discord embeds
- Added fallback changelog content if extraction fails
- Enhanced JSON escaping for special characters in Discord payload

### Changed
- Discord notifications now properly display release changelog content
- Improved markdown to Discord formatting conversion

## [1.0.5] - 2025-08-15

### Fixed
- Restored complete GitHub Actions workflow with Discord notifications
- Fixed workflow file truncation issue
- Ensured Discord webhook runs even if some upload steps fail (if: always())

### Changed
- Improved workflow reliability with proper error handling

## [1.0.4] - 2025-08-15

### Fixed
- Updated WoWInterface description to properly mirror README content
- Removed all problematic Unicode and special characters from distributor descriptions
- Fixed GitHub Actions workflow for proper release deployment

### Changed
- Cleaned up WoWInterface BBCode formatting for better display
- Improved distributor descriptions with complete feature lists

## [1.0.3] - 2025-08-15

### Added
- WoWInterface distributor description file (wowinterface.txt)
- Wago.io distributor description file (wago.md)
- Helper function `SetSetting()` for proper settings management

### Changed
- Updated TOC file with WoWInterface ID (26957) and Wago ID (ANz0AwK4)
- Improved settings persistence system to properly use global SavedVariables
- All options panels now use centralized SetSetting function for consistency

### Fixed
- Settings not persisting across character logout/login, game restarts, and reloads
- Settings now properly save account-wide and sync across all characters
- Color picker settings in options panels now properly save to global variables
- Fixed deep copy issues with nested table settings (colors)

## [1.0.2] - 2025-08-06

### Added
- RealmGX branding throughout README
- Kiwi mascot image and quotes
- Multi-column layouts for better organization
- RealmGX.com links throughout documentation
- README formatting guide documentation
- Additional GitHub stats badges
- Support links for Buy Me a Coffee and PayPal

### Changed
- Updated README with comprehensive brand colors
- Improved visual organization with table layouts
- Enhanced community section with mascot
- Replaced generic quotes with RealmGX branding

### Fixed
- Removed non-functional repository activity badges
- Fixed color consistency throughout README

## [1.0.1] - 2025-08-05

### Added
- GitHub Actions workflow for automated packaging and releases
- Automated deployment to CurseForge, WoWInterface, and Wago
- WakaTime development statistics to README
- Comprehensive coding activity tracking badges

### Fixed
- Outline width buttons - "None" button now properly removes outline instead of applying thin outline
- Exclamation point color in options menu sidebar to use brand color
- CurseForge packaging configuration (.pkgmeta)
- Removed duplicate pkgmeta.yaml file
- Version number consistency across all files
- Updated addon packaging metadata for better compatibility with addon hosting sites

## [1.0.0] - 2025-01-03

### Initial Release
- First public release of Simple Quest Plates
- Full quest tracking functionality for World of Warcraft: The War Within
- RGX Mods community addon