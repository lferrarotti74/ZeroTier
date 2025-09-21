# Contributing to ZeroTier-Docker

Thank you for considering contributing to ZeroTier-Docker! We welcome contributions from everyone and appreciate your help in making this Docker container better for the ZeroTier community.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Getting Started](#getting-started)
- [Development Guidelines](#development-guidelines)
- [Submitting Changes](#submitting-changes)
- [Reporting Issues](#reporting-issues)
- [Style Guidelines](#style-guidelines)
- [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [luca@ferrarotti.it](mailto:luca@ferrarotti.it).

## How Can I Contribute?

### Reporting Bugs
- Use the GitHub issue tracker
- Check if the bug has already been reported
- Provide detailed information about the bug
- Include steps to reproduce the issue

### Suggesting Enhancements
- Use the GitHub issue tracker with the "enhancement" label
- Provide a clear description of the enhancement
- Explain why this enhancement would be useful

### Contributing Code
- Fork the repository
- Create a feature branch
- Make your changes
- Submit a pull request

### Improving Documentation
- Fix typos, clarify language, or add missing information
- Documentation changes follow the same process as code changes

## Getting Started

### Prerequisites
- Docker (version 20.10 or higher)
- Git
- Basic knowledge of ZeroTier networking
- Access to ZeroTier networks for testing (recommended)

### Development Environment Setup

### Local Development Setup

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/lferrarotti74/LibHdHomerun-Docker.git
   cd LibHdHomerun-Docker
   ```
3. Build the Docker image locally:
   ```bash
   docker build -t libhdhomerun-docker:dev .
   ```
4. Create a branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

### Testing Your Changes

1. **Build and test the Docker image:**
   ```bash
   docker build -t libhdhomerun-docker:test .
   ```

2. **Test basic functionality:**
   ```bash
   # Test discovery (requires HDHomeRun on network)
   docker run --rm --network host libhdhomerun-docker:test /libhdhomerun/hdhomerun_config discover
   
   # Test help command
   docker run --rm libhdhomerun-docker:test /libhdhomerun/hdhomerun_config
   ```

3. **Test with your HDHomeRun device (if available):**
   ```bash
   # Replace with your device IP
   docker run --rm --network host libhdhomerun-docker:test /libhdhomerun/hdhomerun_config 192.168.1.100 get /sys/version
   ```

Make sure all tests pass before submitting your changes.

## Development Guidelines

### Docker and Infrastructure Standards
- Follow Docker best practices (multi-stage builds, minimal layers, etc.)
- Use official base images when possible
- Minimize image size while maintaining functionality
- Document any changes to the Dockerfile with comments
- Test on multiple architectures if possible (amd64, arm64)

### Commit Messages
- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

Example:
```
Add user authentication feature

- Implement login/logout functionality
- Add password hashing
- Create user session management
- Fixes #123
```

### Branch Naming
- Use descriptive names: `feature/multi-arch-support`, `bugfix/discovery-timeout`, `docs/usage-examples`
- Use lowercase and hyphens

## Submitting Changes

### Pull Request Process

1. **Before submitting:**
   - Ensure your code follows the project's style guidelines
   - Run the test suite and make sure all tests pass
   - Update documentation if necessary
   - Update the CHANGELOG.md if applicable

2. **Creating the Pull Request:**
   - Use a clear and descriptive title
   - Fill out the pull request template
   - Link to any relevant issues
   - Provide a detailed description of your changes

3. **After submitting:**
   - Be responsive to feedback from maintainers
   - Make requested changes promptly
   - Keep your branch up to date with the main branch

### Pull Request Template
Please include:
- What type of change this is (Docker improvement, bug fix, feature, documentation, etc.)
- What problem this solves or what feature it adds
- How you tested your changes (include Docker commands used)
- Any breaking changes to the container interface
- Test results with HDHomeRun devices (if applicable)
- Image size impact (before/after)

## Reporting Issues

### Before Creating an Issue
- Search existing issues to avoid duplicates
- Check the documentation
- Try the latest version of the project

### When Creating an Issue
- Use a clear and descriptive title
- Provide detailed steps to reproduce the problem
- Include relevant system information:
  - Docker version
  - Host OS (Linux/macOS/Windows)
  - HDHomeRun model and firmware version
  - Network configuration
- Add command output or error messages
- Use the appropriate issue template

## Style Guidelines

### Dockerfile Style
- Use multi-stage builds for efficiency
- Group related RUN commands to minimize layers
- Use specific version tags for base images
- Add labels for metadata (org.opencontainers.image.*)
- Use consistent indentation (2 spaces)
- Comment complex operations

### Documentation Style
- Use clear, concise language
- Include code examples where appropriate
- Keep README and other docs up to date
- Use proper markdown formatting

## Community

### Communication Channels
- GitHub Issues: For bug reports and feature requests
- GitHub Discussions: For general questions and community discussion
- Pull Requests: For code contributions and reviews

### Getting Help
- Check the documentation first
- Search existing issues and discussions
- Ask questions in our community channels
- Tag maintainers appropriately (don't overuse)

## Recognition

Contributors will be recognized in:
- The AUTHORS.md file
- Release notes for significant contributions
- Our website contributors page (if applicable)

## License

By contributing to LibHdHomerun-Docker, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

## Questions?

Don't hesitate to ask! You can reach out through any of our communication channels or open an issue tagged as a question.

Thank you for contributing! 🎉