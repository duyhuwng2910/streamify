CREATE OR REPLACE TABLE int3507-5.streamify_prod.analytic_dataset AS (
    SELECT
        f.userKey,

        du.userId,
        du.gender,
        du.level,
        du.currentRow,
        du.rowActivationDate,
        du.rowExpirationDate,
        f.ts AS timestamp,

        f.songKey,
        ds.title,
        ds.duration,
        ds.tempo,
        ds.year as releaseYear,
        
        f.artistKey,
        da.name,
        da.location as artistLocation,
        
        f.dateKey AS dateKey,
        dd.date,
        dd.dayOfWeek,
        dd.dayOfMonth,
        dd.weekOfYear,
        dd.month,
        dd.year,
        dd.weekendFlag,
        
        f.locationKey AS locationKey,
        dl.city,
        dl.stateCode,
        dl.stateName,
        dl.latitude,
        dl.longitude
    FROM
        `int3507-5`.`streamify_prod`.`fact_streams`f
    INNER JOIN
        `int3507-5`.`streamify_prod`.`dim_users` du ON f.userKey = du.userKey
    INNER JOIN
        `int3507-5`.`streamify_prod`.`dim_songs` ds ON f.songKey = ds.songKey
    INNER JOIN
        `int3507-5`.`streamify_prod`.`dim_artists` da ON f.artistKey = da.artistKey
    INNER JOIN
        `int3507-5`.`streamify_prod`.`dim_datetime` dd ON f.dateKey = dd.dateKey
    INNER JOIN
        `int3507-5`.`streamify_prod`.`dim_location` dl ON f.locationKey = dl.locationKey
);