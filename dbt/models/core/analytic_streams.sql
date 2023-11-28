{{ config(
  materialized = 'table',
  partition_by={
    "field": "ts",
    "data_type": "timestamp",
    "granularity": "hour"
  }
  ) }}
SELECT
    fact_streams.userKey,

    dim_users.userId,
    dim_users.gender,
    dim_users.level,
    dim_users.currentRow,
    dim_users.rowActivationDate,
    dim_users.rowExpirationDate,
    fact_streams.ts AS ts,

    fact_streams.songKey,
    dim_songs.title,
    dim_songs.duration,
    dim_songs.tempo,
    dim_songs.year as releaseYear,
    
    fact_streams.artistKey,
    dim_artists.name as artistName,
    dim_artists.location as artistLocation,
    
    fact_streams.dateKey AS dateKey,
    dim_datetime.date,
    dim_datetime.dayOfWeek,
    dim_datetime.dayOfMonth,
    dim_datetime.weekOfYear,
    dim_datetime.month,
    dim_datetime.year,
    dim_datetime.weekendFlag,
    
    fact_streams.locationKey AS locationKey,
    dim_location.city,
    dim_location.stateCode,
    dim_location.stateName,
    dim_location.latitude,
    dim_location.longitude
FROM
    {{ ref('fact_streams') }}
JOIN
    {{ ref('dim_users') }} ON fact_streams.userKey = dim_users.userKey
JOIN
    {{ ref('dim_songs') }} ON fact_streams.songKey = dim_songs.songKey
JOIN
    {{ ref('dim_location') }} ON fact_streams.locationKey = dim_location.locationKey
JOIN
    {{ ref('dim_datetime') }} ON fact_streams.dateKey = dim_datetime.dateKey
JOIN
    {{ ref('dim_artists') }} ON fact_streams.artistKey = dim_artists.artistKey