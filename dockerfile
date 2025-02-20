FROM openjdk:11-jre-slim

ENV DEPENDENCY_CHECK_VERSION=12.0.2 \
    SCAN_PATH=/app \
    NVD_DATA_PATH=/opt/dependency-check/data

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget unzip curl && \
    wget https://github.com/jeremylong/DependencyCheck/releases/download/v${DEPENDENCY_CHECK_VERSION}/dependency-check-${DEPENDENCY_CHECK_VERSION}-release.zip && \
    unzip dependency-check-${DEPENDENCY_CHECK_VERSION}-release.zip -d /opt && \
    ln -s /opt/dependency-check/bin/dependency-check.sh /usr/local/bin/dependency-check && \
    rm dependency-check-${DEPENDENCY_CHECK_VERSION}-release.zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME ${NVD_DATA_PATH}

# Check if NVD data exists; if not, download it.  Improved check.
RUN if [ ! -d "${NVD_DATA_PATH}/cpe/1.1" ]; then \
    mkdir -p ${NVD_DATA_PATH}/cpe/1.1 ${NVD_DATA_PATH}/cve/1.1 ${NVD_DATA_PATH}/cpematch/1.1 ${NVD_DATA_PATH}/oval/5.10 && \
    wget -O ${NVD_DATA_PATH}/nvd-cve-modified.json.gz https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-modified.json.gz && \
    wget -O ${NVD_DATA_PATH}/nvd-cve-meta.json https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-modified.meta && \
    wget -O ${NVD_DATA_PATH}/nvd-cpe-dictionary.json.gz https://nvd.nist.gov/feeds/json/cpe/1.1/nvdcpe-1.1.json.gz && \
    wget -O ${NVD_DATA_PATH}/nvd-cpe-match.json.gz https://nvd.nist.gov/feeds/json/cpematch/1.1/nvdcpematch-1.1.json.gz && \
    wget -O ${NVD_DATA_PATH}/nvd-oval-definitions.xml.gz https://nvd.nist.gov/feeds/xml/oval/5.10/nvdcve-oval.xml.gz && \
    gunzip ${NVD_DATA_PATH}/nvd-cve-modified.json.gz && \
    gunzip ${NVD_DATA_PATH}/nvd-cpe-dictionary.json.gz && \
    gunzip ${NVD_DATA_PATH}/nvd-cpe-match.json.gz && \
    gunzip ${NVD_DATA_PATH}/nvd-oval-definitions.xml.gz && \
    rm -rf /opt/dependency-check/data/.lock; \
fi


WORKDIR ${SCAN_PATH}

ENTRYPOINT ["/usr/local/bin/dependency-check"]
CMD ["--scan", "${SCAN_PATH}"]