library(tidyverse)
library(ragnar)
library(duckdb)
library(DBI)

df_sessions <- read_csv("data/session.csv")

# setup a duckdb database
con <- DBI::dbConnect(duckdb(), "data/ifoa_session.ragnar.duckdb")

# Store location
store_location <- file.path("data", "ifoa_session.ragnar.duckdb")

store <- ragnar_store_create(
  location = store_location,
  embed = embed_google_gemini(),
  overwrite = TRUE,
  version = 1
)

ragnar_store_insert(store, df_sessions)