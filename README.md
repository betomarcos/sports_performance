# Phase 1 - June 2024

## STEP 1: Define goals
Understand relationships between Sleep and Working out.

Key questions to answer:

**Volume vs. Heart Rate fitness:**
- Does higher workout volume correlate with lower (lower is better) RHR?
- Does higher workout volume correlate with higher (higher is better) HRV?

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

 -- _PLACEHOLDER FOR DATA MODEL_ --
 

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
