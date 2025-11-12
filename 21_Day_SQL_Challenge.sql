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
