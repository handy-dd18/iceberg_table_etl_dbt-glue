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
