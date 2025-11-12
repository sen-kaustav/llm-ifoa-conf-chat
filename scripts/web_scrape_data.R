library(tidyverse)
library(rvest)

link <- "https://actuaries.org.uk/events/IFoALifeConference2025/"

html_page <- read_html(link)

df <- html_page |> 
  html_element(".event-schedule-container") |> 
  html_elements(".panel") |> 
  html_elements("table") |> 
  html_table() |> 
  bind_rows(.id = "Day") |> 
  filter(!(Details == "")) |> 
  mutate(
    is_description = Activity == Time,
    Activity = str_extract(Activity, "^.*"),
    Details = str_replace(Details, "^.*?\n", "\n"),
    Date = case_when(
      Day == 1 ~ ymd(20251105),
      Day == 2 ~ ymd(20251106),
      Day == 3 ~ ymd(20251107),
    )
  ) |> 
  slice(-(1:3)) |> 
  select(Date, is_description, everything())

df_descriptions <- df |> 
  filter(is_description) |>
  select(Title = Activity, Details)

df_times <- df |> 
  filter(!is_description) |> 
  select(Date, Time, Activity)

df_sessions <- 
  bind_cols(df_times, df_descriptions) |> 
  mutate(text = glue::glue("
  Date and Time: {Date}; {Time}
  Session: {Activity}: {Title}
  Details: {Details}
  ")) 
