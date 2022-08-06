--Some rules check conformance to the CDM model, other rules look at data quality


--ruleid 1 check for non-zero counts from checks of improper data (invalid ids, out-of-bound data, inconsistent dates)

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_1

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT DISTINCT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; count (n=', cast(or1.count_value as VARCHAR(19)), ') should not be > 0') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
  	1 as rule_id,
  	or1.count_value as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  WHERE or1.analysis_id IN (
  		7,
  		8,
  		9,
  		114,
  		115,
  		118,
  		207,
  		208,
  		209,
  		210,
  		302,
  		409,
  		410,
  		411,
  		412,
  		413,
  		509,
  		--510, taken out from this umbrella rule and implemented separately
  		609,
  		610,
  		612,
  		613,
  		709,
  		710,
  		711,
  		712,
  		713,
  		809,
  		810,
  		812,
  		813,
  		814,
  		908,
  		909,
  		910,
  		1008,
  		1009,
  		1010,
  		1415,
  		1500,
  		1501,
  		1600,
  		1601,
  		1701
  		) --all explicit counts of data anamolies
  	AND or1.count_value > 0
  ) A;
ANALYZE s_tmpheel_rule_1
;


--ruleid 10 place of service - 14 CMS place of service, 24 OMOP visit

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_10

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; ', cast(COUNT(DISTINCT stratum_1) AS VARCHAR(19)), ' concepts in data are not in correct vocabulary') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    10 as rule_id,
    COUNT(DISTINCT stratum_1) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  INNER JOIN cdm.concept c1
  	ON or1.stratum_1 = CAST(c1.concept_id AS VARCHAR(19))
  WHERE or1.analysis_id IN (202)
  	AND or1.stratum_1 IS NOT NULL
  	AND c1.concept_id <> 0 
    AND lower(c1.domain_id) NOT IN ('visit')
  GROUP BY or1.analysis_id,
  	oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_10
;


--ruleid 11 CDM-conformance rule:specialty - 48 specialty

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_11

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; ', cast(COUNT(DISTINCT stratum_1) AS VARCHAR(19)), ' concepts in data are not in correct vocabulary (Specialty)') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    11 as rule_id,
    COUNT(DISTINCT stratum_1) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  INNER JOIN cdm.concept c1
  	ON or1.stratum_1 = CAST(c1.concept_id AS VARCHAR(19))
  WHERE or1.analysis_id IN (301)
  	AND or1.stratum_1 IS NOT NULL
  	AND c1.concept_id <> 0 
    AND lower(c1.domain_id) NOT IN ('provider')
  GROUP BY or1.analysis_id,
  	oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_11
;


--ruleid 12 condition occurrence, era - 1 SNOMED

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_12

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; ', cast(COUNT(DISTINCT stratum_1) AS VARCHAR(19)), ' concepts in data are not in correct vocabulary') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    12 as rule_id,
    COUNT(DISTINCT stratum_1) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  INNER JOIN cdm.concept c1
  	ON or1.stratum_1 = CAST(c1.concept_id AS VARCHAR(19))
  WHERE or1.analysis_id IN (
  		400,
  		1000
  		)
  	AND or1.stratum_1 IS NOT NULL
  	AND c1.concept_id <> 0 
    AND lower(c1.domain_id) NOT IN ('condition','condition/drug', 'condition/meas', 'condition/obs', 'condition/procedure')
  GROUP BY or1.analysis_id,
  	oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_12
;


--ruleid 13 drug exposure - 8 RxNorm

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_13

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; ', cast(COUNT(DISTINCT stratum_1) AS VARCHAR(19)), ' concepts in data are not in correct vocabulary') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    13 as rule_id,
    COUNT(DISTINCT stratum_1) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  INNER JOIN cdm.concept c1
  	ON or1.stratum_1 = CAST(c1.concept_id AS VARCHAR(19))
  WHERE or1.analysis_id IN (
  		700,
  		900
  		)
  	AND or1.stratum_1 IS NOT NULL
  	AND c1.concept_id <> 0 
    AND lower(c1.domain_id) NOT IN ('drug','condition/drug', 'device/drug', 'drug/measurement', 'drug/obs', 'drug/procedure')
  GROUP BY or1.analysis_id,
  	oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_13
;


--ruleid 14 procedure - 4 CPT4/5 HCPCS/3 ICD9P

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_14

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
  
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; ', cast(COUNT(DISTINCT stratum_1) AS VARCHAR(19)), ' concepts in data are not in correct vocabulary') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    14 as rule_id,
    COUNT(DISTINCT stratum_1) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  INNER JOIN cdm.concept c1
  	ON or1.stratum_1 = CAST(c1.concept_id AS VARCHAR(19))
  WHERE or1.analysis_id IN (600)
  	AND or1.stratum_1 IS NOT NULL
  	AND c1.concept_id <> 0 
    AND lower(c1.domain_id) NOT IN ('procedure','condition/procedure', 'device/procedure', 'drug/procedure', 'obs/procedure')
  GROUP BY or1.analysis_id,
  	oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_14
;


--ruleid 17 revenue code - 43 revenue code

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_17

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; ', cast(COUNT(DISTINCT stratum_1) AS VARCHAR(19)), ' concepts in data are not in correct vocabulary (revenue code)') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    17 as rule_id,
    COUNT(DISTINCT stratum_1) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  INNER JOIN cdm.concept c1
  	ON or1.stratum_1 = CAST(c1.concept_id AS VARCHAR(19))
  WHERE or1.analysis_id IN (1610)
  	AND or1.stratum_1 IS NOT NULL
  	AND c1.concept_id <> 0 
    AND lower(c1.domain_id) NOT IN ('revenue code')
  GROUP BY or1.analysis_id,
  	oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_17
;


--ruleid 18 ERROR:  year of birth in the future

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_18

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT DISTINCT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; should not have year of birth in the future, (n=', cast(or1.record_count as VARCHAR(19)), ')') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    18 as rule_id,
    or1.record_count
  FROM results.ACHILLES_analysis oa1
  INNER JOIN (
      SELECT analysis_id, SUM(count_value) AS record_count FROM results.achilles_results
      WHERE analysis_id IN (3)
            AND CAST(stratum_1 AS INT) > EXTRACT(YEAR FROM CURRENT_DATE)
            AND count_value > 0
      GROUP BY analysis_id
      ) or1
  	ON or1.analysis_id = oa1.analysis_id
) A;
ANALYZE s_tmpheel_rule_18
;


--ruleid 19 WARNING:  year of birth < 1800

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_19

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; should not have year of birth < 1800, (n=', cast(sum(or1.count_value) as VARCHAR(19)), ')') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    19 as rule_id,
    sum(or1.count_value) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  WHERE or1.analysis_id IN (3)
  	AND cAST(or1.stratum_1 AS INT) < 1800
  	AND or1.count_value > 0
  GROUP BY or1.analysis_id,
    oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_19
;


--ruleid 2 distributions where min should not be negative

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_2
	
AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
    SELECT ord1.analysis_id,
    CAST(CONCAT('ERROR: ', cast(ord1.analysis_id as VARCHAR(10)), ' - ', oa1.analysis_name, ' (count = ', cast(COUNT(ord1.min_value) as VARCHAR(19)), '); min value should not be negative') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    2 as rule_id,
    COUNT(ord1.min_value) as record_count
  FROM results.achilles_results_dist ord1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON ord1.analysis_id = oa1.analysis_id
  WHERE ord1.analysis_id IN (
  		103,
  		105,
  		206,
  		406,
  		506,
  		606,
  		706,
  		715,
  		716,
  		717,
  		806,
  		906,
  		907,
  		1006,
  		1007,
  		1502,
  		1503,
  		1504,
  		1505,
  		1506,
  		1507,
  		1508,
  		1509,
  		1510,
  		1511,
  		1602,
  		1603,
  		1604,
  		1605,
  		1606,
  		1607,
  		1608
  		)
  	AND ord1.min_value < 0
  	GROUP BY ord1.analysis_id,  oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_2
	;


--ruleid 20 ERROR:  age < 0

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_20

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; should not have age < 0, (n=', cast(sum(or1.count_value) as VARCHAR(19)), ')') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    20 as rule_id,
    sum(or1.count_value) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  WHERE or1.analysis_id IN (101)
  	AND CAST(or1.stratum_1 AS INT) < 0
  	AND or1.count_value > 0
  GROUP BY or1.analysis_id,
    oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_20
;


--ruleid 21 ERROR: age > 150  (TODO lower number seems more appropriate)

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_21

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; should not have age > 150, (n=', cast(sum(or1.count_value) as VARCHAR(19)), ')') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    21 as rule_id,
    sum(or1.count_value) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  WHERE or1.analysis_id IN (101)
  	AND CAST(or1.stratum_1 AS INT) > 150
  	AND or1.count_value > 0
  GROUP BY or1.analysis_id,
    oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_21
;


--ruleid 22 WARNING:  monthly change > 100%

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_22

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	cast(null as bigint) as record_count
	
FROM
(
  SELECT DISTINCT ar1.analysis_id,
  	CAST(CONCAT('WARNING: ', cast(ar1.analysis_id as VARCHAR(10)), '-', aa1.analysis_name, '; theres a 100% change in monthly count of events') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    22 as rule_id
    
  FROM results.ACHILLES_analysis aa1
  INNER JOIN results.achilles_results ar1
  	ON aa1.analysis_id = ar1.analysis_id
  INNER JOIN results.achilles_results ar2
  	ON ar1.analysis_id = ar2.analysis_id
  		AND ar1.analysis_id IN (
  			420,
  			620,
  			720,
  			820,
  			920,
  			1020
  			)
  WHERE (
  		CAST(ar1.stratum_1 AS INT) + 1 = CAST(ar2.stratum_1 AS INT)
  		OR CAST(ar1.stratum_1 AS INT) + 89 = CAST(ar2.stratum_1 AS INT)
  		)
  	AND 1.0 * abs(ar2.count_value - ar1.count_value) / ar1.count_value > 1
  	AND ar1.count_value > 10
) A;
ANALYZE s_tmpheel_rule_22
;


--ruleid 23 WARNING:  monthly change > 100% at concept level

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_23

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count

FROM
(
  SELECT ar1.analysis_id,
  	CAST(CONCAT('WARNING: ', cast(ar1.analysis_id as VARCHAR(10)), '-', aa1.analysis_name, '; ', cast(COUNT(DISTINCT ar1.stratum_1) AS VARCHAR(19)), ' concepts have a 100% change in monthly count of events') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    23 as rule_id,
    COUNT(DISTINCT ar1.stratum_1) as record_count
  FROM results.ACHILLES_analysis aa1
  INNER JOIN results.achilles_results ar1
  	ON aa1.analysis_id = ar1.analysis_id
  INNER JOIN results.achilles_results ar2
  	ON ar1.analysis_id = ar2.analysis_id
  		AND ar1.stratum_1 = ar2.stratum_1
  		AND ar1.analysis_id IN (
  			402,
  			602,
  			702,
  			802,
  			902,
  			1002
  			)
  WHERE (
  		ROUND(CAST(CAST(ar1.stratum_2 AS DECIMAL(18,4)) AS NUMERIC),0) + 1 = ROUND(CAST(CAST(ar2.stratum_2 AS DECIMAL(18,4)) AS NUMERIC),0)
		OR ROUND(CAST(CAST(ar1.stratum_2 AS DECIMAL(18,4)) AS NUMERIC),0) + 89 = ROUND(CAST(CAST(ar2.stratum_2 AS DECIMAL(18,4)) AS NUMERIC),0)
  		)
  	AND 1.0 * abs(ar2.count_value - ar1.count_value) / ar1.count_value > 1
  	AND ar1.count_value > 10
  GROUP BY ar1.analysis_id,
  	aa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_23
;


--ruleid 24 WARNING: days_supply > 180 

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_24

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT DISTINCT ord1.analysis_id,
    CAST(CONCAT('WARNING: ', cast(ord1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, ' (count = ', cast(ord1.record_count as VARCHAR(19)), '); max value should not be > 180') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    24 as rule_id,
    ord1.record_count as record_count
  FROM results.ACHILLES_analysis oa1
    INNER JOIN (SELECT analysis_id, COUNT(max_value) AS record_count
      FROM results.achilles_results_dist
      WHERE analysis_id IN (715)
          AND max_value > 180
      GROUP BY analysis_id
    ) ord1 ON ord1.analysis_id = oa1.analysis_id
) A;
ANALYZE s_tmpheel_rule_24
;


--ruleid 25 WARNING:  refills > 10

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_25

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT DISTINCT ord1.analysis_id,
    CAST(CONCAT('WARNING: ', cast(ord1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, ' (count = ', cast(ord1.record_count as VARCHAR(19)), '); max value should not be > 10') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    25 as rule_id,
    ord1.record_count
  FROM results.ACHILLES_analysis oa1
  INNER JOIN ( SELECT analysis_id, COUNT(max_value) AS record_count FROM results.achilles_results_dist
    WHERE analysis_id IN (716)
  	AND max_value > 10
    GROUP BY analysis_id) ord1 ON ord1.analysis_id = oa1.analysis_id
) A;
ANALYZE s_tmpheel_rule_25
;


--ruleid 26 DQ rule: WARNING: quantity > 600

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_26

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT DISTINCT ord1.analysis_id,
    CAST(CONCAT('WARNING: ', cast(ord1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, ' (count = ', cast(ord1.record_count as VARCHAR(19)), '); max value should not be > 600') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    26 as rule_id,
    ord1.record_count
  FROM results.ACHILLES_analysis oa1
    INNER JOIN(SELECT analysis_id, count(max_value) as record_count FROM results.achilles_results_dist
    WHERE analysis_id IN (717)
  	AND max_value > 600
    GROUP BY analysis_id) ord1 ON ord1.analysis_id = oa1.analysis_id
) A;
ANALYZE s_tmpheel_rule_26
;


--ruleid 3 death distributions where max should not be positive

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_3

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
  
FROM
(
  SELECT DISTINCT ord1.analysis_id,
    CAST(CONCAT('WARNING: ', cast(ord1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, ' (count = ', cast(ord1.record_count as VARCHAR(19)), '); max value should not be positive, otherwise its a zombie with data >1mo after death ') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    3 as rule_id,
    ord1.record_count
  FROM results.ACHILLES_analysis oa1
		INNER JOIN (SELECT analysis_id, COUNT(max_value) AS record_count FROM results.achilles_results_dist
  	WHERE analysis_id IN (
  		511,
  		512,
  		513,
  		514,
  		515
  		)
  	AND max_value > 60
  	GROUP BY analysis_id) ord1 ON ord1.analysis_id = oa1.analysis_id
) A;
ANALYZE s_tmpheel_rule_3
;


--ruleid 4 CDM-conformance rule: invalid concept_id

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_4

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
  
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; ', cast(COUNT(DISTINCT stratum_1) AS VARCHAR(19)), ' concepts in data are not in vocabulary') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    4 as rule_id,
    COUNT(DISTINCT stratum_1) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  LEFT JOIN cdm.concept c1
  	ON or1.stratum_1 = CAST(c1.concept_id AS VARCHAR(19))
  WHERE or1.analysis_id IN (
  		2,
  		4,
  		5,
  		200,
  		301,
  		400,
  		500,
  		505,
  		600,
  		700,
  		800,
  		900,
  		1000,
  		1609,
  		1610
  		)
  	AND or1.stratum_1 IS NOT NULL
  	AND c1.concept_id IS NULL
  GROUP BY or1.analysis_id,
  	oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_4
;


--ruleid 5 CDM-conformance rule:invalid type concept_id
--this rule is only checking that the concept is valid (joins to concept table at all)
--it does not check the vocabulary_id to further restrict the scope of the valid concepts
--to only include,for example, death types 

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_5

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; ', cast(COUNT(DISTINCT stratum_2) AS VARCHAR(19)), ' concepts in data are not in vocabulary') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    5 as rule_id,
    COUNT(DISTINCT stratum_2) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  LEFT JOIN cdm.concept c1
  	ON or1.stratum_2 = CAST(c1.concept_id AS VARCHAR(19))
  WHERE or1.analysis_id IN (
  		405,
  		605,
  		705,
  		805,
  		1805
  		)
  	AND or1.stratum_2 IS NOT NULL
  	AND c1.concept_id IS NULL
  GROUP BY or1.analysis_id,
  	oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_5
;


--ruleid 6 CDM-conformance rule:invalid concept_id

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_6

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('WARNING: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; data with unmapped concepts') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    6 as rule_id,
    cast(null as bigint) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  WHERE or1.analysis_id IN (
  		2,
  		4,
  		5,
  		200,
  		301,
  		400,
  		500,
  		505,
  		600,
  		700,
  		800,
  		900,
  		1000,
  		1609,
  		1610
  		)
  	AND or1.stratum_1 = '0'
  GROUP BY or1.analysis_id,
  	oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_6
;


--concept from the wrong vocabulary
--ruleid 7 CDM-conformance rule:gender  - 12 HL7

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_7

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; ', cast(COUNT(DISTINCT stratum_1) AS VARCHAR(19)), ' concepts in data are not in correct vocabulary') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    7 as rule_id,
    COUNT(DISTINCT stratum_1) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  INNER JOIN cdm.concept c1
  	ON or1.stratum_1 = CAST(c1.concept_id AS VARCHAR(19))
  WHERE or1.analysis_id IN (2)
  	AND or1.stratum_1 IS NOT NULL
  	AND c1.concept_id <> 0 
    AND lower(c1.domain_id) NOT IN ('gender')
  GROUP BY or1.analysis_id,
  	oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_7
;


--ruleid 8 race  - 13 CDC Race

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_8

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
  
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; ', cast(COUNT(DISTINCT stratum_1) AS VARCHAR(19)), ' concepts in data are not in correct vocabulary') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    8 as rule_id,
    COUNT(DISTINCT stratum_1) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  INNER JOIN cdm.concept c1
  	ON or1.stratum_1 = CAST(c1.concept_id AS VARCHAR(19))
  WHERE or1.analysis_id IN (4)
  	AND or1.stratum_1 IS NOT NULL
  	AND c1.concept_id <> 0 
    AND lower(c1.domain_id) NOT IN ('race')
  GROUP BY or1.analysis_id,
  	oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_8
;


--ruleid 9 ethnicity - 44 ethnicity

--HINT DISTRIBUTE_ON_KEY(analysis_id)
CREATE TEMP TABLE s_tmpheel_rule_9

AS
SELECT
analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	
FROM
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; ', cast(COUNT(DISTINCT stratum_1) AS VARCHAR(19)), ' concepts in data are not in correct vocabulary (CMS Ethnicity)') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    9 as rule_id,
    COUNT(DISTINCT stratum_1) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  INNER JOIN cdm.concept c1
  	ON or1.stratum_1 = CAST(c1.concept_id AS VARCHAR(19))
  WHERE or1.analysis_id IN (5)
  	AND or1.stratum_1 IS NOT NULL
  	AND c1.concept_id <> 0 
    AND lower(c1.domain_id) NOT IN ('ethnicity')
  GROUP BY or1.analysis_id,
  	oa1.analysis_name
) A;
ANALYZE s_tmpheel_rule_9
;


CREATE TEMP TABLE s_tmpheel_1

AS
SELECT
cast(null as int) as analysis_id,
  stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value,
  cast('UnmappedDataByDomain:SourceValueCnt' as varchar(255)) as measure_id

FROM
results.achilles_results where analysis_id = 1900
group by stratum_1;
ANALYZE s_tmpheel_1
;


CREATE TEMP TABLE s_tmpheel_13

AS
SELECT
cast(null as int) as analysis_id,
  cast(r.analysis_id as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  COUNT(*) as statistic_value, 
  cast('Achilles:byAnalysis:RowCnt' as varchar(255)) as measure_id

FROM
results.achilles_results r
group by r.analysis_id
;
ANALYZE s_tmpheel_13
;


CREATE TEMP TABLE s_tmpheel_14

AS
SELECT
cast(null as int) as analysis_id,
  a.stratum_1,
  a.stratum_4 as stratum_2,
  cast(1.0*a.person_cnt/b.population_size as NUMERIC) as statistic_value,
cast('Visit:Type:PersonWithAtLeastOne:byDecile:Percentage' as varchar(255)) as measure_id

FROM
(select 
  stratum_1,  
  stratum_4, 
  sum(count_value) as person_cnt  
  from results.achilles_results
  where analysis_id = 204 
  group by stratum_1, stratum_4) a
inner join 
(select
  stratum_4, 
  sum(count_value) as population_size
  from results.achilles_results
  where analysis_id = 204 
  group by stratum_4) b
on a.stratum_4=b.stratum_4
where a.person_cnt >= 11;
ANALYZE s_tmpheel_14
;


CREATE TEMP TABLE s_tmpheel_15

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('Device:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 2101;
ANALYZE s_tmpheel_15
;


CREATE TEMP TABLE s_tmpheel_16

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('Measurement:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 1801;
ANALYZE s_tmpheel_16
;


CREATE TEMP TABLE s_tmpheel_17

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('Observation:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 801;
ANALYZE s_tmpheel_17
;


CREATE TEMP TABLE s_tmpheel_18

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('Procedure:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 601;
ANALYZE s_tmpheel_18
;


CREATE TEMP TABLE s_tmpheel_19

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('Note:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 2201;
ANALYZE s_tmpheel_19
;


--age at first observation by decile
CREATE TEMP TABLE temp_0

AS
SELECT
analysis_id, stratum_1, stratum_2, sum(count_value) as statistic_value, measure_id

FROM
(
  select 
    cast(null as int) as analysis_id,
    cast(floor(cast(stratum_1 as int)/10) as varchar(255)) as stratum_1,
    cast(null as varchar(255)) as stratum_2,
    count_value,
    cast('AgeAtFirstObsByDecile:PersonCnt' as varchar(255)) as measure_id
  from results.achilles_results where analysis_id = 101
) Q
group by analysis_id, stratum_1, stratum_2, measure_id
;
ANALYZE temp_0
;

--count whether all deciles from 0 to 8 are there  (has later a rule: if less the threshold, issue notification)
CREATE TEMP TABLE temp_1

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value,
 cast('AgeAtFirstObsByDecile:DecileCnt' as varchar(255)) as measure_id

FROM
temp_0
where measure_id = 'AgeAtFirstObsByDecile:PersonCnt' 
and cast(stratum_1 as int) <=8;
ANALYZE temp_1
;

CREATE TEMP TABLE s_tmpheel_2

AS
SELECT
analysis_id, stratum_1, stratum_2, statistic_value, measure_id

FROM
(
  select analysis_id, stratum_1, stratum_2, statistic_value, measure_id
  from temp_0
  union all
  select analysis_id, stratum_1, stratum_2, statistic_value, measure_id
  from temp_1
) A;
ANALYZE s_tmpheel_2
;

truncate table temp_0;
drop table temp_0;

truncate table temp_1;
drop table temp_1;


CREATE TEMP TABLE s_tmpheel_20

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('Death:DeathCause:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 501;
ANALYZE s_tmpheel_20
;


CREATE TEMP TABLE s_tmpheel_21

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('Death:DeathType:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 505;
ANALYZE s_tmpheel_21
;


CREATE TEMP TABLE s_tmpheel_22

AS
SELECT
cast(null as int) as analysis_id,
  stratum_1,
  cast(null as varchar(255)) as stratum_2,
  temp_cnt as statistic_value,
cast('Death:byYear:SafePatientCnt' as varchar(255)) as measure_id

FROM
(select stratum_1,sum(count_value) as temp_cnt 
    from results.achilles_results where analysis_id = 504
    group by stratum_1
   ) a
where temp_cnt >= 11;
ANALYZE s_tmpheel_22
;


CREATE TEMP TABLE s_tmpheel_23

AS
SELECT
cast(null as int) as analysis_id,
  cast(decade as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  temp_cnt as statistic_value,
cast('Death:byDecade:SafePatientCnt' as varchar(255)) as measure_id

FROM
(select left(stratum_1,3) as decade,sum(count_value) as temp_cnt 
    from results.achilles_results where analysis_id = 504
    group by left(stratum_1,3)
   ) a
where temp_cnt >= 11;
ANALYZE s_tmpheel_23
;


CREATE TEMP TABLE s_tmpheel_24

AS
SELECT
cast(null as int) as analysis_id,
  a.stratum_1,
  cast(null as varchar(255)) as stratum_2,
  cast(1.0*a.born_cnt/b.died_cnt as NUMERIC) as statistic_value,
  cast('Death:BornDeceasedRatio' as varchar(255)) as measure_id

FROM
(select 
  stratum_1,
  count_value as born_cnt 
  from results.achilles_results
  where analysis_id = 3) a 
inner join 
(select 
  stratum_1, 
  sum(count_value) as died_cnt 
  from results.achilles_results
  where analysis_id = 504 group by stratum_1) b 
on a.stratum_1 = b.stratum_1
where b.died_cnt > 0;
ANALYZE s_tmpheel_24
;


--general derived measures
--non-CDM sources may generate derived measures directly
--for CDM and Achilles: the fastest way to compute derived measures is to use
--existing measures
--derived measures have IDs over 100 000 (not any more, instead, they use measure_id as their id)


--event type derived measures analysis xx05 is often analysis by xx_type
--generate counts for meas type, drug type, proc type, obs type
--optional TODO: possibly rewrite this with CASE statement to better make 705 into drug, 605 into proc ...etc
--               in measure_id column (or make that separate sql calls for each category)


CREATE TEMP TABLE s_tmpheel_25

AS
SELECT
analysis_id, stratum_1, stratum_2, sum(count_value) as statistic_value, measure_id

FROM
(
  --100000+analysis_id, 
  select
    cast(null as int) as analysis_id,
    stratum_2 as stratum_1,
    cast(null as varchar(255)) as stratum_2,
    count_value,
    CAST(concat('ach_',CAST(analysis_id as VARCHAR), ':GlobalCnt') as varchar(255)) as measure_id
  from results.achilles_results
  where analysis_id in (1805,705,605,805,405) 
) Q
group by analysis_id, stratum_1, stratum_2, measure_id
;
ANALYZE s_tmpheel_25
;


--total number of rows per domain
--this derived measure is used for later measure of % of unmapped rows
--this produces a total count of rows in condition table, procedure table etc.
--used as denominator in later measures

       
CREATE TEMP TABLE s_tmpheel_26

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  sum(count_value) as statistic_value, 
       CAST(concat('ach_',CAST(r.analysis_id as VARCHAR),':GlobalRowCnt') as varchar(255)) as measure_id

FROM
results.achilles_results r
where analysis_id in (401,601,701,801,1801) group by r.analysis_id;
ANALYZE s_tmpheel_26
;


--iris measures by percentage
--for this part, derived table is trying to adopt DQI terminolgy 
--and generalize analysis naming scheme (and generalize the DQ rules)

CREATE TEMP TABLE s_tmpheel_27

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  CAST(100.0*count_value/statistic.total_pts AS NUMERIC) as statistic_value,
  CAST(CONCAT('ach_',CAST(analysis_id as VARCHAR(10)),':Percentage') AS VARCHAR(100)) as measure_id

FROM
results.achilles_results
cross join (SELECT  count_value as total_pts from results.achilles_results r where analysis_id =1 LIMIT 1) as statistic
where analysis_id in (2000,2001,2002,2003);
ANALYZE s_tmpheel_27
;


--concept_0 global row  Counts per domain
--this is numerator for percentage value of unmapped rows (per domain)
CREATE TEMP TABLE s_tmpheel_28

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count_value as statistic_value, 
       CAST(concat('UnmappedData:ach_',cast(analysis_id as VARCHAR),':GlobalRowCnt') as varchar(255)) as measure_id

FROM
results.achilles_results
--TODO:stratum_1 is varchar and this comparison may fail on some db engines
--indeed, mysql got error, changed to a string comparison
where analysis_id in (401,601,701,801,1801) and stratum_1 = '0';
ANALYZE s_tmpheel_28
;


CREATE TEMP TABLE s_tmpheel_29

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  sum(count_value) as statistic_value, 
           cast('Visit:InstanceCnt' as varchar(255)) as measure_id

FROM
results.achilles_results where analysis_id = 201;
ANALYZE s_tmpheel_29
;


CREATE TEMP TABLE s_tmpheel_30

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('Condition:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 401;
ANALYZE s_tmpheel_30
;


CREATE TEMP TABLE s_tmpheel_31

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('Visit:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 201;
ANALYZE s_tmpheel_31
;


CREATE TEMP TABLE s_tmpheel_32

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('Person:Ethnicity:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 5;
ANALYZE s_tmpheel_32
;


CREATE TEMP TABLE s_tmpheel_33

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('Person:Race:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 4;
ANALYZE s_tmpheel_33
;


CREATE TEMP TABLE s_tmpheel_6

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value,
  cast('Provider:SpecialtyCnt' as varchar(255)) as measure_id

FROM
results.achilles_results where analysis_id = 301;
ANALYZE s_tmpheel_6
;



CREATE TEMP TABLE s_tmpheel_7

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('DrugExposure:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 701;
ANALYZE s_tmpheel_7
;


CREATE TEMP TABLE s_tmpheel_8

AS
SELECT
cast(null as int) as analysis_id,
  cast(null as varchar(255)) as stratum_1,
  cast(null as varchar(255)) as stratum_2,
  count(*) as statistic_value, 
  cast('DrugEra:ConceptCnt' as varchar(255)) as measure_id 

FROM
results.achilles_results where analysis_id = 901;
ANALYZE s_tmpheel_8
;


DROP TABLE IF EXISTS s_achilles_rd_0;

CREATE TEMP TABLE s_achilles_rd_0

AS
SELECT
analysis_id, 
	stratum_1,
	stratum_2,
	statistic_value,
	measure_id

FROM
(
  select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_1 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_13 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_14 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_15 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_16 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_17 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_18 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_19 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_2 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_20 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_21 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_22 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_23 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_24 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_25 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_26 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_27 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_28 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_29 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_30 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_31 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_32 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_33 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_6 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_7 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(stratum_1 as varchar(255)) as stratum_1, cast(stratum_2 as varchar(255)) as stratum_2, cast(statistic_value as NUMERIC) as statistic_value, cast(measure_id as varchar(255)) as measure_id
             from s_tmpheel_8
) Q
;
ANALYZE s_achilles_rd_0
;


DROP TABLE IF EXISTS s_achilles_hr_0;

CREATE TEMP TABLE s_achilles_hr_0

AS
SELECT
distinct
  analysis_id,
	achilles_heel_warning,
	rule_id,
	record_count

FROM
(
  select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_1 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_10 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_11 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_12 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_13 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_14 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_17 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_18 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_19 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_2 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_20 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_21 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_22 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_23 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_24 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_25 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_26 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_3 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_4 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_5 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_6 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_7 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_8 
union all
 select
             cast(analysis_id as int) as analysis_id, cast(ACHILLES_HEEL_warning as varchar(255)) as ACHILLES_HEEL_warning, cast(rule_id as int) as rule_id, cast(record_count as bigint) as record_count
             from s_tmpheel_rule_9
) Q
;
ANALYZE s_achilles_hr_0
;


CREATE TEMP TABLE rule27_1

AS
SELECT
*

FROM
(

  select * from s_achilles_rd_0
  
  union all
  
  select
    cast(null as int) as analysis_id,
    CAST('Condition' AS VARCHAR(255)) as stratum_1, 
    cast(null as varchar(255)) as stratum_2,
    CAST(100.0*st.val/statistic_value AS NUMERIC) as statistic_value,
    CAST('UnmappedData:byDomain:Percentage' AS VARCHAR(255)) as measure_id
  from s_achilles_rd_0
  cross join (select statistic_value as val from s_achilles_rd_0
      where measure_id like 'UnmappedData:ach_401:GlobalRowCnt') as st
  where measure_id = 'ach_401:GlobalRowCnt'
) Q
;
ANALYZE rule27_1
;


CREATE TEMP TABLE rule27_2

AS
SELECT
*

FROM
(

  select * from rule27_1
  
  union all
  
  select
    cast(null as int) as analysis_id,
    CAST('Procedure' AS VARCHAR(255)) as stratum_1,
    cast(null as varchar(255)) as stratum_2,
    CAST(100.0*st.val/statistic_value AS NUMERIC) as statistic_value,
     CAST(  'UnmappedData:byDomain:Percentage' AS VARCHAR(255)) as measure_id
  from rule27_1 A
  cross join (select statistic_value as val from rule27_1 
        where measure_id = 'UnmappedData:ach_601:GlobalRowCnt') as st
  where measure_id ='ach_601:GlobalRowCnt'
    
) Q
;
ANALYZE rule27_2
;


CREATE TEMP TABLE rule27_3

AS
SELECT
*

FROM
(

  select * from rule27_2
  
  union all
  
  select
    cast(null as int) as analysis_id,
    CAST('DrugExposure' AS VARCHAR(255)) as stratum_1,
    cast(null as varchar(255)) as stratum_2,
    CAST(100.0*st.val/statistic_value AS NUMERIC) as statistic_value,
    CAST(  'UnmappedData:byDomain:Percentage' AS VARCHAR(255)) as measure_id
  from rule27_2 A
  cross join (select statistic_value as val from rule27_2 
        where measure_id = 'UnmappedData:ach_701:GlobalRowCnt') as st
  where measure_id ='ach_701:GlobalRowCnt'
  
) Q
;
ANALYZE rule27_3
;


CREATE TEMP TABLE rule27_4

AS
SELECT
*

FROM
(

  select * from rule27_3
  
  union all
  
  select
    cast(null as int) as analysis_id,
    CAST('Observation' AS VARCHAR(255)) as stratum_1, 
    cast(null as varchar(255)) as stratum_2,
    CAST(100.0*st.val/statistic_value AS NUMERIC) as statistic_value,
    CAST(  'UnmappedData:byDomain:Percentage' AS VARCHAR(255)) as measure_id
  from rule27_3 A
  cross join (select statistic_value as val from rule27_3
        where measure_id = 'UnmappedData:ach_801:GlobalRowCnt') as st
  where measure_id ='ach_801:GlobalRowCnt'
  
) Q
;
ANALYZE rule27_4
;


CREATE TEMP TABLE rule27_5

AS
SELECT
*

FROM
(

  select * from rule27_4
  
  union all
  
  select
    cast(null as int) as analysis_id,
    CAST('Measurement' AS VARCHAR(255)) as stratum_1, 
    cast(null as varchar(255)) as stratum_2,
    CAST(100.0*st.val/statistic_value AS NUMERIC) as statistic_value,
    CAST(  'UnmappedData:byDomain:Percentage' AS VARCHAR(255)) as measure_id
  from rule27_4 A
  cross join (select statistic_value as val from rule27_4
        where measure_id = 'UnmappedData:ach_1801:GlobalRowCnt') as st
  where measure_id ='ach_1801:GlobalRowCnt'
  
) Q
;
ANALYZE rule27_5
;


CREATE TEMP TABLE serial_rd_27

AS
SELECT
* 

FROM
(
  select * from rule27_5
) Q;
ANALYZE serial_rd_27
;

truncate table rule27_1;
drop table rule27_1;

truncate table rule27_2;
drop table rule27_2;

truncate table rule27_3;
drop table rule27_3;

truncate table rule27_4;
drop table rule27_4;

truncate table rule27_5;
drop table rule27_5;


--actual rule27
  
CREATE TEMP TABLE serial_hr_27

AS
SELECT
*

FROM
(
  select * from s_achilles_hr_0
  
  union all
  
  SELECT 
    cast(null as int) as analysis_id,
    CAST(CONCAT('NOTIFICATION:Unmapped data over percentage threshold in:', 
    cast(d.stratum_1 as varchar(100))) AS VARCHAR(255)) as ACHILLES_HEEL_warning,
    27 as rule_id,
    cast(null as bigint) as record_count
  FROM serial_rd_27 d
  where d.measure_id = 'UnmappedData:byDomain:Percentage'
  and d.statistic_value > 0.1  --thresholds will be decided in the ongoing DQ-Study2
) Q
;
ANALYZE serial_hr_27
;

--end of rule27

drop table s_achilles_hr_0;
drop table s_achilles_rd_0;




--rule28 DQ rule
--are all values (or more than threshold) in measurement table non numerical?
--(count of Measurment records with no numerical value is in analysis_id 1821)


CREATE TEMP TABLE tempResults

AS
SELECT
* 
FROM
(
  select 
    t2.count_value*100.0/all_count as statistic_value,
  CAST('Meas:NoNumValue:Percentage' AS VARCHAR(100)) as measure_id
  from 
  (
    select sum(count_value) as all_count from results.achilles_results where analysis_id = 1820
  ) t1 cross join (select count_value from results.achilles_results where analysis_id = 1821) t2
) t3
;
ANALYZE tempResults
;

CREATE TEMP TABLE serial_rd_28

AS
SELECT
* 
FROM
(
  select * from serial_rd_27
  
  union all
  
  select  
    cast(null as int) as analysis_id,
    cast(null as varchar(255)) as stratum_1,
    cast(null as varchar(255)) as stratum_2,
    statistic_value,
    measure_id
  from tempResults
) Q
;
ANALYZE serial_rd_28
;



CREATE TEMP TABLE serial_hr_28

AS
SELECT
*

FROM
(
  select * from serial_hr_27
  
  union all
  
  select  
    cast(null as int) as analysis_id,
    CAST('NOTIFICATION: percentage of non-numerical measurement records exceeds general population threshold ' AS VARCHAR(255)) as ACHILLES_HEEL_warning,
  	28 as rule_id,
  	cast(statistic_value as int) as record_count
	from tempResults t
    --WHERE t.analysis_id IN (100730,100430) --umbrella version
  WHERE measure_id = 'Meas:NoNumValue:Percentage' --t.analysis_id IN (100000)
  --the intended threshold is 1 percent, this value is there to get pilot data from early adopters
  	AND t.statistic_value >= 80
) Q
;
ANALYZE serial_hr_28
;


--clean up temp tables for rule 28
truncate table tempResults;
drop table tempResults;

--end of rule 28


DROP TABLE IF EXISTS serial_rd_27;

DROP TABLE IF EXISTS serial_hr_27;

--rule29 DQ rule
--unusual diagnosis present, this rule is terminology dependend

CREATE TEMP TABLE tempResults
--set threshold here, currently it is zero

AS
WITH tempcnt   AS (SELECT sum(count_value) as pt_cnt from results.achilles_results
	where analysis_id = 404 --dx by decile
	and stratum_1 =  CAST('195075' as TEXT) and cast(stratum_4 as int) >= 5 --fifth decile or more
)
 SELECT
pt_cnt as record_count 

FROM
tempcnt where pt_cnt > 0;
ANALYZE tempResults
--set threshold here, currently it is zero
;


--using temp table because with clause that occurs prior insert into is causing problems 
--and with clause makes the code more readable

CREATE TEMP TABLE serial_hr_29

AS
SELECT
*

FROM
(
  select * from serial_hr_28
  
  union all
  
  select 
    cast(null as int) as analysis_id,
    CAST('WARNING:[PLAUSIBILITY] infant-age diagnosis (195075) at age 50+' AS VARCHAR(255)) as ACHILLES_HEEL_warning,
    29 as rule_id,
    cast(null as bigint) as record_count
  from tempResults
) Q;
ANALYZE serial_hr_29
;

truncate table tempResults;
drop table tempResults;
--end of rule29


DROP TABLE IF EXISTS serial_hr_28;

--rule31 DQ rule
--ratio of providers to total patients

--compute a derived ratio
--TODO if provider count is zero it will generate division by zero (not sure how dirrerent db engins will react)
CREATE TEMP TABLE serial_rd_31 

AS
SELECT
* 
FROM
(
  select * from serial_rd_28
  
  union all
  
  select 
    cast(null as int) as analysis_id,
    cast(null as varchar(255)) as stratum_1,
    cast(null as varchar(255)) as stratum_2,
    CAST(1.0*ct.total_pts/count_value AS NUMERIC) as statistic_value, 
    CAST('Provider:PatientProviderRatio' AS VARCHAR(255)) as measure_id
  from results.achilles_results
  cross join (select count_value as total_pts from results.achilles_results r where analysis_id =1) ct
  where analysis_id = 300
) Q
;
ANALYZE serial_rd_31 
;

--actual rule

CREATE TEMP TABLE serial_hr_31

AS
SELECT
*

FROM
(
  select * from serial_hr_29
  
  union all
  
  select 
    cast(null as int) as analysis_id,
    CAST('NOTIFICATION:[PLAUSIBILITY] database has too few providers defined (given the total patient number)' AS VARCHAR(255)) as achilles_heel_warning,
    31 as rule_id,
    cast(null as bigint) as record_count
  from serial_rd_31 d
  where d.measure_id = 'Provider:PatientProviderRatio'
  and d.statistic_value > 10000  --thresholds will be decided in the ongoing DQ-Study2
) Q
;
ANALYZE serial_hr_31
;


DROP TABLE IF EXISTS serial_rd_28;

DROP TABLE IF EXISTS serial_hr_29;

--rule32 DQ rule
--uses iris: patients with at least one visit visit 
--does 100-THE IRIS MEASURE to check for percentage of patients with no visits

CREATE TEMP TABLE serial_hr_32

AS
SELECT
*

FROM
(
  select * from serial_hr_31
  
  union all
  
  select 
    cast(null as int) as analysis_id,
    CAST('NOTIFICATION: Percentage of patients with no visits exceeds threshold' AS VARCHAR(255)) as achilles_heel_warning,
    32 as rule_id,
    cast(null as bigint) as record_count
  from serial_rd_31 d
  where d.measure_id = 'ach_2003:Percentage'
  and 100 - d.statistic_value > 27  --threshold identified in the DataQuality study
) Q
;
ANALYZE serial_hr_32
;


DROP TABLE IF EXISTS serial_hr_31;

--rule33 DQ rule (for general population only)
--NOTIFICATION: database does not have all age 0-80 represented


CREATE TEMP TABLE serial_hr_33

AS
SELECT
*

FROM
(
  select * from serial_hr_32
  
  union all
  
  select 
    cast(null as int) as analysis_id,
    CAST('NOTIFICATION: [GeneralPopulationOnly] Not all deciles represented at first observation' AS VARCHAR(255)) as achilles_heel_warning,
    33 as rule_id,
    cast(null as bigint) as record_count
  FROM serial_rd_31 d
  where d.measure_id = 'AgeAtFirstObsByDecile:DecileCnt' 
  and d.statistic_value < 9  --we expect deciles 0,1,2,3,4,5,6,7,8 
) Q
;
ANALYZE serial_hr_33
;


DROP TABLE IF EXISTS serial_hr_32;

--rule34 DQ rule
--NOTIFICATION: number of unmapped source values exceeds threshold
--related to rule 27 that looks at percentage of unmapped rows (rows as focus)
--this rule is looking at source values (as focus)


CREATE TEMP TABLE serial_hr_34

AS
SELECT
*

FROM
(
  select * from serial_hr_33
  
  union all
  
  select
    cast(null as int) as analysis_id,
    CAST(CONCAT('NOTIFICATION: Count of unmapped source values exceeds threshold in: ', cast(stratum_1 as varchar(100))) AS VARCHAR(255)) as ACHILLES_HEEL_warning,
    34 as rule_id,
    cast(statistic_value as int) as record_count
  FROM serial_rd_31 d
  where measure_id = 'UnmappedDataByDomain:SourceValueCnt'
  and statistic_value > 1000 --threshold will be decided in DQ study 2
) Q
;
ANALYZE serial_hr_34
;


DROP TABLE IF EXISTS serial_hr_33;

--rule35 DQ rule, NOTIFICATION
--this rule analyzes Units recorded for measurement
CREATE TEMP TABLE serial_hr_35

AS
SELECT
*

FROM
(
  select * from serial_hr_34
  
  union all
  
  select 
    cast(null as int) as analysis_id,
    achilles_heel_warning,
    rule_id,
    record_count
  from
  (
    SELECT
    CAST('NOTIFICATION: Count of measurement_ids with more than 5 distinct units  exceeds threshold' AS VARCHAR(255)) as ACHILLES_HEEL_warning,
    35 as rule_id,
    cast(meas_concept_id_cnt as int) as record_count
    from (
          select meas_concept_id_cnt from (select sum(freq) as meas_concept_id_cnt from
                          (select u_cnt, count(*) as freq from 
                                  (select stratum_1, count(*) as u_cnt
                                      from results.achilles_results where analysis_id = 1807 group by stratum_1) a
                                      group by u_cnt
                          ) b 
                  where u_cnt >= 5 --threshold one for the rule
              ) c
             where meas_concept_id_cnt >= 10 --threshold two for the rule
         ) d 
  ) Q
) A
;
ANALYZE serial_hr_35
;       


DROP TABLE IF EXISTS serial_hr_34;

--ruleid 36 WARNING: age > 125   (related to an error grade rule 21 that has higher threshold)
CREATE TEMP TABLE serial_hr_36

AS
SELECT
*

FROM
(
  select * from serial_hr_35
  
  union all
  
  SELECT or1.analysis_id,
  	CAST(CONCAT('WARNING: ', cast(or1.analysis_id as VARCHAR), '-', oa1.analysis_name, '; should not have age > 125, (n=', cast(sum(or1.count_value) as VARCHAR(19)), ')') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    36 as rule_id,
    sum(or1.count_value) as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  WHERE or1.analysis_id IN (101)
  	AND CAST(or1.stratum_1 AS INT) > 125
  	AND or1.count_value > 0
  GROUP BY or1.analysis_id,
    oa1.analysis_name
) Q
;
ANALYZE serial_hr_36
;


DROP TABLE IF EXISTS serial_hr_35;

--ruleid 37 DQ rule

--derived measure for this rule - ratio of notes over the number of visits

CREATE TEMP TABLE serial_rd_37

AS
SELECT
* 
FROM
(
  select * from serial_rd_31
  
  union all
  
  SELECT 
    cast(null as int) as analysis_id,
    cast(null as varchar(255)) as stratum_1,
    cast(null as varchar(255)) as stratum_2,
    CAST(1.0*c1.all_notes/1.0*c2.all_visits AS NUMERIC) as statistic_value, 
    CAST(  'Note:NoteVisitRatio' AS VARCHAR(255)) as measure_id
  FROM (SELECT sum(count_value) as all_notes FROM	results.achilles_results r WHERE analysis_id =2201 ) c1
  CROSS JOIN (SELECT sum(count_value) as all_visits FROM results.achilles_results r WHERE  analysis_id =201 ) c2
) A
;
ANALYZE serial_rd_37
;

--one co-author of the DataQuality study suggested measuring data density on visit level (in addition to 
-- patient and dataset level)
--Assumption is that at least one data event (e.g., diagnisis, note) is generated for each visit
--this rule is testing that at least some notes exist (considering the number of visits)
--for datasets with zero notes the derived measure is null and rule does not fire at all
--possible elaboration of this rule include number of inpatient notes given number of inpatient visits
--current rule is on overall data density (for notes only) per visit level


CREATE TEMP TABLE serial_hr_37

AS
SELECT
*

FROM
(
  select * from serial_hr_36
  
  union all
  
  select
    cast(null as int) as analysis_id,
    CAST('NOTIFICATION: Notes data density is below threshold' AS VARCHAR(255)) as ACHILLES_HEEL_warning,
    37 as rule_id,
    cast(statistic_value as int) as record_count
  FROM serial_rd_37 d
  where measure_id = 'Note:NoteVisitRatio'
  and statistic_value < 0.01 --threshold will be decided in DataQuality study
) Q
;
ANALYZE serial_hr_37
;


DROP TABLE IF EXISTS serial_rd_31;

DROP TABLE IF EXISTS serial_hr_36;

--ruleid 38 DQ rule; in a general dataset, it is expected that more than providers with a wide range of specialties 
--(at least more than just one specialty) is present
--notification  may indicate that provider table is missing data on specialty 
--typical dataset has at least 28 specialties present in provider table

CREATE TEMP TABLE serial_hr_38

AS
SELECT
*

FROM
(
  select * from serial_hr_37
  
  union all
  
  select
    cast(null as int) as analysis_id,
    CAST('NOTIFICATION: [GeneralPopulationOnly] Count of distinct specialties of providers in the PROVIDER table is below threshold' AS VARCHAR(255)) as ACHILLES_HEEL_warning,
    38 as rule_id,
    cast(statistic_value as int) as record_count
  FROM serial_rd_37 d
  where measure_id = 'Provider:SpeciatlyCnt'
  and statistic_value < 2 --DataQuality data indicate median of 55 specialties (percentile25 is 28; percentile10 is 2)
) Q
;
ANALYZE serial_hr_38
;


DROP TABLE IF EXISTS serial_hr_37;

--ruleid 39 DQ rule; Given lifetime record DQ assumption if more than 30k patients is born for every deceased patient
--the dataset may not be recording complete records for all senior patients in that year
--derived ratio measure Death:BornDeceasedRatio only exists for years where death data exist
--to avoid alerting on too early years such as 1925 where births exist but no deaths

CREATE TEMP TABLE serial_hr_39

AS
SELECT
*

FROM
(
  select * from serial_hr_38
  
  union all
  
  select
    cast(null as int) as analysis_id,
    CAST('NOTIFICATION: [GeneralPopulationOnly] In some years, number of deaths is too low considering the number of births (lifetime record DQ assumption)' AS VARCHAR(255)) as achilles_heel_warning,
    39 as rule_id,
    year_cnt as record_count 
  from
  (
    select count(*) as year_cnt 
    from serial_rd_37
    where measure_id =  'Death:BornDeceasedRatio' and statistic_value > 30000
  ) a
  where a.year_cnt > 0
) Q
;
ANALYZE serial_hr_39
;


DROP TABLE IF EXISTS serial_hr_38;

--ruleid 40  this rule was under umbrella rule 1 and was made into a separate rule

CREATE TEMP TABLE serial_hr_40

AS
SELECT
*

FROM
(
  select * from serial_hr_39
  
  union all
  
  SELECT DISTINCT or1.analysis_id,
  	CAST(CONCAT('ERROR: Death event outside observation period, ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; count (n=', cast(or1.count_value as VARCHAR), ') should not be > 0') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
  	40 as rule_id,
  	or1.count_value as record_count
  FROM results.achilles_results or1
  INNER JOIN results.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  WHERE or1.analysis_id IN (510)
  	AND or1.count_value > 0
) Q
;
ANALYZE serial_hr_40
;


DROP TABLE IF EXISTS serial_hr_39;

--ruleid 41 DQ rule, data density
--porting a Sentinel rule that checks for certain vital signs data (weight, in this case)
--multiple concepts_ids may be added to broaden the rule, however standardizing on a single
--concept would be more optimal
CREATE TEMP TABLE serial_hr_41

AS
SELECT
*

FROM
(
  select * from serial_hr_40
  
  union all
  
  select 
    cast(null as int) as analysis_id,
    CAST('NOTIFICATION:No body weight data in MEASUREMENT table (under concept_id 3025315 (LOINC code 29463-7))' AS VARCHAR(255)) as achilles_heel_warning,
    41 as rule_id,
    cast(null as bigint) as record_count
  from
  (
    select count(*) as row_present  
    from results.achilles_results
    where analysis_id = 1800 and stratum_1 = '3025315'
  ) a
  where a.row_present = 0
) Q
;
ANALYZE serial_hr_41
;


DROP TABLE IF EXISTS serial_hr_40;

--ruleid 42 DQ rule
--Percentage of outpatient visits (concept_id 9202) is too low (for general population).
--This may indicate a dataset with mostly inpatient data (that may be biased and missing some EHR events)
--Threshold was decided as 10th percentile in empiric comparison of 12 real world datasets in the DQ-Study2

CREATE TEMP TABLE serial_hr_42

AS
SELECT
*

FROM
(
  select * from serial_hr_41
  
  union all
  
  select 
    cast(null as int) as analysis_id,
    CAST('NOTIFICATION: [GeneralPopulationOnly] Percentage of outpatient visits is below threshold' AS VARCHAR(255)) as achilles_heel_warning,
    42 as rule_id,
    cast(null as bigint) as record_count
  from
  (
    select 
      1.0*achilles_results.count_value/c1.count_value as outp_perc
    from results.achilles_results
		cross join (select sum(count_value) as count_value from results.achilles_results where analysis_id = 201) c1
	  where analysis_id = 201 and stratum_1='9202'
  ) d
  where d.outp_perc < 0.43
) Q
;
ANALYZE serial_hr_42
;


DROP TABLE IF EXISTS serial_hr_41;

--ruleid 43 DQ rule
--looks at observation period data, if all patients have exactly one the rule alerts the user
--This rule is based on majority of real life datasets. 
--For some datasets (e.g., UK national data with single payor, one observation period is perfectly valid)

CREATE TEMP TABLE serial_hr_43

AS
SELECT
*

FROM
(
  select * from serial_hr_42
  
  union all
  
  select 
    cast(null as int) as analysis_id,
    CAST('NOTIFICATION: 99+ percent of persons have exactly one observation period' AS VARCHAR(255)) as achilles_heel_warning,
    43 as rule_id,
    cast(null as bigint) as record_count
  from
  (
    select
      100.0*achilles_results.count_value/ct.total_pts as one_obs_per_perc
    from results.achilles_results
	  cross join (select count_value as total_pts from results.achilles_results r where analysis_id =1) as ct
	  where analysis_id = 113 and stratum_1 = '1'
  ) d
  where d.one_obs_per_perc >= 99.0
) Q
;
ANALYZE serial_hr_43
;


DROP TABLE IF EXISTS serial_hr_42;

--ruleid 44 DQ rule
--uses iris measure: patients with at least 1 Meas, 1 Dx and 1 Rx 

CREATE TEMP TABLE serial_hr_44

AS
SELECT
*

FROM
(
  select * from serial_hr_43
  
  union all
  
  SELECT 
    cast(null as int) as analysis_id,
    CAST('NOTIFICATION: Percentage of patients with at least 1 Measurement, 1 Dx and 1 Rx is below threshold' AS VARCHAR(255)) as ACHILLES_HEEL_warning,
    44 as rule_id,
    cast(null as bigint) as record_count
  FROM serial_rd_37 d
  where d.measure_id = 'ach_2002:Percentage'
  and d.statistic_value < 20.5  --threshold identified in the DataQuality study
) Q
;
ANALYZE serial_hr_44
;


DROP TABLE IF EXISTS serial_hr_43;

DROP TABLE IF EXISTS results.achilles_results_derived;

CREATE TABLE results.achilles_results_derived
 AS
SELECT
analysis_id, 
	stratum_1,
	stratum_2,
	statistic_value,
	measure_id

FROM
(
  select * from serial_rd_37
) Q
;


DROP TABLE IF EXISTS results.achilles_heel_results;

CREATE TABLE results.achilles_heel_results
 AS
SELECT
distinct
  analysis_id,
	achilles_heel_warning,
	rule_id,
	record_count

FROM
(
  select * from serial_hr_44
) Q
;
