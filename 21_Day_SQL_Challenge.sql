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
