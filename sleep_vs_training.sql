/*
- Creating a mysql table with specific fields I need to analyze sleep data vs training/activities data.
- Fields: date, sleep_score, sleep_duration, resting_hr, sleep_hours, activity_type, activity_date, title, avg_hr, max_hr, aerobic_te, distance_km, calories, activity_time, duration_minutes
*/

CREATE TABLE new_table_name AS
SELECT 
    p.date,  
    p.sleep_score, 
    p.sleep_duration, 
    p.resting_hr, 
    p.sleep_hours,
    a.*
FROM garmin.prod_table p
LEFT JOIN garmin.garmin_activities_stage a 
    ON p.date = a.activity_date;



######################### EDA #########################
    
SELECT * FROM garmin.sleep_vs_training;
select * from garmin.health_log_raw;

-- pull info on sleep metrics, training, allergies, and alcohol
select 
	t.date, h.day_text, t.sleep_score, t.resting_hr, t.sleep_hours, t.activity_type, t.duration_minutes,
    h.alcohol_ct, h.allergies_score 
from garmin.sleep_vs_training t
left join garmin.health_log_raw h on t.date = h.date
order by date desc;


-- query to get a histogram type of dataset, to evaluate the day of the week 'bins' and compare several metrics on sleep, training, and alcohol.
select day_text, round(avg(sleep_score), 1), round(avg(sleep_hours), 1), count(activity_type), round(avg(alcohol_ct), 1), round(avg(allergies_score), 1)
from (
	select 
		t.date, h.day_text, t.sleep_score, t.resting_hr, t.sleep_hours, t.activity_type, t.duration_minutes,
		h.alcohol_ct, h.allergies_score 
	from garmin.sleep_vs_training t
	left join garmin.health_log_raw h on t.date = h.date
) as histo group by 1 order by day_text asc;



