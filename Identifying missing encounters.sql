SELECT
  e.patient_name,
  e.date_of_service,
  e.provider_name AS "Rendering Provider",
  COALESCE(STRING_AGG(DISTINCT ehr_full.cpt_code, ', ' ORDER BY ehr_full.cpt_code), 'N/A') AS "CPT Codes"
FROM (
  SELECT DISTINCT
    TRIM(LOWER(patient_name)) AS patient_name,
    TO_CHAR(date_of_service, 'YYYY-MM-DD') AS date_of_service,
    TRIM(LOWER(provider_name)) AS provider_name
  FROM ops_case_study_dataset_sample_ehr_data
) e
LEFT JOIN (
  SELECT DISTINCT
    TRIM(LOWER(patient_name)) AS patient_name,
    TO_CHAR(from_date_range, 'YYYY-MM-DD') AS date_of_service,
    TRIM(LOWER(provider_name)) AS provider_name
  FROM ops_case_study_dataset_sample_db_data
) i ON e.patient_name = i.patient_name
    AND e.date_of_service = i.date_of_service
    AND e.provider_name = i.provider_name
JOIN ops_case_study_dataset_sample_ehr_data ehr_full
  ON TRIM(LOWER(ehr_full.patient_name)) = e.patient_name
    AND TO_CHAR(ehr_full.date_of_service, 'YYYY-MM-DD') = e.date_of_service
    AND TRIM(LOWER(ehr_full.provider_name)) = e.provider_name
WHERE i.patient_name IS NULL
   OR i.provider_name IS NULL
   OR i.date_of_service IS NULL
GROUP BY e.patient_name, e.provider_name, e.date_of_service
ORDER BY e.patient_name, e.provider_name, e.date_of_service;
