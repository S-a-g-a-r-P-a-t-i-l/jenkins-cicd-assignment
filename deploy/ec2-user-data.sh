#!/bin/bash

set -e

apt-get update -y

apt-get install -y openjdk-21-jre-headless

echo "Java installation completed!"

java -version
