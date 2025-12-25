-- =====================================================
-- CSVからIcebergテーブルへのデータロード
-- =====================================================

-- devices テーブルへのデータ挿入
INSERT INTO iot_demo.devices
SELECT
    device_id,
    device_name,
    device_type,
    location,
    CAST(installation_date AS DATE),
    CAST(is_active AS BOOLEAN)
FROM iot_demo.devices_csv;

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

-- alerts テーブルへのデータ挿入
INSERT INTO iot_demo.alerts
SELECT
    alert_id,
    device_id,
    CAST(timestamp AS TIMESTAMP),
    alert_type,
    severity,
    message,
    CAST(is_resolved AS BOOLEAN)
FROM iot_demo.alerts_csv;
