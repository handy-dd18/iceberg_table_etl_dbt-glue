{{
    config(
        materialized='table',
        file_format='iceberg'
    )
}}

with readings as (
    select * from {{ ref('stg_sensor_readings') }}
),

devices as (
    select * from {{ ref('stg_devices') }}
),

hourly_aggregation as (
    select
        r.device_id,
        r.reading_date,
        r.reading_hour,
        r.metric_type,
        r.unit,
        count(*) as reading_count,
        avg(r.metric_value) as avg_value,
        min(r.metric_value) as min_value,
        max(r.metric_value) as max_value,
        avg(r.quality_score) as avg_quality_score
    from readings r
    group by
        r.device_id,
        r.reading_date,
        r.reading_hour,
        r.metric_type,
        r.unit
)

select
    h.device_id,
    d.device_name,
    d.device_type,
    d.location,
    h.reading_date,
    h.reading_hour,
    h.metric_type,
    h.unit,
    h.reading_count,
    h.avg_value,
    h.min_value,
    h.max_value,
    h.avg_quality_score,
    current_timestamp() as dbt_updated_at
from hourly_aggregation h
inner join devices d on h.device_id = d.device_id
