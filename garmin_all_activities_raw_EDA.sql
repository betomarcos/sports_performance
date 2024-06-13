SELECT * FROM garmin.garmin_all_activities_raw limit 20;

###############################
############# EDA #############
###############################

-- count records
select count(*) from garmin.garmin_all_activities_raw; -- 2239 as of June 6, 2024

-- look at workouts and how many per type
select activity_type, count(activity_type) as counts
from garmin.garmin_all_activities_raw
group by 1 order by 2 desc;

-- look at max hr record
select *
from garmin.garmin_all_activities_raw
order by max_hr desc limit 30;

select *
from garmin.garmin_all_activities_raw
where max_hr > 200 and max_hr < 210;
		-- some records do not make sense, from usage I know my chest HR strap sometimes does not work. Need to clean up.
        -- I know my HR through activity is around 207, so if the HR is above 207, needs to be '' or null.
        -- Given that faulty HR monitor, need to delete data fields that are affected by HR, such as avg_hr, max_hr, and aerobic_te
			-- alter table to remove the avg_hr, max_hr, and aerobic_te where max_hr > 208

-- look at top 10 longest distances by activity type 
select activity_type, max(distance_km) as max_dist
from garmin.garmin_all_activities_raw
group by 1 order by 2 desc;
		-- noticed several activity_types are in meters and others in kilometers. Need to clean up


-- see all types of activities to figure out how to group them
select distinct activity_type from garmin_all_activities_raw;


-- Total minutes by activity type
select 
	case 
		when activity_type like ('%Cycling%') or activity_type like ('%Biking%') then 'Cycling' 
		when activity_type like ('%Running%') then 'Running' 
        when activity_type like ('%Walking%') then 'Walking' 
        when activity_type like ('%Swim%') then 'Swimming' 
        when activity_type like ('%Yoga%') then 'Yoga' 
        when activity_type like ('%Strength Training%') then 'Strength Training' 
        else 'Other' end as activity_type
    , ROUND(sum(time_to_sec(activity_time) / 60)) as total_minutes
from garmin_all_activities_raw
group by 1  order by 2 desc;


-- Total daily minutes by activity type
select 
     activity_date 
	, case 
		when activity_type like ('%Cycling%') or activity_type like ('%Biking%') then 'Cycling' 
		when activity_type like ('%Running%') then 'Running' 
        when activity_type like ('%Walking%') then 'Walking' 
        when activity_type like ('%Swim%') then 'Swimming' 
        when activity_type like ('%Yoga%') then 'Yoga' 
        when activity_type like ('%Strength Training%') then 'Strength Training' 
        else 'Other' end as activity_type
    , ROUND(sum(time_to_sec(activity_time) / 60)) as total_minutes
from garmin_all_activities_raw
group by 1,2  order by 1 asc;





-- Aerobic training effect TE, with color by workout type
select 
     activity_date
	, case 
		when activity_type like ('%Cycling%') or activity_type like ('%Biking%') then 'Cycling' 
		when activity_type like ('%Running%') then 'Running' 
        when activity_type like ('%Walking%') then 'Walking' 
        when activity_type like ('%Swim%') then 'Swimming' 
        when activity_type like ('%Yoga%') then 'Yoga' 
        when activity_type like ('%Strength Training%') then 'Strength Training' 
        else 'Other' end as activity_type
    , aerobic_te
    , ROUND(sum(time_to_sec(activity_time) / 60)) as total_minutes
from garmin_all_activities_raw
group by 1,2,3  order by 1 asc;