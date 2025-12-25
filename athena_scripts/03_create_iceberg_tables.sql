-- =====================================================
-- Icebergテーブルの作成
-- =====================================================
-- 使用前に ${S3_BUCKET} を実際のS3バケット名に置換してください

-- devices Icebergテーブル
CREATE TABLE IF NOT EXISTS iot_demo.devices (
    device_id STRING,
    device_name STRING,
    device_type STRING,
    location STRING,
    installation_date DATE,
    is_active BOOLEAN
)
LOCATION 's3://${S3_BUCKET}/iot_demo/iceberg/devices/'
TBLPROPERTIES (
    'table_type' = 'ICEBERG',
    'format' = 'PARQUET',
    'write_compression' = 'SNAPPY'
);

-- sensor_readings Icebergテーブル
CREATE TABLE IF NOT EXISTS iot_demo.sensor_readings (
    reading_id STRING,
    device_id STRING,
    reading_timestamp TIMESTAMP,
    metric_type STRING,
    metric_value DOUBLE,
    unit STRING,
    quality_score DOUBLE
)
LOCATION 's3://${S3_BUCKET}/iot_demo/iceberg/sensor_readings/'
TBLPROPERTIES (
    'table_type' = 'ICEBERG',
    'format' = 'PARQUET',
    'write_compression' = 'SNAPPY'
);

-- alerts Icebergテーブル
CREATE TABLE IF NOT EXISTS iot_demo.alerts (
    alert_id STRING,
    device_id STRING,
    alert_timestamp TIMESTAMP,
    alert_type STRING,
    severity STRING,
    message STRING,
    is_resolved BOOLEAN
)
LOCATION 's3://${S3_BUCKET}/iot_demo/iceberg/alerts/'
TBLPROPERTIES (
    'table_type' = 'ICEBERG',
    'format' = 'PARQUET',
    'write_compression' = 'SNAPPY'
);
