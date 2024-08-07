/* 
Garmin Data Analysis project: Austin Half Marathon 2024 Journey

- Data Source: garmin activities export to csv. Dates are when the training program started and ending with the race day 
- July 22, 2023 - Feb 18, 2024. 
- Loaded the data into mysql using the import wizard.

Data Cleanup
- There are duplicate records. Need to find and clean them up.
- Make the Date column a Date, currently is a Datetime. Don't need the time portion on this case.
- Some numeric columns should have decimals (Distance_KM)
- Remove the "Distance" column, as we are using "Distance_KM" 
- Evaluate the time columns (Time, Avg Pace, Best Pace), to transform those into seconds. That way we can manipulate with time functions.

Next steps:
- 


*/


-- Data was loaded to MySQL through the Table Import Wizard.

-- Update the column names and data types to be easier to handle.
ALTER TABLE garmin.austin_marathon
CHANGE COLUMN `Activity Type` activity_type VARCHAR(255),
CHANGE COLUMN `Avg Hr` avg_hr INT,
CHANGE COLUMN `Max Hr` max_hr INT,
CHANGE COLUMN `Aerobic TE` aerobic_te DECIMAL(5,1),
CHANGE COLUMN `Avg Pace` avg_pace VARCHAR(255),
CHANGE COLUMN `Best Pace` best_pace VARCHAR(255),
CHANGE COLUMN `Avg Resp` avg_resp INT,
MODIFY COLUMN `Date` DATE,
DROP COLUMN `Distance`,
CHANGE COLUMN `Date` activity_date DATE,
CHANGE COLUMN `Time` activity_time VARCHAR(255),
CHANGE COLUMN `Distance_KM` distance_km DECIMAL(5,2);

-- get counts of activity_type prior to evaluating duplicates and cleaning them up. 
select activity_type, count(*) as counts
from garmin.austin_marathon 
group by 1 order by 2 desc; 
-- results Feb 26 12:57pm: walking 96, running 84, strength 30, cycling 11, yoga 9, mtb 2, soccer 1.
-- results Feb 8:37pm: walking 92, running 43, strength 30, cycling 7, yoga 9, mtb 1, soccer 1.


-- Get range of dates from start/end of the program
select min(activity_date), max(activity_date)
from garmin.austin_marathon
;

-- Prior to reloading the csv, we knew there were duplicates in the table, used this query to identify which rows were duplicated
WITH DuplicatesCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY activity_date, title, distance_km, activity_time) AS row_num
    FROM garmin.austin_marathon
) SELECT * FROM DuplicatesCTE WHERE row_num > 1;


select * from garmin.austin_marathon;


-- how many runs did I do in prep for the race: which month had the highest amount of runs and/or kilometers
select DATE_FORMAT(activity_date, '%b %Y') AS dates, count(*) as num_runs, sum(distance_km) as total_kms from garmin.austin_marathon
where activity_type = 'Running'
group by 1
order by 3 desc;

-- what was the longest training session?
select activity_type, activity_date, distance_km, activity_time, avg_pace
from garmin.austin_marathon
where activity_type = 'Running' and activity_date <> '2024-02-18'
order by 3 desc;

-- min max AVG_pace when training running workouts
select max(avg_pace) , min(avg_pace)
from garmin.austin_marathon
where activity_type = 'Running';

-- min max activity durations
select max(activity_time), min(activity_time)
from garmin.austin_marathon
where activity_type = 'Running';

-- how many workouts were Strength or Yoga?
select count(*) 
from garmin.austin_marathon
where activity_type in ('Strength', 'Yoga')
group by activity_type;


