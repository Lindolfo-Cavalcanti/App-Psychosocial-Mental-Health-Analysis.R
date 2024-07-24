library(shiny)
library(shinydashboard)
library(tidyverse)

data = read.csv("Data/Psychosocial_Health_Analysis.csv")

data_psy = data %>% select(psychological_catehory)

data_category = data %>% select(problem_category)

data_summary = data %>% select(problem_summary)

ui <- dashboardPage(
  dashboardHeader(title = "Psychosocial Analysis"),
  dashboardSidebar(
    sidebarMenu(
      id = "tab",
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Mental Health Analysis", tabName = "Mental Health Analysis", icon = icon("edit")),
      conditionalPanel(condition = "input.tab == 'Mental Health Analysis'",
                       div(
                         fileInput("file", "Upload File", multiple = FALSE, accept = 'csv'),
                         # Psychological Problem,
                         # Problem Category
                         # Problem Summary
                       ))
    )
  ),
  dashboardBody()
)



server = function(input, output, session) {
}

shinyApp(ui, server)
