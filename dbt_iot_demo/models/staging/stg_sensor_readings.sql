{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ source('iot_demo', 'sensor_readings') }}
),

renamed as (
    select
        reading_id,
        device_id,
        reading_timestamp,
        metric_type,
        metric_value,
        unit,
        quality_score,
        -- 派生カラム
        date(reading_timestamp) as reading_date,
        hour(reading_timestamp) as reading_hour,
        case
            when quality_score >= 0.98 then 'excellent'
            when quality_score >= 0.95 then 'good'
            when quality_score >= 0.90 then 'fair'
            else 'poor'
        end as quality_category
    from source
)

select * from renamed
