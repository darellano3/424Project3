# libraries
library(shiny)
library(shinydashboard)
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


#detect the number of cpus on your machine. leave one for system processes (my server has 224 which is why I have the ifelse, you can remove that)
cores <- detectCores()-1
cores <- ifelse(cores>10,9,cores)

options(shiny.trace=TRUE)

source("www/Sidebar.R",  local = TRUE)

source("www/Body.R",  local = TRUE)

ui <- dashboardPage(
  dashboardHeader(title="Live AOT AQI Visualizations ",
                  dropdownMenuOutput("messageMenu"))
  ,
  sidebar,
  body
)
server <- function(input, output,session) {
  pollutants_names <- c("CO","NO2","Ozone","SO2","PM2.5","PM10")
  categories <- c("Good","Moderate","Sensitive Unhealthy","Unhealthy","Very Unhealthy","Hazardous")
  cb_pallete <- c("#009292","#ff6db6","#006ddb","#D55E00","#24ff24","#ffff6d")
  theme_set(theme_grey(base_size = 18)) 
  
  
  # import dependent files
  source("www/Server.R",  local = TRUE)
  
  source("source/Map.R", local = TRUE)
  
  ##
}

shinyApp(ui, server)