-- avg sleep score when alcohol_ct = 0,1,2,3,4 etc
select 
	alcohol_prior
    , count(alcohol_prior) as occurrences
    , avg(current_sleep_score)
from (SELECT 
    p1.`date` AS date_prior,
    p1.alcohol_ct AS alcohol_prior,
    p2.`date` AS `current_date`,
    p2.sleep_score AS current_sleep_score,
    p2.sleep_hours
FROM 
    garmin.prod_table p1
JOIN 
    garmin.prod_table p2 ON DATE_ADD(p1.`date`, INTERVAL 1 DAY) = p2.`date`
WHERE p2.sleep_hours > 3) as temp
GROUP BY 1;


/*
output:
# alcohol_prior, occurrences, avg(current_sleep_score)
'0', '57', '87.491228'
'1', '11', '88.909091'
'2', '15', '83.400000'
'3', '3', '80.666667'
'4', '2', '86.000000'
*/
