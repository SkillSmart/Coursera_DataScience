#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define the UI
Skip to content
This repository
Search
Pull requests
Issues
Gist
@SkillSmart
Watch 133
Star 450
Fork 1,434 rstudio/shiny-examples
Code  Issues 13  Pull requests 1  Projects 0  Wiki  Pulse  Graphs
Branch: master Find file Copy pathshiny-examples/063-superzip-example/ui.R
ca20e6b  on Aug 28
@wch wch Remove shinyUI and shinyServer
4 contributors @wch @yihui @jcheng5 @garrettgman
RawBlameHistory     
80 lines (66 sloc)  2.23 KB
library(leaflet)

# Choices for drop-downs
vars <- c(
        "Is SuperZIP?" = "superzip",
        "Centile score" = "centile",
        "College education" = "college",
        "Median income" = "income",
        "Population" = "adultpop"
)


navbarPage("Superzip", id="nav",
           
           tabPanel("Interactive map",
                    div(class="outer",
                        
                        tags$head(
                                # Include our custom CSS
                                includeCSS("styles.css"),
                                includeScript("gomap.js")
                        ),
                        
                        leafletOutput("map", width="100%", height="100%"),
                        
                        # Shiny versions prior to 0.11 should use class="modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 330, height = "auto",
                                      
                                      h2("ZIP explorer"),
                                      
                                      selectInput("color", "Color", vars),
                                      selectInput("size", "Size", vars, selected = "adultpop"),
                                      conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
                                                       # Only prompt for threshold when coloring or sizing by superzip
                                                       numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
                                      ),
                                      ☼
                                      plotOutput("histCentile", height = 200),
                                      plotOutput("scatterCollegeIncome", height = 250)
                        ),
                        
                        tags$div(id="cite",
                                 'Data compiled for ', tags$em('Coming Apart: The State of White America, 1960–2010'), ' by Charles Murray (Crown Forum, 2012).'
                        )
                    )
           ),
           
           tabPanel("Data explorer",
                    fluidRow(
                            column(3,
                                   selectInput("states", "States", c("All states"="", structure(state.abb, names=state.name), "Washington, DC"="DC"), multiple=TRUE)
                            ),
                            column(3,
                                   conditionalPanel("input.states",
                                                    selectInput("cities", "Cities", c("All cities"=""), multiple=TRUE)
                                   )
                            ),
                            column(3,
                                   conditionalPanel("input.states",
                                                    selectInput("zipcodes", "Zipcodes", c("All zipcodes"=""), multiple=TRUE)
                                   )
                            )
                    ),
                    fluidRow(
                            column(1,
                                   numericInput("minScore", "Min score", min=0, max=100, value=0)
                            ),
                            column(1,
                                   numericInput("maxScore", "Max score", min=0, max=100, value=100)
                            )
                    ),
                    hr(),
                    DT::dataTableOutput("ziptable")
           ),
           
           conditionalPanel("false", icon("crosshair"))
)
Contact GitHub API Training Shop Blog About
© 2016 GitHub, Inc. Terms Privacy Security Status Help