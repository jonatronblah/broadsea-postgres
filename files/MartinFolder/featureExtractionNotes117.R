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

covariateSettings <- createCovariateSettings(
  useDemographicsGender = TRUE,
  useDemographicsAgeGroup = TRUE,
  useDemographicsRace = TRUE,
  useConditionGroupEraLongTerm = TRUE,
  useDrugGroupEraLongTerm = TRUE,
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
  longTermStartDays = -730
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

convertAgeCovs <- function(dat) {
  dat %>%
    mutate(
      age_group = case_when(
        CovId_3003 == 1 ~ 1, #age group 15-19
        CovId_4003 == 1 ~ 1, #age group 20-24
        CovId_5003 == 1 ~ 1, #age group 25-29
        CovId_6003 == 1 ~ 1, #age group 30-34
        CovId_7003 == 1 ~ 2, #age group 35-39
        CovId_8003 == 1 ~ 2, #age group 40-44
        CovId_9003 == 1 ~ 2, #age group 45-49
        CovId_10003 == 1 ~ 3, #age group 50-54
        CovId_11003 == 1 ~ 3, #age group 55-59
        CovId_12003 == 1 ~ 3, #age group 60-64
        CovId_13003 == 1 ~ 4, #age group 65-69
        CovId_14003 == 1 ~ 4, #age group 70-74
        CovId_15003 == 1 ~ 4, #age group 75-79
        CovId_16003 == 1 ~ 4, #age group 80-84
        CovId_17003 == 1 ~ 4, #age group 85-89
        CovId_18003 == 1 ~ 4, #age group 90-94
        CovId_19003 == 1 ~ 4, #age group 95-99
        CovId_20003 == 1 ~ 4, #age group 100-104
        CovId_21003 == 1 ~ 4 #age group 105-109
      ),
      .keep = "unused"
    )
}

convertGenderCovs <- function(dat) {
  dat %>%
    mutate(
      gender_group = case_when(
        CovId_8507001 == 1 ~ 1, #male
        CovId_8532001 == 1 ~ 2 #female
      ),
      .keep = "unused"
    )
}

convertRaceCovs <- function(dat) {
  dat %>%
    mutate(
      race_group = case_when(
        CovId_8515004 == 1 ~ 1, #asian
        CovId_8516004 == 1 ~ 2, #black
        CovId_8527004 == 1 ~ 3, #white
        TRUE ~ 4 #other
      ),
      .keep = "unused"
    )
}



covariateSummary <- function(covData, covId, covRef) {
  
  nm <- covRef %>%
    as_tibble() %>%
    filter(covariateId == covId) 
  writeLines(paste("Covariate Id:", nm$covariateId))
  writeLines(paste("Covariate Name:", nm$covariateName))
  x <- covData %>%
    select(contains(as.character(covId))) 
  pct <- paste(format((sum(x) / NROW(x))*100, digits = 2), "%")
  writeLines(paste("Prevalence in Cohort:", pct, "\n"))
  
}

kk <- names(hh)[2:10] %>% gsub("CovId_", "", .) %>% as.numeric()

purrr::map(kk, ~covariateSummary(covData = hh, covId = .x, covRef = covRef))


hh <- cov %>%
  left_join(covRef, by = c("covariateId")) %>%
  dplyr::select(rowId, covariateId, covariateValue) %>%
  pivot_wider(names_from = covariateId, names_glue = "CovId_{covariateId}",
              values_from = covariateValue, values_fill = 0) %>%
  convertAgeCovs() %>%
  convertGenderCovs() %>%
  convertRaceCovs()
  


# hh1 <- covariateData$covariates %>%
#   left_join(covariateData$covariateRef, by = c("covariateId")) %>%
#   dplyr::select(rowId, covariateId, covariateValue) %>%
#   pivot_wider(names_from = covariateId, names_glue = "CovId_{covariateId}",
#               values_from = covariateValue, values_fill = 0)

