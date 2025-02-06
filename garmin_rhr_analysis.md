### Problem: 
Sleep and energy levels have been inconsistent over the past two months. Issues like low energy upon waking, difficulty falling asleep, waking up in the middle of the night, and not feeling rested have been affecting my sleep quality.   
  
Fortunately, my Garmin watch tracks sleep metrics, and I’ve been wearing it every night for years.

### Task:
Explore Garmin sleep tracking data (such as Resting Heart Rate, Heart Rate Variability,  Sleep Score, Hours of sleep, etc) to find potential causes and insights related to sleep performance. 

### Action:
Initial exploration by manually exporting 1 year of Resting Heart Rate (RHR) data from my Garmin Connect. Analyzed it in a Jupyter notebook to establish baselines and calculate basic statistics.

### Result:  
Basic statistics:  
- Count: 363 entries of RHR (1 per day) 
- Range 18, Max 69, Min 51
- Mean: 55.51
- St Dev: 3.06
- CV: 5.51

Based on initial exploration of the RHR data:   
- Most occurrences fall within the 52-58 bpm range, with a small variation of ±1 standard deviation.
- The coefficient of variation (CV) is 5.5%, indicating low variance and stable RHR with minimal fluctuations.
- Defined a baseline of 55 bpm, with a ±3 bpm range, for comparison.  

Next steps:  
- Further analysis will bring in additional dimensions like sleep hours, sleep time, exercise, and allergy scores, day of the week, temperature
- Investigate outliers by creating a new dataset for RHR values > 58 bpm, and analyze the influence of seasonality, holidays, and days of the week.
- Compare my data with demographic averages to contextualize results.
