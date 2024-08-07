SELECT * FROM garmin.garmin_all_activities_raw;

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
        -- I know my HR through activity is around 208, so if the HR is above 207, needs to be '' or null.
        -- Given that faulty HR monitor, need to delete data fields that are affected by HR, such as avg_hr, max_hr, and aerobic_te
			-- alter table to remove the avg_hr, max_hr, and aerobic_te where max_hr > 208








