> **注意**: このプロジェクトは生成AI（Claude）によって作成されました。本番環境での使用前に、コードのレビューと検証を行ってください。

# dbt-glue Iceberg Table ETL デモ

dbtとdbt-glueアダプターを使用して、AWS S3上のIcebergテーブルを対象としたデータモデリングを行うデモプロジェクトです。

## プロジェクト概要

このプロジェクトでは、IoTセンサーデータを題材として以下を実現します：

- **ソースデータ**: IoTデバイス、センサー読み取り、アラートの3種類のサンプルデータ
- **データストレージ**: AWS S3上のApache Icebergテーブル
- **データカタログ**: AWS Glue Data Catalog
- **ETL実行**: dbt-glueアダプターを使用したdbtによるデータ変換
- **実行環境**: Dockerコンテナ（ローカル環境依存を最小化）

## 前提条件

### AWSリソース

1. **AWSアカウント**
   - 有効なAWSアカウントが必要です

2. **S3バケット**
   - データ格納用のS3バケットを作成済みであること
   - バケット名を控えておいてください

3. **IAMロール（Glue用）**
   - AWS Glueサービスロールが必要です
   - 以下のポリシーがアタッチされていること：
     - `AWSGlueServiceRole`
     - S3バケットへのread/write権限
     - Glue Data Catalogへのアクセス権限
   - 信頼関係に `glue.amazonaws.com` が設定されていること

4. **Amazon Athena**
   - Athenaのクエリ結果出力先S3バケットが設定済みであること

5. **AWS CLI認証情報**
   - ローカルマシンにAWS認証情報が設定済みであること（`~/.aws/credentials`）
   - 使用するプロファイルに以下の権限が必要：
     - Glue: `StartSession`, `CancelSession`, `GetSession`, `CreateTable`, `GetTable`, `UpdateTable`, `GetDatabase`
     - S3: 対象バケットへのread/write
     - Athena: クエリ実行権限

### ローカル環境

1. **Docker & Docker Compose**
   - Docker Engine 20.10以降
   - Docker Compose v2以降

2. **AWS CLI**（オプション）
   - S3へのデータアップロードに使用
   - バージョン2.x推奨

## ディレクトリ構成

```
.
├── README.md
├── Dockerfile
├── docker-compose.yml
├── profiles.yml                    # dbt接続プロファイル
├── .env.example                    # 環境変数テンプレート
├── data/
│   └── raw/                        # サンプルCSVデータ
│       ├── devices.csv
│       ├── sensor_readings.csv
│       └── alerts.csv
├── athena_scripts/                 # Athena SQLスクリプト
│   ├── 01_create_database.sql
│   ├── 02_create_external_tables.sql
│   ├── 03_create_iceberg_tables.sql
│   ├── 04_load_data_to_iceberg.sql
│   └── 05_verify_data.sql
└── dbt_iot_demo/                   # dbtプロジェクト
    ├── dbt_project.yml
    └── models/
        ├── staging/                # ステージング層（View）
        │   ├── sources.yml
        │   ├── schema.yml
        │   ├── stg_devices.sql
        │   ├── stg_sensor_readings.sql
        │   └── stg_alerts.sql
        └── marts/                  # マート層（Icebergテーブル）
            ├── schema.yml
            ├── dim_devices.sql
            ├── fct_hourly_metrics.sql
            └── fct_daily_alerts.sql
```

## セットアップ手順

### 1. 環境変数の設定

```bash
# .env.exampleをコピー
cp .env.example .env

# .envファイルを編集して実際の値を設定
vim .env
```

設定が必要な環境変数：

| 変数名 | 説明 | 例 |
|--------|------|-----|
| `AWS_REGION` | AWSリージョン | `ap-northeast-1` |
| `AWS_PROFILE` | 使用するAWS CLIプロファイル | `default` |
| `GLUE_ROLE_ARN` | Glueサービス用IAMロールのARN | `arn:aws:iam::123456789012:role/GlueServiceRole` |
| `GLUE_DATABASE` | Glueデータベース名 | `iot_demo` |
| `S3_BUCKET` | データ格納用S3バケット名 | `my-data-bucket` |
| `S3_DATA_DIR` | dbt出力先S3パス | `s3://my-data-bucket/iot_demo/` |

### 2. S3へのサンプルデータアップロード

```bash
# 環境変数を読み込み
source .env

# CSVデータをS3にアップロード
aws s3 cp data/raw/devices.csv s3://${S3_BUCKET}/iot_demo/raw/devices/devices.csv
aws s3 cp data/raw/sensor_readings.csv s3://${S3_BUCKET}/iot_demo/raw/sensor_readings/sensor_readings.csv
aws s3 cp data/raw/alerts.csv s3://${S3_BUCKET}/iot_demo/raw/alerts/alerts.csv
```

### 3. AthenaでIcebergテーブルを作成

AWS CLIを使用して、`athena_scripts/` 内のSQLスクリプトを順番に実行します。
`envsubst` コマンドで環境変数を自動的に置換します。

```bash
# Athenaクエリ結果の出力先を設定
ATHENA_OUTPUT_LOCATION="s3://${S3_BUCKET}/athena-results/"

# 1. データベース作成
aws athena start-query-execution \
  --query-string "$(envsubst < athena_scripts/01_create_database.sql)" \
  --result-configuration OutputLocation=${ATHENA_OUTPUT_LOCATION}

# 2. 外部テーブル（CSV）作成
aws athena start-query-execution \
  --query-string "$(envsubst < athena_scripts/02_create_external_tables.sql)" \
  --result-configuration OutputLocation=${ATHENA_OUTPUT_LOCATION}

# 3. Icebergテーブル作成
aws athena start-query-execution \
  --query-string "$(envsubst < athena_scripts/03_create_iceberg_tables.sql)" \
  --result-configuration OutputLocation=${ATHENA_OUTPUT_LOCATION}

# 4. データロード
aws athena start-query-execution \
  --query-string "$(envsubst < athena_scripts/04_load_data_to_iceberg.sql)" \
  --result-configuration OutputLocation=${ATHENA_OUTPUT_LOCATION}

# 5. データ検証
aws athena start-query-execution \
  --query-string "$(envsubst < athena_scripts/05_verify_data.sql)" \
  --result-configuration OutputLocation=${ATHENA_OUTPUT_LOCATION}
```

**注意**:
- `envsubst` は `gettext` パッケージに含まれています（`apt install gettext` または `brew install gettext`）
- 各クエリの実行状況はAthenaコンソールまたは `aws athena get-query-execution` で確認できます
- 複数のSQL文を含むファイルは、Athenaでは1文ずつ実行する必要があります

### 4. Dockerイメージのビルド

```bash
docker-compose build
```

## dbtコマンドの実行

### 接続テスト

```bash
docker-compose run --rm dbt debug
```

### モデル一覧の確認

```bash
docker-compose run --rm dbt list
```

### dbt run（モデル実行）

```bash
# 全モデルを実行
docker-compose run --rm dbt run

# 特定のモデルのみ実行
docker-compose run --rm dbt run --select stg_devices

# staging層のみ実行
docker-compose run --rm dbt run --select staging.*

# marts層のみ実行
docker-compose run --rm dbt run --select marts.*
```

### dbt test（テスト実行）

```bash
docker-compose run --rm dbt test
```

### ドキュメント生成

```bash
docker-compose run --rm dbt docs generate
```

### インタラクティブシェル

```bash
docker-compose run --rm dbt bash
```

## データモデル

### ステージング層（staging）

ソーステーブルを軽微な変換を加えて参照するViewモデル：

| モデル名 | 説明 |
|----------|------|
| `stg_devices` | デバイスマスタ（マルチセンサーフラグ追加） |
| `stg_sensor_readings` | センサー読み取り（日付・時間分割、品質カテゴリ追加） |
| `stg_alerts` | アラート（日付分割、重要度レベル追加） |

### マート層（marts）

ビジネス分析向けに集計・結合したIcebergテーブル：

| モデル名 | 説明 |
|----------|------|
| `dim_devices` | デバイスディメンション（アラート・読み取りサマリー付き） |
| `fct_hourly_metrics` | 時間単位のセンサーメトリクス集計 |
| `fct_daily_alerts` | 日次アラート集計 |

## トラブルシューティング

### Glueセッションが開始しない

- IAMロールの信頼関係を確認
- ロールに必要なポリシーがアタッチされているか確認
- リージョン設定が正しいか確認

### S3アクセスエラー

- IAMロールにS3バケットへのアクセス権限があるか確認
- バケットポリシーでアクセスがブロックされていないか確認

### Icebergテーブルが見つからない

- Athenaスクリプトが正常に実行されたか確認
- Glue Data Catalogにテーブルが登録されているか確認

## 参考リンク

- [dbt-glue GitHub](https://github.com/aws-samples/dbt-glue)
- [dbt Documentation](https://docs.getdbt.com/)
- [Apache Iceberg](https://iceberg.apache.org/)
- [AWS Glue Documentation](https://docs.aws.amazon.com/glue/)
- [Amazon Athena Documentation](https://docs.aws.amazon.com/athena/)
