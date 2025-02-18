# Use OpenJDK 11 slim as the base image
FROM naivedh/owasp-dependency:latest

# Declare build argument for NVD API key
ARG NVD_API_KEY

# Update NVD data during build
RUN /usr/local/bin/dependency-check --updateonly --nvdApiKey ${NVD_API_KEY} && \
    rm -rf /opt/dependency-check/data/.lock

# Set entrypoint to Dependency-Check script
ENTRYPOINT ["/usr/local/bin/dependency-check"]

# Default command to scan the working directory
CMD ["--scan", "${SCAN_PATH}", "--nvdApiKey", "${NVD_API_KEY}"]