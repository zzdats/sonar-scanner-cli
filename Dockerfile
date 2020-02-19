FROM openjdk:8-alpine

LABEL maintainer="SIA ZZ Dats <opensource@zzdats.lv>"

ARG SONAR_SCANNER_VERSION="4.2.0.1873"

# Settings
ENV TZ=Europe/Riga \
    SONAR_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip" \
    SONAR_RUNNER_HOME="/opt/sonar-scanner-${SONAR_SCANNER_VERSION}-linux"
ENV PATH $PATH:$SONAR_RUNNER_HOME/bin

# Set timezone to CST
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apk add --no-cache --virtual=.run-deps bash=4.4.19-r1 && \
    apk add --no-cache --virtual=.build-deps curl=7.64.0-r3 grep=3.1-r2 sed=4.5-r0 unzip=6.0-r4 && \
    mkdir -p /opt && \
    curl --insecure -o /opt/sonarscanner.zip -L $SONAR_URL && \
	unzip /opt/sonarscanner.zip -d /opt && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' $SONAR_RUNNER_HOME/bin/sonar-scanner && \
    apk del .build-deps && \
	rm /opt/sonarscanner.zip && \
    rm -rf $SONAR_RUNNER_HOME/jre/

COPY printScannerConfig.sh /opt
RUN chmod +x /opt/printScannerConfig.sh

CMD [ "/opt/printScannerConfig.sh" ]
