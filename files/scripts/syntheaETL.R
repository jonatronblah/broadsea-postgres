library(ETLSyntheaBuilder)

 # We are loading a version 5.3.1 CDM into a local PostgreSQL database called "synthea10".  
 # The supported Synthea version is 2.7.0 or master
 # The schema to load the Synthea tables is called "native".
 # The schema to load the Vocabulary and CDM tables is "cdm_synthea10".  
 # The username and pw are "postgres" and "lollipop".
 # The Synthea and Vocabulary CSV files are located in /tmp/synthea/output/csv and /tmp/Vocabulary_20181119, respectively.
 
cd <- DatabaseConnector::createConnectionDetails(
  dbms     = "postgresql", 
  server   = "db/db", 
  user     = "grover", 
  password = "babybun", 
  port     = 5432,
  pathToDriver = '/home/rstudio/misc'
)

cdmSchema      <- "cdm"
cdmVersion     <- "5.3.1"
syntheaVersion <- "master"
syntheaSchema  <- "native"
syntheaFileLoc <- "/home/rstudio/data/synthea"
vocabFileLoc   <- "/home/rstudio/data/vocab"



ETLSyntheaBuilder::CreateCDMTables(connectionDetails = cd, cdmSchema = cdmSchema, cdmVersion = cdmVersion)
                                     
ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaVersion = syntheaVersion)
                                       
ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaFileLoc = syntheaFileLoc)
                                     
ETLSyntheaBuilder::LoadVocabFromCsv(connectionDetails = cd, cdmSchema = cdmSchema, vocabFileLoc = vocabFileLoc)
                                    
ETLSyntheaBuilder::LoadEventTables(connectionDetails = cd, cdmSchema = cdmSchema, syntheaSchema = syntheaSchema, cdmVersion = cdmVersion, syntheaVersion = syntheaVersion)

# Optional: Create index and constraint DDL scripts for the rdbms that support them.  Scripts will be written to the "output" directory.
ETLSyntheaBuilder::CreateCDMIndexAndConstraintScripts(connectionDetails = cd, cdmSchema = cdmSchema, cdmVersion = cdmVersion, githubTag = "v5.3.1")

