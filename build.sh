#!/bin/bash

# Create connectors directory
mkdir -p connectors

# Download Debezium MySQL connector
wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/2.1.3.Final/debezium-connector-mysql-2.1.3.Final-plugin.tar.gz
tar -xvf debezium-connector-mysql-2.1.3.Final-plugin.tar.gz -C connectors/
rm debezium-connector-mysql-2.1.3.Final-plugin.tar.gz

# Download Postgres connector for sink
wget https://d1i4a15mxbxib1.cloudfront.net/api/plugins/confluentinc/kafka-connect-jdbc/versions/10.7.1/confluentinc-kafka-connect-jdbc-10.7.1.zip
mkdir -p connectors/kafka-connect-jdbc
unzip confluentinc-kafka-connect-jdbc-10.7.1.zip -d connectors/kafka-connect-jdbc
rm confluentinc-kafka-connect-jdbc-10.7.1.zip

# Add execute permissions
chmod -R +x connectors/
