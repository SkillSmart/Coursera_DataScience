library(shiny)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
        
        fluidRow(
                # Display controls
                column(4,
                       uiOutput("choose_dataset"),
                       textOutput("new"),
                       uiOutput("choose_xVar"),
                       uiOutput("choose_yVar")
                       ),
                # Display Plot
                column(8,
                       "Here comes the plot",
                       plotOutput("scatterPlot"))
        ),
        fluidRow(
                # Display controls
                column(4),
                # Display Plot
                column(8)
        )
)

server <- function(input, output){
        
        # Create select input for dataset
        output$choose_dataset <- renderUI({
                selectInput("dataset", "Choose the Dataset:", as_data_frame(data()$results)$Item)
        })
        
        new <- reactive({
                get(input$dataset)
        })
        
        output$new <- renderText(sprintf("You chose %s", new()))

        # # Select xVar
        output$choose_xVar <- renderUI({
                if(is.null(input$dataset)){
                        return()
                }
                data <- get(input$dataset)
                colnames <- names(data)
                selectInput("xVar", "What variable do you want to examine?:", choices = colnames)
        })
        
        # Select yVar
        output$choose_yVar <- renderUI({
                if(is.null(input$dataset)){
                        return()
                }
                
                data <- get(input$dataset)
                colnames <- names(data)
                selectInput("yVar", "What influence on this variable do you want to measure?", choices = colnames)
        })
        
        
        # Render the plot
        output$scatterPlot <- renderPlot({
                
                if(is.null(input$dataset)){
                        return()
                }
                # Load and plot the data
                data <- get(input$dataset)
                qplot(data[,input$xVar], data[,input$yVar])
        })
}



# Serving the App
shinyApp(ui, server)