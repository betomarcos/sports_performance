# Garmin Resting Heart Rate Analysis on Sleep Performance

### Problem: 
Sleep and energy levels have been inconsistent over the past two months.   
Issues: low energy upon waking, difficulty falling asleep, not feeling rested.   
Fortunately, my Garmin watch tracks sleep metrics, been wearing it every night for years.

### Task and Action:
Explore Garmin sleep tracking data (Resting Heart Rate) to find potential causes and insights related to sleep performance.    
Initial exploration by manually exporting 1 year of Resting Heart Rate (RHR) data from my Garmin Connect.   
Analyzed it in a Jupyter notebook to establish baselines and calculate basic statistics.

### Results and Findings:  
<img width="399" alt="image" src="https://github.com/user-attachments/assets/b5852b39-56d1-40b9-8dcd-1f229ac1efba" />  

**12-month statistics:**  
- Date range: 2024-02-06 to 2025-02-03 (363 entries of RHR, 1 per day)
- Range 18 (Max 69, Min 51)
- Mean: 55.51
- St Dev: 3.06
- CV: 5.51

Based on initial exploration of the RHR data:  
- Most occurrences fall within the 52-58 bpm range, with a small variation of ±1 standard deviation.
- The coefficient of variation (CV) is 5.5%, indicating low variance and stable RHR with minimal fluctuations.
- Defined a baseline of 55 bpm, with a ±3 bpm range, for comparison.  

**2-month statistics:**  
Given the previous 2 months are where I started noticing more variance in my sleep quality, I ran a tilmeline with the average RHR over the last 60 days, with MEAN and Trend line.  

<img width="845" alt="image" src="https://github.com/user-attachments/assets/536aa5c9-0612-4e4a-bbfb-3fdaeccc9dee" />   

Based on the graph above:
- The RHR is trending upwards. Higher RHR means less sleep quality.  


**Recommendations:**
- Try to improve circadian rhythm with consistent bed times and alarms.
- Increase the humidity to reduce the dry sleeping environment.
- Reduce caffeine quantity by half.


**Next steps:**
- Further analysis will bring in additional dimensions like sleep hours, sleep time, exercise, and allergy scores, day of the week, temperature
- Investigate outliers by creating a new dataset for RHR values > 58 bpm, and analyze the influence of seasonality, holidays, and days of the week.
- Compare my data with demographic averages to contextualize results.






