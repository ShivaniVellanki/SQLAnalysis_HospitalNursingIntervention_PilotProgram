use Hospital;

/* Identify which hospitals have an Intensive Care Unit (ICU bed_id = 4) bed or a Surgical Intensive Care Unit 
(SICU bed_id = 15) bed or both. */

-- select count(*) from business;

-- select * from bed_fact;

-- select * from bed_type;

/* Identify which hospitals have an Intensive Care Unit (ICU bed_id = 4) bed or a 
Surgical Intensive Care Unit (SICU bed_id = 15) bed or both. */

SELECT count(DISTINCT(b.business_name))
FROM bed_fact bf
INNER JOIN business b
ON bf.ims_org_id = b.ims_org_id
WHERE bf.bed_id = 4 OR bf.bed_id = 15;

/* License beds: List of Top 10 Hospitals ordered descending by the total ICU or SICU license beds.
Include just two variables, hospital_name (business_name) and the total license beds */

SELECT b.business_name, sum(bf.license_beds) as total_license_beds
FROM bed_fact bf
INNER JOIN business b
ON bf.ims_org_id = b.ims_org_id
WHERE bed_id IN(4,15)
GROUP BY b.business_name
ORDER BY total_license_beds DESC
LIMIT 10;

/* List of Top 10 Hospitals ordered by total icu or sicu census beds. Include just two variables, hospital_name 
(business_name) and the total census beds from above as one summary fact. Include only 10 rows again. */

SELECT b.business_name,sum(bf.census_beds) AS total_census_beds 
FROM bed_fact bf
INNER JOIN business b
ON bf.ims_org_id = b.ims_org_id
WHERE bed_id IN (4,15)
GROUP BY b.business_name
ORDER BY total_census_beds DESC
LIMIT 10;

/* List of Top 10 Hospitals ordered by the total icu or sicu staffed beds. Include just two variables, hospital_name 
(business_name) and the sum of staffed beds from above as one summary fact. Include only 10 rows again.*/

SELECT business_name, sum(bf.staffed_beds) AS total_staffed_beds
FROM bed_fact bf
INNER JOIN business b
ON bf.ims_org_id = b.ims_org_id
WHERE bed_id IN (4,15)
GROUP BY b.business_name
ORDER BY total_staffed_beds DESC
LIMIT 10;

/* Hospitals that have sufficient volume of both ICU and SICU LICENSE beds. only hospitals 
that have at least 1 ICU bed and at least 1 SICU bed */

SELECT b.business_name,
       (
           SELECT SUM(license_beds) 
           FROM bed_fact 
           WHERE ims_org_id = b.ims_org_id AND bed_id IN (4, 15)
       ) AS total_license_beds /* retrieving the name of each business along with the total number of 
       licensed ICU and SICU beds, using a related subquery to sum the beds for each business */
FROM business b
WHERE EXISTS (
    SELECT * 
    FROM bed_fact bf 
    WHERE bf.ims_org_id = b.ims_org_id AND bf.bed_id = 4 /* WHERE EXISTS clause checking for the existence of at 
    least one ICU bed (with bed_id = 4) in the bed_fact table for each business in the business table, 
    making sure that only businesses with ICU beds are included in the final result */
) AND EXISTS (
    SELECT * 
    FROM bed_fact bf 
    WHERE bf.ims_org_id = b.ims_org_id AND bf.bed_id = 15 /* filtering the query to consider only those businesses
    that have both ICU and SICU beds. */
)
ORDER BY total_license_beds DESC
LIMIT 10;

/* Hospitals that have sufficient volume of both ICU and SICU CENSUS beds. only hospitals 
that have at least 1 ICU bed and at least 1 SICU bed */

SELECT b.business_name,
       (
           SELECT SUM(census_beds) 
           FROM bed_fact 
           WHERE ims_org_id = b.ims_org_id AND bed_id IN (4, 15)
       ) AS total_census_beds /* retrieving the name of each business along with the total number of 
       census ICU and SICU beds, using a related subquery to sum the beds for each business */
FROM business b
WHERE EXISTS (
    SELECT * 
    FROM bed_fact bf 
    WHERE bf.ims_org_id = b.ims_org_id AND bf.bed_id = 4 /* WHERE EXISTS clause checking for the existence of at 
    least one ICU bed (with bed_id = 4) in the bed_fact table for each business in the business table, 
    making sure that only businesses with ICU beds are included in the final result */
) AND EXISTS (
    SELECT * 
    FROM bed_fact bf 
    WHERE bf.ims_org_id = b.ims_org_id AND bf.bed_id = 15 /* filtering the query to consider only those businesses
    that have both ICU and SICU beds. */
)
ORDER BY total_census_beds DESC
LIMIT 10;

/* Hospitals that have sufficient volume of both ICU and SICU STAFFED beds. only hospitals 
that have at least 1 ICU bed and at least 1 SICU bed */

SELECT b.business_name,
       (
           SELECT SUM(staffed_beds) 
           FROM bed_fact 
           WHERE ims_org_id = b.ims_org_id AND bed_id IN (4, 15)
       ) AS total_staffed_beds /* retrieving the name of each business along with the total number of 
       staffed ICU and SICU beds, using a related subquery to sum the beds for each business */
FROM business b
WHERE EXISTS (
    SELECT * 
    FROM bed_fact bf 
    WHERE bf.ims_org_id = b.ims_org_id AND bf.bed_id = 4 /* WHERE EXISTS clause checking for the existence of at 
    least one ICU bed (with bed_id = 4) in the bed_fact table for each business in the business table, 
    making sure that only businesses with ICU beds are included in the final result */
) AND EXISTS (
    SELECT * 
    FROM bed_fact bf 
    WHERE bf.ims_org_id = b.ims_org_id AND bf.bed_id = 15 /* filtering the query to consider only those businesses
    that have both ICU and SICU beds. */
)
ORDER BY total_staffed_beds DESC
LIMIT 10;














