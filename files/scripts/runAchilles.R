library(Achilles)

cd <- DatabaseConnector::createConnectionDetails(
  dbms     = "postgresql",
  server   = "db/db",
  user     = "grover",
  password = "babybun",
  port     = 5432,
  pathToDriver = '/home/rstudio/misc'
)

achilles(cd, 
  cdmDatabaseSchema = "cdm", 
  resultsDatabaseSchema="results",
  vocabDatabaseSchema = "cdm",
  numThreads = 4,
  sourceName = "OHDSI CDM V5 Database", 
  cdmVersion = "5.3.1",
  runHeel = TRUE,
  runCostAnalysis = TRUE)
