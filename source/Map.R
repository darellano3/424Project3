#Add longitude and latitude to observations_data on pollutants so we can actually bring data together
#SO2_Sites <- merge(sites_reportingSO2, node_data, by.x = "vsn")

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


data_of_click <- reactiveValues(clickedMarker=NULL)

output$Map_nodes <- renderLeaflet({
  
  m = leaflet() %>%
    #the way we visualize can be changed for rn we are just putting circles on the map wherever there are SO2 readings
    #we can change based on user input once we bring all info together
    # Base groups
    addTiles(group = "OSM(default") %>%
    addProviderTiles("Esri.WorldImagery", group = "Satellite View") %>%
    addProviderTiles(providers$Stamen.Toner, group = "Toner Lite") %>%
    addMarkers(data = inteLocations, lng = ~latitude.y, lat = ~longitude.x, layerId = ~node_vsn, popup = ~node_vsn, group = "Light Intensity(default)") %>%
    addMarkers(data = humLocations, lng = ~latitude.y, lat = ~longitude.x, layerId = ~node_vsn, popup = ~node_vsn, group = "Humidity") %>%
    addMarkers(data = tempLocations, lng = ~latitude.y, lat = ~longitude.x, layerId = ~node_vsn , popup = ~node_vsn, group = "Temperature") %>%
    addMarkers(data = SO2Locations, lng = ~latitude.y, lat = ~longitude.x, layerId = ~node_vsn, popup = ~node_vsn, group = "SO2") %>%
    addMarkers(data = H2SLocations, lng = ~latitude.y, lat = ~longitude.x, layerId = ~node_vsn, popup = ~node_vsn, group = "H2S") %>%
    addMarkers(data = OzoneLocations, lng = ~latitude.y, lat = ~longitude.x, layerId = ~node_vsn, popup = ~node_vsn, group = "Ozone") %>%
    addMarkers(data = NO2Locations, lng = ~latitude.y, lat = ~longitude.x, layerId = ~node_vsn, popup = ~node_vsn, group = "NO2") %>%
    addMarkers(data = COLocations, lng = ~latitude.y, lat = ~longitude.x, layerId = ~node_vsn, popup = ~node_vsn, group = "CO") %>%
    
    
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
  data_of_click$clickedMarker <- input$Map_nodes_marker_click
  
  as.POSIXlt("2019-04-28T17:14:42", tz = "GMT", "%Y-%m-%dT%H:%M:%OS")
  
})









output$graph <- renderPlotly({
  node_id = data_of_click$clickedMarker$id
  
  if(is.null(node_id)){
    node_id = "004"
  }
  currentTimeObject <- as.POSIXlt(Sys.Date() - lubridate::hours(1), tz = "GMT", "%Y-%m-%d %H:%M:%OS" )
  past24TimeObject <- as.POSIXlt(Sys.Date() - lubridate::hours(24), tz = "GMT", "%Y-%m-%d %H:%M:%OS" )
  pastWeekTimeObject <- as.POSIXlt(Sys.Date() - lubridate::days(7), tz = "GMT", "%Y-%m-%d %H:%M:%OS" )
  
  
  tempCurrent <- subset(tempLocations, as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  humidityCurrent <- subset(humLocations, as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  SO2Current <- subset(SO2Locations, as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  COCurrent <- subset(COLocations, as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  OzoneCurrent <- subset(OzoneLocations, as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  inteCurrent <- subset(inteLocations, as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  NO2Current <- subset(NO2Locations, as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  H2SCurrent <- subset(H2SLocations, as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)

  tempPast24 <- subset(tempLocations, as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  humPast24 <- subset(humLocations, as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  SO2Past24 <- subset(SO2Locations, as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  COPast24 <- subset(COLocations, as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  OzonePast24 <- subset(OzoneLocations, as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  intePast24 <- subset(inteLocations, as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  NO2Past24 <- subset(NO2Locations, as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
  H2SPast24 <- subset(H2SLocations, as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)

  tempPastWeek <- subset(tempLocations, as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
  humPastWeek <- subset(humLocations, as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
  SO2PastWeek <- subset(SO2Locations, as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
  COPastWeek <- subset(COLocations, as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
  OzonePastWeek <- subset(OzoneLocations, as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
  intePastWeek <- subset(inteLocations, as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
  NO2PastWeek <- subset(NO2Locations, as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
  H2SPastWeek <- subset(H2SLocations, as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)

  
  # p = ggplot() +
  #   geom_line(data = COPastWeek, aes(x = timestamp, y = value, colour = "CO", group = 1), color = "#56B4E9", size = 3) +
  #   geom_line(data = SO2PastWeek, aes(x = timestamp, y = value, colour = "S02", group = 1), color = "#009E73", size = 3) +
  #   #geom_line(data = OzonePastWeek, aes(x = timestamp, y = value, colour = "Ozone", group = 1), color = "#F0E442", size = 3) +
  #   geom_line(data = NO2PastWeek, aes(x = timestamp, y = value, colour = "NO2", group = 1), color = "#0072B2", size = 3) +
  #   geom_line(data = H2SPastWeek, aes(x = timestamp, y = value, colour = "H2S", group = 1), color = "#D55E00", size = 3) +
  #   geom_point() + theme(axis.text.x=element_blank()) +
  #   xlab('Time') + ylab('Value')
  # print(p)
  
  p = ggplot() +
    geom_line(data = COPastWeek, aes(x = timestamp, y = value, group = 1, colour = 'CO'),  size = 3 ) +
    geom_line(data = SO2PastWeek, aes(x = timestamp, y = value,  group = 1, colour = 'SO2'),  size = 3 ) +
    #geom_line(data = OzonePastWeek, aes(x = timestamp, y = value,  group = 1, colour = 'Ozone'),  size = 3) +
    geom_line(data = NO2PastWeek, aes(x = timestamp, y = value,  group = 1, colour = 'NO2'),  size = 3 ) +
    geom_line(data = H2SPastWeek, aes(x = timestamp, y = value,  group = 1, colour = 'H2S'), size = 3 ) +
    
    geom_point(data = COPastWeek, aes(x = timestamp, y = value, group = 1, colour = 'CO'),  size = 5 ) +
    geom_point(data = SO2PastWeek, aes(x = timestamp, y = value, group = 1, colour = 'SO2'),  size = 5 ) +
    #geom_point(data = OzonePastWeek, aes(x = timestamp, y = value,  group = 1, colour = 'Ozone'),  size = 5) +
    geom_point(data = NO2PastWeek, aes(x = timestamp, y = value, group = 1, colour = 'NO2'),  size = 5 ) +
    geom_point(data = H2SPastWeek, aes(x = timestamp, y = value, group = 1, colour = 'H2S'),  size = 5 ) +
    
    theme(axis.text.x=element_blank())  + 
    
    xlab('Time') + ylab('Value') + labs(color = "Pollutants") + 
    scale_color_manual(values=c("#E69F00","#56B4E9","#009E73","#0072B2","#D55E00", "#E69F00", "#56B4E9","#009E73","#0072B2","#D55E00") ) 
    
  p

})


observeEvent(input$AOTSelect, {
  
  
  if (input$AOTSelect == 'current'){
    output$graph <- renderPlotly({
      node_id = data_of_click$clickedMarker$id
      
      if(is.null(node_id)){
        node_id = "004"
      }
      currentTimeObject <- as.POSIXlt(Sys.Date() - lubridate::hours(1), tz = "GMT", "%Y-%m-%d %H:%M:%OS" )
      past24TimeObject <- as.POSIXlt(Sys.Date() - lubridate::hours(24), tz = "GMT", "%Y-%m-%d %H:%M:%OS" )
      pastWeekTimeObject <- as.POSIXlt(Sys.Date() - lubridate::days(7), tz = "GMT", "%Y-%m-%d %H:%M:%OS" )
      
      
      tempCurrent <- subset(tempLocations, as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      humidityCurrent <- subset(humLocations, as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      SO2Current <- subset(SO2Locations, as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      COCurrent <- subset(COLocations, as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      OzoneCurrent <- subset(OzoneLocations, as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      inteCurrent <- subset(inteLocations, as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      NO2Current <- subset(NO2Locations, as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      H2SCurrent <- subset(H2SLocations, as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      
      tempPast24 <- subset(tempLocations, as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      humPast24 <- subset(humLocations, as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      SO2Past24 <- subset(SO2Locations, as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      COPast24 <- subset(COLocations, as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      OzonePast24 <- subset(OzoneLocations, as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      intePast24 <- subset(inteLocations, as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      NO2Past24 <- subset(NO2Locations, as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      H2SPast24 <- subset(H2SLocations, as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
      
      tempPastWeek <- subset(tempLocations, as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
      humPastWeek <- subset(humLocations, as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
      SO2PastWeek <- subset(SO2Locations, as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
      COPastWeek <- subset(COLocations, as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
      OzonePastWeek <- subset(OzoneLocations, as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
      intePastWeek <- subset(inteLocations, as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
      NO2PastWeek <- subset(NO2Locations, as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
      H2SPastWeek <- subset(H2SLocations, as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
      
      # p = ggplot() +
      #   geom_line(data = COCurrent, aes(x = timestamp, y = value, colour = "CO", group = 1), color = "#56B4E9", size = 3) +
      #   geom_line(data = SO2Current, aes(x = timestamp, y = value, colour = "S02", group = 1), color = "#009E73", size = 3) +
      #   #geom_line(data = OzoneCurrent, aes(x = timestamp, y = value, colour = "Ozone", group = 1), color = "#F0E442", size = 3) +
      #   geom_line(data = NO2Current, aes(x = timestamp, y = value, colour = "NO2", group = 1), color = "#0072B2", size = 3) +
      #   geom_line(data = H2SCurrent, aes(x = timestamp, y = value, colour = "H2S", group = 1), color = "#D55E00", size = 3) +
      #   geom_point() + theme(axis.text.x=element_blank()) +
      #   xlab('Time') + ylab('Value')
      # print(p)
      
      p = ggplot() +
        geom_line(data = COCurrent, aes(x = timestamp, y = value, group = 1, colour = 'CO'),  size = 3 ) +
        geom_line(data = SO2Current, aes(x = timestamp, y = value,  group = 1, colour = 'SO2'),  size = 3 ) +
        #geom_line(data = OzoneCurrent, aes(x = timestamp, y = value,  group = 1, colour = 'Ozone'),  size = 3) +
        geom_line(data = NO2Current, aes(x = timestamp, y = value,  group = 1, colour = 'NO2'),  size = 3 ) +
        geom_line(data = H2SCurrent, aes(x = timestamp, y = value,  group = 1, colour = 'H2S'), size = 3 ) +
        
        geom_point(data = COCurrent, aes(x = timestamp, y = value, group = 1, colour = 'CO'),  size = 5 ) +
        geom_point(data = SO2Current, aes(x = timestamp, y = value, group = 1, colour = 'SO2'),  size = 5 ) +
        #geom_point(data = OzoneCurrent, aes(x = timestamp, y = value,  group = 1, colour = 'Ozone'),  size = 5) +
        geom_point(data = NO2Current, aes(x = timestamp, y = value, group = 1, colour = 'NO2'),  size = 5 ) +
        geom_point(data = H2SCurrent, aes(x = timestamp, y = value, group = 1, colour = 'H2S'),  size = 5 ) +
        
        theme(axis.text.x=element_blank())  + 
        
        xlab('Time') + ylab('Value') + labs(color = "Pollutants") + 
        scale_color_manual(values=c("#E69F00","#56B4E9","#009E73","#0072B2","#D55E00", "#E69F00", "#56B4E9","#009E73","#0072B2","#D55E00") ) 
      
      p

      
    })
    
      
    
    
  } else if (input$AOTSelect == '24 hours'){
    
      
      
      output$graph <- renderPlotly({
        node_id = data_of_click$clickedMarker$id
        
        if(is.null(node_id)){
          node_id = "004"
        }
        currentTimeObject <- as.POSIXlt(Sys.Date() - lubridate::hours(1), tz = "GMT", "%Y-%m-%d %H:%M:%OS" )
        past24TimeObject <- as.POSIXlt(Sys.Date() - lubridate::hours(24), tz = "GMT", "%Y-%m-%d %H:%M:%OS" )
        pastWeekTimeObject <- as.POSIXlt(Sys.Date() - lubridate::days(7), tz = "GMT", "%Y-%m-%d %H:%M:%OS" )
        
        
        tempCurrent <- subset(tempLocations, as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        humidityCurrent <- subset(humLocations, as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        SO2Current <- subset(SO2Locations, as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        COCurrent <- subset(COLocations, as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        OzoneCurrent <- subset(OzoneLocations, as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        inteCurrent <- subset(inteLocations, as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        NO2Current <- subset(NO2Locations, as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        H2SCurrent <- subset(H2SLocations, as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        
        tempPast24 <- subset(tempLocations, as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        humPast24 <- subset(humLocations, as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        SO2Past24 <- subset(SO2Locations, as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        COPast24 <- subset(COLocations, as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        OzonePast24 <- subset(OzoneLocations, as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        intePast24 <- subset(inteLocations, as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        NO2Past24 <- subset(NO2Locations, as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        H2SPast24 <- subset(H2SLocations, as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        
        tempPastWeek <- subset(tempLocations, as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        humPastWeek <- subset(humLocations, as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        SO2PastWeek <- subset(SO2Locations, as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        COPastWeek <- subset(COLocations, as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        OzonePastWeek <- subset(OzoneLocations, as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        intePastWeek <- subset(inteLocations, as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        NO2PastWeek <- subset(NO2Locations, as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        H2SPastWeek <- subset(H2SLocations, as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
      
      # p = ggplot() +
      #   geom_line(data = COPast24, aes(x = timestamp, y = value, colour = "CO", group = 1), color = "#56B4E9", size = 3) +
      #   geom_line(data = SO2Past24, aes(x = timestamp, y = value, colour = "S02", group = 1), color = "#009E73", size = 3) +
      #   #geom_line(data = OzonePast24, aes(x = timestamp, y = value, colour = "Ozone", group = 1), color = "#F0E442", size = 3) +
      #   geom_line(data = NO2Past24, aes(x = timestamp, y = value, colour = "NO2", group = 1), color = "#0072B2", size = 3) +
      #   geom_line(data = H2SPast24, aes(x = timestamp, y = value, colour = "H2S", group = 1), color = "#D55E00", size = 3) +
      #   geom_point() + theme(axis.text.x=element_blank()) +
      #   xlab('Time') + ylab('Value')
      # print(p)
      
      
      p = ggplot() +
        geom_line(data = COPast24, aes(x = timestamp, y = value, group = 1, colour = 'CO'),  size = 3 ) +
        geom_line(data = SO2Past24, aes(x = timestamp, y = value,  group = 1, colour = 'SO2'),  size = 3 ) +
        #geom_line(data = OzonePast24, aes(x = timestamp, y = value,  group = 1, colour = 'Ozone'),  size = 3) +
        geom_line(data = NO2Past24, aes(x = timestamp, y = value,  group = 1, colour = 'NO2'),  size = 3 ) +
        geom_line(data = H2SPast24, aes(x = timestamp, y = value,  group = 1, colour = 'H2S'), size = 3 ) +
        
        geom_point(data = COPast24, aes(x = timestamp, y = value, group = 1, colour = 'CO'),  size = 5 ) +
        geom_point(data = SO2Past24, aes(x = timestamp, y = value, group = 1, colour = 'SO2'),  size = 5 ) +
        #geom_point(data = OzonePast24, aes(x = timestamp, y = value,  group = 1, colour = 'Ozone'),  size = 5) +
        geom_point(data = NO2Past24, aes(x = timestamp, y = value, group = 1, colour = 'NO2'),  size = 5 ) +
        geom_point(data = H2SPast24, aes(x = timestamp, y = value, group = 1, colour = 'H2S'),  size = 5 ) +
        
        theme(axis.text.x=element_blank())  + 
        
        xlab('Time') + ylab('Value') + labs(color = "Pollutants") + 
        scale_color_manual(values=c("#E69F00","#56B4E9","#009E73","#0072B2","#D55E00", "#E69F00", "#56B4E9","#009E73","#0072B2","#D55E00") ) 
      
      p
      #print(p)
      
      
      })
   
    
  } else if (input$AOTSelect == '7 days'){
    
      output$graph <- renderPlotly({
        node_id = data_of_click$clickedMarker$id
        
        if(is.null(node_id)){
          node_id = "004"
        }
        currentTimeObject <- as.POSIXlt(Sys.Date() - lubridate::hours(1), tz = "GMT", "%Y-%m-%d %H:%M:%OS" )
        past24TimeObject <- as.POSIXlt(Sys.Date() - lubridate::hours(24), tz = "GMT", "%Y-%m-%d %H:%M:%OS" )
        pastWeekTimeObject <- as.POSIXlt(Sys.Date() - lubridate::days(7), tz = "GMT", "%Y-%m-%d %H:%M:%OS" )
        
        
        tempCurrent <- subset(tempLocations, as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        humidityCurrent <- subset(humLocations, as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        SO2Current <- subset(SO2Locations, as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        COCurrent <- subset(COLocations, as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        OzoneCurrent <- subset(OzoneLocations, as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        inteCurrent <- subset(inteLocations, as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        NO2Current <- subset(NO2Locations, as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        H2SCurrent <- subset(H2SLocations, as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        
        tempPast24 <- subset(tempLocations, as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        humPast24 <- subset(humLocations, as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        SO2Past24 <- subset(SO2Locations, as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        COPast24 <- subset(COLocations, as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        OzonePast24 <- subset(OzoneLocations, as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        intePast24 <- subset(inteLocations, as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        NO2Past24 <- subset(NO2Locations, as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        H2SPast24 <- subset(H2SLocations, as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > currentTimeObject & node_vsn == node_id)
        
        tempPastWeek <- subset(tempLocations, as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(tempLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        humPastWeek <- subset(humLocations, as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(humLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        SO2PastWeek <- subset(SO2Locations, as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(SO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        COPastWeek <- subset(COLocations, as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(COLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        OzonePastWeek <- subset(OzoneLocations, as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(OzoneLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        intePastWeek <- subset(inteLocations, as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(inteLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        NO2PastWeek <- subset(NO2Locations, as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(NO2Locations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        H2SPastWeek <- subset(H2SLocations, as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) < as.POSIXlt(Sys.time(),tz = "GMT", "%Y-%m-%d %H:%M:%OS" ) & as.POSIXlt(H2SLocations[["timestamp"]], tz = "GMT", "%Y-%m-%dT%H:%M:%OS" ) > past24TimeObject & node_vsn == node_id)
        
        
        # p = ggplot() +
        #   geom_line(data = COPastWeek, aes(x = timestamp, y = value, colour = "CO", group = 1), color = "#56B4E9", size = 3) +
        #   geom_line(data = SO2PastWeek, aes(x = timestamp, y = value, colour = "S02", group = 1), color = "#009E73", size = 3) +
        #   #geom_line(data = OzonePastWeek, aes(x = timestamp, y = value, colour = "Ozone", group = 1), color = "#F0E442", size = 3) +
        #   geom_line(data = NO2PastWeek, aes(x = timestamp, y = value, colour = "NO2", group = 1), color = "#0072B2", size = 3) +
        #   geom_line(data = H2SPastWeek, aes(x = timestamp, y = value, colour = "H2S", group = 1), color = "#D55E00", size = 3) +
        #   geom_point() + theme(axis.text.x=element_blank()) +
        #   xlab('Time') + ylab('Value')
        # print(p)
        
        p = ggplot() +
          geom_line(data = COPastWeek, aes(x = timestamp, y = value, group = 1, colour = 'CO'),  size = 3 ) +
          geom_line(data = SO2PastWeek, aes(x = timestamp, y = value,  group = 1, colour = 'SO2'),  size = 3 ) +
          #geom_line(data = OzonePastWeek, aes(x = timestamp, y = value,  group = 1, colour = 'Ozone'),  size = 3) +
          geom_line(data = NO2PastWeek, aes(x = timestamp, y = value,  group = 1, colour = 'NO2'),  size = 3 ) +
          geom_line(data = H2SPastWeek, aes(x = timestamp, y = value,  group = 1, colour = 'H2S'), size = 3 ) +
          
          geom_point(data = COPastWeek, aes(x = timestamp, y = value, group = 1, colour = 'CO'),  size = 5 ) +
          geom_point(data = SO2PastWeek, aes(x = timestamp, y = value, group = 1, colour = 'SO2'),  size = 5 ) +
          #geom_point(data = OzonePastWeek, aes(x = timestamp, y = value,  group = 1, colour = 'Ozone'),  size = 5) +
          geom_point(data = NO2PastWeek, aes(x = timestamp, y = value, group = 1, colour = 'NO2'),  size = 5 ) +
          geom_point(data = H2SPastWeek, aes(x = timestamp, y = value, group = 1, colour = 'H2S'),  size = 5 ) +
          
          theme(axis.text.x=element_blank())  + 
          
          xlab('Time') + ylab('Value') + labs(color = "Pollutants") + 
          scale_color_manual(values=c("#E69F00","#56B4E9","#009E73","#0072B2","#D55E00", "#E69F00", "#56B4E9","#009E73","#0072B2","#D55E00") ) 
        
        p
        #print(p)
        
        
      })
   

  }
  
}, ignoreInit = TRUE)

