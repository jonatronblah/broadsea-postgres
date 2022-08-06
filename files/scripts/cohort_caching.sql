/*
ALTER TABLE @results_schema.cohort_inclusion ADD design_hash int NULL;

ALTER TABLE @results_schema.cc_results ADD aggregate_id int NULL;
ALTER TABLE @results_schema.cc_results ADD aggregate_name varchar(1000);
ALTER TABLE @results_schema.cc_results ADD missing_means_zero int NULL;
*/

CREATE TABLE IF NOT EXISTS @results_schema.cohort_cache (
	design_hash int NOT NULL,
	SUBJECT_ID bigint NOT NULL,
	cohort_start_date date NOT NULL,
	cohort_end_date date NOT NULL
);

CREATE TABLE IF NOT EXISTS @results_schema.cohort_censor_stats_cache (
  design_hash int NOT NULL,
  lost_count BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS @results_schema.cohort_inclusion_result_cache (
  design_hash int NOT NULL,
  mode_id int NOT NULL,
  inclusion_rule_mask bigint NOT NULL,
  person_count bigint NOT NULL
);

CREATE TABLE IF NOT EXISTS @results_schema.cohort_inclusion_stats_cache (
  design_hash int NOT NULL,
  rule_sequence int NOT NULL,
  mode_id int NOT NULL,
  person_count bigint NOT NULL,
  gain_count bigint NOT NULL,
  person_total bigint NOT NULL
);

CREATE TABLE IF NOT EXISTS @results_schema.cohort_summary_stats_cache (
  design_hash int NOT NULL,
  mode_id int NOT NULL,
  base_count bigint NOT NULL,
  final_count bigint NOT NULL
);

CREATE TABLE IF NOT EXISTS @results_schema.cohort_sample_element (
    cohort_sample_id int NOT NULL, 
    rank_value int NOT NULL, 
    person_id bigint NOT NULL, 
    age int NULL, 
    gender_concept_id int NULL
);
