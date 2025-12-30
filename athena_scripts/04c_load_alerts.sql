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
