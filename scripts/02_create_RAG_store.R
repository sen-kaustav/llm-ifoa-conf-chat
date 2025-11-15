library(tidyverse)
library(ragnar)
library(duckdb)
library(DBI)

df_sessions <- read_csv("data/session.csv")

# Store location
store_location <- file.path("data", "ifoa_session.ragnar.duckdb")

# setup a duckdb database
con <- DBI::dbConnect(duckdb(), store_location, read_only = FALSE)

store <- ragnar_store_create(
  location = store_location,
  embed = embed_google_gemini(),
  title = "IFoA Life Conference 2025 schedule",
  overwrite = TRUE,
  version = 1
)

ragnar_store_insert(store, df_sessions)
ragnar_store_build_index(store)

dbDisconnect(con)
