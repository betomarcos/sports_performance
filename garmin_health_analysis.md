# GARMIN HEALTH AND ACTIVITIES ANALYSIS


## 1. OVERVIEW

- Goal: understand relationships between Sleep, Working out, Alcohol consumption, and other health metrics.
- The data in scope comes from 2 sources: **1)** Garmin exports (sleep, workouts) and **2)** manual log with diet habits updated in a google sheet.
    - Garmin activities in scope: running, cycling, strength training, yoga, walking.
    - 89 rows in the final dataset, where 1 row = 1 day. If 1 day had more than 1 workout, they get added in terms of workout time and aerobic benefit.
    - Date range: 2024-02-01 to 2024-05-01
- The results and outputs should include correlations summary and recommendations.

## 2. METHODOLOGY

The following steps are detailed after the Results section.
1) Determine metrics to research and formulate questions for guidance
2) Define data and data sources
3) Exploratory Data Analysis (EDA)
4) Data Analysis
5) Interpretation and Insights
6) Visualization and Presentation

## 3. RESULTS

**CORRELATION ANALYSIS**

After running the following MySQL query to pull info on sleep metrics, training, allergies, and alcohol, I exported the data to Excel and ran correlations.
  ```sql
SELECT 
    t.date, 
    MAX(h.day_text) AS day_text,  
    ROUND(AVG(t.sleep_score)) AS avg_sleep_score,
    ROUND(AVG(t.resting_hr)) AS avg_resting_hr,  
    ROUND(AVG(t.sleep_hours), 2) AS avg_sleep_hours,  
    GROUP_CONCAT(DISTINCT t.activity_type) AS activity_types,  
    ROUND(SUM(t.duration_minutes)) AS total_duration_minutes,  
    ROUND(MAX(t.max_hr)) AS max_hr,
    SUM(t.aerobic_te) as total_te, 
    ROUND(AVG(h.alcohol_ct)) AS avg_alcohol_ct,  
    ROUND(AVG(h.allergies_score),2) AS avg_allergies_score  
FROM garmin.sleep_vs_training t
LEFT JOIN garmin.health_log_raw h ON t.date = h.date
GROUP BY t.date
HAVING avg_sleep_score > 0
ORDER BY t.date DESC;

  ```


**Data definitions utilized in the CORRELATION ANALYSIS:**
 
* _sleep_score:_ Sleep Score, 0-100 score measured by a mix of native metrics from Garmin such as Heart Rate, Heart Rate Variability (HRV), Resting Heart Rate (RHR), Stress, etc.
* _resting_hr:_ Resting Heart Rate, beats per minutes measured when in rest (sleeping)
* _sleep_hours:_ Sleep Hours, number of hours slept
* _activity_type:_ Activity Type from Garmin workouts: Running, Cycling, Walking, Strength, Yoga
* _duration_minutes:_ Activity duration in minutes
* _max_hr:_ Maximum heart rate reached during an workout activity
* _aerobit_te:_ Measures the aerobic benefit of a workout activity
* _alcohol_ct:_ number of alcoholic beverages consumed in 1 day. 1 alcoholic beverage could be: 1 glass of wine, 1 beer, 1 ounce of liquor.
* _allergies_score:_ score from 0-1 on environmental allergies with effects such as runny nose, blocked nostrils, sneezing, fatigue, etc. Example:
    * 0: no allergy symptoms
    * .5: noticeable but manageable symptoms that do not interfere with work or exercise activities too much
    * 1: barely manageable symptoms, not able to fully functoin and focus at work or exercise

<br />
Sample dataset (actual dataset has 89 entries)

![image](https://github.com/user-attachments/assets/c84bfa17-2bfe-4eb2-91d6-789ef1c5bfe5)

Summary of weekly habits:  

<img width="753" alt="image" src="https://github.com/user-attachments/assets/01fdecf7-03f5-426e-b575-ec307f0376d7">

Afterwards, ran the Excel =CORREL() function and the results are as follows:  

![image](https://github.com/user-attachments/assets/65a6b249-dc84-4b5e-8d25-a2bc39a57410)


 
<br />

**Correlation Analysis: Results Summary**

**Recommendation**: Based on the following results and the data available for the analysis, the recommendation would be to focus most of the attention to increasing the # of hours slept every day. This is the metric that has the most impact on Sleep Score.

**Correlation scores: Sleep vs:**

* **resting_hr: -0.252:** Moderate Negative Correlation: Indicates that as resting heart rate increases, the sleep score tends to decrease. The relationship is moderate.
* **-> sleep_hours: 0.710:** Strong Positive Correlation: This shows a strong positive relationship, suggesting that as sleep hours increase, the sleep score also tends to increase, indicating better sleep quality with more sleep hours.
* **alcohol_ct: 0.009:** Very Weak Positive Correlation: There is almost no correlation between alcohol count and sleep score, indicating that alcohol consumption has minimal impact on sleep score in this dataset.
* **allergies_score: 0.089:** Very Weak Positive Correlation: This suggests a very slight positive relationship between allergies score and sleep score, which is not likely to be significant.
* **duration_minutes: 0.094:** Very Weak Positive Correlation: There is a very slight positive correlation, indicating that longer duration of activities has a minimal impact on increasing the sleep score.
* **max_hr: -0.005:** Very Weak Negative Correlation: There is virtually no correlation between maximum heart rate and sleep score, suggesting little to no relationship.
* **aerobic_te: -0.069:** Very Weak Negative Correlation: Indicates a very slight negative relationship between aerobic training effect and sleep score, which is not likely to be significant.




---------------------------------------------------------------  

---------------------------------------------------------------  

# METHODOLOGY 
## STEP 1: Determine metrics to research and formulate questions for guidance
Understand relationships between Sleep, Working out, Alcohol consumption, and other health metrics.

Guiding questions:

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

**Correlation Analysis:**
Run Correlations to compare how different habits can impact Sleep Score.

**Regression Analysis:**
Perform linear regression to quantify the relationship between workout metrics (independent variables) and heart rate metrics (dependent variables).

**Time Series Analysis:**
Analyze trends and patterns in heart rate metrics over time in relation to changes in workout volume and intensity.



## Step 5: Interpretation and Insights
**Key Questions to Answer from STEP 1:**
Interpretations documented on the overview section, in RESULTS.

## Step 6: Visualization and Presentation
TBD
