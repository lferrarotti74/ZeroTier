# Security Policy

## Supported Versions

We actively support the following versions of ZeroTier-Docker with security updates:

| Version | Supported          | ZeroTier Version | License |
| ------- | ------------------ | ---------------- | ------- |
| 2025.x  | :white_check_mark: | 1.14.2          | BSL v1.1 |
| 2024.x  | :x:                | 1.12.x          | BSL v1.1 |

### Important Licensing Information

- **Current Version (1.14.2)**: Available under BSL v1.1 license
- **Future Versions (1.16.0+)**: Will include additional commercial restrictions for controller functionality
- **Non-Commercial Use**: Always remains free for businesses, academic institutions, and personal use

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security issue in ZeroTier-Docker, please report it responsibly.

### How to Report

**Email**: luca@ferrarotti.it

**Subject Line**: `[SECURITY] ZeroTier-Docker Vulnerability Report`

**Encryption**: For sensitive reports, please use PGP encryption. Our public key is available upon request.

### What to Include

Please provide the following information in your report:

1. **Description**: A clear description of the vulnerability
2. **Impact**: Potential impact and attack scenarios
3. **Reproduction**: Step-by-step instructions to reproduce the issue
4. **Environment**: 
   - Docker version
   - Host operating system
   - ZeroTier network configuration
   - Container runtime details
5. **Proof of Concept**: If applicable, include a minimal PoC
6. **Suggested Fix**: If you have ideas for remediation

### Response Timeline

| Severity | Initial Response | Status Update | Resolution Target |
|----------|------------------|---------------|-------------------|
| Critical | 24 hours | 48 hours | 7 days |
| High | 48 hours | 72 hours | 14 days |
| Medium | 72 hours | 1 week | 30 days |
| Low | 1 week | 2 weeks | 60 days |

### Vulnerability Severity Guidelines

**Critical**: 
- Remote code execution
- Container escape
- Privilege escalation to host
- Network segmentation bypass

**High**:
- Local privilege escalation
- Information disclosure of sensitive data
- Authentication bypass
- ZeroTier network compromise

**Medium**:
- Denial of service
- Information disclosure of non-sensitive data
- Configuration vulnerabilities

**Low**:
- Minor information leaks
- Non-exploitable bugs with security implications

## Security Best Practices

### For Users

1. **Keep Updated**: Always use the latest version
2. **Network Security**: Run containers in isolated networks
3. **User Permissions**: Don't run as root unless necessary
4. **Host Security**: Keep Docker and host OS updated
5. **Resource Limits**: Set appropriate CPU/memory limits

### For Contributors

1. **Dependencies**: Keep all dependencies updated
2. **Secrets**: Never commit secrets or credentials
3. **Input Validation**: Validate all user inputs
4. **Least Privilege**: Follow principle of least privilege
5. **Security Testing**: Test for common vulnerabilities

## Security Features

### Current Security Measures

- **Multi-stage Builds**: Minimal attack surface
- **Non-root User**: Container runs as non-privileged user
- **Dependency Scanning**: Automated vulnerability scanning with Docker Scout
- **Code Analysis**: SonarQube security analysis
- **Supply Chain**: Dependabot for dependency updates

### Planned Security Enhancements

- Container signing and verification
- SBOM (Software Bill of Materials) generation
- Runtime security monitoring integration
- Security policy enforcement

## Disclosure Policy

### Coordinated Disclosure

1. **Private Report**: Vulnerability reported privately
2. **Investigation**: We investigate and develop fix
3. **Fix Development**: Patch created and tested
4. **Release**: Security update released
5. **Public Disclosure**: Details published after fix is available
6. **Credit**: Reporter credited (if desired)

### Timeline

- **90 days**: Maximum time before public disclosure
- **Shorter for critical**: Critical issues may be disclosed sooner
- **Extension possible**: If fix requires significant changes

## Security Contact

- **Primary Contact**: Luca Ferrarotti
- **Email**: [luca@ferrarotti.it](mailto:luca@ferrarotti.it)
- **Response Time**: Within 48 hours
- **Timezone**: UTC+1 (CET)

## Acknowledgments

We appreciate security researchers and users who help improve our security:

- Security reports are acknowledged in release notes
- Hall of Fame for significant contributions
- Coordination with CVE assignment when applicable

---

**Last Updated**: January 2024
**Next Review**: Quarterly

*This security policy is subject to updates. Check back regularly for the latest version.*