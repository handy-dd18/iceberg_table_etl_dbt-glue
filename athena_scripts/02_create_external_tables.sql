-- =====================================================
-- CSVからの外部テーブル作成（一時テーブル）
-- =====================================================
-- 使用前に ${S3_BUCKET} を実際のS3バケット名に置換してください

-- devices 外部テーブル
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

-- sensor_readings 外部テーブル
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

-- alerts 外部テーブル
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
