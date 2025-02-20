# Use OpenJDK 11 slim as the base image
FROM naivedh/owasp-dependency:latest

# Update NVD data during build
RUN /usr/local/bin/dependency-check --updateonly && \
    rm -rf /opt/dependency-check/data/.lock

# Set entrypoint to Dependency-Check script
ENTRYPOINT ["/usr/local/bin/dependency-check"]

# Default command to scan the working directory
CMD ["--scan", "."]