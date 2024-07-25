library(shiny)
library(shinydashboard)
library(tidyverse)

data <- read.csv("Data/Clean3_Psychosocial_Health_Analysis.csv")

data_psy <- unique(data$psychological_category)

ui <- dashboardPage(
  dashboardHeader(title = "Psychosocial Analysis"),
  dashboardSidebar(
    sidebarMenu(
      id = "tab",
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Mental Health Analysis", tabName = "mental_health_analysis", icon = icon("edit")),
      conditionalPanel(
        condition = "input.tab == 'mental_health_analysis'",
        div(
          selectInput("psy_selector", "Psychological Problem", choices = data_psy), 
          selectInput("category_selector", "Category", choices = NULL),
          selectInput("summary_selector", "Summary", choices = NULL),
          actionButton("search_button", "Search", icon = icon("search"))
        )
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home", includeMarkdown("Markdown/Instuctions.Rmd")),
      tabItem(tabName = "mental_health_analysis",
              fluidRow(
                box(title = "Problem Description", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                    uiOutput("filtered_text_ui"))
              )
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$psy_selector, {
    filtered_data <- data %>%
      filter(psychological_category == input$psy_selector)
    
    updateSelectInput(session, "category_selector", choices = unique(filtered_data$problem_category))
    updateSelectInput(session, "summary_selector", choices = NULL)  # Reset summary choices when psy_selector changes
  })
  
  observeEvent(input$category_selector, {
    filtered_data <- data %>%
      filter(psychological_category == input$psy_selector,
             problem_category == input$category_selector)
    
    updateSelectInput(session, "summary_selector", choices = unique(filtered_data$problem_summary))
  })
  
  filtered_data <- reactive({
    req(input$search_button)
    data %>%
      filter(psychological_category == input$psy_selector,
             problem_category == input$category_selector,
             problem_summary == input$summary_selector)
  })
  
  output$filtered_text_ui <- renderUI({
    descriptions <- filtered_data() %>%
      pull(Problem_description)
    
    description_html <- if (length(descriptions) > 0) {
      paste(
        sapply(descriptions, function(desc) {
          paste0("<div style='display: flex; align-items: center; margin-bottom: 5px;'>",
                 "<div style='flex: 1;'>", desc, "</div>",
                 "</div>")
        }),
        collapse = ""
      )
    } else {
      "No matching descriptions found."
    }
    
    HTML(description_html)
  })
}

shinyApp(ui, server)

