# CONSTANT endpoints for AOT
NODES_ENDPOINT = 'https://api.arrayofthings.org/api/nodes?size=200&location=chicago'
SENSORS_ENDPOINT = 'https://api.arrayofthings.org/api/sensors?size=200'
OBSERVATIONS_ENDPOINT = 'https://api.arrayofthings.org/api/observations?size=5000'

# Anything that calls autoInvalidate will automatically invalidate
# every 60 seconds.
autoInvalidate <- reactiveTimer(90 * 1000)

observe({
  #invalidating timer function - triggers every minute
  autoInvalidate()
  print("updating data")
  
  getData()
})


#function to retrieve data and update csv
getData <- function() {
  # update all data files (data log) - avoid reactives
  isolate(initNodes())
  isolate(initSensors())
  isolate(initObservations())
  
  # read from file - this approach allows us to remove ourself from reactive scope
  # and gives us better data managability
  node_data <- fread("data/nodes.csv",nThread = cores,data.table=F)
  observations_data <- fread("data/observations.csv",nThread = cores,data.table=F)
  sensors_data <-fread("data/sensors.csv",nThread = cores,data.table=F)
  
  print(">> data retrieved")
  print(head(observations_data))
}


initNodes <- function() {
  #invalidating timer function - triggers every minute
  print(">> nodes init")
  
  # create requests from endpoints
  n_request <- GET(url = NODES_ENDPOINT)
  
  # create responses/json
  n_response <- content(n_request, as = "text", encoding = "UTF-8")
  n_json <- jsonlite::fromJSON(n_response)
  
  # create dataframes
  n_df <- data.frame(n_json$data)
  
  # clean our data 
  #nodes
  coords <- n_df$location$geometry$coordinates
  lats <- c()
  longs <- c()
  for(i in coords){ lats <- c(lats, i[1]) }
  for(i in coords){ longs <- c(longs, i[2]) }
  n_df$latitude = lats
  n_df$longitude = longs
  n_df = subset(n_df, select = c(vsn,description,address,latitude,longitude) )
  n_df <- n_df[!grepl("TBD", n_df$address),]
  n_df <- n_df[!grepl("Georgia Tech", n_df$address),]
  write.csv(n_df,'data/nodes.csv', row.names = FALSE)
}

initSensors <- function() {
  #invalidating timer function - triggers every minute
  print(">> sensors init")
  
  # create requests from endpoints
  s_request <- GET(url = SENSORS_ENDPOINT)
  
  # create responses/json
  s_response <- content(s_request, as = "text", encoding = "UTF-8")
  s_json <- jsonlite::fromJSON(s_response)
  
  # create dataframes
  s_df <- data.frame(s_json$data)
  write.csv(s_df,'data/sensors.csv', row.names = FALSE)
}

initObservations <- function() {
  print(">> observations init")
  
  # create requests from endpoints
  o_request <- GET(url = OBSERVATIONS_ENDPOINT)
  
  # create responses/json
  o_response <- content(o_request, as = "text", encoding = "UTF-8")
  o_json <- jsonlite::fromJSON(o_response)
  
  # create dataframes
  o_df <- data.frame(o_json$data)
  
  # clean our data 
  #observations
  coords <- o_df$location$geometry$coordinates
  lats <- c()
  longs <- c()
  for(i in coords){ lats <- c(lats, i[1]) }
  for(i in coords){ longs <- c(longs, i[2]) }
  o_df$latitude = lats
  o_df$longitude = longs
  o_df = subset(o_df, select = c(value,uom,timestamp,sensor_path,node_vsn,latitude,longitude) )
  write.csv(o_df,'data/observations.csv', row.names = FALSE)
}

# get data function call
getData()