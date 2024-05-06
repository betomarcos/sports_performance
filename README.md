## OVERVIEW
Generate health insights leveraging data from Garmin (health, workouts), and manual entry (health log).

## Project Goals:
Create a reporting app with SQL and Tableau, to gather insights and monitor health metrics. App components:
- Data (CSVs + SQL): exports from Garmin, and manual input logs. Loaded to a local MySQL instance.
- Insights (SQL + Tableau): Understand relations and correlations on my daily habits, over time. Create a Tableau dashboard. Potentially divided by:
- 1) Workouts and performance: Vo2max, HRV, Running Pace over time, Threshold pace, etc
- 2) Health: sleep scores, mood scores, productivity scores

Some examples to explore further:
- Which type of workout, or what intensity, or what duration correlates more with better Sleep score
- Which type of workout, or what intensity, or what duration correlates more with better Mood score
- What is the impact of taking vs not taking allergy medicine, on my Sleep score, Mood score

Load to Tableau and create visualizations to measure the impact of several parameters on my health. Examples:
- Which days I worked out the most out of the week? (filter: year)
- Top 3 Months with most activities vs least activities (filter: year)
- Top 5 most recorded activities (filter: year)
- Average duration per activity (filter: year) 
- Compare HR per activity, on coldest months vs hottest months
- How is my HR on average, in (Dec+Jan+Feb) vs (June+July+Aug), per activity.
- Body Battery per Activity type
- HRV per Activity type
- Resting HR per Activity type
- Sleep Score per Activity type


## Technical Goals:
SQL data loading, cleanup, prep, and logic
Descriptive and Inferential statistics
Tableau data visualization and storytelling 

## DATA
Garmin Health:
- Export from Garmin
- date, body battery, sleep hours, time of sleep, pulse ox, respiration, hrv, sleep score, resting hr, 

Garmin Activities:
- Export from Garmin
- Date, activity, title, distance, calories, time, hr, pace...

Manual Log:
- Manual spreadsheet with personal input
- had coffee, had alcohol, had allergies, socialized, meditated, happy score, productive score, motivation score, etc



