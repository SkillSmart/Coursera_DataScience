
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)


shinyServer(function(input, output){

        # Dynamically creating content for the sidebar
        output$menu <- renderMenu({
                sidebarMenu(
                        sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                                          label = "Search..."),
                                menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                                menuItem("Widgets", tabName = "widgets", icon = icon("th")),
                                menuItem("Data", tabName = "data", icon = icon("data")),
                                menuItem("Schedules", tabName = "schedules",icon = icon("calendar")),
                                menuItem("Settings", tabName = "settings", icon = icon("cog", lib = "glyphicon")),
                                menuItem("Database", tabName = "database", icon = icon("th"))
                                
                        
                        # Include dynamic input items
                        sliderInput(inputId = "inp", label = "Slider:",
                                value = 10, min = 1, max = 20), 
                        
                                textInput(inputId = "text", label = "Text input:"),
                                
                                dateRangeInput(inputId = "daterng", label ="Date Range:", start = Sys.time())
                )
                
        # "Dashboard" - Functions
        
                
                
                # Graphics Functions (Plots, Displays, etc...)
                
                # "MapExplorer" - Interactive Map with Data Overlay for explora
                output$mapExplorer
        
        
        
        
})

})