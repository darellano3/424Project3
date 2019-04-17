#parse csv's
#fread from data.table is much faster unless you are storing your data in RDS files
node_data <- fread("data/nodes_updated.csv",nThread = cores,data.table=F)
observations_data <- fread("data/observations.csv",nThread = cores,data.table=F)
sensors_data <-fread("data/sensors.csv",nThread = cores,data.table=F)


##############################
#### RENDER STATE DATA ########
###############################

# NOTE: enter UI elements here for the sidebar filters/inputs

# output$Units <- renderUI({
#   df <- allData[allData$State== input$State & allData$County== input$County, "Year"]
#   selectInput("Year", "Year:", choices = c("Imperial","Metric"))
# })




