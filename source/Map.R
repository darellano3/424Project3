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


output$Map_nodes <- renderLeaflet({
  #filter based on pollutants and add longitude and latitude
  #as of right now the filtering isn't working accurately but I think we can fix that later as long as the visualization works
  tempReports <-subset(observations_data, sensor_path == "metsense.tsys01.temperature" ) 
  tempLocations <- merge(tempReports, node_data, by.x = "node_vsn", by.y = "vsn")
  humReports <-subset(observations_data, sensor_path == "metsense.htu21d.humidity" )
  humLocations <- merge(humReports, node_data, by.x = "node_vsn", by.y = "vsn")
  inteReports <-subset(observations_data, sensor_path == "metsense.tsl250rd.intensity" ) 
  inteLocations <- merge(inteReports, node_data, by.x = "node_vsn", by.y = "vsn")
  SO2Reports <-subset(observations_data, sensor_path == "chemsense.so2.concentration" ) 
  SO2Locations <- merge(SO2Reports, node_data, by.x = "node_vsn", by.y = "vsn")
  COReports <-subset(observations_data, sensor_path == "chemsense.co.concentration" ) 
  COLocations <- merge(COReports, node_data, by.x = "node_vsn", by.y = "vsn")
  NO2Reports <- subset(observations_data, sensor_path == "chemsense.no2.concentration" ) 
  NO2Locations <- merge(NO2Reports, node_data, by.x = "node_vsn", by.y = "vsn")
  OzoneReports <- subset(observations_data, sensor_path == "chemsense.ozone.concentration" ) 
  OzoneLocations <- merge(OzoneReports, node_data, by.x = "node_vsn", by.y = "vsn")
  H2SReports <-subset(observations_data, sensor_path == "chemsense.h2s.concentration" ) 
  H2SLocations <- merge(H2SReports, node_data, by.x = "node_vsn", by.y = "vsn")
  

  m = leaflet() %>%
    #the way we visualize can be changed for rn we are just putting circles on the map wherever there are SO2 readings
    #we can change based on user input once we bring all info together
    # Base groups
    addTiles(group = "OSM(default") %>%
    addProviderTiles("Esri.WorldImagery", group = "Satellite View") %>%
    addProviderTiles(providers$Stamen.Toner, group = "Toner Lite") %>%
    addMarkers(data = inteLocations, lng = ~latitude, lat = ~longitude, popup = ~node_vsn, group = "Light Intensity(default)") %>%
    addMarkers(data = humLocations, lng = ~latitude, lat = ~longitude, popup = ~node_vsn, group = "Humidity") %>%
    addMarkers(data = tempLocations, lng = ~latitude, lat = ~longitude, popup = ~node_vsn, group = "Temperature") %>%
    addMarkers(data = SO2Locations, lng = ~latitude, lat = ~longitude, popup = ~node_vsn, group = "SO2") %>%
    addMarkers(data = H2SLocations, lng = ~latitude, lat = ~longitude, popup = ~node_vsn, group = "H2S") %>%
    addMarkers(data = OzoneLocations, lng = ~latitude, lat = ~longitude, popup = ~node_vsn, group = "Ozone") %>%
    addMarkers(data = NO2Locations, lng = ~latitude, lat = ~longitude, popup = ~node_vsn, group = "NO2") %>%
    addMarkers(data = COLocations, lng = ~latitude, lat = ~longitude, popup = ~node_vsn, group = "CO") %>%
    
    
    setView(-87.647, 41.87, zoom = 11)%>%
    addLayersControl(
      position = "bottomright",
      baseGroups = c("OSM(default)", "Satellite View","Toner Lite"),
      overlayGroups = c("Light Intensity(default)", "Humidity", "Temperature", "SO2", "H2S", "Ozone", "NO2", "CO"),
      options = layersControlOptions(collapsed = FALSE)
    )
  m
})

observeEvent(input$Map_nodes_marker_click, { 
  p <- input$map_marker_click
  print(p)
})