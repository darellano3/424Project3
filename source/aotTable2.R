
#this file populates the aotTable with Imperial System measurements

output$tempTable <- renderDataTable({
  tempReports <-subset(observations_data, sensor_path == "metsense.tsys01.temperature" ) 
  # convert fahrenheit to table 
  tempReports$value <- round (( (tempReports$value * 9/5) + 32), digits = 0 )
  tempReports$uom <- ('F')
  tempLocations <- merge(tempReports, node_data, by.x = "node_vsn", by.y = "vsn")

  dplyr::select(tempLocations, timestamp, value, uom) 

})


output$OZoneTable <- renderDataTable({
  OzoneReports <- subset(observations_data, sensor_path == "chemsense.ozone.concentration" ) 
  OzoneLocations <- merge(OzoneReports, node_data, by.x = "node_vsn", by.y = "vsn")

  dplyr::select(OzoneLocations, timestamp, value, uom)
  
})
  
  
output$H2STable <- renderDataTable({
  H2SReports <-subset(observations_data, sensor_path == "chemsense.h2s.concentration" ) 
  # convert ppm to mg/L
  H2SReports$value <- round( (H2SReports$value * 0.000008345404), digits = 7)
  H2SReports$uom <- ('lb/gal')
  
  H2SLocations <- merge(H2SReports, node_data, by.x = "node_vsn", by.y = "vsn")
  dplyr::select(H2SLocations, timestamp, value, uom)
  
})

  
output$humTable <- renderDataTable({
  humReports <-subset(observations_data, sensor_path == "metsense.htu21d.humidity" )
  humLocations <- merge(humReports, node_data, by.x = "node_vsn", by.y = "vsn")
  
  dplyr::select(humLocations, timestamp, value, uom)
  
})
  
output$inteTable <- renderDataTable({
  inteReports <-subset(observations_data, sensor_path == "metsense.tsl250rd.intensity" ) 
  # convert cm^2 to in^2
  inteReports$value <- round( (inteReports$value * 0.155), digits = 3)
  inteReports$uom <- ('in^2')
  
  inteLocations <- merge(inteReports, node_data, by.x = "node_vsn", by.y = "vsn")
  
  dplyr::select(inteLocations, timestamp, value, uom)
  
})
  
output$SO2Table <- renderDataTable({
  SO2Reports <-subset(observations_data, sensor_path == "chemsense.so2.concentration" )
  # convert ppm to mg/L
  SO2Reports$value <- round( (SO2Reports$value * 0.000008345404), digits = 7)
  SO2Reports$uom <- ('lb/gal')
  
  SO2Locations <- merge(SO2Reports, node_data, by.x = "node_vsn", by.y = "vsn")
  
  dplyr::select(SO2Locations, timestamp, value, uom)
  
})
    
output$COTable <- renderDataTable({
  COReports <-subset(observations_data, sensor_path == "chemsense.co.concentration" ) 
  # convert ppm to mg/L
  COReports$value <- round( (COReports$value * 0.000008345404), digits = 7)
  COReports$uom <- ('lb/gal')
  
  COLocations <- merge(COReports, node_data, by.x = "node_vsn", by.y = "vsn")
  
  dplyr::select(COLocations, timestamp, value, uom)
  
})
  
  
output$NO2Table <- renderDataTable({
  NO2Reports <- subset(observations_data, sensor_path == "chemsense.no2.concentration" ) 
  # convert ppm to mg/L
  NO2Reports$value <- round( (NO2Reports$value * 0.000008345404), digits = 7)
  NO2Reports$uom <- ('lb/gal')
  
  NO2Locations <- merge(NO2Reports, node_data, by.x = "node_vsn", by.y = "vsn")
  
  dplyr::select(NO2Locations, timestamp, value, uom)
  
})
  
  
  
