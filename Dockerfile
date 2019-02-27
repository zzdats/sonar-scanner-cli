FROM openjdk:8-alpine

LABEL maintainer="SIA ZZ Dats <opensource@zzdats.lv>"

ARG SONAR_SCANNER_VERSION="3.3.0.1492"

RUN apk add --no-cache curl grep sed unzip bash

# Set timezone to CST
ENV TZ=Europe/Riga
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Settings
ENV SONAR_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip"
ENV SONAR_RUNNER_HOME="/opt/sonar-scanner-${SONAR_SCANNER_VERSION}-linux"
ENV PATH $PATH:$SONAR_RUNNER_HOME/bin

# Ensure Sonar uses the provided Java for musl instead of a borked glibc one
RUN mkdir -p /opt && \
    curl --insecure -o /opt/sonarscanner.zip -L $SONAR_URL && \
	unzip /opt/sonarscanner.zip -d /opt && \
	rm /opt/sonarscanner.zip && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' $SONAR_RUNNER_HOME/bin/sonar-scanner

COPY printScannerConfig.sh /opt
RUN chmod +x /opt/printScannerConfig.sh

CMD [ "/opt/printScannerConfig.sh" ]
