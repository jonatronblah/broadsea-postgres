library(SqlRender)
library(readr)
library(DatabaseConnector)

cd <- createConnectionDetails(
  dbms     = "postgresql",
  server   = "db/db",
  user     = "grover",
  password = "babybun",
  port     = 5432,
  pathToDriver = '/home/rstudio/misc'
)
conn <- connect(cd)

sql <- read_file('scripts/cohort_caching.sql')
#tsql <- translate(sql, targetDialect = "postgresql")
rsql <- render(sql3, results_schema = 'ohdsi')

sql2 <- "ALTER TABLE @results_schema.cohort_inclusion_result ADD mode_id  int NOT NULL DEFAULT 0;
ALTER TABLE @results_schema.cohort_inclusion_stats ADD mode_id  int NOT NULL DEFAULT 0;
ALTER TABLE @results_schema.cohort_summary_stats ADD mode_id  int NOT NULL DEFAULT 0;"

sql3 <- "ALTER TABLE @results_schema.cohort_inclusion_result DROP CONSTRAINT cohort_inclusion_result_pkey;
ALTER TABLE @results_schema.cohort_inclusion_stats DROP CONSTRAINT cohort_inclusion_stats_pkey;
ALTER TABLE @results_schema.cohort_inclusion DROP CONSTRAINT cohort_inclusion_pkey;
ALTER TABLE @results_schema.cohort_summary_stats DROP CONSTRAINT cohort_summary_stats_pkey;"

executeSql(conn, rsql)
