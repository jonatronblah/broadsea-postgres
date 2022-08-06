SET search_path to 'cdm';

CREATE UNIQUE INDEX IDX_CONCEPT_CONCEPT_ID  ON cdm.CONCEPT  (CONCEPT_ID ASC);
CLUSTER CONCEPT  USING IDX_CONCEPT_CONCEPT_ID ;
CREATE INDEX IDX_CONCEPT_CODE ON cdm.CONCEPT (CONCEPT_CODE ASC);
CREATE INDEX IDX_CONCEPT_VOCABLUARY_ID ON cdm.CONCEPT (VOCABULARY_ID ASC);
CREATE INDEX IDX_CONCEPT_DOMAIN_ID ON cdm.CONCEPT (DOMAIN_ID ASC);
CREATE INDEX IDX_CONCEPT_CLASS_ID ON cdm.CONCEPT (CONCEPT_CLASS_ID ASC);

CREATE UNIQUE INDEX IDX_VOCABULARY_VOCABULARY_ID  ON cdm.VOCABULARY  (VOCABULARY_ID ASC);
CLUSTER VOCABULARY  USING IDX_VOCABULARY_VOCABULARY_ID ;

CREATE UNIQUE INDEX IDX_DOMAIN_DOMAIN_ID  ON cdm.DOMAIN  (DOMAIN_ID ASC);
CLUSTER DOMAIN  USING IDX_DOMAIN_DOMAIN_ID ;

CREATE UNIQUE INDEX IDX_CONCEPT_CLASS_CLASS_ID  ON cdm.CONCEPT_CLASS  (CONCEPT_CLASS_ID ASC);
CLUSTER CONCEPT_CLASS  USING IDX_CONCEPT_CLASS_CLASS_ID ;

CREATE INDEX IDX_CONCEPT_RELATIONSHIP_ID_1 ON cdm.CONCEPT_RELATIONSHIP (CONCEPT_ID_1 ASC);
CREATE INDEX IDX_CONCEPT_RELATIONSHIP_ID_2 ON cdm.CONCEPT_RELATIONSHIP (CONCEPT_ID_2 ASC);
CREATE INDEX IDX_CONCEPT_RELATIONSHIP_ID_3 ON cdm.CONCEPT_RELATIONSHIP (RELATIONSHIP_ID ASC);

CREATE UNIQUE INDEX IDX_RELATIONSHIP_REL_ID  ON cdm.RELATIONSHIP  (RELATIONSHIP_ID ASC);
CLUSTER RELATIONSHIP  USING IDX_RELATIONSHIP_REL_ID ;

CREATE INDEX IDX_CONCEPT_SYNONYM_ID  ON cdm.CONCEPT_SYNONYM  (CONCEPT_ID ASC);
CLUSTER CONCEPT_SYNONYM  USING IDX_CONCEPT_SYNONYM_ID ;

CREATE INDEX IDX_CONCEPT_ANCESTOR_ID_1  ON cdm.CONCEPT_ANCESTOR  (ANCESTOR_CONCEPT_ID ASC);
CLUSTER CONCEPT_ANCESTOR  USING IDX_CONCEPT_ANCESTOR_ID_1 ;
CREATE INDEX IDX_CONCEPT_ANCESTOR_ID_2 ON cdm.CONCEPT_ANCESTOR (DESCENDANT_CONCEPT_ID ASC);

CREATE INDEX IDX_SOURCE_TO_CONCEPT_MAP_ID_3  ON cdm.SOURCE_TO_CONCEPT_MAP  (TARGET_CONCEPT_ID ASC);
CLUSTER SOURCE_TO_CONCEPT_MAP  USING IDX_SOURCE_TO_CONCEPT_MAP_ID_3 ;
CREATE INDEX IDX_SOURCE_TO_CONCEPT_MAP_ID_1 ON cdm.SOURCE_TO_CONCEPT_MAP (SOURCE_VOCABULARY_ID ASC);
CREATE INDEX IDX_SOURCE_TO_CONCEPT_MAP_ID_2 ON cdm.SOURCE_TO_CONCEPT_MAP (TARGET_VOCABULARY_ID ASC);
CREATE INDEX IDX_SOURCE_TO_CONCEPT_MAP_CODE ON cdm.SOURCE_TO_CONCEPT_MAP (SOURCE_CODE ASC);

CREATE INDEX IDX_DRUG_STRENGTH_ID_1  ON cdm.DRUG_STRENGTH  (DRUG_CONCEPT_ID ASC);
CLUSTER DRUG_STRENGTH  USING IDX_DRUG_STRENGTH_ID_1 ;
CREATE INDEX IDX_DRUG_STRENGTH_ID_2 ON cdm.DRUG_STRENGTH (INGREDIENT_CONCEPT_ID ASC);

CREATE INDEX IDX_COHORT_DEFINITION_ID  ON cdm.COHORT_DEFINITION  (COHORT_DEFINITION_ID ASC);
CLUSTER COHORT_DEFINITION  USING IDX_COHORT_DEFINITION_ID ;

CREATE INDEX IDX_ATTRIBUTE_DEFINITION_ID  ON cdm.ATTRIBUTE_DEFINITION  (ATTRIBUTE_DEFINITION_ID ASC);
CLUSTER ATTRIBUTE_DEFINITION  USING IDX_ATTRIBUTE_DEFINITION_ID ;


/**************************

STANDARDIZED META-DATA

***************************/





/************************

STANDARDIZED CLINICAL DATA

************************/

CREATE UNIQUE INDEX IDX_PERSON_ID  ON cdm.PERSON  (PERSON_ID ASC);
CLUSTER PERSON  USING IDX_PERSON_ID ;

CREATE INDEX IDX_OBSERVATION_PERIOD_ID  ON cdm.OBSERVATION_PERIOD  (PERSON_ID ASC);
CLUSTER OBSERVATION_PERIOD  USING IDX_OBSERVATION_PERIOD_ID ;

CREATE INDEX IDX_SPECIMEN_PERSON_ID  ON cdm.SPECIMEN  (PERSON_ID ASC);
CLUSTER SPECIMEN  USING IDX_SPECIMEN_PERSON_ID ;
CREATE INDEX IDX_SPECIMEN_CONCEPT_ID ON cdm.SPECIMEN (SPECIMEN_CONCEPT_ID ASC);

CREATE INDEX IDX_DEATH_PERSON_ID  ON cdm.DEATH  (PERSON_ID ASC);
CLUSTER DEATH  USING IDX_DEATH_PERSON_ID ;

CREATE INDEX IDX_VISIT_PERSON_ID  ON cdm.VISIT_OCCURRENCE  (PERSON_ID ASC);
CLUSTER VISIT_OCCURRENCE  USING IDX_VISIT_PERSON_ID ;
CREATE INDEX IDX_VISIT_CONCEPT_ID ON cdm.VISIT_OCCURRENCE (VISIT_CONCEPT_ID ASC);

CREATE INDEX IDX_VISIT_DETAIL_PERSON_ID  ON cdm.VISIT_DETAIL  (PERSON_ID ASC);
CLUSTER VISIT_DETAIL  USING IDX_VISIT_DETAIL_PERSON_ID ;
CREATE INDEX IDX_VISIT_DETAIL_CONCEPT_ID ON cdm.VISIT_DETAIL (VISIT_DETAIL_CONCEPT_ID ASC);

CREATE INDEX IDX_PROCEDURE_PERSON_ID  ON cdm.PROCEDURE_OCCURRENCE  (PERSON_ID ASC);
CLUSTER PROCEDURE_OCCURRENCE  USING IDX_PROCEDURE_PERSON_ID ;
CREATE INDEX IDX_PROCEDURE_CONCEPT_ID ON cdm.PROCEDURE_OCCURRENCE (PROCEDURE_CONCEPT_ID ASC);
CREATE INDEX IDX_PROCEDURE_VISIT_ID ON cdm.PROCEDURE_OCCURRENCE (VISIT_OCCURRENCE_ID ASC);

CREATE INDEX IDX_DRUG_PERSON_ID  ON cdm.DRUG_EXPOSURE  (PERSON_ID ASC);
CLUSTER DRUG_EXPOSURE  USING IDX_DRUG_PERSON_ID ;
CREATE INDEX IDX_DRUG_CONCEPT_ID ON cdm.DRUG_EXPOSURE (DRUG_CONCEPT_ID ASC);
CREATE INDEX IDX_DRUG_VISIT_ID ON cdm.DRUG_EXPOSURE (VISIT_OCCURRENCE_ID ASC);

CREATE INDEX IDX_DEVICE_PERSON_ID  ON cdm.DEVICE_EXPOSURE  (PERSON_ID ASC);
CLUSTER DEVICE_EXPOSURE  USING IDX_DEVICE_PERSON_ID ;
CREATE INDEX IDX_DEVICE_CONCEPT_ID ON cdm.DEVICE_EXPOSURE (DEVICE_CONCEPT_ID ASC);
CREATE INDEX IDX_DEVICE_VISIT_ID ON cdm.DEVICE_EXPOSURE (VISIT_OCCURRENCE_ID ASC);

CREATE INDEX IDX_CONDITION_PERSON_ID  ON cdm.CONDITION_OCCURRENCE  (PERSON_ID ASC);
CLUSTER CONDITION_OCCURRENCE  USING IDX_CONDITION_PERSON_ID ;
CREATE INDEX IDX_CONDITION_CONCEPT_ID ON cdm.CONDITION_OCCURRENCE (CONDITION_CONCEPT_ID ASC);
CREATE INDEX IDX_CONDITION_VISIT_ID ON cdm.CONDITION_OCCURRENCE (VISIT_OCCURRENCE_ID ASC);

CREATE INDEX IDX_MEASUREMENT_PERSON_ID  ON cdm.MEASUREMENT  (PERSON_ID ASC);
CLUSTER MEASUREMENT  USING IDX_MEASUREMENT_PERSON_ID ;
CREATE INDEX IDX_MEASUREMENT_CONCEPT_ID ON cdm.MEASUREMENT (MEASUREMENT_CONCEPT_ID ASC);
CREATE INDEX IDX_MEASUREMENT_VISIT_ID ON cdm.MEASUREMENT (VISIT_OCCURRENCE_ID ASC);

CREATE INDEX IDX_NOTE_PERSON_ID  ON cdm.NOTE  (PERSON_ID ASC);
CLUSTER NOTE  USING IDX_NOTE_PERSON_ID ;
CREATE INDEX IDX_NOTE_CONCEPT_ID ON cdm.NOTE (NOTE_TYPE_CONCEPT_ID ASC);
CREATE INDEX IDX_NOTE_VISIT_ID ON cdm.NOTE (VISIT_OCCURRENCE_ID ASC);

CREATE INDEX IDX_NOTE_NLP_NOTE_ID  ON cdm.NOTE_NLP  (NOTE_ID ASC);
CLUSTER NOTE_NLP  USING IDX_NOTE_NLP_NOTE_ID ;
CREATE INDEX IDX_NOTE_NLP_CONCEPT_ID ON cdm.NOTE_NLP (NOTE_NLP_CONCEPT_ID ASC);

CREATE INDEX IDX_OBSERVATION_PERSON_ID  ON cdm.OBSERVATION  (PERSON_ID ASC);
CLUSTER OBSERVATION  USING IDX_OBSERVATION_PERSON_ID ;
CREATE INDEX IDX_OBSERVATION_CONCEPT_ID ON cdm.OBSERVATION (OBSERVATION_CONCEPT_ID ASC);
CREATE INDEX IDX_OBSERVATION_VISIT_ID ON cdm.OBSERVATION (VISIT_OCCURRENCE_ID ASC);

CREATE INDEX IDX_FACT_RELATIONSHIP_ID_1 ON cdm.FACT_RELATIONSHIP (DOMAIN_CONCEPT_ID_1 ASC);
CREATE INDEX IDX_FACT_RELATIONSHIP_ID_2 ON cdm.FACT_RELATIONSHIP (DOMAIN_CONCEPT_ID_2 ASC);
CREATE INDEX IDX_FACT_RELATIONSHIP_ID_3 ON cdm.FACT_RELATIONSHIP (RELATIONSHIP_CONCEPT_ID ASC);



/************************

STANDARDIZED HEALTH SYSTEM DATA

************************/





/************************

STANDARDIZED HEALTH ECONOMICS

************************/

CREATE INDEX IDX_PERIOD_PERSON_ID  ON cdm.PAYER_PLAN_PERIOD  (PERSON_ID ASC);
CLUSTER PAYER_PLAN_PERIOD  USING IDX_PERIOD_PERSON_ID ;





/************************

STANDARDIZED DERIVED ELEMENTS

************************/


CREATE INDEX IDX_COHORT_SUBJECT_ID ON cdm.COHORT (SUBJECT_ID ASC);
CREATE INDEX IDX_COHORT_C_DEFINITION_ID ON cdm.COHORT (COHORT_DEFINITION_ID ASC);

CREATE INDEX IDX_CA_SUBJECT_ID ON cdm.COHORT_ATTRIBUTE (SUBJECT_ID ASC);
CREATE INDEX IDX_CA_DEFINITION_ID ON cdm.COHORT_ATTRIBUTE (COHORT_DEFINITION_ID ASC);

CREATE INDEX IDX_DRUG_ERA_PERSON_ID  ON cdm.DRUG_ERA  (PERSON_ID ASC);
CLUSTER DRUG_ERA  USING IDX_DRUG_ERA_PERSON_ID ;
CREATE INDEX IDX_DRUG_ERA_CONCEPT_ID ON cdm.DRUG_ERA (DRUG_CONCEPT_ID ASC);

CREATE INDEX IDX_DOSE_ERA_PERSON_ID  ON cdm.DOSE_ERA  (PERSON_ID ASC);
CLUSTER DOSE_ERA  USING IDX_DOSE_ERA_PERSON_ID ;
CREATE INDEX IDX_DOSE_ERA_CONCEPT_ID ON cdm.DOSE_ERA (DRUG_CONCEPT_ID ASC);

CREATE INDEX IDX_CONDITION_ERA_PERSON_ID  ON cdm.CONDITION_ERA  (PERSON_ID ASC);
CLUSTER CONDITION_ERA  USING IDX_CONDITION_ERA_PERSON_ID ;
CREATE INDEX IDX_CONDITION_ERA_CONCEPT_ID ON cdm.CONDITION_ERA (CONDITION_CONCEPT_ID ASC);

