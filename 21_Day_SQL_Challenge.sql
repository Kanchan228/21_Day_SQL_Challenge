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
 
