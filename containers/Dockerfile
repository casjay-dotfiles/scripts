FROM casjaysdev/almalinux:latest AS base

# Install bash and systemd
RUN yum install -yy bash systemd

# Copy all files to the container
COPY . /usr/local/share/CasjaysDev/scripts

# Make scripts executable and run install
RUN chmod +x /usr/local/share/CasjaysDev/scripts/bin/* && \
    chmod +x /usr/local/share/CasjaysDev/scripts/install.sh && \
    cd /usr/local/share/CasjaysDev/scripts && \
    bash ./install.sh

# Enable systemd
RUN systemctl set-default multi-user.target && systemctl mask systemd-udev-trigger.service systemd-udevd.service

FROM casjaysdev/almalinux:latest

# Add labels and metadata
LABEL maintainer="Jason Hempstead <jason@casjaysdev.pro>"
LABEL org.opencontainers.image.title="CasjaysDev Scripts"
LABEL org.opencontainers.image.description="Collection of useful scripts and tools for system administration and development"
LABEL org.opencontainers.image.version="202510070821-git"
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
