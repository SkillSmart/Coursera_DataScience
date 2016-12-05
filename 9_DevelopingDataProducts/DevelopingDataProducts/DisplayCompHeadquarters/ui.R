#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

# Define UI for mapping application that displays the biggest international internet companies
shinyUI(navbarPage( tags$style(type = "text/css", ".outer {position: fixed; 
                              top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
   
   
   tabPanel("Interactive map",
        div(class="outer",
           
           # Output the map 
           leafletOutput("map", height="100%", width="100%")
        )
    ),
   tabPanel("Data Explorer",
            div(class="outer",
                
                fluidRow(
                        column(8,
                               # Output the DataTable
                               dataTableOutput("data")       
                               ),
                        
                        column(4)
                        
                
                
                
                ))
   ),
   
   # Define the controls panel
   absolutePanel(id="controls", top = 150, right = 40, draggable = TRUE, fixed = TRUE,
                 tags$style(type="text/css", "#revenue {background:cloud;
                                                        padding:5px 10px;
                                                        opacity:50%;
                                                        }"),
                 
                 h4("Top 100 Global Explorer"),
                 
                 # Content of the control panel
                 sliderInput("revenue", "Revenue",
                             min(wikiTbl$`Revenue ($B)`), max(wikiTbl$`Revenue ($B)`),
                             value = range(wikiTbl$`Revenue ($B)`), step = 0.1
                 ),
                 selectInput("industry", "Industry",
                             choice=unique(wikiTbl$Industry), multiple = FALSE
                 ),
                 sliderInput("employees", "Employees",
                             min(wikiTbl$Employees), max(wikiTbl$Employees),
                             value = range(wikiTbl$Employees), step = 0.5
                 ),
                 checkboxInput("legend", "Show Legend", TRUE
                 ),
                 checkboxInput("satelite", "Satelite Image", FALSE
                 ),
                 textOutput("mapInbound")
   )
))




# Code Deposit
# 
# dataTableOutput("data"),
# 
# 