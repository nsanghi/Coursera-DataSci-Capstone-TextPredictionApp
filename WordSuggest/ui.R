#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Suggest Auto complete"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textAreaInput("sentence", "Enter text here:")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h3("These are the top choices for next word in sentence in order of priority."),
      h6("Please be patient with first query. It takes time to load the tr/bi/unigram data set into memory. Hence first query takes a little longer(45-60 sec). Subsequent queries are fast."),
      htmlOutput("nextwords", style="font-weight: 500; font-size:26px; color:#4d3a7d;"),
      plotOutput("wordmap")
    )
  )
))
