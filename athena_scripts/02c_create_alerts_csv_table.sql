-- alerts 外部テーブル（CSV）
CREATE EXTERNAL TABLE IF NOT EXISTS iot_demo.alerts_csv (
    alert_id STRING,
    device_id STRING,
    timestamp STRING,
    alert_type STRING,
    severity STRING,
    message STRING,
    is_resolved STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 's3://${S3_BUCKET}/iot_demo/raw/alerts/'
TBLPROPERTIES ('skip.header.line.count'='1');
