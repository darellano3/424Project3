key <- "cd5410435406de37ec2c4cfad221332f"
Sys.setenv(DARKSKY_API_KEY = key)
# forecast request example:   https://api.darksky.net/forecast/[key]/[latitude],[longitude]
# darksky::get_current_forecast(41.870, -87.647,"cd5410435406de37ec2c4cfad221332f", add_headers=TRUE)

get_current_forecast_byVSN <- function(vsn) {
  lat <- node_data[node_data$vsn == "004", ]$latitude
  lon <- node_data[node_data$vsn == "004", ]$longitude
  
  df <- darksky::get_current_forecast(41.870, -87.647)
  return(df)
}