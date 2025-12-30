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
