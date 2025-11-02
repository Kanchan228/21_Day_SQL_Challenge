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

---------------------------------
# Day-2
-- 1. Find patient who are older than 60 years
select patient_id, name, age
 from patients
 where age >60;
 
 -- 2. Retrieve all staff members who work in the 'Emergency' service.
 select * from staff
 where service = 'Emergency';
 
 -- 3. List all weeks where more than 100 patients requested admission in any service.
 select week, 
 sum(patients_admitted) as patient_num
 from services_weekly
 GROUP BY week
 having sum(patients_admitted)>100 ;
 