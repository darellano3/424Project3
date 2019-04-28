



output$tempTable <- renderDataTable({

  tempReports <-subset(observations_data, sensor_path == "metsense.tsys01.temperature" ) 
  tempLocations <- merge(tempReports, node_data, by.x = "node_vsn", by.y = "vsn")
  
  

  dplyr::select(tempLocations, timestamp, value) 


})


output$OZoneTable <- renderDataTable({
  OzoneReports <- subset(observations_data, sensor_path == "chemsense.ozone.concentration" ) 
  OzoneLocations <- merge(OzoneReports, node_data, by.x = "node_vsn", by.y = "vsn")
  
  dplyr::select(OzoneLocations, timestamp, value)
  
  
})
  
  
output$H2STable <- renderDataTable({
  H2SReports <-subset(observations_data, sensor_path == "chemsense.h2s.concentration" ) 
  H2SLocations <- merge(H2SReports, node_data, by.x = "node_vsn", by.y = "vsn")
  
  dplyr::select(H2SLocations, timestamp, value)
  
})
  
  
  
  
output$humTable <- renderDataTable({
  humReports <-subset(observations_data, sensor_path == "metsense.htu21d.humidity" )
  humLocations <- merge(humReports, node_data, by.x = "node_vsn", by.y = "vsn")
    
  
  dplyr::select(humLocations, timestamp, value)
  
})
  
output$inteTable <- renderDataTable({
  inteReports <-subset(observations_data, sensor_path == "metsense.tsl250rd.intensity" ) 
  inteLocations <- merge(inteReports, node_data, by.x = "node_vsn", by.y = "vsn")
  
  
  dplyr::select(inteLocations, timestamp, value)
  
})
  
output$SO2Table <- renderDataTable({
  SO2Reports <-subset(observations_data, sensor_path == "chemsense.so2.concentration" ) 
  SO2Locations <- merge(SO2Reports, node_data, by.x = "node_vsn", by.y = "vsn")
  
  dplyr::select(SO2Locations, timestamp, value)
  
})
    
output$COTable <- renderDataTable({
  COReports <-subset(observations_data, sensor_path == "chemsense.co.concentration" ) 
  COLocations <- merge(COReports, node_data, by.x = "node_vsn", by.y = "vsn")
  
  dplyr::select(COLocations, timestamp, value)
  
})
  
  
output$NO2Table <- renderDataTable({
  NO2Reports <- subset(observations_data, sensor_path == "chemsense.no2.concentration" ) 
  NO2Locations <- merge(NO2Reports, node_data, by.x = "node_vsn", by.y = "vsn")
  
  
  dplyr::select(NO2Locations, timestamp, value)
  
})
  
  
  
