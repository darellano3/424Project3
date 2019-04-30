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
library(maptools)
library(jsonlite)


#detect the number of cpus on your machine. leave one for system processes (my server has 224 which is why I have the ifelse, you can remove that)
cores <- detectCores()-1
cores <- ifelse(cores>10,9,cores)

options(shiny.trace=TRUE)

# Sidebar code here
source("www/Sidebar.R",  local = TRUE)

# UI/plots code here
source("www/Body.R",  local = TRUE)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

  nodeInfoList <- c("so2", "Ozone", "no2", "co", "h2s", "humidity", "temperature", "intensity")
  categories <- c("Good","Moderate","Sensitive Unhealthy","Unhealthy","Very Unhealthy","Hazardous")
  cb_pallete <- c("#009292","#ff6db6","#006ddb","#D55E00","#24ff24","#ffff6d")
  timeFrames <- c("current", "Past 24 hours", "Past Week")
  theme_set(theme_grey(base_size = 18))

  source("www/Server.R",  local = TRUE)

 source("www/darksky.R", local = TRUE)

  # aot data code here
  source("www/dataScript.R", local = TRUE)

  source("source/Map.R", local = TRUE)

  source("source/aotTable.R", local = TRUE)

  observeEvent(input$menu, {
    if (input$menu == 'Map'){
      updateTabsetPanel(session, "tabs", selected = "mapTab")
    }
    if (input$menu == 'B'){
      updateTabsetPanel(session, "tabs", selected = "BTab")
    }
  })

  observeEvent(input$menu, {

    if (input$menu == 'Imperial'){
      source("source/aotTable2.R", local = TRUE)

    } else if (input$menu == 'Metric'){
      source("source/aotTable.R", local = TRUE)
    }

  }, ignoreInit = TRUE)



}

# Run the application
shinyApp(ui = ui, server = server)
