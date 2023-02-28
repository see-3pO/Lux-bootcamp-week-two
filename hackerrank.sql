
WITH MaxSubmissionsPerDay as(
    SELECT submission_date,
           hacker_id, 
           RANK() OVER(PARTITION BY submission_date ORDER BY SubmissionCount DESC,hacker_id)AS Ranking
           FROM
           (
            SELECT submission_date, hacker_id, COUNT(1) AS SubmissionCount
            FROM submissions
            GROUP BY submission_date, hacker_id
           ) subQuery
),


DailyRank AS (
    SELECT submission_date,
           hacker_id,
           DENSE_RANK() OVER (ORDER BY submission_date) as dayRank
           FROM submissions
),

HackerCount AS (
    SELECT outtr.submission_date,
           outtr.hacker_id,
           CASE WHEN outtr.submission_date= '2016-03-01' THEN 1
            ELSE 1+(SELECT COUNT(DISTINCT a.submission_date)
                    FROM submissions a WHERE a.hacker_id =outtr.hacker_id AND a.submission_date<outtr.submission_date)
            END AS PreviousCount,
                   outrr.dayRank
                   FROM DailyRank outrr
),

HackerDailySub AS (
    SELECT submission_date,
           COUNT(DISTINCT hacker_id) AS HackerCnt
   FROM HackerCount
   WHERE PreviousCount =dayRank
   GROUP BY submission_date
)
SELECT HackerDailySub.submission_date,
       HackerDailySub.HackerCnt,
       MaxSubmissionsPerDay.hacker_id,
       Hackers.name

FROM HackerDailySub
INNER JOIN MaxSubmissionsPerDay
ON HackerDailySub.submission_date = MaxSubmissionsPerDay.submission_date
INNER JOIN Hackers
ON Hackers.hacker_id =  MaxSubmissionsPerDay.hacker_id
WHERE MaxSubmissionsPerDay.Ranking=1
