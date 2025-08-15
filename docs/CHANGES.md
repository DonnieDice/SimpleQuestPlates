## Version 1.1.0-alpha

### 🎮 Alpha Release - MoP Classic Support

This alpha release adds full support for Mists of Pandaria Classic with performance optimizations.

### ✨ New Features
- **MoP Classic Compatibility**: Full nameplate quest tracking support for MoP Classic
- **Performance Optimizations**: Reduced lag from icon position updates
- **Smart Update System**: Adaptive update intervals (faster out of combat, slower in combat)
- **Nameplate Caching**: Improved performance through intelligent caching

### 🔧 Technical Improvements
- Created `compat_mop.lua` for MoP-specific nameplate handling
- Implemented OnUpdate polling system for older nameplate API
- Added UnitIsQuestBoss support for MoP quest detection
- Fixed C_TaskQuest API compatibility issues

### ⚡ Performance Enhancements
- Update interval: 0.2s (normal) / 0.5s (combat)
- Nameplate lookup caching reduces CPU usage
- Skip redundant scans when nameplate count unchanged

### 📦 Installation
Copy the SimpleQuestPlates folder to your Interface/AddOns directory for:
- Retail (The War Within)
- Classic Cataclysm
- Classic Era
- **MoP Classic** (NEW!)

### ⚠️ Alpha Notice
This is an alpha release. Please report any issues on our GitHub page.