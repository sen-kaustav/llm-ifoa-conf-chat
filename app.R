library(shiny)
library(bslib)
library(shinychat)
library(ellmer)
library(ragnar)

store <- ragnar_store_connect(
  here::here("data", "ifoa_session.ragnar.duckdb")
)

welcome_message <- interpolate_file(here::here("welcome_message.md"))
system_prompt <- interpolate_file(here::here("system_prompt.md"))

ui <- page_fillable(
  chat_ui("chat", messages = welcome_message),
  title = "Chatbot for IFoA Life Conference 2025",
  fillable_mobile = TRUE,
  theme = bs_theme(
    base_font = font_google("Karla")
  )
)

server <- function(input, output, session) {
  chat <- chat_google_gemini(
    model = "gemini-2.5-flash",
    system_prompt = system_prompt
  )
  ragnar_register_tool_retrieve(chat, store)

  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
