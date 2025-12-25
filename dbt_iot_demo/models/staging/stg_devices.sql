{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ source('iot_demo', 'devices') }}
),

renamed as (
    select
        device_id,
        device_name,
        device_type,
        location,
        installation_date,
        is_active,
        -- 派生カラム
        case
            when device_type = 'multi' then true
            else false
        end as is_multi_sensor
    from source
)

select * from renamed
