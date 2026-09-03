USE Healthcare_Analytics_DB;

-- =================================================================
-- Q1: List first 10 patients from 'Bengaluru'
-- =================================================================
SELECT 
    patient_id, 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    city, 
    blood_group
FROM patients
WHERE city = 'Bengaluru'
LIMIT 10;


-- =================================================================
-- Q2: Active doctors with > 10 years experience
-- =================================================================
SELECT 
    doctor_id, 
    CONCAT(first_name, ' ', last_name) AS doctor_name, 
    experience_years, 
    status
FROM doctors
WHERE status = 'Active' 
  AND experience_years > 10;


-- =================================================================
-- Q3: Total number of patients treated by each doctor
-- =================================================================
SELECT 
    d.doctor_id, 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, 
    COUNT(p.patient_id) AS patient_count
FROM doctors d
LEFT JOIN patients p 
    ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;


-- =================================================================
-- Q4: Count of 'Paid' bills and total net_amount per payment mode
-- =================================================================
SELECT 
    payment_mode,
    COUNT(bill_id) AS total_paid_bills,
    SUM(net_amount) AS total_net_amount
FROM bills
WHERE payment_status = 'Paid'
GROUP BY payment_mode;


-- =================================================================
-- Q5: Top 5 departments with highest revenue from paid bills
-- =================================================================
SELECT 
    dp.department_id, 
    dp.department_name, 
    SUM(b.net_amount) AS total_revenue
FROM bills b
JOIN doctors d 
    ON b.doctor_id = d.doctor_id
JOIN departments dp 
    ON d.department_id = dp.department_id
WHERE b.payment_status = 'Paid'
GROUP BY dp.department_id, dp.department_name
ORDER BY total_revenue DESC
LIMIT 5;


-- =================================================================
-- Q6: Create View "vw_doctor_revenue" & Query Doctors with Revenue > ₹1000
-- =================================================================
-- Step 6A: Create View
CREATE OR REPLACE VIEW vw_doctor_revenue AS
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_full_name,
    SUM(b.net_amount) AS total_revenue
FROM bills b
JOIN doctors d 
    ON b.doctor_id = d.doctor_id
WHERE b.payment_status = 'Paid'
GROUP BY d.doctor_id, d.first_name, d.last_name;

-- Step 6B: Select Doctors exceeding ₹1000 threshold
SELECT 
    doctor_id,
    doctor_full_name,
    total_revenue
FROM vw_doctor_revenue
WHERE total_revenue > 1000;


-- =================================================================
-- Q7: Top 5 patients who paid the highest total amount
-- =================================================================
SELECT 
    p.patient_id, 
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name, 
    SUM(b.net_amount) AS total_amount_paid
FROM patients p
JOIN bills b 
    ON p.patient_id = b.patient_id
WHERE b.payment_status = 'Paid'
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY total_amount_paid DESC
LIMIT 5;


-- =================================================================
-- Q8: Medications prescribed by doctors in 'ology' departments
-- =================================================================
SELECT 
    m.medication_id, 
    m.generic_name, 
    m.brand_name, 
    m.dosage, 
    d.doctor_id, 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, 
    dp.department_name
FROM medications m
JOIN doctors d 
    ON m.doctor_id = d.doctor_id
JOIN departments dp 
    ON d.department_id = dp.department_id
WHERE dp.department_name LIKE '%ology%';


-- =================================================================
-- Q9: Top 3 earning patients per city using Window Function & Subquery
-- =================================================================
SELECT 
    city,
    patient_name,
    total_paid,
    rank_in_city
FROM (
    SELECT 
        p.city,
        CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
        SUM(b.net_amount) AS total_paid,
        DENSE_RANK() OVER (
            PARTITION BY p.city 
            ORDER BY SUM(b.net_amount) DESC
        ) AS rank_in_city
    FROM patients p
    JOIN bills b 
        ON p.patient_id = b.patient_id
    WHERE b.payment_status = 'Paid'
    GROUP BY p.city, p.patient_id, p.first_name, p.last_name
) AS ranked_patients
WHERE rank_in_city <= 3
ORDER BY city, rank_in_city;


-- =================================================================
-- Q10: Update 5% discount for Pending bills (Check, Preview, Update, Verify)
-- =================================================================
-- Step 1: Check count
SELECT COUNT(bill_id) AS pending_bills_count
FROM bills
WHERE payment_status = 'Pending';

-- Step 2: Preview rows
SELECT bill_id, net_amount, discount, payment_status
FROM bills
WHERE payment_status = 'Pending'
LIMIT 5;

-- Step 3: Apply 5% discount increase
SET SQL_SAFE_UPDATES = 0;

UPDATE bills
SET discount = COALESCE(discount, 0) * 1.05
WHERE payment_status = 'Pending';

SET SQL_SAFE_UPDATES = 1;

-- Step 4: Verify update
SELECT bill_id, net_amount, discount, payment_status
FROM bills
WHERE payment_status = 'Pending'
LIMIT 5;


-- =================================================================
-- Q11: CTE & Trigger
-- =================================================================
-- Part A: CTE for doctors with > 8 appointments
WITH DoctorAppointments AS (
    SELECT 
        d.doctor_id,
        CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
        COUNT(a.appointment_id) AS appointment_count
    FROM doctors d
    JOIN appointments a 
        ON d.doctor_id = a.doctor_id
    GROUP BY d.doctor_id, d.first_name, d.last_name
)
SELECT 
    doctor_id,
    doctor_name,
    appointment_count
FROM DoctorAppointments
WHERE appointment_count > 8
ORDER BY appointment_count DESC;

-- Part B: Trigger for 10% auto-discount on NULL inserts
DELIMITER //

CREATE TRIGGER trg_update_discount
BEFORE INSERT ON bills
FOR EACH ROW
BEGIN
    IF NEW.discount IS NULL THEN
        SET NEW.discount = NEW.net_amount * 0.10;
    END IF;
END //

DELIMITER ;


-- =================================================================
-- Q12: DDL Task - Database & Schema Setup
-- =================================================================
-- Step 1: Create and use Database
CREATE DATABASE IF NOT EXISTS Hospital_Training_DB;
USE Hospital_Training_DB;

-- Step 2: Create test_doctors table
CREATE TABLE test_doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100),
    experience_years INT
);

-- Step 3: Create test_patients table
CREATE TABLE test_patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    doctor_id INT,
    city VARCHAR(100),
    FOREIGN KEY (doctor_id) REFERENCES test_doctors(doctor_id)
);

-- Step 4: Insert sample records
INSERT INTO test_doctors (first_name, last_name, specialization, experience_years) 
VALUES 
    ('Rajesh', 'Sharma', 'Cardiology', 12),
    ('Priya', 'Nair', 'Neurology', 8);

INSERT INTO test_patients (first_name, last_name, doctor_id, city) 
VALUES 
    ('Amit', 'Patel', 1, 'Mumbai'),
    ('Sneha', 'Rao', 2, 'Bengaluru');

-- Step 5: Verify relationship via JOIN
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.city,
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS assigned_doctor,
    d.specialization
FROM test_patients p
JOIN test_doctors d 
    ON p.doctor_id = d.doctor_id;