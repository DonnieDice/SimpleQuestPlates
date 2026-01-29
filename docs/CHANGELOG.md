# Changelog

## v1.6.5
- Refactored quest detection logic to use tooltip scanning, significantly improving accuracy for item-based quests and objectives with multiple mob types.
- Centralized version number handling to rely on `core.lua` as the single source of truth.
- Removed redundant version comments from all `.lua` files.
- Streamlined changelog process by consolidating into `CHANGELOG.md` and removing the redundant `CHANGES.md` file.
- Updated `.pkgmeta` to point to the correct changelog file.