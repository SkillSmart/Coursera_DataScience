#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#



# Get list of Headquarters for  top 100 internet companies from Wikipedia
require(shiny)
require(rvest)
require(readr)
require(leaflet)
require(dplyr)

# Check if file exists and if so load it, or otherwise create it
if(!file.exists("./data/lrgstInternetCompanies.csv")){
        
        # check for data subdirectory
        if(!dir.exists("./data/")){ dir.create("./data/")}
        
        
        # Load the html source
        dat <- read_html("https://en.wikipedia.org/wiki/List_of_largest_Internet_companies")
        
        # Parse out the information from the Wikitable
        wikiTbl <- dat %>% html_nodes(xpath="//*[@id=\"mw-content-text\"]/table[2]") %>% 
                html_table()
        
        # Subset the dataset
        wikiTbl <- wikiTbl[[1]]
        wikiTbl <- wikiTbl[,3:dim(wikiTbl)[2]]
        wikiTbl$Industry <- as.factor(wikiTbl$Industry)
        
        
        # Clean the columns and rejoin in data.frame
        subTbl <- wikiTbl %>% select(`Revenue ($B)`, Employees, `Market cap ($B)`) %>% 
                lapply(., function(x){ gsub("\\$", "", x)}) %>% 
                lapply(., function(x){gsub(",", "", x)}) %>% 
                lapply(., as.numeric)
        
        # update table information
        wikiTbl$`Revenue ($B)` <- subTbl$`Revenue ($B)`
        wikiTbl$Employees <- subTbl$Employees
        wikiTbl$`Market cap ($B)` <- subTbl$`Market cap ($B)`
        
        
        
        # get Location Data for the company headquarters
        getGeoDetails <- function(address){
                
                geo_reply = geocode(address, output = "all", messaging=TRUE, override_limit=TRUE )
                
                list(lat = geo_reply$results[[1]]$geometry$location$lat,
                     lng = geo_reply$results[[1]]$geometry$location$lng)
        }
        
        
        # Annotating the lat and long data for the headquarters
        geoList <- unlist(lapply(wikiTbl$Headquarters, getGeoDetails))
        wikiTbl$lat <- geoList[names(geoList)=="lat"]
        wikiTbl$lng <- geoList[names(geoList)=="lng"]
        
        # Storing result to file
        write_csv(wikiTbl,"./data/lrgstInternetCompanies.csv")
        
} else { wikiTbl <- read_csv("./data/lrgstInternetCompanies.csv")}





# Selective input of subsamples of data based on the industries to display
 

shinyServer(function(input, output, session) {
   
        # Subset dataset based on (Industry, Revenue, Employees, Market Cap)
        filteredData <- reactive({
                # Filter the rows based on input
                wikiTbl %>% filter(
                        Industry == input$industry,
                        `Revenue ($B)`>= input$revenue[1] & `Revenue ($B)`<= input$revenue[2],
                        Employees >= input$employees[1] & Employees <= input$employees[2]
                )
        })
        
        
        # Display map for the whole dataset
        output$map <- renderLeaflet({

                leaflet(data = filteredData())%>% addTiles() %>% 
                        addMarkers(lng = ~lng, lat = ~lat)
        })

        # Display data to check for filtering
        output$data <- renderDataTable(
                filteredData()
        )
        
        # Show a popup at the given location
        showZipcodePopup <- function(Company, lat, lng) {
                selectedComp <- filteredData()[filteredData()$Company == Company,]
                content <- as.character(tagList(
                        p(Company),
                        p(lat),
                        p(lng)
                        
                ))
                leafletProxy("map") %>% addPopups(lng, lat, content, layerId = Company)
        }
        
        # When map is clicked, show a popup with city info
        observe({
                leafletProxy("map") %>% clearPopups()
                event <- input$map_shape_click
                if (is.null(event))
                        return()
                
                isolate({
                        showZipcodePopup(event$id, event$lat, event$lng)
                })
        })
        
        # Reactive Expression to return the bounds of the map right now
        mapInbound <- reactive({
                input$map_bounds
                
        })
        # Rendering the values
        output$mapInbound <- renderText(mapInbound())
        
        
  })
  
