# renv::restore()
library(APACStudyFudan2025)

# Maximum number of cores to be used:
maxCores <- parallel::detectCores()

# The folder where the study intermediate and result files will be written:
outputFolder <- "studyResults/APACStudyFudan2025"

# Optional: specify where the temporary files (used by the Andromeda package) will be created:
# options(andromedaTempFolder = file.path(outputFolder, "andromedaTemp"))

# Details for connecting to the server:
connectionDetails <-
  DatabaseConnector::createConnectionDetails(
    dbms = "pdw",
    server = Sys.getenv("PDW_SERVER"),
    user = NULL,
    password = NULL,
    port = Sys.getenv("PDW_PORT")
  )

# The name of the database schema where the CDM data can be found:
cdmDatabaseSchema <- "CDM_IBM_MDCD_V1153.dbo"

# The name of the database schema and table where the study-specific cohorts will be instantiated:
cohortDatabaseSchema <- "scratch.dbo"
cohortTable <- "APACStudyFudan2025"

# Some meta-information that will be used by the export function:
databaseId <- "" # Short database identifier e.g. Synpuf 
databaseName <- "" # e.g. Medicare Claims Synthetic Public Use Files (SynPUFs)
databaseDescription <- "OHDSI APAC study - Fudan"

# For some database platforms (e.g. Oracle): define a schema that can be used to emulate temp tables:
options(sqlRenderTempEmulationSchema = NULL)

APACStudyFudan2025::execute(
  connectionDetails = connectionDetails,
  cdmDatabaseSchema = cdmDatabaseSchema,
  cohortDatabaseSchema = cohortDatabaseSchema,
  cohortTable = cohortTable,
  verifyDependencies = TRUE,
  outputFolder = outputFolder,
  databaseId = databaseId,
  databaseName = databaseName,
  databaseDescription = databaseDescription
)

CohortDiagnostics::createMergedResultsFile(
  dataFolder = outputFolder,
  sqliteDbPath = file.path(outputFolder,
                           "MergedCohortDiagnosticsData.sqlite")
)

CohortDiagnostics::launchDiagnosticsExplorer(
  sqliteDbPath = file.path(outputFolder,"MergedCohortDiagnosticsData.sqlite"))


# Upload the results to the OHDSI SFTP server:
privateKeyFileName <- ""
userName <- ""
APACStudyFudan2025::uploadResults(outputFolder, privateKeyFileName, userName)
