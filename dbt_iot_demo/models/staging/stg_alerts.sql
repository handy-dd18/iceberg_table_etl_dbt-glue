{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ source('iot_demo', 'alerts') }}
),

renamed as (
    select
        alert_id,
        device_id,
        alert_timestamp,
        alert_type,
        severity,
        message,
        is_resolved,
        -- 派生カラム
        date(alert_timestamp) as alert_date,
        case
            when severity = 'critical' then 3
            when severity = 'warning' then 2
            when severity = 'info' then 1
            else 0
        end as severity_level
    from source
)

select * from renamed
