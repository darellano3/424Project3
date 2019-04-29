key <- "cd5410435406de37ec2c4cfad221332f"
Sys.setenv(DARKSKY_API_KEY = key)
# ex:
# forecast request example:   https://api.darksky.net/forecast/[key]/[latitude],[longitude]
# darksky::get_current_forecast(41.870, -87.647,"cd5410435406de37ec2c4cfad221332f", add_headers=TRUE)

# requirements B:
# When the user is looking at the AoT data for the current time, last 24 hours, last 7 days, add in the related Chicago area weather 
# data (temperature, humidity, wind speed, wind bearing, cloud cover, visibility, pressure, ozone, summary) 
# from Dark Sky for that location

get_current_forecast_darksky <- function(vsn) {
  lat <- node_data[node_data$vsn == vsn, ]$latitude
  lon <- node_data[node_data$vsn == vsn, ]$longitude
  
  df <- darksky::get_current_forecast(lat,lon)
  return(df)
}

get_last24hrs_darksky <- function(vsn) {
  current_time <- Sys.time()
  last24_time <- curr_time - 3600*24 # gets 24 hours ago timestamp
  
  lat <- node_data[node_data$vsn == vsn, ]$latitude
  lon <- node_data[node_data$vsn == vsn, ]$longitude
  
  last24 <- darksky::get_forecast_for(lat,lon,timestamp = last24_time, add_headers = TRUE)
  now24  <- darksky::get_forecast_for(lat,lon,timestamp = curr_time, add_headers = TRUE)
  last24_df <- dplyr::bind_rows(last24$hourly , now24$hourly) #bind yesterday and today
  last24_df <- subset(last24_df, time <= curr_time & time >= last24_time) #clean data - only last 24 hrs
  
  return(last24_df)
}

get_last7days_darksky <- function(vsn) {
  current_date <- Sys.Date()
  current_time <- Sys.time()

  lat <- node_data[node_data$vsn == vsn, ]$latitude
  lon <- node_data[node_data$vsn == vsn, ]$longitude
  
  # hourly data for each of last 7 days
  today <- darksky::get_forecast_for(lat,lon,timestamp = current_time, add_headers = TRUE)
  day2 <- darksky::get_forecast_for(lat,lon,timestamp = current_date-1, add_headers = TRUE)
  day3 <-darksky::get_forecast_for(lat,lon,timestamp = current_date-2, add_headers = TRUE)
  day4 <-darksky::get_forecast_for(lat,lon,timestamp = current_date-3, add_headers = TRUE)
  day5 <-darksky::get_forecast_for(lat,lon,timestamp = current_date-4, add_headers = TRUE)
  day6 <-darksky::get_forecast_for(lat,lon,timestamp = current_date-5, add_headers = TRUE)
  day7 <-darksky::get_forecast_for(lat,lon,timestamp = current_date-6, add_headers = TRUE)
  last7days_df <- dplyr::bind_rows(today$hourly, day2$hourly, day3$hourly, day4$hourly, day5$hourly, day6$hourly, day7$hourly)
  last7days_df <- subset(last24_df, time <= curr_time) #clean data - nothing past current time
  
  return(last7days_df)
}
