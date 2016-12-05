#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

source("predictionModel.R")
library(wordcloud)
library(RColorBrewer)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  suggestion = reactive({
    query <- get_query_words(input$sentence)  
    if (length(query) >= 2) {
      suggestion <- backoff_trigram( query[length(query)-1], query[length(query)])
    } else {
      suggestion<- data.table(nextword=c("None found"), prob=c(1.0)) 
    }
    suggestion
  })
   
  output$nextwords <- renderText({
    wordlist <- as.character(suggestion()$nextword)
  })
  
  output$wordmap <- renderPlot({
    data <- suggestion()
    #print (data)
    if (length(data) >= 2) {
      wordcloud(data$nextword, data$prob, scale=c(8,.2), color=brewer.pal(8, "Dark2"), rot.per=.15)
    }
  })
  
})
