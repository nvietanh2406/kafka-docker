CREATE DATABASE IF NOT EXISTS sourcemysqldb;
USE sourcemysqldb;

CREATE TABLE IF NOT EXISTS customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customers (name, email) VALUES 
    ('John Doe', 'john@example.com'),
    ('Jane Smith', 'jane@example.com'),
    ('Bob Wilson', 'bob@example.com');

-- Test update
UPDATE customers SET email = 'john.doe@example.com' WHERE id = 1;

-- Test delete
DELETE FROM customers WHERE id = 3;
