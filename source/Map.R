#Add longitude and latitude to observations_data on pollutants so we can actually bring data together
#SO2_Sites <- merge(sites_reportingSO2, node_data, by.x = "vsn")

#this part will be reactive in our final product
# Daisy original  R map script
# m = leaflet() %>%
#   #the way we visualize can be changed for rn we are just putting circles on the map wherever there are SO2 readings
#   #we can change based on user input once we bring all info together
#   addCircleMarkers(data = SO2_locations, lng = ~latitude, lat = ~longitude, radius = 2, stroke = FALSE, fillOpacity = 0.75) %>%
#   addTiles() %>%
#   setView(-87.647, 41.87, zoom = 9)
# m

SO2_Reporting <- subset(observations_data, sensor_path = "chemsense.so2.concentration")
SO2_locations <- merge(SO2_Reporting, node_data, by.x = "node_vsn", by.y = "vsn")


output$Map_nodes <- renderLeaflet({
  #filter based on pollutants and add longitude and latitude
  #as of right now the filtering isn't working accurately but I think we can fix that later as long as the visualization works
  if(input$Visualized_Element == "temperature"){
    filename <- "metsense.tsys01.temperature"
  }
  else if(input$Visualized_Element == "humidity"){
    filename <- "metsense.htu21d.humidity"
  }
  else if(input$Visualized_Element == "intensity"){
    filename <- "metsense.tsl250rd.intensity"
  }
  else{
  filename <- paste("chemsense", input$Pollutant, "concentration", sep = "." )
  }
  #print(filename)
  Reporting <- subset(observations_data, sensor_path == filename)
  Locations <- merge(Reporting, node_data, by.x = "node_vsn", by.y = "vsn")
  m = leaflet() %>%
    #the way we visualize can be changed for rn we are just putting circles on the map wherever there are SO2 readings
    #we can change based on user input once we bring all info together
    addCircleMarkers(data = Locations, lng = ~latitude, lat = ~longitude, radius = 4, stroke = FALSE, fillOpacity = 0.75) %>%
    addTiles() %>%
    setView(-87.647, 41.87, zoom = 9)
  m
})