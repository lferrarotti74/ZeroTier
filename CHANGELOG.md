# Changelog

All notable changes to the ZeroTier-Docker project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project documentation structure
- Comprehensive contribution guidelines
- Maintainer governance documentation
- Author attribution system
- ZeroTier One v1.14.2 integration
- Multi-architecture support (amd64, arm64, armv7)
- Licensing information for ZeroTier versions

### Changed
- Updated project documentation to follow community standards
- Migrated from LibHdHomerun to ZeroTier One

### Deprecated

### Removed

### Fixed

### Security

## [v2025.01.21] - 2025-01-21

### Added
- Docker image for ZeroTier One v1.14.2
- Multi-architecture support (amd64, amd64/v2, amd64/v3, arm64, armv7)
- Automated CI/CD pipeline with GitHub Actions
- Docker Scout security scanning
- SonarQube code quality analysis
- Dependabot dependency management
- BSL v1.1 License compliance

### Documentation
- README with ZeroTier usage instructions
- Docker Hub integration
- Build and deployment workflows
- Licensing considerations for v1.16.0 upgrade path

### Important Notes
- **Licensing**: Based on ZeroTier One v1.14.2 under BSL v1.1
- **Future Versions**: v1.16.0+ will have additional commercial restrictions for controller functionality
- **Non-Commercial Use**: Remains free for businesses, academic institutions, and personal use

---

## Release Notes Guidelines

### Version Format
- **vYYYY.MM.DD** (e.g., v2025.01.21)
- Date-based versioning for Docker images
- Optional semantic versioning for major releases

### Change Categories
- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security improvements
- **Documentation**: Documentation updates

### Entry Format
- Use present tense ("Add feature" not "Added feature")
- Reference issues/PRs when applicable: `- Fix memory leak (#123)`
- Credit contributors: `- Add ARM support (@contributor)`

### Release Process
1. Update CHANGELOG.md with new version
2. Update version in relevant files
3. Create GitHub release with changelog excerpt
4. Tag release following semver

---

## Contributors

Thanks to all contributors who help improve this project:

- **Luca Ferrarotti** (@lferrarotti74) - Project Creator & Maintainer

*Contributors are automatically added when they make their first contribution.*

---

**Note**: Dates use YYYY-MM-DD format. Unreleased changes are tracked at the top.