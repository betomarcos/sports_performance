# Phase 1 - June 2024


## OVERVIEW
The goal of this project is to understand relationships between Sleep, Working out, Alcohol consumption, and other health metrics.
The data in scope comes from 2 main sources: 1) Garmin exports (sleep, workouts) and 2) manual log with diet habits updated in a google sheet


## RESULTS (work in progress)

After running the following MySQL query to pull info on sleep metrics, training, allergies, and alcohol, I exported the data to Excel and ran correlations.
  ```sql
select 
	t.date, h.day_text, t.sleep_score, t.resting_hr, t.sleep_hours, t.activity_type, t.duration_minutes, t.max_hr, t.aerobic_te
    , h.alcohol_ct, h.allergies_score 
from garmin.sleep_vs_training t
left join garmin.health_log_raw h on t.date = h.date
order by date desc;
  ```

Sample dataset (actual dataset has 130+ entries:

![image](https://github.com/user-attachments/assets/c84bfa17-2bfe-4eb2-91d6-789ef1c5bfe5)


Afterwards, ran the Excel =CORREL() function and the results are as follows:

![image](https://github.com/user-attachments/assets/24735faa-fb92-4c9b-9a12-38f9e59893b6)


## Results summary:

resting_hr: -0.342
- Moderate Negative Correlation: As resting heart rate increases, the sleep score tends to decrease. This might indicate that higher resting heart rates are associated with lower sleep quality.

sleep_hours: 0.848
- Strong Positive Correlation: As sleep hours increase, the sleep score also tends to increase significantly, suggesting that more sleep is associated with better sleep quality.

alcohol_ct: -0.112
- Weak Negative Correlation: There is a slight tendency for sleep score to decrease as alcohol consumption increases, but the relationship is weak.

allergies_score: 0.084
- Very Weak Positive Correlation: There is almost no correlation between allergies score and sleep score, indicating that allergies may not significantly impact sleep quality in this dataset.

duration_minutes: -0.314
- Weak to Moderate Negative Correlation: As the duration of activities increases, the sleep score tends to decrease. This might indicate that longer durations of physical activity could be linked to lower sleep quality, though the relationship is not strong.

max_hr: -0.080
- Very Weak Negative Correlation: There's a minimal negative correlation between maximum heart rate and sleep score, suggesting little to no relationship between these variables.

aerobic_te: -0.220
- Weak Negative Correlation: There is a slight negative correlation between aerobic training effect and sleep score, indicating that higher aerobic training effect might be associated with lower sleep scores, but the relationship is not strong.



## STEP 1: Define goals
Understand relationships between Sleep, Working out, Alcohol consumption, and other health metrics.

Some questions to answer:

**Volume vs. Heart Rate fitness:**
- Does higher workout volume correlate with lower (lower is better) RHR?
- Does higher workout volume correlate with higher (higher is better) Sleep Scores?

**Intensity vs. Heart Rate fitness:**
- How does workout intensity impact RHR?
- How does workout intensity impact HRV?

**Consistency and Stability:**
- How does consistency in workout routines impact the stability of RHR and HRV over time?

_Focus on workout types: running, cycling, strength training, and walking._

## STEP 2: Define data and data sources

4 Datasets: 
- Garmin Connect CSV exports: Activities, Sleep, Heart Rate
- Manual health log spreadsheet

To answer the questions from STEP 1, the data fields required will be documented in further steps, after EDA and data cleanup.

2 Datasets already loaded to MySQL:
Garmin.prod_table. This dataset is a join of Garmin exports + manual input log on health habits I care about (alcohol consumption, mood, work stress, etc)  

## Step 3: Exploratory Data Analysis (EDA)

**Data cleanup and prep**
- Ensure the table we are working with is a copy or stage table so there are no risks
- Remove duplicates
- Standardize the data
- Deal with Nulls or blanks
- Remove columns that are not needed

**Descriptive Statistics:**
1. Workout summary stats per week: 
- total minutes (duration of workouts) with color by workout type
- average HR during workouts, color by workout type 
- aerobic training effect TE, with color by workout type 
2. Sleep summary stats per week: - RHR and HRV 
3. Create additional tables as needed for specific analysis, and after data cleanup and exploration


  **Below are the queries in MySQL to do initial data exploration and cleanup. Also the CREATE statements to generate the dataset.**
  ```sql
  -- Create table "health_log" from a csv export from Google sheets. 
-- Data is a manual daily log about health metrics I want to track. 
-- Loaded the csv data using the MySQL Data Import Wizard.
-- After simple EDA on garmin.health_log, then I loaded Garmin health metrics (HR, HRV, Sleep score, etc) to then join with manual log.


CREATE TABLE garmin.health_log (
    date DATE,
    day_text VARCHAR(20),
    coffee_ct INT,
    alcohol_ct INT,
    allergies_score DECIMAL(5,2),
    zyrtec_ct INT,
    flonase_ct INT,
    sick_score DECIMAL(5,2),
    hangover_score DECIMAL(5,2),
    outdoors INT,
    socialized INT,
    meditated INT,
    mood_score DECIMAL(5,2),
    productivity_score DECIMAL(5,2),
    work_stress_score DECIMAL(5,2)
);

select * from health_log_raw;

-- see which day of the week I consume more coffee or alcohol
select day_text, sum(coffee_ct), sum(alcohol_ct)
from health_log_raw
group by day_text;

-- see which day of the week I am have better mood, or when I have more stress
select day_text, avg(mood_score), avg(work_stress_score)
from health_log_raw
group by day_text;

-- see which day of the week I socialize, or go outdoors the most
select day_text, sum(outdoors), sum(socialized)
from health_log_raw
group by day_text;



-- Create 2 more tables, Load data (using Data Import Wizard) from Garmin health metrics (HR, HRV, Sleep score, etc) to then join with manual log.

CREATE TABLE garmin.garmin_sleep_raw (
    Date DATE,
    Score DECIMAL(5,2),
    Quality VARCHAR(20),
    Duration VARCHAR(20),
    Sleep_Need VARCHAR(20),
    Bedtime TIME,
    Wake_Time TIME
);

CREATE TABLE garmin.garmin_hr_raw (
    Date DATE,
    Resting VARCHAR(20),
    High VARCHAR(20)
);

-- EDA on the new 2 tables:
select * from garmin.garmin_sleep_raw;
select * from garmin.garmin_hr_raw;

-- see avg min max from resting HR
select dayname(Date) as day, round(avg(resting), 1) as avg, min(resting) as min, max(resting) as max, (max(resting)-min(resting)) as dif
from garmin.garmin_hr_raw
group by 1;




-- create a new table that joins most important metrics per day

select *
from garmin.health_log_raw hl
left join garmin.garmin_sleep_raw s on hl.date = s.date
left join garmin.garmin_hr_raw hr on hl.date = hr.date
order by hl.date asc;

select 
	hl.*
    , s.Score as sleep_score
    , s.Duration as sleep_duration
    , s.Bedtime as sleep_bedtime
    , s.Wake_time as sleep_waketime
    , hr.Resting as resting_hr
    , hr.High as max_hr
from garmin.health_log_raw hl
left join garmin.garmin_sleep_raw s on hl.date = s.date
left join garmin.garmin_hr_raw hr on hl.date = hr.date
order by hl.date asc;

-- Create a stage table based on the query with all the necessary data

CREATE TABLE garmin.stage_table AS
SELECT 
    hl.*,
    s.Score AS sleep_score,
    s.Duration AS sleep_duration,
    s.Bedtime AS sleep_bedtime,
    s.Wake_Time AS sleep_waketime,
    hr.Resting AS resting_hr,
    hr.High AS max_hr
FROM
    garmin.health_log_raw hl
        LEFT JOIN garmin.garmin_sleep_raw s ON hl.date = s.Date
        LEFT JOIN garmin.garmin_hr_raw hr ON hl.date = hr.Date
ORDER BY hl.date ASC;


select * from garmin.stage_table;


-- now clean up the stage_table.
-- the sleep_duration would be more usable if we had number of minutes, instead of the "8h 01m" format it currently is. 
-- However, we can extract that from sleep_bedtime-sleep_waketime.
-- Afterwards, discovered that "Sleep Duration" a native field ffrom Garmin, means the actual duration of sleeping time, not necesarily the difference between bedtime and wake time.


select 
	sleep_bedtime
    , sleep_waketime
    , sleep_duration
    , TIMESTAMPDIFF(SECOND, sleep_bedtime, sleep_waketime) / 60 / 60 AS sleep_duration_minutes
from garmin.stage_table
limit 10;

-- will split "sleep_duration" into hours an dminutes


select *, ((hours * 60) + minutes) as sleep_minutes
from (
select 
	`date`
    , sleep_duration
    , SUBSTRING_INDEX(sleep_duration, 'h', 1) AS hours
    , SUBSTRING_INDEX(SUBSTRING_INDEX(sleep_duration, 'h', -1), 'm', 1) AS minutes
from garmin.stage_table
limit 5
) as newtable;


select
 ((SUBSTRING_INDEX(sleep_duration, 'h', 1)*60) +  SUBSTRING_INDEX(SUBSTRING_INDEX(sleep_duration, 'h', -1), 'm', 1)) AS sleep_minutes
from garmin.stage_table
limit 5;

 
-- create new field, and insert the "sleep_minutes" new calculated column and data to the stage_table
ALTER TABLE garmin.stage_table ADD COLUMN sleep_minutes INT;
UPDATE stage_table SET sleep_minutes =  ((SUBSTRING_INDEX(sleep_duration, 'h', 1)*60) +  SUBSTRING_INDEX(SUBSTRING_INDEX(sleep_duration, 'h', -1), 'm', 1));
select * from garmin.stage_table;

-- create new field to insert a "sleep_hours" to stage_table
ALTER TABLE garmin.stage_table ADD COLUMN sleep_hours DECIMAL(5,2);
UPDATE stage_table SET sleep_hours = round(sleep_minutes/60, 2);


-- data is ready. Now from stage_table create a PROD table. This way we can keep editing Stage_table if needed, but Prod is used for analysis.

CREATE TABLE garmin.prod_table AS
SELECT * FROM stage_table 
ORDER BY date ASC;

select * from garmin.prod_table;






------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
/* 
Next step, create a script / stored procedure for the ETL process.
- given the RAW tables are created and reloaded manually using the import wizard, 
we only need to update the stage and prod tables running the etl scripts.
- run the MySQL Data Import Wizard to reload the RAW tables.
- Run the stage_table script
- Run the prod_table script
*/ 
    
-- Step 1: run the MySQL Data Import Wizard to reload the RAW tables. Ensure data types are accurate
-- Step 2: drop the stage_table
	DROP TABLE garmin.stage_table;

-- Step 3: recreate the stage_table    
	CREATE TABLE garmin.stage_table AS
	SELECT 
		hl.*,
		s.Score AS sleep_score,
		s.Duration AS sleep_duration,
		s.Bedtime AS sleep_bedtime,
		s.Wake_Time AS sleep_waketime,
		hr.Resting AS resting_hr,
		hr.High AS max_hr
	FROM garmin.health_log_raw hl
			LEFT JOIN garmin.garmin_sleep_raw s ON hl.date = s.Date
			LEFT JOIN garmin.garmin_hr_raw hr ON hl.date = hr.Date
	ORDER BY hl.date ASC;

-- Step 4: run 2 alter tables to add 2 fields to stage_table
	ALTER TABLE garmin.stage_table ADD COLUMN sleep_minutes INT;
	UPDATE stage_table SET sleep_minutes =  ((SUBSTRING_INDEX(sleep_duration, 'h', 1)*60) +  SUBSTRING_INDEX(SUBSTRING_INDEX(sleep_duration, 'h', -1), 'm', 1));

	ALTER TABLE garmin.stage_table ADD COLUMN sleep_hours DECIMAL(5,2);
	UPDATE stage_table SET sleep_hours = round(sleep_minutes/60, 2);

-- Step 5: drop the prod_table
	DROP TABLE garmin.prod_table;

-- Step 6: recreate the prod_table 
	CREATE TABLE garmin.prod_table AS SELECT * FROM stage_table ORDER BY date ASC;
    
-- Step 7: review prod_table
	SELECT * FROM garmin.prod_table limit 50;
    
-- Step 8: process is completed. Data can be analized and visualized.



  ```


  

## Step 4: Data Analysis

**1. Regression Analysis:**
Perform linear regression to quantify the relationship between workout metrics (independent variables) and heart rate metrics (dependent variables).

**2. Time Series Analysis:**
Analyze trends and patterns in heart rate metrics over time in relation to changes in workout volume and intensity.


## Step 5: Interpretation and Insights
**Key Questions to Answer from STEP 1:**

**Volume vs. Heart Rate fitness:**
- Does higher workout volume correlate with lower (lower is better) RHR?
- Does higher workout volume correlate with higher (higher is better) HRV?

**Intensity vs. Heart Rate fitness:**
- How does workout intensity impact RHR?
- How does workout intensity impact HRV?

**Consistency and Stability:**
- How does consistency in workout routines impact the stability of RHR and HRV over time?


## Step 6: Visualization and Presentation

Using Tableau:
1. Scatter Plots:
- Plot workout volume vs. resting heart rate.
- Plot workout intensity vs. HRV.

2. Line Plots:
- Plot RHR and HRV trends over time alongside workout volume and intensity metrics.

3. Dashboards:
- Create interactive dashboards to explore relationships between different metrics and to drill down into specific time periods or workout types.


