FROM python:3.10-slim

# 必要なシステムパッケージのインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    gcc \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリの設定
WORKDIR /dbt

# Python依存パッケージのインストール
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
    dbt-core==1.7.* \
    dbt-glue==1.7.* \
    boto3

# dbtプロジェクトのコピー
COPY dbt_iot_demo/ /dbt/

# AWS認証情報をマウントするためのディレクトリ
RUN mkdir -p /root/.aws

# プロファイルディレクトリの作成
RUN mkdir -p /root/.dbt

# profiles.ymlをコピー
COPY profiles.yml /root/.dbt/profiles.yml

# デフォルトのエントリポイント
ENTRYPOINT ["dbt"]
CMD ["--help"]
