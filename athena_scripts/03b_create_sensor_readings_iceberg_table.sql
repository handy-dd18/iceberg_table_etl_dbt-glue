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
