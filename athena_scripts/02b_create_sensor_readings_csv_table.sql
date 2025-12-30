-- sensor_readings 外部テーブル（CSV）
CREATE EXTERNAL TABLE IF NOT EXISTS iot_demo.sensor_readings_csv (
    reading_id STRING,
    device_id STRING,
    timestamp STRING,
    metric_type STRING,
    metric_value STRING,
    unit STRING,
    quality_score STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 's3://${S3_BUCKET}/iot_demo/raw/sensor_readings/'
TBLPROPERTIES ('skip.header.line.count'='1');
