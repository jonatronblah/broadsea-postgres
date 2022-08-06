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

conn <- DatabaseConnector::connect(cd)

#create sql to merge cohort with person table to get person_source_value
sql <- 'SELECT a.*, b.person_source_value 
        FROM ohdsi.COHORT a
        JOIN cdm.PERSON b
        ON a.subject_id = b.person_id
        WHERE cohort_definition_id = 4'

#get dataframe
pcVisitCohort <- DatabaseConnector::querySql(
  connection = conn,
  sql = sql
)

syntheaEncounters <- readr::read_csv("data/synthea/encounters.csv")
syntheaProviders <- readr::read_csv("data/synthea/providers.csv")

providerInfo <- syntheaEncounters %>%
  left_join(syntheaProviders, by = c("PROVIDER" = "Id")) %>%
  select(PATIENT, PROVIDER, START, ENCOUNTERCLASS:DESCRIPTION, NAME) %>%
  filter(ENCOUNTERCLASS %in% c("ambulatory", "wellness", "outpatient")) %>%
  mutate(startDate = lubridate::date(START), .keep = "unused") %>%
  filter(between(startDate, lubridate::date("2018-01-01"), lubridate::date("2019-12-31"))) %>% #29590 obs
  right_join(pcVisitCohort,
             by = c("PATIENT" = "PERSON_SOURCE_VALUE")) #2634 obs



#find the number of visits in the year
providerCount <- function(dat, dateVar,
                          start, stop,
                          ...) {
  datVar <- rlang::enquo(datVar)
  start <- lubridate::date(start)
  stop <- lubridate::date(stop)
  group_ <- rlang::enquos(...)
  
  dat %>%
    dplyr::filter(between(!!datVar, start, stop)) %>%
    dplyr::group_by(!!!group_) %>%
    dplyr::count(name = "provider_count")
}

#test
#find last visit date for the provider
providerMaxDate <- function(dat, dateVar,
                            start, stop,
                            ...) {
  datVar <- rlang::enquo(datVar)
  start <- lubridate::date(start)
  stop <- lubridate::date(stop)
  group_ <- rlang::enquos(...)
  
  dat %>%
    dplyr::filter(between(!!datVar, start, stop)) %>%
    dplyr::group_by(!!!group_) %>%
    dplyr::summarize(max_visit_date = max(!!datVar), .groups = "drop_last")
}


#pick pcp over provider count and max visit date
pickPcp <- function(dat, patientVar, providerVar) {
  
  #setup
  patientVar <- rlang::enquo(patientVar)
  providerVar <- rlang::enquo(providerVar)
  
  dat %>%
    group_by(!!patientVar) %>%
    mutate(rank1 = min_rank(desc(provider_count)),
           rank2 = min_rank(desc(max_visit_date))) %>%
    arrange(rank1, rank2) %>% 
    mutate(rn = row_number()) %>%
    ungroup() %>% 
    filter(rn == 1) %>%
    select(-c(rank1, rank2, rn))
}


#get year 1 pcp
dat1Yr1 <-providerCount(providerInfo, dateVar = startDate, start = "2018-01-01", stop = "2018-12-31", PATIENT, PROVIDER, NAME)
dat2Yr1 <- providerMaxDate(providerInfo, dateVar = startDate, start = "2018-01-01", stop = "2018-12-31", PATIENT, PROVIDER, NAME)
pcpFirstYear <- dat1Yr1 %>%
  inner_join(dat2Yr1, by=c("PATIENT", "PROVIDER", "NAME")) %>%
  pickPcp(patientVar = PATIENT, providerVar = PROVIDER)

#get year 2 pcp
dat1Yr2 <-providerCount(providerInfo, dateVar = startDate, start = "2019-01-01", stop = "2019-12-31", PATIENT, PROVIDER, NAME)
dat2Yr2 <- providerMaxDate(providerInfo, dateVar = startDate, start = "2019-01-01", stop = "2019-12-31", PATIENT, PROVIDER, NAME)
pcpSecondYear <- dat1Yr2 %>%
  inner_join(dat2Yr2, by=c("PATIENT", "PROVIDER", "NAME")) %>%
  pickPcp(patientVar = PATIENT, providerVar = PROVIDER)

#join two years and pick pcp over time
pcpBoth <- pcpFirstYear %>%
  union(pcpSecondYear) %>%
  pickPcp(patientVar = PATIENT, providerVar = PROVIDER) %>%
  mutate(assigned_pcp = gsub("\\d", "", NAME),
         assigned_pcp = forcats::as_factor(assigned_pcp),
         assigned_pcp = forcats::fct_lump(assigned_pcp, n = 15),
         assigned_pcp = forcats::fct_infreq(assigned_pcp)) %>%
  select(PATIENT, assigned_pcp)

#check
pcpBoth %>%
  count(assigned_pcp, sort = T)

# randomly add to known assigned_pcp (remove other)

#get weights
w <- pcpBoth %>%
  filter(assigned_pcp != "Other") %>%
  count(assigned_pcp) %>%
  arrange(desc(n)) %>%
  mutate(w = rev(n) / sum(n)) %>%
  pull(w)

#find the number of other
numOther <- pcpBoth %>%
  filter(assigned_pcp == "Other") %>%
  nrow()

#randomly pick where other will go
set.seed(12)
x <- rmultinom(numOther, 1, prob = w) %>%
  apply(2, which.max) %>%
  `+`(., 1)


y <- as.numeric(pcpBoth$assigned_pcp)

y[y == 1] <- x




pcpBothUpdate <- pcpBoth %>%
  mutate(assigned_pcp = levels(assigned_pcp)[y])

pcpBothUpdate %>%
  count(assigned_pcp, sort = T)


### NExt Steps
#Find a set of covariates to use for clustering and generate panel size estimation

#Scenario 1: Counts and demographics
