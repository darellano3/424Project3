#
# Name: Daisy Arellano & Jhon Nunez & Cesar Lazcano & Jay Patel
# Class: CS424 Visualization and Visual Analytics 
# Spring 2019
#
# Project 3 The Air that I Breathe
# Description: Visual Representation of Air Quality in the City of Chicago


# libraries
library(shiny)
library(shinydashboard)
library(dashboardthemes)
library(dplyr)
library(ggplot2)
library(ggmap)
library(scales)
library(grid)
library(gridExtra)
library(DT)
library(leaflet)
library(data.table)
library(parallel)
library(readr)
library(shinyWidgets)
library(lubridate)
library(jpeg)
library(readr)
library(tidyr)
library(plotly)
#live libs
library(tidyverse)
library(httr)
library(jsonlite)


#detect the number of cpus on your machine. leave one for system processes (my server has 224 which is why I have the ifelse, you can remove that)
cores <- detectCores()-1
cores <- ifelse(cores>10,9,cores)

options(shiny.trace=TRUE)

source("www/Sidebar.R",  local = TRUE)

source("www/dataScript.R", local = TRUE)

source("www/Body.R",  local = TRUE)


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


# Define UI for application that draws a histogram
ui <- dashboardPage(
  
  #Dashboard Title
  dashboardHeader(title = "Array of Things Visualization",
                  titleWidth = 350),
  sidebar,
  dashboardBody(
    
    shinyDashboardThemes(
      theme = "purple_gradient"
    ),
    
    #tags$head(tags$style(HTML('
    # .skin-blue .main-sidebar {
    #                          background-color: #0072B2;
    #                          }
    #                          .skin-blue .sidebar-menu>li.active>a, .skin-blue .sidebar-menu>li:hover>a {
    #                          background-color: #444444;
    #                          }
    #                          '))),
    
    tabsetPanel(id = "tabs",
                
                tabPanel("Interactive Map", br(), value = "mapTab", 
                         
                         div(style = "font-size: 20px; padding: 5px 0px; margin:0%",
                             
                             fluidRow(width = 12,
                                      box( 
                                        width = 12, title="Graph of AOT Nodes",solidHeader = TRUE,
                                        plotlyOutput(outputId = "graph", height = 400)
                                      )
                             ),
                             fluidRow(width = 12,
                                      box( 
                                        width = 8, title="Interactive Map of AOT Nodes",solidHeader = TRUE,#status="success",
                                        leafletOutput(outputId = "Map_nodes", height = 800)
                                      ),
                                      box( 
                                        width = 4, title="Table of AOT Nodes",solidHeader = TRUE,
                                        plotlyOutput(outputId = "table", height = 800)
                                      )
                             )
                         ) 
                ),
                tabPanel("Heat Map", br(), value = "BTab",
                         
                         div(style = "font-size: 20px; padding: 5px 0px; margin:0%",
                             box(
                               width = 12, solidHeader = TRUE, leafletOutput("heatMap", height = 1200)
                             )
                         )
                )
    )#end of tabsetPanel
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  observeEvent(input$menu, {
    if (input$menu == 'Map'){
      updateTabsetPanel(session, "tabs", selected = "mapTab")
    }
    if (input$menu == 'B'){
      updateTabsetPanel(session, "tabs", selected = "BTab")
    }
  })
  
  #NEW
  nodeInfoList <- c("so2", "Ozone", "no2", "co", "h2s", "humidity", "temperature", "intensity")
  categories <- c("Good","Moderate","Sensitive Unhealthy","Unhealthy","Very Unhealthy","Hazardous")
  cb_pallete <- c("#009292","#ff6db6","#006ddb","#D55E00","#24ff24","#ffff6d")
  theme_set(theme_grey(base_size = 18)) 
  
  source("www/Server.R",  local = TRUE)
  
  source("source/Map.R", local = TRUE)
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)