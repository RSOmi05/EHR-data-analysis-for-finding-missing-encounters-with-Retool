SELECT
  TRIM(cpt_code) AS individual_cpt_code,
  COUNT(*) AS total_counts
FROM
  (
    SELECT
      UNNEST (
        STRING_TO_ARRAY (
          REGEXP_REPLACE (cpt_codes, '[{}"\s]', '', 'g'),
          ','
        )
      ) AS cpt_code
    FROM
      missing_encounters_data
  ) AS sub
WHERE
  cpt_code IS NOT NULL
GROUP BY
  individual_cpt_code
ORDER BY
  total_counts DESC;