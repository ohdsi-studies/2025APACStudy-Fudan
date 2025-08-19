# APACStudyFudan2025

# Requirements

-   A database in [Common Data Model version 5](https://github.com/OHDSI/CommonDataModel) in one of these platforms: SQL Server, Oracle, PostgreSQL, IBM Netezza, Apache Impala, Amazon RedShift, Google BigQuery, or Microsoft APS.
-   R version 4.0.0 or newer
-   On Windows: [RTools](http://cran.r-project.org/bin/windows/Rtools/)
-   [Java](http://java.com)
-   25 GB of free disk space

# Installation

1.  Follow [these instructions](https://ohdsi.github.io/Hades/rSetup.html) for setting up your R environment, including RTools and Java.

2.  Open your study package in RStudio. Use the following code to install all the dependencies:

    ``` r
    renv::restore()
    ```

3.  In **RStudio, select 'Build' then 'Install and Restart'** to build the package.

# How to run

4.  Once installed, you can execute the study by modifying and using the code below. For your convenience, this code is also provided under **`extras/CodeToRun.R`**:

    ``` r
    library(APACStudyFudan2025)

    # Optional: specify where the temporary files (used by the Andromeda package) will be created:
    options(andromedaTempFolder = "s:/andromedaTemp")

    # Maximum number of cores to be used:
    maxCores <- parallel::detectCores()

    # The folder where the study intermediate and result files will be written:
    outputFolder <- "APACStudyFudan2025"

    # Details for connecting to the server:
    # See ?DatabaseConnector::createConnectionDetails for help
    connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "postgresql",
                                    server = "some.server.com/ohdsi",
                                    user = "joe",
                                    password = "secret")

    # The name of the database schema where the CDM data can be found:
    cdmDatabaseSchema <- "cdm_synpuf"

    # The name of the database schema and table where the study-specific cohorts will be instantiated:
    cohortDatabaseSchema <- "scratch.dbo"
    cohortTable <- "my_study_cohorts"

    # Some meta-information that will be used by the export function:
    databaseId <- "" # Short database identifier e.g. Synpuf 
    databaseName <- "" #e.g. Medicare Claims Synthetic Public Use Files (SynPUFs)
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
    ```

5.  Upload the file `export/Results_<DatabaseId>.zip` in the output folder to the study coordinator:

    ``` r
    uploadResults(outputFolder, privateKeyFileName = "<file>", userName = "<name>")
    ```

    Where `<file>` and `<name<` are the credentials provided to you personally by the study coordinator.

6.  To view the results, use the Shiny app:

    ``` r
    CohortDiagnostics::createMergedResultsFile(
      dataFolder = outputFolder,
      sqliteDbPath = file.path(outputFolder,
                               "MergedCohortDiagnosticsData.sqlite")
    )

    CohortDiagnostics::launchDiagnosticsExplorer(
      sqliteDbPath = file.path(outputFolder,"MergedCohortDiagnosticsData.sqlite"))
    ```

Note that you can save plots from within the Shiny app.

# License

The APACStudyFudan2025 package is licensed under Apache License 2.0

# Development

APACStudyFudan2025 was developed in ATLAS and R Studio.

### Development status

Unknown
