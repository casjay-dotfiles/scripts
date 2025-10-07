# CasjaysDev Scripts - Container Images

This directory contains Dockerfiles for building container images with CasjaysDev Scripts pre-installed.

## Available Images

### AlmaLinux (Default)
**File:** `Dockerfile`
**Base Image:** `casjaysdev/almalinux:latest`
**Init System:** systemd

```bash
# Build
docker build -t casjaysdev/scripts:almalinux -f containers/Dockerfile .

# Run
docker run -d --privileged casjaysdev/scripts:almalinux
```

### Alpine Linux
**File:** `Dockerfile.alpine`
**Base Image:** `casjaysdev/alpine:latest`
**Init System:** OpenRC

```bash
# Build
docker build -t casjaysdev/scripts:alpine -f containers/Dockerfile.alpine .

# Run
docker run -d --privileged casjaysdev/scripts:alpine
```

## Features

Both container images include:
- ✅ All CasjaysDev scripts installed
- ✅ setupmgr with cross-platform support
- ✅ Pre-configured development environment
- ✅ Health checks enabled
- ✅ Multi-stage build for smaller image size

## Image Labels

All images include comprehensive OCI labels:
- `org.opencontainers.image.title` - Image title
- `org.opencontainers.image.description` - Description
- `org.opencontainers.image.version` - Version (matches script version)
- `org.opencontainers.image.authors` - Maintainer info
- `org.opencontainers.image.vendor` - CasjaysDev
- `org.opencontainers.image.licenses` - WTFPL
- `org.opencontainers.image.url` - Project URL
- `org.opencontainers.image.source` - Source repository
- `org.opencontainers.image.documentation` - Documentation URL
- `org.opencontainers.image.base.name` - Base image reference

## Quick Start with Docker Compose

```bash
# Build and run all images
cd containers
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all containers
docker-compose down
```

## Building

### Build All Images
```bash
# AlmaLinux (systemd)
docker build -t casjaysdev/scripts:almalinux -f containers/Dockerfile .

# Alpine (OpenRC)
docker build -t casjaysdev/scripts:alpine -f containers/Dockerfile.alpine .

# Tag latest (AlmaLinux)
docker tag casjaysdev/scripts:almalinux casjaysdev/scripts:latest
```

### Multi-Architecture Builds
```bash
# Using buildx for multi-arch
docker buildx build --platform linux/amd64,linux/arm64 \
  -t casjaysdev/scripts:almalinux \
  -f containers/Dockerfile .

docker buildx build --platform linux/amd64,linux/arm64 \
  -t casjaysdev/scripts:alpine \
  -f containers/Dockerfile.alpine .
```

## Testing

### Test Container
```bash
# AlmaLinux
docker run --rm -it casjaysdev/scripts:almalinux bash -c 'setupmgr --version'

# Alpine
docker run --rm -it casjaysdev/scripts:alpine bash -c 'setupmgr --version'
```

### Interactive Shell
```bash
# AlmaLinux
docker run --rm -it casjaysdev/scripts:almalinux bash

# Alpine
docker run --rm -it casjaysdev/scripts:alpine bash
```

## Version

Current Version: **202510070543-git**

All container images are versioned to match the scripts version for consistency.

## License

WTFPL - Do What The Fuck You Want To Public License

## Maintainer

Jason Hempstead <jason@casjaysdev.pro>
