CREATE TABLE Redanta_Hospital
(
    Patient_ID INT PRIMARY KEY,
    Admit_Date DATE,
    Discharge_Date DATE,
    Diagnosis VARCHAR(140),
    Bed_Occupancy VARCHAR(100),
    Test VARCHAR(100),
    Doctor VARCHAR(140),
    Followup_Date DATE,
    Feedback NUMERIC,
    Billing_Amount NUMERIC,
    Health_Insurance_Amount INT
);
copy 
Redanta_Hospital(Patient_ID,Admit_Date,Discharge_Date,Diagnosis,Bed_Occupancy,Test,Doctor, Followup_Date,Feedback,Billing_Amount,Health_Insurance_Amount)
from 'D:\all file\DataAnalysis\powerBi\HospitalProjectBi/Redanta_Hospital.csv'
delimiter ','
header csv;

select * from Redanta_Hospital;

--A. Hospital & Patient Overview
--Q1--Find the total number of patients and total hospital revenue.
select count(distinct patient_id) as num_of_paient,sum(billing_amount)as hospital_revenue
from Redanta_Hospital;

--Q2--Find the number of patients admitted on each date.
select admit_date,count(distinct patient_id) 
from Redanta_Hospital
group by admit_date;

--Q3--Find the number of patients discharged on each date.
select discharge_date,count(discharge_date ) 
from Redanta_Hospital
group by discharge_date
order by discharge_date;

--Q4--Find the average length of stay for all patients.
select round(avg(discharge_date-admit_date),2)as avg_stay_duration
from Redanta_Hospital;

--Q5--Find the maximum and minimum length of stay.
select max(discharge_date-admit_date)as maximum_day_stay,min(discharge_date-admit_date)as min_day_stay
from Redanta_Hospital;

--Q6--Find the top 10 patients with the longest hospital stay.
select patient_id,discharge_date,admit_date,(discharge_date-admit_date)as longest_hospital_stay 
from Redanta_Hospital
group by patient_id
order by longest_hospital_stay desc limit 10 ;

--Q7--Find patients whose length of stay is greater than the overall average.
select patient_id,discharge_date,admit_date,(discharge_date-admit_date)as longest_hospital_stay 
from Redanta_Hospital
where (discharge_date-admit_date)>(select avg(discharge_date-admit_date) from Redanta_Hospital)
order by longest_hospital_stay desc ;


--Q8--Find the monthly admission count.
select to_char(admit_date,'Month yyyy')as Admission_Month, count( admit_date)as No_of_Patient_admited
from Redanta_Hospital
group by to_char(admit_date,'Month yyyy')
order by min(admit_date);

--Q9--Find the month with the highest number of admissions.
select to_char(admit_date,'Month yyyy')as admission_Month, count(admit_date)as No_of_Patient_admited
from Redanta_Hospital
group by to_char(admit_date,'Month yyyy')
order by No_of_Patient_admited desc limit 1 ;

--Q10--Find the average length of stay for each month.
select to_char(admit_date,'Month yyyy')as month_name, round(avg(discharge_date-admit_date),2)as avg_stay
from Redanta_Hospital 
group by to_char(admit_date,'Month yyyy'),extract(month from admit_date)
order by extract(month from admit_date) asc;

---Diagnosis Analysis--------------------------

--Q11--Find the number of patients for each diagnosis.
select diagnosis,count(distinct patient_id)as number_of_patient
from Redanta_Hospital
group by diagnosis 
order by number_of_patient desc;

--Q12--Find the top 5 most common diagnoses.
select diagnosis,count( patient_id)as number_of_patient
from Redanta_Hospital
group by diagnosis 
order by number_of_patient desc limit 5;

--Q13--Find the diagnosis with the highest total billing amount.
select diagnosis, sum(billing_amount)as Total_billing_amount
from Redanta_Hospital
group by diagnosis 
order by Total_billing_amount desc limit 1;

--Q14--Calculate the average billing amount for each diagnosis.
select diagnosis, round(avg(billing_amount),2)as avg_billing_amount
from Redanta_Hospital
group by diagnosis 
order by avg_billing_amount desc ;

--Q15--Find diagnoses whose average billing amount is greater than the overall average.
select diagnosis, round(avg(billing_amount),2)as avg_billing_amount
from Redanta_Hospital
group by diagnosis 
having round(avg(billing_amount),2)> (select avg(billing_amount) from Redanta_Hospital);


--Q16--Find the diagnosis with the highest average length of stay.
select diagnosis,round(avg(discharge_date-admit_date),2)as avg_stay_length 
from Redanta_Hospital
group by diagnosis;

--Q17--Find the top 5 diagnoses based on total revenue.
select diagnosis,sum(billing_amount)as total_revenue from Redanta_Hospital
group by diagnosis
order by total_revenue desc limit 5;

--Q18--Find the percentage of patients belonging to each diagnosis.
select diagnosis, round(count(*)*100.0/(select count(*) from Redanta_Hospital),2) as percent_of_patients
from Redanta_hospital
group by diagnosis
order by percent_of_patients;

----2nd__Method--------------
with diagnosis_patient as(
select diagnosis,count(*)as patient_count
from Redanta_Hospital
group by diagnosis)
select diagnosis,patient_count,
round(patient_count*100/(select sum(patient_count) from diagnosis_patient),2) as percent_of_patient
from diagnosis_patient
order by percent_of_patient;

-----Doctor Performance-------------------

--Q19--Find the number of patients handled by each doctor.
select doctor,count(*)as num_of_patient from Redanta_Hospital
group by doctor
order by num_of_patient desc;

--Q20--Find the top 5 doctors based on the number of patients handled.
select doctor,count(patient_id)as num_of_patient from Redanta_Hospital
group by doctor
order by num_of_patient desc limit 5;

--Q21--Calculate total billing amount generated by each doctor.
select doctor,sum(billing_amount)as amount_generate_doctor from Redanta_Hospital
group by doctor
order by amount_generate_doctor desc;

--Q22--Find the top 5 doctors based on total billing amount.
select doctor,sum(billing_amount)as amount_generate_doctor from Redanta_Hospital
group by doctor
order by amount_generate_doctor desc limit 5;

--Q23--Calculate the average billing amount for each doctor.
select doctor,round(avg(billing_amount),2)as avg_bill_generate_doctor from Redanta_Hospital
group by doctor
order by avg_bill_generate_doctor desc;

--Q24--Find doctors whose average billing amount is greater than the overall average.
select doctor,round(avg(billing_amount),2)as avg_bill_generate_perdoctor 
from Redanta_Hospital
group by doctor
having round(avg(billing_amount),2)>(select avg(billing_amount) from Redanta_Hospital);

--Q25--Rank doctors according to their total billing amount.
select doctor,sum(billing_amount)as revenue,row_number() over(order by sum(billing_amount) desc )
from Redanta_Hospital
group by doctor;

------Bed Occupancy Analysis-------
select * from Redanta_Hospital;
--Q26--Find the number of patients in each bed-occupancy category.
select bed_occupancy,count(*)as num_of_patient from Redanta_Hospital
group by bed_occupancy
order by num_of_patient desc;

--Q27--Calculate total billing amount for each bed-occupancy category.
select bed_occupancy,sum(billing_amount)as billing_amount from Redanta_Hospital
group by bed_occupancy
order by billing_amount desc;

--Q28--Calculate average billing amount for each bed-occupancy category.
select bed_occupancy,round(avg(billing_amount),2)as avg_billing_amount from Redanta_Hospital
group by bed_occupancy
order by avg_billing_amount desc;

--Q29--Find the bed-occupancy category generating the highest revenue.
select bed_occupancy,sum(billing_amount)as billing_amount from Redanta_Hospital
group by bed_occupancy
order by billing_amount desc limit 1;

--Q30--Find the diagnosis with the highest number of ICU/Private/General occupancy records.
select bed_occupancy,diagnosis,count(bed_occupancy) as occupancy from Redanta_Hospital
group by diagnosis ,bed_occupancy
order by occupancy desc limit 1;


----------Billing & Insurance Analysis
select * from Redanta_Hospital
order by billing_amount desc ;
--Q31--Calculate the total billing amount.
select sum(billing_amount) from Redanta_Hospital;

--Q32--Calculate the total health insurance amount.
select sum(health_insurance_amount) from Redanta_Hospital;

--Q33--Calculate the average billing amount.
select round(avg(billing_amount),2) as avg_billing_amount from Redanta_Hospital;

--Q34--Calculate the average health insurance amount.
select round(avg(health_insurance_amount),2)as avg_insurance_amount from Redanta_Hospital;

--Q35--Calculate the difference between billing amount and health insurance amount for each patient.
select patient_id,billing_amount,health_insurance_amount,
(billing_amount-health_insurance_amount)as difference from Redanta_Hospital
group by patient_id
order by difference desc;

--Q36--Find patients where the health insurance amount is greater than the billing amount.
select patient_id,billing_amount,health_insurance_amount from Redanta_Hospital
where health_insurance_amount>billing_amount
group by patient_id ;

--Q37--Find the top 10 patients based on billing amount.
select patient_id,sum(billing_amount)as billing_amount from Redanta_Hospital
group by patient_id
order by billing_amount desc  limit 10;

--Q38--Calculate the percentage of billing covered by health insurance.
select patient_id,billing_amount,health_insurance_amount, round(sum(health_insurance_amount*100.0/billing_amount ),2) as percentage 
from Redanta_Hospital
group by patient_id 
order by billing_amount desc;

--Q39--Find doctors generating more revenue than the average doctor revenue.
with avg_doctor_revenue as(
select doctor,sum(billing_amount)as doct_revenue from Redanta_Hospital
group by doctor)
select * from avg_doctor_revenue
where doct_revenue>(select avg(doct_revenue) from avg_doctor_revenue);

--Q40--Create a monthly revenue report showing month, number of patients, total billing amount, 
--total insurance amount, and average billing amount.
select to_char(admit_date ,'Month YYYY')as month_name, count(patient_id)as num_of_patient,
sum(billing_amount)as billing_amount,sum(health_insurance_amount)as Insurance, 
round(avg(billing_amount),2)as avg_billing_amount
from Redanta_Hospital
group by to_char(admit_date ,'Month YYYY')
order by min(admit_date);