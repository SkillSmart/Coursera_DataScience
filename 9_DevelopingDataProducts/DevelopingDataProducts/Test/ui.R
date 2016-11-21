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
        
        titlePanel("Predict Horespower from MPG"),
        sidebarLayout(
                sidebarPanel(
                        sliderInput("sliderMPG", "What is the MPG of the car?", 10, 35, value = 20),
                        checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
                        checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE),
                        submitButton("Submit")
                ),
                mainPanel(
                        plotOutput("plot1"),
                        h3("Predicted Horsepower from Model 1:"),
                        textOutput("pred1"),
                        h3("Predicted Horespower from Model 2:"),
                        textOutput("pred2")
                )
        )
        
        
))
