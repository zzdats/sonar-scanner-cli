#!/bin/bash

echo "##### Sonar-Scanner Version:"
sonar-scanner -v

echo "##### Sonar-Scanner Settings:"
echo $(cat $SONAR_RUNNER_HOME/conf/sonar-scanner.properties)
