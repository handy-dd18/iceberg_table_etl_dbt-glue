{{
    config(
        materialized='table',
        file_format='iceberg'
    )
}}

with devices as (
    select * from {{ ref('stg_devices') }}
),

alerts_summary as (
    select
        device_id,
        count(*) as total_alerts,
        sum(case when is_resolved = false then 1 else 0 end) as unresolved_alerts,
        max(severity_level) as max_severity_level
    from {{ ref('stg_alerts') }}
    group by device_id
),

readings_summary as (
    select
        device_id,
        count(*) as total_readings,
        avg(quality_score) as avg_quality_score
    from {{ ref('stg_sensor_readings') }}
    group by device_id
)

select
    d.device_id,
    d.device_name,
    d.device_type,
    d.location,
    d.installation_date,
    d.is_active,
    d.is_multi_sensor,
    coalesce(a.total_alerts, 0) as total_alerts,
    coalesce(a.unresolved_alerts, 0) as unresolved_alerts,
    coalesce(a.max_severity_level, 0) as max_severity_level,
    coalesce(r.total_readings, 0) as total_readings,
    coalesce(r.avg_quality_score, 0) as avg_quality_score,
    current_timestamp() as dbt_updated_at
from devices d
left join alerts_summary a on d.device_id = a.device_id
left join readings_summary r on d.device_id = r.device_id
