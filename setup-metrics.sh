#!/bin/bash

AGENT_VERSION="1.0.1"
AGENT_JAR="jmx_prometheus_javaagent-${AGENT_VERSION}.jar"
AGENT_URL="https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${AGENT_VERSION}/${AGENT_JAR}"

echo "--- Đang tải JMX Java Agent version ${AGENT_VERSION} ---"
curl -L -o jmx_prometheus_javaagent.jar ${AGENT_URL}

# 2. Tạo file kafka-config.yml (Cấu hình chuẩn để lọc metrics Kafka)
echo "--- Đang tạo file kafka-config.yml ---"
cat <<EOF > kafka-config.yml
lowercaseOutputName: true
lowercaseOutputLabelNames: true
rules:
  # Các metrics đặc trưng của Kafka Broker
  - pattern: kafka.server<type=(.+), name=(.+)><>(Count|Value)
    name: kafka_server_\$1_\$2
  - pattern: kafka.network<type=(.+), name=(.+)><>(Count|Value)
    name: kafka_network_\$1_\$2
  - pattern: kafka.controller<type=(.+), name=(.+)><>(Count|Value)
    name: kafka_controller_\$1_\$2
  - pattern: 'java.lang<type=Memory><HeapMemoryUsage>(\w+)'
    name: jvm_memory_usage_heap_\$1
    type: GAUGE
  - pattern: 'java.lang<type=OperatingSystem><>(FreePhysicalMemorySize|TotalPhysicalMemorySize|SystemCpuLoad)'
    name: jvm_os_\$1
    type: GAUGE
EOF

chmod +x jmx_prometheus_javaagent.jar
echo "--- Hoàn tất! Bạn có thể chạy 'docker-compose up -d' bây giờ ---"
