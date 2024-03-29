/*********************************************************************************
# COPYRIGHT 2014 OBSERVATIONAL HEALTH DATA SCIENCES AND INFORMATICS
#
#
# LICENSED UNDER THE APACHE LICENSE, VERSION 2.0 (THE "LICENSE");
# YOU MAY NOT USE THIS FILE EXCEPT IN COMPLIANCE WITH THE LICENSE.
# YOU MAY OBTAIN A COPY OF THE LICENSE AT
#
#     HTTP://WWW.APACHE.ORG/LICENSES/LICENSE-2.0
#
# UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING, SOFTWARE
# DISTRIBUTED UNDER THE LICENSE IS DISTRIBUTED ON cdm.AN "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
# SEE THE LICENSE FOR THE SPECIFIC LANGUAGE GOVERNING PERMISSIONS AND
# LIMITATIONS UNDER THE LICENSE.
********************************************************************************/

/************************

 ####### #     # ####### ######      #####  ######  #     #           #######      #####     ###
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #           #     #     #  #    # #####  ###### #    # ######  ####
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #                 #     #  ##   # #    # #       #  #  #      #
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######       #####      #  # #  # #    # #####    ##   #####   ####
 #     # #     # #     # #          #       #     # #     #    #    #       # ###       #     #  #  # # #    # #        ##   #           #
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ### #     #     #  #   ## #    # #       #  #  #      #    #
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ###  #####     ### #    # #####  ###### #    # ######  ####


POSTGRESQL SCRIPT TO CREATE THE REQUIRED INDEXES WITHIN OMOP COMMON DATA MODEL, VERSION 5.3

LAST REVISED: 14-NOVEMBER-2017

AUTHOR:  PATRICK RYAN, CLAIR BLACKETER

DESCRIPTION:  THESE PRIMARY KEYS AND INDICES ARE CONSIDERED A MINIMAL REQUIREMENT TO ENSURE ADEQUATE PERFORMANCE OF ANALYSES.

*************************/


/************************
*************************
*************************
*************************

PRIMARY KEY CONSTRAINTS

*************************
*************************
*************************
************************/



/************************

STANDARDIZED VOCABULARY

************************/



ALTER TABLE cdm.CONCEPT ADD CONSTRAINT XPK_CONCEPT PRIMARY KEY (CONCEPT_ID);

ALTER TABLE cdm.VOCABULARY ADD CONSTRAINT XPK_VOCABULARY PRIMARY KEY (VOCABULARY_ID);

ALTER TABLE cdm.DOMAIN ADD CONSTRAINT XPK_DOMAIN PRIMARY KEY (DOMAIN_ID);

ALTER TABLE cdm.CONCEPT_CLASS ADD CONSTRAINT XPK_CONCEPT_CLASS PRIMARY KEY (CONCEPT_CLASS_ID);

ALTER TABLE cdm.CONCEPT_RELATIONSHIP ADD CONSTRAINT XPK_CONCEPT_RELATIONSHIP PRIMARY KEY (CONCEPT_ID_1,CONCEPT_ID_2,RELATIONSHIP_ID);

ALTER TABLE cdm.RELATIONSHIP ADD CONSTRAINT XPK_RELATIONSHIP PRIMARY KEY (RELATIONSHIP_ID);

ALTER TABLE cdm.CONCEPT_ANCESTOR ADD CONSTRAINT XPK_CONCEPT_ANCESTOR PRIMARY KEY (ANCESTOR_CONCEPT_ID,DESCENDANT_CONCEPT_ID);

ALTER TABLE cdm.SOURCE_TO_CONCEPT_MAP ADD CONSTRAINT XPK_SOURCE_TO_CONCEPT_MAP PRIMARY KEY (SOURCE_VOCABULARY_ID,TARGET_CONCEPT_ID,SOURCE_CODE,VALID_END_DATE);

ALTER TABLE cdm.DRUG_STRENGTH ADD CONSTRAINT XPK_DRUG_STRENGTH PRIMARY KEY (DRUG_CONCEPT_ID, INGREDIENT_CONCEPT_ID);

ALTER TABLE cdm.COHORT_DEFINITION ADD CONSTRAINT XPK_COHORT_DEFINITION PRIMARY KEY (COHORT_DEFINITION_ID);

ALTER TABLE cdm.ATTRIBUTE_DEFINITION ADD CONSTRAINT XPK_ATTRIBUTE_DEFINITION PRIMARY KEY (ATTRIBUTE_DEFINITION_ID);


/**************************

STANDARDIZED META-DATA

***************************/



/************************

STANDARDIZED CLINICAL DATA

************************/


/**PRIMARY KEY NONCLUSTERED CONSTRAINTS**/

ALTER TABLE cdm.PERSON ADD CONSTRAINT XPK_PERSON PRIMARY KEY ( PERSON_ID ) ;

ALTER TABLE cdm.OBSERVATION_PERIOD ADD CONSTRAINT XPK_OBSERVATION_PERIOD PRIMARY KEY ( OBSERVATION_PERIOD_ID ) ;

ALTER TABLE cdm.SPECIMEN ADD CONSTRAINT XPK_SPECIMEN PRIMARY KEY ( SPECIMEN_ID ) ;

ALTER TABLE cdm.DEATH ADD CONSTRAINT XPK_DEATH PRIMARY KEY ( PERSON_ID ) ;

ALTER TABLE cdm.VISIT_OCCURRENCE ADD CONSTRAINT XPK_VISIT_OCCURRENCE PRIMARY KEY ( VISIT_OCCURRENCE_ID ) ;

ALTER TABLE cdm.VISIT_DETAIL ADD CONSTRAINT XPK_VISIT_DETAIL PRIMARY KEY ( VISIT_DETAIL_ID ) ;

ALTER TABLE cdm.PROCEDURE_OCCURRENCE ADD CONSTRAINT XPK_PROCEDURE_OCCURRENCE PRIMARY KEY ( PROCEDURE_OCCURRENCE_ID ) ;

ALTER TABLE cdm.DRUG_EXPOSURE ADD CONSTRAINT XPK_DRUG_EXPOSURE PRIMARY KEY ( DRUG_EXPOSURE_ID ) ;

ALTER TABLE cdm.DEVICE_EXPOSURE ADD CONSTRAINT XPK_DEVICE_EXPOSURE PRIMARY KEY ( DEVICE_EXPOSURE_ID ) ;

ALTER TABLE cdm.CONDITION_OCCURRENCE ADD CONSTRAINT XPK_CONDITION_OCCURRENCE PRIMARY KEY ( CONDITION_OCCURRENCE_ID ) ;

ALTER TABLE cdm.MEASUREMENT ADD CONSTRAINT XPK_MEASUREMENT PRIMARY KEY ( MEASUREMENT_ID ) ;

ALTER TABLE cdm.NOTE ADD CONSTRAINT XPK_NOTE PRIMARY KEY ( NOTE_ID ) ;

ALTER TABLE cdm.NOTE_NLP ADD CONSTRAINT XPK_NOTE_NLP PRIMARY KEY ( NOTE_NLP_ID ) ;

ALTER TABLE cdm.OBSERVATION  ADD CONSTRAINT XPK_OBSERVATION PRIMARY KEY ( OBSERVATION_ID ) ;




/************************

STANDARDIZED HEALTH SYSTEM DATA

************************/


ALTER TABLE cdm.LOCATION ADD CONSTRAINT XPK_LOCATION PRIMARY KEY ( LOCATION_ID ) ;

ALTER TABLE cdm.CARE_SITE ADD CONSTRAINT XPK_CARE_SITE PRIMARY KEY ( CARE_SITE_ID ) ;

ALTER TABLE cdm.PROVIDER ADD CONSTRAINT XPK_PROVIDER PRIMARY KEY ( PROVIDER_ID ) ;



/************************

STANDARDIZED HEALTH ECONOMICS

************************/


ALTER TABLE cdm.PAYER_PLAN_PERIOD ADD CONSTRAINT XPK_PAYER_PLAN_PERIOD PRIMARY KEY ( PAYER_PLAN_PERIOD_ID ) ;

ALTER TABLE cdm.COST ADD CONSTRAINT XPK_VISIT_COST PRIMARY KEY ( COST_ID ) ;


/************************

STANDARDIZED DERIVED ELEMENTS

************************/

ALTER TABLE cdm.COHORT ADD CONSTRAINT XPK_COHORT PRIMARY KEY ( COHORT_DEFINITION_ID, SUBJECT_ID, COHORT_START_DATE, COHORT_END_DATE  ) ;

ALTER TABLE cdm.COHORT_ATTRIBUTE ADD CONSTRAINT XPK_COHORT_ATTRIBUTE PRIMARY KEY ( COHORT_DEFINITION_ID, SUBJECT_ID, COHORT_START_DATE, COHORT_END_DATE, ATTRIBUTE_DEFINITION_ID ) ;

ALTER TABLE cdm.DRUG_ERA ADD CONSTRAINT XPK_DRUG_ERA PRIMARY KEY ( DRUG_ERA_ID ) ;

ALTER TABLE cdm.DOSE_ERA  ADD CONSTRAINT XPK_DOSE_ERA PRIMARY KEY ( DOSE_ERA_ID ) ;

ALTER TABLE cdm.CONDITION_ERA ADD CONSTRAINT XPK_CONDITION_ERA PRIMARY KEY ( CONDITION_ERA_ID ) ;


/************************
*************************
*************************
*************************

INDICES

*************************
*************************
*************************
************************/

/************************

STANDARDIZED VOCABULARY

************************/

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

