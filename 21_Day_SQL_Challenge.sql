CREATE DATABASE hospital
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

CREATE TABLE patients (
    patient_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    arrival_date DATE,
    departure_date DATE,
    service VARCHAR(50),
    satisfaction INT
);
--------------------------
-- 2. Services Weekly Table
CREATE TABLE services_weekly (
    week INT,
    month INT,
    service VARCHAR(50),
    available_beds INT,
    patients_request INT,
    patients_admitted INT,
    patients_refused INT,
    patient_satisfaction INT,
    staff_morale INT,
    event VARCHAR(100)
);
--------------------------------
-- 3. Staff Table
CREATE TABLE staff (
    staff_id VARCHAR(50) PRIMARY KEY,
    staff_name VARCHAR(100),
    role VARCHAR(50),
    service VARCHAR(50)
);
--------------------------
-- 4. Staff Schedule Table
CREATE TABLE staff_schedule (
    week INT,
    staff_id VARCHAR(50),
    staff_name VARCHAR(100),
    role VARCHAR(50),
    service VARCHAR(50),
    present TINYINT(1),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);
------------------------------------------------------------------------------------------------------------------------------------------
# Day-1
# 1. Retrive all columns from patients table
select * from patients;

# 2. Select patient_id, name, age from patients table
	Select patient_id, name, age
	from patients;

#3. Display first 10 records from services_weekly
Select * 
from services_weekly
limit 10;

# Challenge
# List all unique hospital services available in the hospital.
Select DISTINCT(service) 
from services_weekly;
------------------------------------------------------------------------------------------------------------------------------------------ 
# Day-2
-- 1. Find patient who are older than 60 years
SELECT patient_id, 
       name, age
 FROM patients
 WHERE age >60;
 
 -- 2. Retrieve all staff members who work in the 'Emergency' service.
 SELECT staff_name
 FROM staff
 WHERE service = 'Emergency';
 
 -- 3. List all weeks where more than 100 patients requested admission in any service.
 SELECT week, 
 sum(patients_admitted) as patient_num
 FROM services_weekly
 GROUP BY week
 HAVING sum(patients_admitted)>100 ;
 
 /* Challenge - Find all patients admitted to 'Surgery' service with a satisfaction score below 70,
 showing their patient_id, name, age, and satisfaction score.*/
 
 SELECT patient_id, 
        name, age,
        satisfaction
 FROM patients
 WHERE service ="Surgery" AND satisfaction <70;
------------------------------------------------------------------------------------------------------------------------------------------
 # Day -3
 -- 1. List all patients sorted by age in descending order.
 SELECT patient_id,
        name, age
 FROM patients
 ORDER BY age DESC;
 
 -- 2. Show all services_weekly data sorted by week number ascending and patients_request descending.
 SELECT *
 FROM services_weekly
 ORDER BY week,
 patients_request DESC;
 
 -- 3. Display staff members sorted alphabetically by their names.
 SELECT staff_name
 FROM staff
 ORDER BY staff_name;
 
 /* Challenge Question: Retrieve the top 5 weeks with the highest patient refusals across all services, 
 showing week, service, patients_refused, and patients_request. Sort by patients_refused in descending order.*/
 
 SELECT week,
        service, 
        patients_refused,
		patients_request
 FROM services_weekly
 ORDER BY patients_refused DESC
 LIMIT 5;
------------------------------------------------------------------------------------------------------------------------------------------ 
# Day 4
 -- 1. Display the first 5 patients from the patients table.
 
 SELECT * 
 FROM patients
 LIMIT 5;
 
 -- 2. Show patients 11-20 using OFFSET.
SELECT patient_id,
       name
FROM patients
LIMIT 10 OFFSET 10;

-- 3. Get the 10 most recent patient admissions based on arrival_date.
SELECT patient_id,
       name, 
       arrival_date
FROM patients
ORDER BY arrival_date DESC
LIMIT 10;
 
/* Challenge Question: Find the 3rd to 7th highest patient satisfaction scores from the patients table, 
showing patient_id, name, service, and satisfaction. Display only these 5 records. */
 
SELECT 
    patient_id,
    name,
    service,
    satisfaction
FROM patients
ORDER BY satisfaction DESC
LIMIT 5 OFFSET 2;
------------------------------------------------------------------------------------------------------------------------------------------
# Day 5
-- 1. Count the total number of patients in the hospital.
SELECT 
     count(DISTINCT patient_id) as no_of_patients
 FROM patients;

-- 2. Calculate the average satisfaction score of all patients
SELECT round(avg(satisfaction),2) as avg_satisfaction_score 
from patients;

-- 3. Find the minimum and maximum age of patients.
SELECT MIN(age) as min_age,
MAX(age) as max_age
FROM patients;

/* Question: Calculate the total number of patients admitted, total patients refused, and the average patient 
satisfaction across all services and weeks. Round the average satisfaction to 2 decimal places. */

SELECT 
SUM(patients_admitted) as total_patient,
SUM(patients_refused) as total_patient_refused,
ROUND (AVG(patient_satisfaction),2) AS avg_patient_satisfaction
FROM services_weekly;
------------------------------------------------------------------------------------------------------------------------------------------
# Day 6
-- 1. Count the number of patients by each service.
SELECT service,
count(patient_id) as total_patient
FROM patients
GROUP BY service;

-- 2. Calculate the average age of patients grouped by service.
SELECT service,
ROUND(AVG(age),2) AS Avg_age
FROM patients
GROUP BY service;

-- 3. Find the total number of staff members per role.
SELECT role,
COUNT(staff_id) as total_staff_members
FROM staff
GROUP BY role;

/* Challenge Question: For each hospital service, calculate the total number of patients admitted, total patients 
refused, and the admission rate (percentage of requests that were admitted). Order by admission rate descending. */

SELECT service,
SUM(patients_admitted) as total_patient,
SUM(patients_refused) as total_patient_refused,
ROUND(SUM(patients_admitted)*100/ SUM(patients_request),2) AS admission_rate
FROM services_weekly
GROUP BY service
ORDER BY admission_rate;
------------------------------------------------------------------------------------------------------------------------------------------
# Day 7
-- 1. Find services that have admitted more than 500 patients in total.
SELECT service,
		SUM(patients_admitted) AS total_patient
 FROM services_weekly
 GROUP BY  service
 HAVING sum(patients_admitted)>500;
 
-- 2. Show services where average patient satisfaction is below 75.
SELECT
		service,
        AVG(patient_satisfaction) AS avg_satisfaction
FROM services_weekly
GROUP BY service
HAVING AVG(patient_satisfaction)<75;

-- 3. List weeks where total staff presence across all services was less than 50.

SELECT 
    week, SUM(present) AS total_staff_present
FROM staff_schedule
GROUP BY week
HAVING SUM(present) < 50;

/*Question: Identify services that refused more than 100 patients in total and had an average patient satisfaction
 below 80. Show service name, total refused, and average satisfaction.*/
 
SELECT 
		service,
        SUM(patients_refused) AS total_patients,
        Round(AVG(patient_satisfaction),2) AS avg_satisfaction
FROM services_weekly
GROUP BY service
HAVING SUM(patients_refused)>100 AND
AVG(patient_satisfaction)<80 ;
------------------------------------------------------------------------------------------------------------------------------------------
# Day 9
-- 1. Extract the year from all patient arrival dates.
SELECT
		patient_id,
		arrival_date,
		YEAR(arrival_date) AS arrival_year
 FROM patients;

 -- or
SELECT 
    patient_id,
    arrival_date,
    EXTRACT(YEAR FROM arrival_date) AS arrival_year
FROM patients;
 
-- 2. Calculate the length of stay for each patient (departure_date - arrival_date).
SELECT 
	patient_id, name,
	DATEDIFF(departure_date, arrival_date) AS stay_length
FROM patients;

-- 3. Find all patients who arrived in a specific month.
SELECT	
	COUNT(patient_id) no_of_patients,
	MONTH(arrival_date) AS month_name
FROM patients
GROUP BY month(arrival_date)
ORDER BY month_name;

/* Question: Calculate the average length of stay (in days) for each service, showing only services where the 
average stay is more than 7 days. Also show the count of patients and order by average stay descending. */

SELECT 
	service,
    COUNT(patient_id) as no_of_patient,
	ROUND(AVG(DATEDIFF(departure_date, arrival_date)),2) AS avg_stay
FROM patients
GROUP BY service
HAVING AVG(DATEDIFF(departure_date, arrival_date))>7;
------------------------------------------------------------------------------------------------------------------------------------------
# Day 10
-- 1. Categorise patients as 'High', 'Medium', or 'Low' satisfaction based on their scores.
SELECT 
     patient_id,name,
CASE WHEN satisfaction >=90 THEN 'High'
	 WHEN satisfaction >=75 THEN 'Medium'
     ELSE 'Low'
END AS satisfaction_category
FROM patients;

-- 2. Label staff roles as 'Medical' or 'Support' based on role type.
SELECT 
	 staff_id, 
     staff_name,
	 CASE WHEN role IN ('doctor', 'nurse') THEN 'Medical'
     ELSE 'Support'
END as role_type		
FROM staff;

-- 3. Create age groups for patients (0-18, 19-40, 41-65, 65+).
SELECT 
patient_id, 
name, age,
CASE WHEN age BETWEEN 0 and 18 THEN 'Pediatric'
	WHEN age BETWEEN 10 AND 40 THEN 'Young_adult'
    WHEN age BETWEEN 41 AND 65 THEN 'Adult'
    ELSE 'Senior'
END AS Age_category
FROM patients;

/* Challenge Question: Create a service performance report showing service name, total patients admitted, and a 
performance category based on the following: 'Excellent' if avg satisfaction >= 85, 'Good' if >= 75, 'Fair' if
 >= 65, otherwise 'Needs Improvement'. Order by average satisfaction descending. */

SELECT 
service,
SUM(patients_admitted) AS Total_patient_admitted,
ROUND(AVG(patient_satisfaction),2) AS Avg_patient_satisfaction,
CASE WHEN AVG(patient_satisfaction)>=85 THEN 'Excellent'
     WHEN AVG(patient_satisfaction)>=75 THEN 'Good'
     WHEN AVG(patient_satisfaction)>=65 THEN 'Fair'
     ELSE 'Needs Improvement'
END as Performance_category
FROM services_weekly
GROUP BY service
ORDER BY AVG(patient_satisfaction) DESC;
------------------------------------------------------------------------------------------------------------------------------------------
# Day 11
-- 1. List all unique services in the patients table.
SELECT DISTINCT service
FROM services_weekly;

-- 2. Find all unique staff roles in the hospital.
SELECT 
DISTINCT role
FROM staff;

-- 3. Get distinct months from the services_weekly table
SELECT
DISTINCT month
FROM services_weekly;

/*Challenge Question: Find all unique combinations of service and event type from the services_weekly table where 
events are not null or none, along with the count of occurrences for each combination. Order by count descending. */

SELECT 
		service, event,
		COUNT(*) AS occurrence
FROM services_weekly
WHERE event is not null and
	  event <> 'none'
GROUP BY service, event
ORDER BY occurrence DESC;
------------------------------------------------------------------------------------------------------------------------------------------
# Day 12
-- 1. Find all weeks in services_weekly where no special event occurred.
SELECT 
	  DISTINCT week
FROM services_weekly
WHERE event = 'none' OR
	  event IS NULL;

-- 2. Count how many records have null or empty event values.
SELECT 
    COUNT(*) AS null_or_empty_events
FROM services_weekly
WHERE event IS NULL 
      OR event = '';

-- 3. List all services that had at least one week with a special event.
SELECT
      DISTINCT service
FROM services_weekly
WHERE event is not null AND
	 event !='none' AND
	 event != '';
     
/* Challlenge Question: Analyze the event impact by comparing weeks with events vs weeks without events.
Show: event status ('With Event' or 'No Event'), count of weeks, average patient satisfaction, and average staff 
morale. Order by average patient satisfaction descending. */     
 
 SELECT 
 CASE WHEN
      event IS NOT NULL AND 
      event!= '' AND
      event != 'none' THEN 'with_event' 
      ELSE 'without_event'
 END AS event_status,
     COUNT(DISTINCT week) AS week_count,
     ROUND(AVG(patient_satisfaction),2) as avg_score,
     ROUND(AVG(staff_morale),2) as avg_staff_morale
 FROM services_weekly
 GROUP BY event_status;
------------------------------------------------------------------------------------------------------------------------------------------

 # Day 13
 -- 1. Join patients and staff based on their common service field (show patient and staff who work in same service).
 SELECT 
       p.name AS Patient_name,
       s.staff_name, 
       p.service
 FROM patients p
 INNER JOIN staff s
 ON p.service =s.service;
 
 -- 2. Join services_weekly with staff to show weekly service data with staff information.
 SELECT *
FROM services_weekly sw
INNER JOIN staff s
ON s.service=sw.service;
 
 -- 3. Create a report showing patient information along with staff assigned to their service.
 SELECT 
       p.*,
	   s.staff_name
 FROM patients p
 INNER 	JOIN staff s
 ON p.service = s.service;
 
 /* Question: Create a comprehensive report showing patient_id, patient name, age, service, and the total number of
 staff members available in their service. Only include patients from services that have more than 5 staff members.
 Order by number of staff descending, then by patient name. */
 SELECT
 p.name AS Patient_name,
 p.age,
 p.service,
 COUNT(s.staff_id) AS no_of_staff
 FROM patients p
 INNER JOIN staff s
 ON p.service = s.service
 GROUP BY p.service,p.name,p.age
 HAVING COUNT(s.staff_id)>5
 ORDER BY no_of_staff DESC,
          patient_name;
------------------------------------------------------------------------------------------------------------------------------------------
# Day 14
 -- 1. Show all staff members and their schedule information (including those with no schedule entries).
 SELECT s.staff_id,
		s.staff_name,
        ss.week,
        ss.role,
        ss.present
        from staff s
	LEFT JOIN staff_schedule ss
 ON s.staff_id =ss.staff_id;
 select * from staff;
 
 -- 2. List all services from services_weekly and their corresponding staff(show services even if no staff assigned).
 SELECT sw.service,
		s.staff_name
FROM services_weekly sw
LEFT JOIN staff s 
ON s.service = sw.service;

-- 3. Display all patients and their service's weekly statistics (if available).
SELECT p.name,
       s.week,
	   s.service,
       s.available_beds,
       s.patient_satisfaction,
       s.patients_admitted,
       s.patients_refused,
       s.patients_request
 FROM patients p 
 LEFT JOIN services_weekly s
 ON	p.service = s.service;
 
 /* Challenge Question: Create a staff utilisation report showing all staff members (staff_id, staff_name, role, 
 service) and the count of weeks they were present (from staff_schedule). Include staff members even if they have no
 schedule records. Order by weeks present descending. */
SELECT 
    s.staff_id,
    s.staff_name,
    s.role,
    s.service,
    COUNT(ss.week) AS weeks_present
FROM staff s
LEFT JOIN staff_schedule ss
    ON s.staff_id = ss.staff_id
    AND ss.present = 1
GROUP BY s.staff_id,s.staff_name,
         s.role, s.service
ORDER BY weeks_present DESC;
-----------------------------------------------------------------------------------------------------------------------------------------
# Day 15
-- 1. Join patients, staff, and staff_schedule to show patient service and staff availability.
SELECT p.patient_id,
		p.name as Patient_name,
        p.service,
        s.staff_name,
        ss.week,
        COUNT(DISTINCT s.staff_id) AS assigned_staff,
        ROUND(AVG(ss.present),2) AS avg_staff_present
 FROM patients p 
 LEFT join staff s ON p.service = s.service
 LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
 GROUP BY  p.patient_id, p.name, p.service,s.staff_name,ss.week;
 
 -- 2. Combine services_weekly with staff and staff_schedule for comprehensive service analysis.
 SELECT sw.service,
		sw.week,
        sw.patients_admitted,
        sw.patients_refused,
        sw.patient_satisfaction
FROM services_weekly sw
JOIN staff s ON sw.service = s.service
JOIN staff_schedule ss ON ss.staff_id = s.staff_id 
                       And ss.week = sw.week;

    
-- 3. Create a multi-table report showing patient admissions with staff information.
SELECT p.patient_id,
	   p.name,
       sw.week,
       sw.patients_admitted,
       s.staff_name
FROM patients p 
LEFT JOIN services_weekly sw ON p.service = sw.service
LEFT JOIN staff s ON p.service = s.service
LEFT JOIN staff_schedule ss ON s.staff_id =ss.staff_id 
And sw.week = ss.week;

/* Challenge Question: Create a comprehensive service analysis report for week 20 showing: service name, total patients 
admitted that week, total patients refused, average patient satisfaction, count of staff assigned to service, and
 count of staff present that week. Order by patients admitted descending. */
SELECT
      sw.service,
      SUM(sw.patients_admitted) AS total_patients_admitted,
      SUM(sw.patients_refused) AS total_patients_refused,
	  ROUND(avg(sw.patient_satisfaction),2) AS avg_patient_satisfaction
FROM services_weekly sw
JOIN staff_schedule ss ON sw.service =ss.service 
                    AND sw.week =ss.week
WHERE sw.week = 20
GROUP BY sw.service
ORDER BY total_patients_admitted DESC;
---------------------------------------------------------------------------------------------------------------------------------------
# Day 16
 -- 1. Find patients who are in services with above-average staff count.
 SELECT * FROM patients
 WHERE service IN(
      SELECT service FROM staff 
       GROUP BY service
 HAVING count(staff_id)>
    (SELECT AVG(service_count) 
FROM(
 SELECT count(staff_id) AS service_count
 FROM staff
  GROUP BY service)t));
  
-- 2. List staff who work in services that had any week with patient satisfaction below 70.
SELECT * FROM staff
WHERE service IN (
   SELECT DISTINCT service
   FROM services_weekly
   WHERE patient_satisfaction<70);
   
-- 3. Show patients from services where total admitted patients exceed 1000.
select *
FROM patients
WHERE service IN(
    SELECT service
    FROM services_weekly 
    GROUP BY service
	HAVING sum(patients_admitted)>1000);
    
/* Question: Find all patients who were admitted to services that had at least one week where patients were refused
 AND the average patient satisfaction for that service was below the overall hospital average satisfaction. Show
 patient_id, name, service, and their personal satisfaction score. */
 SELECT 
    p.patient_id,p.name,
    p.service, p.satisfaction
FROM patients p
WHERE p.service IN (
    SELECT sw.service
    FROM services_weekly sw
    GROUP BY sw.service
    HAVING SUM(sw.patients_refused) > 0
           AND AVG(sw.patient_satisfaction) < (
            SELECT AVG(patient_satisfaction)
            FROM services_weekly ));
---------------------------------------------------------------------------------------------------------------------------------------
# Day 17
-- 1. Show each patient with their service's average satisfaction as an additional column.
SELECT patient_id,
name,service, satisfaction,
(SELECT ROUND(AVG(satisfaction),2)
FROM patients p1 WHERE p1.service = p.service ) AS Avg_satisfaction
FROM patients p;
-- OR -- using window function
SELECT 
    patient_id,
    name,
    service,
    satisfaction,
    ROUND(AVG(satisfaction) OVER (PARTITION BY service), 2) 
        AS avg_service_satisfaction
FROM patients;

-- 2. Create a derived table of service statistics and query from it.
SELECT * 
FROM (
SELECT 
      service,
     SUM(patients_request) AS Total_patients_request,
     SUM(patients_admitted) AS Total_patients_admitted,
     SUM(patients_refused) AS Total_patients_refused,
     ROUND(AVG(patient_satisfaction),2) AS Avg_satisfaction
FROM services_weekly
GROUP BY service) AS service_stats
WHERE Total_patients_request>1000;

-- 3. Display staff with their service's total patient count as a calculated field.
SELECT * from staff;
Select * from patients;
	SELECT staff_id, staff_name,
	service, role,
	(SELECT COUNT(DISTINCT patient_id)
	FROM patients p
	WHERE p.service = s.service ) AS total_patients
	FROM staff s;
    
/* Question: Create a report showing each service with: service name, total patients admitted, the difference between
 their total admissions and the average admissions across all services, and a rank indicator ('Above Average',
 'Average', 'Below Average'). Order by total patients admitted descending. */
SELECT s.service,
s.Total_admitted,
a.Avg_Patient_admitted,
s.Total_admitted - a.Avg_Patient_admitted AS differnce,
CASE WHEN Total_admitted> Avg_Patient_admitted THEN 'Above Average'
     WHEN Total_admitted = Avg_Patient_admitted THEN 'Average'
     ELSE 'Below Average'
END AS Rank_indicator
FROM(
SELECT service,
       SUM(patients_admitted) AS Total_admitted
FROM services_weekly
GROUP BY service) s
CROSS JOIN
(SELECT	 ROUND(AVG(total_admitted),2) AS Avg_Patient_admitted  FROM
     (SELECT SUM(patients_admitted) AS total_admitted FROM services_weekly GROUP BY service)
AS x ) a
ORDER BY s.Total_admitted DESC ;
-------------------------------------------------------------------------------------------------------------------------------------------
# Day 18
-- 1. Combine patient names and staff names into a single list.
SELECT name AS full_name, 
       'patient' AS type
FROM patients
UNION ALL
SELECT staff_name, 
       'staff' AS type
FROM staff;

-- 2. Create a union of high satisfaction patients (>90) and low satisfaction patients (<50).
SELECT satisfaction,
       'High Satisfaction' AS Level
FROM patients
WHERE satisfaction>90
UNION ALL
SELECT satisfaction,
       'Low Satisfaction' AS Level
FROM patients
WHERE satisfaction<50;

-- 3. List all unique names from both patients and staff tables.
SELECT name AS full_name
FROM patients
UNION 
SELECT staff_name
FROM staff;

/* Question: Create a comprehensive personnel and patient list showing: identifier (patient_id or staff_id), 
full name, type ('Patient' or 'Staff'), and associated service. Include only those in 'surgery' or 'emergency'
 services. Order by type, then service, then name. */

select * from(
SELECT patient_id AS Identifier,
	   name AS full_name, 
       'Patient' AS Type,
        service
FROM patients
UNION ALL
SELECT staff_id AS Identifier,
       staff_name AS full_name, 
       'Staff' AS Type,
        service
FROM staff) a
ORDER BY Type, service, full_name;

-------------------------------------------------------------------------------------------------------------------
# Day 19
-- 1. Rank patients by satisfaction score within each service.
SELECT 
     patient_id,
     name,
     service,
     satisfaction,
DENSE_RANK() OVER(PARTITION BY service ORDER BY satisfaction DESC) AS rn
FROM patients
ORDER BY service,rn;

-- 2. Assign row numbers to staff ordered by their name.
SELECT 
     ROW_NUMBER() OVER(ORDER BY staff_name) AS Rn,
     staff_name
FROM staff;

-- 3. Rank services by total patients admitted.
SELECT
      service,
      SUM(patients_admitted) AS Total_patient_admitted,
	  RANK() OVER(ORDER BY SUM(patients_admitted) DESC) AS rnk
FROM services_weekly
GROUP BY service;

/* Question: For each service, rank the weeks by patient satisfaction score (highest first). Show service, week,
 patient_satisfaction, patients_admitted, and the rank. Include only the top 3 weeks per service.*/

SELECT * FROM(
  SELECT 
       service,
       week,
       SUM(patient_satisfaction) AS patient_satisfaction_score,
       SUM(patients_admitted) AS Total_patient_admitted,
       DENSE_RANK() OVER(ORDER BY SUM(patient_satisfaction) DESC) AS Rnk
FROM services_weekly
GROUP BY service, week
ORDER BY Rnk) a
WHERE Rnk <=3;
----------------------------------------------------------------------------------------------------------------------------------------------
# Day 20
-- 1. Calculate running total of patients admitted by week for each service.
# for each service there is one week ie 1 row - no need of sum(patient_admitted) or group by 
SELECT 
     service,
     week,
     patients_admitted,
SUM(patients_admitted) OVER(PARTITION BY service ORDER BY week) AS patient_admitted
FROM services_weekly;

-- 2. Find the moving average of patient satisfaction over 4-week periods.
SELECT
week,
service,
patient_satisfaction,
ROUND(AVG(patient_satisfaction) OVER( ORDER BY week ROWS BETWEEN 3 PRECEDING AND CURRENT ROW),2)
      AS 4_week_moving_avg
FROM services_weekly;

-- 3. Show cumulative patient refusals by week across all services.
# Here across all services mean there are multiple service for 1 week so first group by week then find cumlative
SELECT
week,
sum(patients_refused),
SUM(SUM(patients_refused)) OVER(ORDER BY week ) AS Cum_patient_refusal
FROM services_weekly
GROUP BY week;

/* Challenge Question: Create a trend analysis showing for each service and week: week number, patients_admitted,
running total of patients admitted (cumulative), 3-week moving average of patient satisfaction (current week and
 2 prior weeks), and the difference between current week admissions and the service average. Filter for weeks 10-20 
 only. */
 Select * from(
 SELECT 
 week,
 sum(patients_admitted),
 SUM(sum(patients_admitted)) OVER( ORDER BY week),
 AVG(SUM(patient_satisfaction)) OVER(ORDER BY week ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),
 sum(patients_admitted)- AVG(SUM(patient_satisfaction)) OVER( ORDER BY week)
 FROM services_weekly
 GROUP BY week) a
 where week between 10 and 20;
 
 SELECT *
FROM (
    SELECT 
        service,
        week,
        SUM(patients_admitted) AS patients_admitted,
        ROUND(AVG(patient_satisfaction),2) AS avg_satisfaction,
        SUM(SUM(patients_admitted)) OVER(PARTITION BY service ORDER BY week) AS running_total, 
        
        ROUND(AVG(AVG(patient_satisfaction)) OVER(PARTITION BY service ORDER BY week
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_avg_satisfaction,
            
        SUM(patients_admitted) -
        ROUND(AVG(SUM(patients_admitted)) OVER(PARTITION BY service),2) AS diff_from_service_avg
   FROM services_weekly
   GROUP BY service, week
) a
WHERE week BETWEEN 10 AND 20
ORDER BY service, week;


 
 
 
 
  
 
 
 
 
 
 
