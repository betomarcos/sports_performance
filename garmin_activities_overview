**OVERVIEW**

- Analysis on Garmin activities data. 
- Mostly focused on running and triathlon related activities.
- Used data exports from Garmin Connect. Loaded to a local MySQL instance with the query below.
 <br />
 <br /> 
 
**TABLEAU**
- Garmin Workouts Analysis: https://public.tableau.com/app/profile/alberto.marcos/viz/garminactivities/Dashboard2?publish=yes
<img width="1202" alt="image" src="https://github.com/betomarcos/garmin_activities/assets/130506688/6781c4a2-8205-4f69-b333-f1806bc17843"> <br /> 
 <br /> 
 <br /> 


**QUERY TO CREATE DATASET**
- betomarcos/garmin_activities/garmin_activities_stage.sql
```sql
DROP TABLE IF EXISTS garmin_activities_stage;

CREATE TABLE garmin_activities_stage AS
SELECT
    CASE 
        WHEN activity_type LIKE '%Multisport%' THEN 'Triathlon'
        WHEN activity_type LIKE '%Cycling%' OR activity_type LIKE '%Biking%' THEN 'Cycling' 
        WHEN activity_type LIKE '%Running%' THEN 'Running' 
        WHEN activity_type LIKE '%Walking%' THEN 'Walking' 
        WHEN activity_type LIKE '%Yoga%' THEN 'Yoga' 
        WHEN activity_type LIKE '%Strength Training%' THEN 'Strength Training' 
        ELSE 'Other' -- Other includes: swim, golf, soccer, cardio, breathwork, etc
    END AS activity_type,
    DATE(activity_date) AS activity_date,
    Title AS title,
    avg_hr,
    max_hr,
    aerobic_te,
    distance_km,
    Calories AS calories,
    activity_time,
    ROUND(
        CASE
            WHEN activity_time LIKE '%.%' THEN
                -- Minutes:Seconds format
                SUBSTRING_INDEX(activity_time, ':', 1) * 60 +
                SUBSTRING_INDEX(activity_time, ':', -1)
            ELSE
                -- Hours:Minutes:Seconds format
                SUBSTRING_INDEX(activity_time, ':', 1) * 3600 +
                SUBSTRING_INDEX(SUBSTRING_INDEX(activity_time, ':', -2), ':', 1) * 60 +
                SUBSTRING_INDEX(activity_time, ':', -1)
        END / 60
    ) AS duration_minutes -- fixes issue with having some 'activity_type' fields measured in minutes vs hours. Example: Yoga activities were in mm:ss. Running activities were in hh:mm:ss.
FROM garmin_all_activities_raw
WHERE 
    (avg_hr IS NOT NULL AND TRIM(avg_hr) != '' AND avg_hr > 0)
    OR (activity_type LIKE '%Multisport%') -- Multisport types have 0 as AVG HR. But still want to bring those to the visuals.
    AND distance_km IS NOT NULL AND TRIM(distance_km) != ''
HAVING 
    max_hr < 201 -- this could change later on, currently limiting to under 201 bpm due to a Garmin HR monitor strap issue, some activities have HR of 240-250, which is not accurate as the activity had not even started.
;
```

