# Changelog

This file tracks notable changes to **nrelWattileExt**. The format is based on
[Keep a Changelog], and this project adheres to [Semantic Versioning].

[Keep a Changelog]: https://keepachangelog.com/ "Keep a Changelog"
[Semantic Versioning]: https://semver.org/ "Semantic Versioning"

## Unreleased

[View Changes](https://github.com/NREL/nrelWattileExt/compare/main...develop)

### Changed

- Update license to BSD-3

## [v0.2.1] (2024-07-09)

[v0.2.1]: https://github.com/NREL/nrelWattileExt/releases/tag/v0.2.1

[View Changes](https://github.com/NREL/nrelUtilityExt/compare/v0.2.0...v0.2.1)

### Added

- `wattileResolveRec()`: a cluster-aware function that resolves a reference to a
  record dictionary

### Fixed

- Error messages that used helper function `recDisWithId()` no longer fail when
  the target record does not exist in the local database

### Changed

- `wattileRecDisWithId()` replaces `recDisWithId()`; new function is
  Wattile-specific, cluster aware, and safe
- `wattileResolveRef()` and `wattileResolveRec()` now support a `checked` flag

## [v0.2.0] (2024-03-26)

[v0.2.0]: https://github.com/NREL/nrelWattileExt/releases/tag/v0.2.0

### Added

- First release of **nrelWattileExt**! For use with [Wattile]
  [v0.2](https://github.com/NREL/Wattile/releases/tag/0.2.0)

[Wattile]: https://github.com/NREL/wattile/ "Wattile"