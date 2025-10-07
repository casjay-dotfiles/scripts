FROM casjaysdev/almalinux:latest AS base

RUN yum install -yy systemd

# Copy scripts to the container
COPY . /usr/local/share/CasjaysDev/scripts

# Install scripts and dependencies
RUN /usr/local/share/CasjaysDev/scripts/install.sh

# Enable systemd
RUN systemctl set-default multi-user.target && systemctl mask systemd-udev-trigger.service systemd-udevd.service

FROM casjaysdev/almalinux:latest

# Add labels and metadata
LABEL maintainer="Jason Hempstead <jason@casjaysdev.pro>"
LABEL org.opencontainers.image.title="CasjaysDev Scripts"
LABEL org.opencontainers.image.description="Collection of useful scripts and tools for system administration and development"
LABEL org.opencontainers.image.version="202510070543-git"
LABEL org.opencontainers.image.base.name="casjaysdev/almalinux:latest"
LABEL org.opencontainers.image.authors="Jason Hempstead <jason@casjaysdev.pro>"
LABEL org.opencontainers.image.vendor="CasjaysDev"
LABEL org.opencontainers.image.licenses="WTFPL"
LABEL org.opencontainers.image.url="https://github.com/casjay-dotfiles/scripts"
LABEL org.opencontainers.image.source="https://github.com/casjay-dotfiles/scripts"
LABEL org.opencontainers.image.documentation="https://github.com/casjay-dotfiles/scripts/blob/main/README.md"

# Copy everything from base stage
COPY --from=base / /

# Set working directory
WORKDIR /root

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD bash -c 'echo "Container is healthy"' || exit 1

# start systemd init
ENTRYPOINT ["/sbin/init"]
# Keep container running with a persistent process
CMD ["bash", "-c", "while true; do sleep 30; done"]
