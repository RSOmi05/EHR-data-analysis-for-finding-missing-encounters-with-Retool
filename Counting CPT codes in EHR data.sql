SELECT
  TRIM(REPLACE(cpt_code, '"', '')) AS individual_cpt_code,
  COUNT(*) AS total_counts
FROM (
  SELECT
    UNNEST(
      STRING_TO_ARRAY(
        REPLACE(REPLACE("cpt_code", '"', ''), ' ', ''),
        ','
      )
    ) AS cpt_code
  FROM ops_case_study_dataset_sample_ehr_data
  WHERE "cpt_code" IS NOT NULL AND "cpt_code" != ''
) AS sub
WHERE TRIM(cpt_code) != ''
GROUP BY TRIM(REPLACE(cpt_code, '"', ''))
ORDER BY total_counts DESC;
