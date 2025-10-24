CREATE USER debezium WITH PASSWORD 'dbz123';
CREATE DATABASE targetdb;
GRANT ALL PRIVILEGES ON DATABASE targetdb TO debezium;

\c targetdb

CREATE TABLE IF NOT EXISTS customers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    created_at TIMESTAMP
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO debezium;
