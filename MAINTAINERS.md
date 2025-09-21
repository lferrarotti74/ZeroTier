# Maintainers

This document lists the current maintainers of ZeroTier-Docker and describes the project's governance and maintenance responsibilities.

## Table of Contents

- [Current Maintainers](#current-maintainers)
- [Roles and Responsibilities](#roles-and-responsibilities)
- [How to Reach Maintainers](#how-to-reach-maintainers)
- [Becoming a Maintainer](#becoming-a-maintainer)
- [Maintainer Guidelines](#maintainer-guidelines)
- [Decision Making Process](#decision-making-process)
- [Emeritus Maintainers](#emeritus-maintainers)

## Current Maintainers

### Project Maintainer
| Name | GitHub | Email | Areas of Focus | Timezone |
|------|--------|-------|----------------|----------|
| Luca Ferrarotti | [@lferrarotti74](https://github.com/lferrarotti74) | luca@ferrarotti.it | Overall project direction, Docker container development, ZeroTier integration, releases | UTC+1 (CET) |

## Roles and Responsibilities

### Lead Maintainers
- Set overall project vision and roadmap
- Make final decisions on controversial issues
- Coordinate releases and version planning
- Represent the project in external communications
- Mentor new maintainers
- Have full administrative access to the repository

### Core Maintainers
- Review and merge pull requests
- Triage and manage issues
- Participate in architectural decisions
- Maintain code quality standards
- Have push access to main branches
- Can create releases (with lead maintainer approval)

### Area Maintainers
- Specialize in specific project areas
- Review PRs related to their expertise
- Maintain documentation in their area
- Support users with area-specific questions
- May have limited push access to specific directories

## How to Reach Maintainers

### General Inquiries
- **GitHub Issues**: For bugs, feature requests, and general project discussion
- **GitHub Discussions**: For questions and community discussions
- **Email**: luca@ferrarotti.it for private or sensitive matters

### Specific Areas
- **Security Issues**: luca@ferrarotti.it (private)
- **Code of Conduct**: luca@ferrarotti.it (private)
- **General Contact**: luca@ferrarotti.it

### Response Times
I aim to respond to issues and PRs within:
- **Critical bugs/security**: 24-48 hours
- **Bug reports**: 3-7 business days
- **Feature requests**: 1-2 weeks
- **Pull requests**: 1 week for initial review

*Note: Response times may vary based on availability and issue complexity.*

## Becoming a Maintainer

### Path to Maintainership
As this project grows, additional maintainers may be welcomed. The path to maintainership includes:

1. **Regular Contributor** (3+ months)
   - Submit quality pull requests
   - Help with issue triage and user support
   - Participate in discussions and reviews

2. **Trusted Contributor** (6+ months)
   - Demonstrate deep understanding of Docker and HDHomeRun integration
   - Provide helpful code reviews
   - Show commitment to project values

3. **Maintainer Candidate**
   - Nominated by current maintainer
   - Demonstrate expertise in Docker, networking, or HDHomeRun devices
   - Show leadership in community interactions

### Selection Criteria
- Technical expertise in Docker, networking, or HDHomeRun devices
- Commitment to project's long-term success
- Excellent communication skills
- Collaborative approach to problem-solving
- Alignment with project values and code of conduct
- Regular availability for maintenance duties

### Nomination Process
1. Current maintainer evaluates candidate contributions
2. Discussion with candidate about interest and availability
3. Trial period with limited access
4. Full maintainer access granted after successful trial
5. New maintainer receives mentoring and guidance

## Maintainer Guidelines

### Code Review Standards
- **Quality**: Code meets Docker best practices and includes testing
- **Documentation**: Changes are properly documented
- **Compatibility**: Backward compatibility with HDHomeRun devices maintained
- **Security**: No security vulnerabilities introduced
- **Functionality**: Changes tested with actual HDHomeRun hardware when possible

### Merge Requirements
- Approval from maintainer
- All CI checks passing
- No unresolved review comments
- Docker image builds successfully
- Basic functionality testing completed

### Release Process
1. Maintainer creates release candidate
2. Test with various HDHomeRun devices
3. Update documentation and version numbers
4. Create and publish Docker Hub release
5. Create GitHub release with changelog
6. Announce release to community

### Communication Standards
- Be respectful and professional in all interactions
- Provide constructive feedback on contributions
- Respond promptly to mentions and assigned issues
- Escalate conflicts to lead maintainers when needed

## Decision Making Process

### Decision Making
- Currently, decisions are made by the sole maintainer
- Community input is welcomed through GitHub issues and discussions
- Major changes are announced and discussed before implementation

### Future Governance
As the project grows and additional maintainers join:
1. **Discussion Period**: 1 week minimum for major decisions
2. **Consensus Building**: Strive for agreement among maintainers
3. **Documentation**: All decisions and rationale documented

### Major Decision Types
- Breaking changes to container interface
- New major features
- Changes to project governance
- Adding/removing maintainers
- Changes to project license

## Emeritus Maintainers

*No emeritus maintainers at this time. This section will be updated as the project evolves.*

*Former maintainers who have made significant contributions will be recognized here, and are always welcome to return to active maintenance.*

## Stepping Down

Maintainers can step down at any time by:
1. Notifying other maintainers of intent
2. Transferring responsibilities and knowledge
3. Removing access permissions
4. Moving to emeritus status (optional)

## Contact Information

For maintainer-specific inquiries or to report issues with the maintenance process:

- **Project Maintainer**: luca@ferrarotti.it
- **GitHub**: [@lferrarotti74](https://github.com/lferrarotti74)
- **Issues**: Use GitHub Issues for project-related matters

---

*This document is reviewed and updated as needed.*

## Acknowledgments

Thanks to all contributors who help make LibHdHomerun-Docker better for the HDHomeRun community. Special recognition goes to Silicondust for creating the original libhdhomerun library that this project containerizes.

*"The best way to find yourself is to lose yourself in the service of others." - Mahatma Gandhi*