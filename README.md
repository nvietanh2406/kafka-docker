# MySQL to Postgres Data Pipeline with Kafka Connect

## Cài đặt và Chạy

1. Clone repository và chuẩn bị môi trường:
```bash
cd ./kafka-docker
chmod +x build.sh apply-source-sink.sh
```

2. Download connectors:
```bash
./build.sh
```

3. Khởi động các services:
```bash
docker-compose up -d
```

## Cấu hình Connectors

### 1. Source MySQL Connector
Chỉnh sửa file `configs/source-mysql-customers.json`:

```json
{
    "database.hostname": "your-mysql-host",     // Địa chỉ MySQL server
    "database.port": "3306",                    // Port MySQL (mặc định 3306)
    "database.user": "your-mysql-user",         // Username MySQL
    "database.password": "your-mysql-password", // Password MySQL
    "database.server.name": "mysql-source",     // Tên server (prefix cho topic)
    "database.include.list": "your-database",   // Tên database nguồn
    "table.include.list": "your-database.your-table" // Database.table cần sync
}
```

### 2. Sink Postgres Connector
Chỉnh sửa file `configs/sink-postgres-customers.json`:

```json
{
    "topics": "mysql-source.your-database.your-table", // Phải khớp với source
    "connection.url": "jdbc:postgresql://your-postgres-host:5432/your-database",
    "connection.user": "your-postgres-user",
    "connection.password": "your-postgres-password",
    "table.name.format": "target_table_name",  // Tên bảng đích trong Postgres
    "pk.fields": "id"                          // Primary key của bảng
}
```

## Apply Connectors

1. Apply source và sink connectors:
```bash
./apply-source-sink.sh
```

2. Kiểm tra trạng thái:
```bash
curl http://localhost:8083/connectors/mysql-customers-source/status
curl http://localhost:8083/connectors/postgres-customers-sink/status
```

## Kiểm tra Hoạt động

1. Truy cập Kafka UI: http://localhost:8080
   - Kiểm tra topics đã được tạo
   - Xem trạng thái các connector

2. Kiểm tra log của connector:
```bash
docker logs kafka-connect
```

3. Kiểm tra dữ liệu trong Postgres:
```bash
docker exec -it postgres psql -U postgres -d postgres -c "SELECT * FROM target_table_name;"
```

## Test Data Migration

### 1. Import test data vào MySQL
```bash
# Kết nối đến MySQL container
docker exec -i mysql mysql -uroot -pmysql < test-data/init.sql

# Kiểm tra data đã import
docker exec -i mysql mysql -uroot -pmysql -e "SELECT * FROM sourcemysqldb.customers;"
```

### 2. Kiểm tra data trong Postgres
```bash
# Đợi 1-2 phút để data được sync, sau đó kiểm tra trong Postgres
docker exec -i postgres psql -U postgres -d postgres -c "SELECT * FROM customers;"
```

### 3. Test realtime sync
```bash
# Thêm record mới trong MySQL
docker exec -i mysql mysql -uroot -pmysql -e "INSERT INTO sourcemysqldb.customers (name, email) VALUES ('Alice Brown', 'alice@example.com');"

# Update record trong MySQL
docker exec -i mysql mysql -uroot -pmysql -e "UPDATE sourcemysqldb.customers SET email='alice.brown@example.com' WHERE name='Alice Brown';"

# Delete record trong MySQL
docker exec -i mysql mysql -uroot -pmysql -e "DELETE FROM sourcemysqldb.customers WHERE name='Alice Brown';"

# Kiểm tra kết quả trong Postgres (đợi 30s-1p để data sync)
docker exec -i postgres psql -U postgres -d postgres -c "SELECT * FROM customers;"
```

### 4. Monitoring
1. Check CDC events trên Kafka UI (http://localhost:8080):
   - Xem messages trong topic `mysql-source.sourcemysqldb.customers`
   - Kiểm tra các operation type: create (c), update (u), delete (d)

2. Check connector metrics:
```bash
# Source connector
curl -s http://localhost:8083/connectors/mysql-customers-source/status | jq

# Sink connector
curl -s http://localhost:8083/connectors/postgres-customers-sink/status | jq
```

3. Check logs:
```bash
# Xem log của Kafka Connect
docker logs kafka-connect | grep -i error
```

## Troubleshooting

1. Nếu connector failed:
```bash
# Xem log chi tiết
docker logs kafka-connect

# Xóa connector để tạo lại
curl -X DELETE http://localhost:8083/connectors/mysql-customers-source
curl -X DELETE http://localhost:8083/connectors/postgres-customers-sink
```

2. Kiểm tra kết nối MySQL:
```bash
docker exec -it kafka-connect ping your-mysql-host
```

3. Kiểm tra kết nối Postgres:
```bash
docker exec -it kafka-connect ping your-postgres-host
```
