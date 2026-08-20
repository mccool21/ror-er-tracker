# Changelog

All notable changes to this project are documented here. Versioning follows
[Semantic Versioning](https://semver.org/): the current version lives in the
`VERSION` file at the repo root — bump it alongside an entry here whenever a
change is worth noting (new feature, notable fix), not on every commit.

## [0.1.0] - 2026-08-20

### Added
- Playthroughs: users can create playthroughs and mark which weapons, armors,
  shields, talismans, incantations, sorceries, ashes of war, bosses,
  creatures, npcs, and locations they've found in each one, with per-type
  progress counts.
- Bootstrap 5 visual redesign (vendored locally via importmap, not a CDN),
  including a responsive mobile navbar with a working collapse toggle.

### Fixed
- Turbo's JS was never actually loading (`config/importmap.rb` and
  `javascript_importmap_tags` were missing), so `data-turbo-confirm` delete
  dialogs silently did nothing — importmap/Turbo/Stimulus are now wired up
  correctly.
- After signing in, signing up, or completing Google OAuth, users now land on
  their playthroughs page instead of their profile.
