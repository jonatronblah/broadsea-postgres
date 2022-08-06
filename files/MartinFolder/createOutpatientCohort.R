#Create Outpatient cohort ---------------

library(Capr)
library(DatabaseConnector)
library(SqlRender)
library(tidyverse)

#connection details using local cdm
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms     = "postgresql",
  server   = "db/db",
  user     = "grover",
  password = "babybun",
  port     = 5432,
  pathToDriver = '/home/rstudio/misc'
)


#set connection
connection <- DatabaseConnector::connect(connectionDetails)

#vocab schema for local
vocabularyDatabaseSchema <- "cdm"


#create outpatient concept set expression
outpatientVisitCSE <- getConceptIdDetails(conceptIds = 9202,
                                          connection = connection,
                                          vocabularyDatabaseSchema = vocabularyDatabaseSchema,
                                          mapToStandard = TRUE) %>%
  createConceptSetExpression(Name = "Outpatient Visit",
                             includeDescendants = TRUE)

#create attribute > 18
ageGte18 <- createAgeAttribute(Op = "gte",
                               Value = 18)
#visit start date attribute
visitStartDate <- createOccurrenceStartDateAttribute(Op = "gte", 
                                                     Value = "2018-01-01")
#visit end date attribute
visitEndDate <- createOccurrenceEndDateAttribute(Op = "lte", 
                                                 Value = "2019-12-31")

#create query
outpatientVisitQuery <- createVisitOccurrence(conceptSetExpression = outpatientVisitCSE,
                                              attributeList = list(ageGte18,
                                                                   visitStartDate,
                                                                   visitEndDate))

#set query as primary criteria
pc <- createPrimaryCriteria(Name = "Outpatient VisitPC",
                            ComponentList = list(outpatientVisitQuery),
                            Limit = "Last")

#set censoring
cohortEra <- createCohortEra(RightCensorDate = "2019-12-31")

#createcohort
outpatientCohort <- createCohortDefinition(Name = "Outpatient Visit Cohort",
                                           PrimaryCriteria = pc,
                                           CohortEra = cohortEra)

genOp <- CirceR::createGenerateOptions(cohortIdFieldName = "cohort_definition_id",
                                       cohortId = 5,
                                       cdmSchema = "cdm",
                                       targetTable = "COHORT",
                                       resultSchema = "ohdsi",
                                       vocabularySchema = "cdm",
                                       generateStats = F)

#compile cohort definition
cohortInfo <- compileCohortDefinition(outpatientCohort, generateOptions = genOp)
#legible definition
cat(cohortInfo$cohortRead)
cat(cohortInfo$ohdiSQL)



#set search path to ohdsi
sql <- "SET SEARCH_PATH TO ohdsi"
DatabaseConnector::executeSql(connection, sql)

#write sql to backend 
cohortInfo$ohdiSQL %>%
   SqlRender::translate(targetDialect = "postgresql") %>%
   SqlRender::render() %>%
   DatabaseConnector::executeSql(connection = connection, sql = .)


# readr::read_file("~/Documents/R/Dissertation/aim3/outpatientCohort.sql") %>%
#   SqlRender::translate(targetDialect = "postgresql") %>%
#   DatabaseConnector::executeSql(connection = connection, sql = .)
# # 
# #fix tables if there is an error
# sql <- '
# DROP TABLE IF EXISTS #cohort_rows;
# 
# DROP TABLE IF EXISTS #final_cohort;
# 
# DROP TABLE IF EXISTS #inclusion_events;
# 
# DROP TABLE IF EXISTS #qualified_events;
# 
# DROP TABLE IF EXISTS #included_events;
# 
# DROP TABLE IF EXISTS #Codesets;
# '
# sql %>%
#   SqlRender::translate(targetDialect = "postgresql") %>%
#   DatabaseConnector::executeSql(connection = connection, sql = .)
# 


## Query Table to check 

sql <- "SELECT * FROM COHORT WHERE cohort_definition_id = 5"
tb <- DatabaseConnector::querySql(connection, sql = sql)
