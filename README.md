# Finding missing encounters with Retool #

Two datasets have been provided in CSV format:
1) Closed Encounters from the Clientʼs EHR: A list of encounters that have been closed in the client's electronic health record EHR.
2) Imported Closed Encounters: A list of closed encounters that have been successfully imported into Normandy.
Each dataset contains information about Patient Name, Date of Service, and Rendering Provider, which together form a unique id for an encounter, alongside procedure-level details.
Some encounters in the clientʼs EHR may not be present in our database, and your task is to identify these missing encounters and come to a conclusion as to why the encounters werenʼt imported.

**Instructions:**

**Task 1: Identifying Missing Encounters**
	Compare the two datasets and identify which encounters from the Client EHR Closed Encounters file are not found in the Imported Closed Encounters file.
	Provide a list of these missing encounters in the form of the unique ID mentioned above Patient Name, Date of Service, and Rendering Provider)

**Task 2: Investigating the Cause**
	Analyze the missing encounters and identify any patterns or reasons why they might not have been imported into the database.
	Summarize your findings and explain why certain encounters were not imported.
		Go deep, simply finding counts is not enough.


## Investigating potential patterns behind the missing encounters not being imported into the database ##


**Analysis 1: Unrecognized or Invalid CPT Codes**

Some CPT codes found in the missing encounters do not appear in the imported data, suggesting they may not be supported or whitelisted by the Normandy system. For example, the CPT code NORCM appears 203 times in the missing data but not at all in the imported dataset.
Except for some encounters (~19–20) with having CPT code of G0283, all other cpt codes that are not numeric (alphabetic or alphanumeric) were not imported according to my findings (Check in table 6).

**Analysis 2: CPT Code Format and Standardization Issues**

Many of the missing records contain CPT codes with special characters or lowercase/uppercase inconsistencies (e.g., sp120, SP$110, SP, TOS etc.). Assumably, the imported data uses standardized numeric CPT codes, while the missing dataset includes alphanumeric or malformed codes. This implies a data validation failure due to case sensitivity, invalid symbols ($, letters), or lack of normalization.

**Analysis 3: Missing records with five unique patients**

From my analysis, I found 5 unique patients’ records that were not imported as follows:
Ethan Lopez (27 records in EHR data),
Isabella Thomas (29 records in EHR data),
Layla Miller (24 records in EHR data),
Mateo Thomas (16 records in EHR data),
Sebastian Jones (3 records in EHR data)
Not a single record of these 5 patients was imported into Normandy (Due to inconsistent formatting, a mismatch in the string format during join/matching or even trimming issues).

**Analysis 4: Uncommon Combinations of CPT Codes**

Some bundles of CPT codes in missing encounters are unusual or not commonly used together based on the frequency of CPT combinations in the imported data. For example, Code 97113 appears frequently in missing records, but is much less common in imported data. Maybe, records with combinations like 97113, NORCM do not appear in imported records at all since they may have been flagged or filtered out due to non-standard service bundling or internal business rules.

**Analysis 5: Bulk Data Processing Failures (Dates & Volume)**

A pattern in the Date of Service for many missing records shows clustering around specific dates (e.g., August–September 2024). Many missing encounters occur between August 25 – September 10, 2024, which may suggest a failed batch import job or ETL job cutoff window during those dates.

**Analysis 6: High Concentration of Missing Records from Certain Providers**

Specific providers (e.g., Aiden King, Liam Young) appear frequently in the missing data, suggesting a provider-specific import issue since Aiden King is associated with multiple missing encounters containing invalid CPTs (NORCM, 97113). Either the encounters from specific providers were filtered out due to custom business rules, or the provider’s data submission had formatting or maybe system issues.
