# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Plots recipe for dos, projection and band structure
### Removed
- Dependence on Plots.jl

## [0.2.0]
### Added
- Visualize DOS and pDOS
- Tools for orbit transformation
- Tools for separating spin up and spin down for PROCAR of LNONCOLLINEAR

## [0.1.5]
### Added
- Load PROCAR for noncollinear calculation

### Fixed
- Lacking whitespace for negative k points coordinates in PROCAR

## [0.1.4]
### Added
- Generate DOS and pDOS

## [0.1.3]
### Added
- Visualize band structure and projected band structure

## [0.1.2]
### Added
- load EIGENVAL

### Removed
- bands and kpoints metadata in Projection type

## [0.1.1]
### Added
- type for band, k-point and projection
- load and save PROCAR
- load PROOUT

## [0.1.0]
### Added
- Type for lattice, atom and cell
- load and save POSCAR

[Unreleased]: https://github.com/yaozhenghangma/MatterEnv/blob/main/CHANGELOG.md
[0.2.0]: https://github.com/yaozhenghangma/MatterEnv.jl/tree/v0.2.0
[0.1.5]: https://github.com/yaozhenghangma/MatterEnv.jl/tree/v0.1.5
[0.1.4]: https://github.com/yaozhenghangma/MatterEnv.jl/tree/v0.1.4
[0.1.3]: https://github.com/yaozhenghangma/MatterEnv.jl/tree/v0.1.3
[0.1.2]: https://github.com/yaozhenghangma/MatterEnv.jl/tree/v0.1.2
[0.1.1]: https://github.com/yaozhenghangma/MatterEnv.jl/tree/v0.1.1
[0.1.0]: https://github.com/yaozhenghangma/MatterEnv.jl/tree/v0.1.0