-- =====================================================
-- データ検証クエリ
-- =====================================================

-- devices テーブルの確認
SELECT * FROM iot_demo.devices LIMIT 10;

-- sensor_readings テーブルの確認
SELECT * FROM iot_demo.sensor_readings LIMIT 10;

-- alerts テーブルの確認
SELECT * FROM iot_demo.alerts LIMIT 10;

-- 各テーブルのレコード数確認
SELECT 'devices' as table_name, COUNT(*) as record_count FROM iot_demo.devices
UNION ALL
SELECT 'sensor_readings', COUNT(*) FROM iot_demo.sensor_readings
UNION ALL
SELECT 'alerts', COUNT(*) FROM iot_demo.alerts;
