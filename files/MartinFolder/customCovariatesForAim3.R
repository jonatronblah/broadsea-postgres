library(FeatureExtraction)
library(DatabaseConnector)
library(Andromeda)
library(tidyverse)

cd <- DatabaseConnector::createConnectionDetails(
  dbms     = "postgresql",
  server   = "db/db",
  user     = "grover",
  password = "babybun",
  port     = 5432,
  pathToDriver = '/home/rstudio/misc'
)

connection <- DatabaseConnector::connect(cd)

#create condition concepts
covConditionConcepts <- c(
  201820, #diabetes mellitus
  316866, #hypertensive disease
  46271022, #chronic kidney disease
  316139, #heart failure
  321588, #heart disease
  255573, #Chronic obstructive lung disease
  4217975, #normal Pregnancy
  4001336, #concussion
  4208104, #drug overdose
  441542, #anxiety
  80502, #osteoporosis
  317009, #asthma
  257012, #chronic sinusitis
  4291025, #arthritis
  318736, #migraine
  36714559, #disease caused by alcohol
  435875, #Complication of pregnancy, childbirth and/or the puerperium
  381591, #Cerebrovascular disease
  4182210, #dementia
  4056622, #chronic uniary tract disease
  132797, #sepsis
  436096, #chronic pain
  439777, #anemia
  81251, #neoplasm of breast
  4130995, #neoplasm of colon
  4028253, #neoplasm of digestive system
  4054836, #Neoplasm of intrathoracic organs
  4129902, #neoplasm of prostate
  4131598, #neoplasm of intestinal tract
  4133974, #Neoplasm of abdomen
  4128888, #neoplasm of lung
  196931, #Neoplasm of digestive tract
  252280, #Neoplasm of respiratory tract
  4054501, #Neoplasm of trunk
  4054503, #Neoplasm of intra-abdominal organs
  4111798, #Neoplasm of digestive organ
  4112735, #Neoplasm of lower respiratory tract
  4129898, #Neoplasm of male genital organ
  4130514, #Neoplasm of large intestine
  4054839, #Neoplasm of pelvis
  4111018, #Neoplasm of thorax
  4130373 #Neoplasm of gastrointestinal tract
)

covConditionConcepts <- as.numeric(paste0(covConditionConcepts, "210"))

#create drug concepts
covDrugConcepts <- c(
  21600961, #ANTITHROMBOTIC AGENTS
  21604254, #OPIOIDS
  21604686, #ANTIDEPRESSANTS
  21601665, #Beta blocking agents
  21600744, #blood glucose lowering drugs
  21600713, # INSULINS AND ANALOGUES
  21601854, #Lipid modifying agents plain
  21602471, #SEX HORMONES AND MODULATORS OF THE GENITAL SYSTEM
  21601783, #ace inhibitors
  21601744, #calcium channel blockers
  21603553, #antibiotics
  21603248 #DRUGS FOR OBSTRUCTIVE AIRWAY DISEASES
)

covDrugConcepts <- as.numeric(paste0(covDrugConcepts, "410"))


miscCov <- c(
  4060985802, #BMI 30+ obesity Observation
  4249893502 #colonoscopy procedure
)

##demographic 
demographicCov <- c(8507001, #gender Male
                    8532001, #gender Female
                    8515004, #race asian
                    8527004, #race white
                    8516004, #race black
                    seq(3003,21003, 1000) #age groups 15-19 to 105-109
                    )



#counts and scores
countCov <- c(1901, 1902, 1904, 1905, 1908, 1911, 1914, 1917, 1926, 9202923, 9203923, 9201923)

#combine concepts 
covConceptsAll <- c(covConditionConcepts, covDrugConcepts, demographicCov, countCov, miscCov)

covariateSettings <- createCovariateSettings(
  useDemographicsGender = TRUE,
  useDemographicsAgeGroup = TRUE,
  useDemographicsRace = TRUE,
  useConditionGroupEraLongTerm = TRUE,
  useDrugGroupEraLongTerm = TRUE,
  useProcedureOccurrenceLongTerm = TRUE,
  useObservationLongTerm = TRUE,
  useCharlsonIndex = TRUE,
  useDcsi = TRUE,
  useChads2Vasc = TRUE,
  useHfrs = TRUE,
  useDistinctConditionCountLongTerm = TRUE,
  useDistinctIngredientCountLongTerm = TRUE,
  useDistinctMeasurementCountLongTerm = TRUE,
  useDistinctProcedureCountLongTerm = TRUE,
  useDistinctObservationCountLongTerm = TRUE,
  useVisitConceptCountLongTerm = TRUE,
  longTermStartDays = -730,
  includedCovariateIds = covConceptsAll
)


covariateData <- getDbCovariateData(connectionDetails = cd,
                                    cdmDatabaseSchema = "cdm",
                                    cohortDatabaseSchema = "ohdsi",
                                    cohortTable = "COHORT",
                                    cohortId = 4L,
                                    rowIdField = "subject_id",
                                    covariateSettings = covariateSettings)

#connect to sql lite db
library(RSQLite)
sqlite <- DBI::dbDriver("SQLite")


featuredb <- DBI::dbConnect(sqlite, covariateData@dbname)
cov <- DBI::dbGetQuery(featuredb, "SELECT * FROM covariates")
analRef <- DBI::dbGetQuery(featuredb, "SELECT * FROM analysisRef")
covRef <- DBI::dbGetQuery(featuredb, "SELECT * FROM covariateRef")

#get final covariates
source("~/MartinFolder/functionsForCovariates.R")

covDatFinal <- cov %>%
  left_join(covRef, by = c("covariateId")) %>%
  dplyr::select(rowId, covariateId, covariateValue) %>%
  pivot_wider(names_from = covariateId, names_glue = "CovId_{covariateId}",
              values_from = covariateValue, values_fill = 0) %>%
  convertAgeCovs() %>%
  convertGenderCovs() %>%
  convertRaceCovs()




