library(shiny)
library(shinydashboard)
library(ggplot2)
library(lubridate)
library(DT)
library(jpeg)
library(grid)
library(gridExtra)
library(leaflet)
library(scales)
library(readr)
library(dplyr)
library(tidyr)
library(plotly)
library(leaflet)
library(ggplot2)

#download all information
node_data <- read.csv(file = "nodes_updated.csv", header=TRUE, sep=",")
observations_data <- read.csv(file = "observations.csv",  header=TRUE, sep=",")
sensors_data <- read.csv(file = "sensors.csv",  header=TRUE, sep=",")

#filter based on pollutants and add longitude and latitude
#as of right now the filtering isn't working accurately but I think we can fix that later as long as the visualization works
sites_reportingSO2 <- subset(observations_data, sensor_path = "chemsense.so2.concentration")
SO2_locations <- merge(sites_reportingSO2, node_data, by.x = "node_vsn", by.y = "vsn")
sites_reportingCO <- subset(observations_data, sensor_path = "chemsense.co.concentration")
CO_locations <- merge(sites_reportingCO, node_data, by.x = "node_vsn", by.y = "vsn")
sites_reportingNO2 <- subset(observations_data, sensor_path = "chemsense.no2.concentration")
NO2_locations <- merge(sites_reportingNO2, node_data, by.x = "node_vsn", by.y = "vsn")
sites_reportingO3 <- subset(observations_data, sensor_path = "chemsense.o3.concentration")
O3_locations <- merge(sites_reportingO3, node_data, by.x = "node_vsn", by.y = "vsn")
sites_reportingH2S <- subset(observations_data, sensor_path = "chemsense.h2s.concentration")
H2S_locations <- merge(sites_reportingH2S, node_data, by.x = "node_vsn", by.y = "vsn")
sites_reportingpm10 <- subset(observations_data, sensor_path = "alphasense.opc_n2.pm10")
sites_reportingpm2.5 <- subset(observations_data, sensor_path = "alphasense.opc_n2.pm2_5")


#Add longitude and latitude to observations_data on pollutants so we can actually bring data together
#SO2_Sites <- merge(sites_reportingSO2, node_data, by.x = "vsn")

#this part will be reactive in our final product
m = leaflet() %>%
  #the way we visualize can be changed for rn we are just putting circles on the map wherever there are SO2 readings
  #we can change based on user input once we bring all info together
  addCircleMarkers(data = SO2_locations, lng = ~latitude, lat = ~longitude, radius = 2, stroke = FALSE, fillOpacity = 0.75) %>%
  addTiles() %>%
  setView(-87.647, 41.87, zoom = 9)
print(m)


