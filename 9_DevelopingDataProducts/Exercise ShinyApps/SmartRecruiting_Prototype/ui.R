require(shiny)
require(shinydashboard)


shinyUI(dashboardPage(skin = "yellow",

                    # Create header
                    dashboardHeader(title="SMART Recruiting",
                                    dropdownMenu(type = "messages",
                                                 messageItem(
                                                         from = "Sales Dept",
                                                         message = "Sales are steady this month."
                                                 ),
                                                 messageItem(
                                                         from = "New User",
                                                         message = "How do I register?",
                                                         icon = icon("question"),
                                                         time = "13:45"
                                                 ),
                                                 messageItem(
                                                         from = "Support",
                                                         message = "The new server is ready.",
                                                         icon = icon("life-ring"),
                                                         time = "2014-12-01"
                                                 )
                                    ),
                                    dropdownMenu(type = "notifications",
                                                 notificationItem(
                                                         text = "5 new users today",
                                                         icon("users")
                                                 ),
                                                 notificationItem(
                                                         text = "12 items delivered",
                                                         icon("truck"),
                                                         status = "success"
                                                 ),
                                                 notificationItem(
                                                         text = "Server load at 86%",
                                                         icon = icon("exclamation-triangle"),
                                                         status = "warning"
                                                 )
                                    ),
                                    dropdownMenu(type = "tasks", badgeStatus = "success",
                                                 taskItem(value = 90, color = "green",
                                                          "Documentation"
                                                 ),
                                                 taskItem(value = 17, color = "aqua",
                                                          "Project X"
                                                 ),
                                                 taskItem(value = 75, color = "yellow",
                                                          "Server deployment"
                                                 ),
                                                 taskItem(value = 80, color = "red",
                                                          "Overall project"
                                                 )
                                    )

                    ),

                    # Create Sidebar
                    sidebar <- dashboardSidebar(

                            # Dynamically creating the sidebar
                            sidebarMenuOutput("menu"),

                            # Dynamically creating this section on sever side
                            menuItemOutput("menuitem")
                    ),

                    # Create Body
                    dashboardBody(

                            tabItems(

                                    # First Sidebar Menu Tab content
                                    tabItem(tabName = "dashboard",

                                            # First Row - "Dashboard"
                                            fluidRow(
                                                    # Controlls for map
                                                    column(4, box(
                                                            title = "controls",
                                                            sliderInput("num",
                                                                        label="Choose a number",
                                                                        value = 100, min = 10, max = 250),
                                                            sliderInput("sd",
                                                                        label = "Choose a sd",
                                                                        value = 10, min = 5, max = 15),
                                                            sliderInput("var",
                                                                        label = "Choose a variance",
                                                                        value = 150, min = 100, max = 200))
                                                    ),

                                                    # render Map
                                                    column(8, box( collapsible = TRUE,
                                                                   title = "Labour Market Map",
                                                                   plotOutput("plot1",height = 350)
                                                    ))

                                            ),
                                            # Second Row - "Dashboard"
                                            fluidRow(
                                                    # This row will represent summary graphics for the chosen map layout
                                                    column(4),


                                                    # Second graphic
                                                    column(4,

                                                           box(collapsible = TRUE,
                                                               title = "plot2",
                                                               plotOutput("plot2", height = 250, width = "100%"))
                                                    ),

                                                    # Third grapic
                                                    column(4,
                                                           title = "controls",
                                                           box( collapsible = TRUE,
                                                                plotOutput("plot3", height = 250),
                                                                p("This will display a map of Austria that i will put all information about the relevant players in a region into."))
                                                    )
                                            )
                                    ),




                                    # 2nd Sidebar-Menu Item - "Widgets"
                                    tabItem(tabName = "widgets",

                                            # First Row of Content
                                            fluidRow(
                                                    column(6, tabBox(
                                                            tabPanel("Tab1",
                                                                     h4("Tab Header"),
                                                                     p("Tab content. This can actually be filled with anything i would like to put in here.")
                                                            ),
                                                            tabPanel("Tab2",
                                                                     h4("Tab 2 Header"),
                                                                     p("Again this can be set to hold any kind of information i would like to present here.")),
                                                            tabPanel("Tab3",
                                                                     h4("Tab 3 Header"),
                                                                     p("This too hold information for later use.s"))
                                                    ))
                                            ),

                                            # Second Row of Content
                                            fluidRow(
                                                    # Row1-Column1
                                                    column(6, box(
                                                            title = "first Box",
                                                            plotOutput("plot4", height = 200)

                                                    ))
                                            )
                                    ),

                                    # 3rd Sidebar-Menu Item
                                    tabItem(tabName = "data",

                                            # First Row of Content
                                            fluidRow(

                                                    # First column
                                                    column(5,
                                                           tabBox(title = "Source Connections",
                                                                  tabPanel(
                                                                          title = "Status",
                                                                          h3("Current Datasource Status"),
                                                                          p("This describes the current connection and retrieval status for all associated data sources.")
                                                                  ),
                                                                  tabPanel(
                                                                          title = "Jobs",
                                                                          h3("Current Job status on data retrieval"),
                                                                          p("This describes the current progress and status on the data retrieval jobs scheduled."),
                                                                          tabsetPanel(
                                                                                  tabPanel(
                                                                                          title = "out of sync",
                                                                                          h5("Datasources found to be updatable.")
                                                                                  ),
                                                                                  tabPanel(
                                                                                          title = "up to date",
                                                                                          h5("Datasoureces that are up to date.")
                                                                                  ),
                                                                                  tabPanel(
                                                                                          title = "disconnected",
                                                                                          h5("Datasources currently unavailable.")
                                                                                  )
                                                                          )
                                                                  )

                                                           )),
                                                    # Second Column
                                                    column(7,
                                                           tabBox(title = "Data Retrieval",
                                                                  tabPanel(
                                                                          title = "Trafic",
                                                                          h3("Network Traffic"),
                                                                          plotOutput(outputId = "datasourceTraffic",
                                                                                     height = 450)
                                                                  ),
                                                                  tabPanel(
                                                                          title = "Progress",
                                                                          h3("Ongoing Traffic"),
                                                                          plotOutput(outputId = "trafficOngoing",
                                                                                     height = 250),
                                                                          h3("Progress"),
                                                                          plotOutput(outputId = "trafficProgress",
                                                                                     height = 250)
                                                                  )
                                                           ))
                                            ),
                                            # Second Row of Content
                                            fluidRow(
                                                    # First Column

                                                    # Second Column
                                                    # Third Column

                                            )),

                                    # 4th Sidebar-Menu Item "Schedules"
                                    tabItem(tabName = "schedules",

                                            # First row of Content
                                            fluidRow(



                                            )

                                    ), #End of "Schedules"



                                    # 5th Sidebar-Menu Item
                                    tabItem(tabName = "settings",

                                            # First row of Content
                                            fluidRow(

                                                    # First Column
                                                    column(4,
                                                           box( title = "Color Setup",
                                                                radioButtons(inputId = "color",
                                                                             label = "Set the Dashboard Theme",
                                                                             choices = c("black"= "black",
                                                                                         "white"="white",
                                                                                         "green"="green",
                                                                                         "red"="red",
                                                                                         "orange"="orange"))

                                                           )
                                                    )
                                            ))

                            )

                    )
))