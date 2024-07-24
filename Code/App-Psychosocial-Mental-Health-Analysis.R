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
      menuItem("Mental Health Analysis", tabName = "Mental Health Analysis", icon = icon("edit")),
      conditionalPanel(condition = "input.tab == 'Mental Health Analysis'",
                       div(
                         selectInput("psy_selector", "Psychological Problem", choices = data_psy), 
                         selectInput("category_selector", "Category", choices = data_category),
                         selectInput("summary_selector", "Summary", choices = data_summary)
                       ))
    )
  ),
  dashboardBody()
)



server = function(input, output, session) {
}

shinyApp(ui, server)

