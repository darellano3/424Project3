# This file containts the sidebar for user input 

sidebar <- dashboardSidebar(width=350, 
                            
                            shiny::conditionalPanel(condition="input$sidebar == 'tabOne'",
                                                    HTML("
                                                         <IMG SRC=logo.png ALT='UIC' WIDTH=300 HEIGHT=90>"
                                                    )
                                                    ),
                            
                            br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),
                            br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),
                            
                            shiny::conditionalPanel(condition="input$sidebar == 'tabOne'",
                                                    HTML("
                                                         &nbsp &nbsp <font size=+1> <strong> Project 3: The Air That I Breathe </strong> </font> <br> 
                                                         &nbsp &nbsp <i> Air quality data in the City of Chicago </i> <br><br>"
                                                    )
                                                    ),
                            sidebarMenu(
                              id ="menu",
                              menuItem('Visualizations',tabName='visualizations',startExpanded = TRUE,
                                       menuSubItem("Interactive Map",tabName='Map'),
                                       menuSubItem("Heat Map",tabName='B')
                              ),
                              menuItem('Measurement',tabName='Measurement',startExpanded = FALSE,
                                       menuSubItem("Metric",tabName='Metric'),
                                       menuSubItem("Imperial",tabName='Imperial')
                              ),
                              br(),
                              shiny::conditionalPanel(condition="input$sidebar == 'tabOne'",
                                                      HTML("
                                                           &nbsp &nbsp <b> Authors: </b> <br> 
                                                           &nbsp &nbsp Daisy Arellano & Jhon Nunez <br> 
                                                           &nbsp &nbsp Cesar Lazcano & Jay Patel <br> <br>
                                                           &nbsp &nbsp <b> Libraries Used: </b> <br>
                                                           &nbsp &nbsp dplyr, ggplot2, ggmap, scales, gridExtra, DT <br>
                                                           &nbsp &nbsp leaflet, data.table, parallel, readr, shinyWidgets <br> 
                                                           &nbsp &nbsp lubridate, jpeg, readr, tidyr, plotly <br> <br>
                                                           &nbsp &nbsp <b> Data: </b> <br>
                                                           &nbsp &nbsp Data imported from the EPA <br>
                                                           &nbsp &nbsp (United States Environmental Protection Agency) <br><br><br>
                                                           "
                                                      )
                                                      )
                                                      )
                                                      )
# end sidebar