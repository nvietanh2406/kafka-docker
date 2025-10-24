#!/bin/bash

echo "Applying MySQL source connector for customers table..."
curl -X POST http://localhost:8083/connectors \
     -H "Content-Type: application/json" \
     -d @configs/source-mysql-customers.json

echo "Applying Postgres sink connector for customers table..."
curl -X POST http://localhost:8083/connectors \
     -H "Content-Type: application/json" \
     -d @configs/sink-postgres-customers.json

echo "Checking connectors status..."
curl http://localhost:8083/connectors/mysql-customers-source/status
curl http://localhost:8083/connectors/postgres-customers-sink/status
