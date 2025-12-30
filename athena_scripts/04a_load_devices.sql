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
