{{
    config(
        materialized='table',
        file_format='iceberg'
    )
}}

with alerts as (
    select * from {{ ref('stg_alerts') }}
),

devices as (
    select * from {{ ref('stg_devices') }}
),

daily_aggregation as (
    select
        a.device_id,
        a.alert_date,
        a.severity,
        a.alert_type,
        count(*) as alert_count,
        sum(case when a.is_resolved = true then 1 else 0 end) as resolved_count,
        sum(case when a.is_resolved = false then 1 else 0 end) as unresolved_count
    from alerts a
    group by
        a.device_id,
        a.alert_date,
        a.severity,
        a.alert_type
)

select
    da.device_id,
    d.device_name,
    d.device_type,
    d.location,
    da.alert_date,
    da.severity,
    da.alert_type,
    da.alert_count,
    da.resolved_count,
    da.unresolved_count,
    current_timestamp() as dbt_updated_at
from daily_aggregation da
inner join devices d on da.device_id = d.device_id
