library(shiny)
library(shinydashboard)
library(tidyverse)

data = read.csv("Data/Psychosocial_Health_Analysis.csv")

data_psy = unique(data$psychological_catehory)

data_category = unique(data$problem_category)

data_summary = unique(data$problem_summary)

ui <- dashboardPage(
  dashboardHeader(title = "Psychosocial Analysis"),
  dashboardSidebar(
    sidebarMenu(
      id = "tab",
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Mental Health Analysis", tabName = "mental_health_analysis", icon = icon("edit")),
      conditionalPanel(
        condition = "input.tab === 'mental_health_analysis'",
        div(
          selectInput("psy_selector", "Psychological Problem", choices = unique(data$psychological_catehory)), 
          selectInput("category_selector", "Category", unique(data$problem_category)),#choices = NULL),
          selectInput("summary_selector", "Summary", unique(data$problem_summary))#choices = NULL)
        )
      )
    )
  ),
  dashboardBody()
)



server = function(input, output, session) {
}

shinyApp(ui, server)

