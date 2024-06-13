
-- First ensure the MySQL connection > Advanced > Others has in the text box: 'OPT_LOCAL_INFILE=1'
-- This script reloads the garmin_all_activities_raw data in MySQL
-- The source data from CSV is an export from Garmin Connect, then run a Macro to format and remove bad data.


TRUNCATE TABLE garmin.garmin_all_activities_raw;

LOAD DATA LOCAL INFILE '/Users/albertomarcos/Documents/Projects/DATA PROJECTS/1. data_analysis_folder/datasets/Garmin datasets/garmin_all_activities_2024_june_5 cleanup.csv'
INTO TABLE garmin.garmin_all_activities_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;



-- Ran this to remove a column from the schema, no need to run everytime reloading data
-- ALTER TABLE garmin.garmin_all_activities_raw DROP COLUMN Distance;
-- ALTER TABLE garmin.garmin_all_activities_raw DROP COLUMN avg_resp;


select * from garmin.garmin_all_activities_raw;




ALTER TABLE garmin.garmin_all_activities_raw
MODIFY COLUMN distance_km DECIMAL(10, 2),
MODIFY COLUMN avg_hr DECIMAL(10, 2),
MODIFY COLUMN max_hr DECIMAL(10, 2);


-- Try removing the '0' from rows that don't need, such as when Activity_type = 'Strength', 'distance_km' should be ' ', not '0'
UPDATE garmin.garmin_all_activities_raw
SET 
    distance_km = IF(distance_km = '0.00', '', distance_km),
    avg_hr = IF(avg_hr = '0.00', '', avg_hr),
    max_hr = IF(max_hr = '0.00', '', max_hr);


  
  
