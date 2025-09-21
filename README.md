# ZeroTier-Docker

[![GitHub CI](https://github.com/lferrarotti74/ZeroTier/workflows/Build%20release%20image/badge.svg)](https://github.com/lferrarotti74/ZeroTier/actions/workflows/build.yml)
[![Release](https://img.shields.io/github/v/release/lferrarotti74/ZeroTier)](https://github.com/lferrarotti74/ZeroTier/releases)
[![Docker Hub](https://img.shields.io/docker/pulls/lferrarotti74/zerotier)](https://hub.docker.com/r/lferrarotti74/zerotier)
[![Docker Image Size](https://img.shields.io/docker/image-size/lferrarotti74/zerotier/latest)](https://hub.docker.com/r/lferrarotti74/zerotier)
[![GitHub](https://img.shields.io/github/license/lferrarotti74/ZeroTier)](LICENSE)

<!-- SonarQube Badges -->
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=lferrarotti74_ZeroTier&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=lferrarotti74_ZeroTier)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=lferrarotti74_ZeroTier&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=lferrarotti74_ZeroTier)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=lferrarotti74_ZeroTier&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=lferrarotti74_ZeroTier)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=lferrarotti74_ZeroTier&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=lferrarotti74_ZeroTier)

A Docker container for [ZeroTier One](https://github.com/zerotier/ZeroTierOne), the smart programmable Ethernet switch for planet Earth. This container provides an easy way to run ZeroTier network nodes in containerized environments without needing to install ZeroTier directly on your host system.

## What is ZeroTier?

ZeroTier is a smart programmable Ethernet switch for planet Earth that allows all networked devices, VMs, containers, and applications to communicate as if they all reside in the same physical data center or cloud region.

Key features include:
- **Global Area Networking**: Connect devices anywhere in the world
- **End-to-End Encryption**: All traffic encrypted with keys you control
- **Peer-to-Peer**: Most traffic flows directly between devices
- **Software-Defined Networking**: Advanced enterprise SDN features
- **Cross-Platform**: Works on virtually any device or platform

## ⚠️ Important Licensing Information

**Current Version**: This Docker image is based on **ZeroTier One v1.14.2**, which is available under the BSL (Business Source License) v1.1.

**Future Considerations**: When upgrading to **ZeroTier One v1.16.0** and later versions, please note:
- The ZeroTier controller functionality has additional **commercial use restrictions**
- **Non-commercial use** remains free for businesses, academic institutions, and personal use
- **Commercial use** of the controller (such as offering ZeroTier network management as a SaaS service) requires a commercial license
- **Client/node functionality** remains freely available for all use cases

For detailed licensing information, please refer to:
- [ZeroTier Pricing Page](https://www.zerotier.com/pricing/)
- [Original ZeroTier Repository](https://github.com/zerotier/ZeroTierOne)
- [LICENSE.txt](LICENSE) in this repository

## Quick Start

### Pull the Docker Image

```bash
docker pull lferrarotti74/zerotier:latest
```

### Run the Container

```bash
# Run ZeroTier daemon
docker run -d --name zerotier-one --restart unless-stopped \
  --cap-add NET_ADMIN --cap-add SYS_ADMIN \
  --device /dev/net/tun \
  -v /var/lib/zerotier-one:/var/lib/zerotier-one \
  lferrarotti74/zerotier:latest

# Join a network
docker exec zerotier-one zerotier-cli join <network-id>

# Check status
docker exec zerotier-one zerotier-cli status
```

## Usage Examples

### Basic Network Operations

```bash
# List networks
docker exec zerotier-one zerotier-cli listnetworks

# Get network info
docker exec zerotier-one zerotier-cli get <network-id>

# Leave a network
docker exec zerotier-one zerotier-cli leave <network-id>

# Show peers
docker exec zerotier-one zerotier-cli peers
```

### Network Management

```bash
# Get node identity
docker exec zerotier-one zerotier-cli info

# Show network configuration
docker exec zerotier-one zerotier-cli get <network-id> allowManaged
docker exec zerotier-one zerotier-cli get <network-id> allowGlobal
docker exec zerotier-one zerotier-cli get <network-id> allowDefault

# Set network configuration
docker exec zerotier-one zerotier-cli set <network-id> allowManaged=1
```

### Using with Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  zerotier:
    image: lferrarotti74/zerotier:latest
    container_name: zerotier-one
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
      - SYS_ADMIN
    devices:
      - /dev/net/tun
    volumes:
      - zerotier-data:/var/lib/zerotier-one
    environment:
      - ZEROTIER_NETWORK_IDS=<your-network-id>
    networks:
      - zerotier-net

volumes:
  zerotier-data:

networks:
  zerotier-net:
    driver: bridge
```

Run with:

```bash
docker-compose up -d
```

### Interactive Usage

For multiple commands, you can run the container interactively:

```bash
docker exec -it zerotier-one /bin/bash
```

Then inside the container:

```bash
zerotier-cli status
zerotier-cli listnetworks
zerotier-cli join <network-id>
```

## Available Commands

The `zerotier-cli` utility supports various commands:

- `status` - Show ZeroTier service status
- `info` - Show node identity and version
- `join <network-id>` - Join a ZeroTier network
- `leave <network-id>` - Leave a ZeroTier network
- `listnetworks` - List joined networks
- `peers` - List network peers
- `get <network-id> <setting>` - Get network setting
- `set <network-id> <setting>=<value>` - Set network setting

## Network Requirements

- The container requires `NET_ADMIN` and `SYS_ADMIN` capabilities
- Access to `/dev/net/tun` device for VPN functionality
- Persistent storage for ZeroTier identity and configuration
- Internet connectivity for initial peer discovery
- UDP port 9993 should be accessible (automatically handled by Docker)

## Network Configuration

### Common Network Settings

**Allow Managed Routes:**
```bash
docker exec zerotier-one zerotier-cli set <network-id> allowManaged=1
```

**Allow Global Routes:**
```bash
docker exec zerotier-one zerotier-cli set <network-id> allowGlobal=1
```

**Allow Default Route Override:**
```bash
docker exec zerotier-one zerotier-cli set <network-id> allowDefault=1
```

## Building from Source

To build the Docker image yourself:

```bash
git clone https://github.com/lferrarotti74/ZeroTier.git
cd ZeroTier
docker build -t zerotier-docker .
```

## Documentation

- **[Contributing Guidelines](CONTRIBUTING.md)** - How to contribute to the project
- **[Code of Conduct](CODE_OF_CONDUCT.md)** - Community standards and behavior expectations
- **[Security Policy](SECURITY.md)** - How to report security vulnerabilities
- **[Changelog](CHANGELOG.md)** - Version history and release notes
- **[Maintainers](MAINTAINERS.md)** - Project governance and maintainer information
- **[Authors](AUTHORS.md)** - Contributors and acknowledgments

## Contributing

We welcome contributions from the community! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

- **Bug Reports**: Use GitHub issues with detailed information
- **Feature Requests**: Propose enhancements via GitHub issues
- **Code Contributions**: Fork, create feature branch, and submit PR
- **Documentation**: Help improve docs and examples

Please follow our [Code of Conduct](CODE_OF_CONDUCT.md) in all interactions.

## Support

For issues related to this Docker container, please open an issue on [GitHub](https://github.com/lferrarotti74/ZeroTier/issues).

For ZeroTier-specific support, please refer to:
- [ZeroTier Documentation](https://docs.zerotier.com/)
- [ZeroTier Community Forum](https://discuss.zerotier.com/)
- [Original ZeroTier Repository](https://github.com/zerotier/ZeroTierOne)

## License

This project is licensed under the BSL (Business Source License) v1.1 - see the [LICENSE](LICENSE) file for details.

**Important**: This Docker container packages ZeroTier One, which is subject to ZeroTier's licensing terms. Please review the licensing information above and the original project's license before use.

## Related Links

- **[Original ZeroTier Repository](https://github.com/zerotier/ZeroTierOne)** - The source ZeroTier One project
- **[ZeroTier Official Website](https://www.zerotier.com/)** - Official ZeroTier website and services
- **[ZeroTier Documentation](https://docs.zerotier.com/)** - Comprehensive ZeroTier documentation
- **[ZeroTier Pricing](https://www.zerotier.com/pricing/)** - Licensing and pricing information
- **[Docker Hub Repository](https://hub.docker.com/r/lferrarotti74/zerotier)** - Pre-built Docker images

## Acknowledgments

This Docker container is based on [ZeroTier One](https://github.com/zerotier/ZeroTierOne) by ZeroTier, Inc.

Special thanks to the ZeroTier team for creating this amazing networking solution that makes global area networking accessible to everyone.