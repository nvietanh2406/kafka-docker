CREATE USER 'debezium'@'%' IDENTIFIED WITH mysql_native_password BY 'dbz123';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium'@'%';

CREATE DATABASE sourcemysqldb;
GRANT ALL PRIVILEGES ON sourcemysqldb.* TO 'debezium'@'%';

USE sourcemysqldb;
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
