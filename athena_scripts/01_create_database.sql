-- =====================================================
-- データベースの作成
-- =====================================================
-- 使用前に ${S3_BUCKET} を実際のS3バケット名に置換してください

-- Glueデータカタログにデータベースを作成
CREATE DATABASE IF NOT EXISTS iot_demo
COMMENT 'IoT Demo Database for dbt-glue demonstration'
LOCATION 's3://${S3_BUCKET}/iot_demo/';
