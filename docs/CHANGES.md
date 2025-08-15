## Version 1.1.0 - Production Release

### Added
- Full support for MoP Classic (5.4.8)
- Multi-version compatibility (Retail, MoP, Cata, Wrath, Vanilla)
- Dynamic nameplate detection based on WoW version
- Integrated compatibility layer for all versions

### Fixed
- MoP nameplate detection using NamePlate1-40 frames
- Quest icon attachment to nameplates in Classic versions
- Target detection using alpha values in MoP

### Changed
- Consolidated all compatibility code into single compat.lua
- Removed all debug and test files for production
- Streamlined codebase for better performance
- Optimized file structure