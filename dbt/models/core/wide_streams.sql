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
    fact_streams.artistKey,
    fact_streams.songKey,
    fact_streams.dateKey,
    fact_streams.locationKey,
    fact_streams.ts AS timestamp,

    dim_users.gender,
    dim_users.level,
    dim_users.userId,
    dim_users.currentRow,

    dim_songs.year AS releaseYear,
    dim_songs.duration AS songDuration,
    dim_songs.tempo,
    dim_songs.title,

    dim_location.city,
    dim_location.stateCode,
    dim_location.stateName,
    dim_location.latitude AS latitude,
    dim_location.longitude AS longitude,

    dim_datetime.date,
    dim_datetime.dayOfWeek,
    dim_datetime.dayOfMonth,
    dim_datetime.weekOfYear,
    dim_datetime.month,
    dim_datetime.year,
    dim_datetime.weekendFlag,
    
    dim_artists.latitude AS artistLatitude,
    dim_artists.longitude AS artistLongitude,
    dim_artists.name AS artistName
    dim_artists.location as artistLocation
FROM
    {{ ref('fact_streams') }}
INNER JOIN
    {{ ref('dim_users') }} ON fact_streams.userKey = dim_users.userKey
INNER JOIN
    {{ ref('dim_songs') }} ON fact_streams.songKey = dim_songs.songKey
INNER JOIN
    {{ ref('dim_location') }} ON fact_streams.locationKey = dim_location.locationKey
INNER JOIN
    {{ ref('dim_datetime') }} ON fact_streams.dateKey = dim_datetime.dateKey
INNER JOIN
    {{ ref('dim_artists') }} ON fact_streams.artistKey = dim_artists.artistKey