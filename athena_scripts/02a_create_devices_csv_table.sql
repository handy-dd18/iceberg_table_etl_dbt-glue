-- devices 外部テーブル（CSV）
CREATE EXTERNAL TABLE IF NOT EXISTS iot_demo.devices_csv (
    device_id STRING,
    device_name STRING,
    device_type STRING,
    location STRING,
    installation_date STRING,
    is_active STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 's3://${S3_BUCKET}/iot_demo/raw/devices/'
TBLPROPERTIES ('skip.header.line.count'='1');
