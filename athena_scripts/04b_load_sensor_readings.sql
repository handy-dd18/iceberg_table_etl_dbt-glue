-- sensor_readings テーブルへのデータ挿入
INSERT INTO iot_demo.sensor_readings
SELECT
    reading_id,
    device_id,
    CAST(timestamp AS TIMESTAMP),
    metric_type,
    CAST(metric_value AS DOUBLE),
    unit,
    CAST(quality_score AS DOUBLE)
FROM iot_demo.sensor_readings_csv;
