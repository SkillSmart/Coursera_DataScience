#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
        
          model <- reactive({
                  brushed_data <- brushedPointes(trees, input$brush1,
                                                 xvar = "Girth", yvar = "Volume")
          if(nrow(brushed_data) < 2){
                  return(NULL)
          }
          lm(Volume ~ Girth, data = brushed_data)
          }),
          
          output$plot1 <- renderPlot({
                  
          }),
          
          output$slopeOut <- renderText({
                  if(is.null(model())){
                          "No model found."
                  } else {
                    model()[[1]][2]
                  }
          }),
          output$intOut <- renderText({
                  if(is.null(model())){
                          "No model found."
                  }else {
                   model()[[1]][1]
                  }
          })
})
