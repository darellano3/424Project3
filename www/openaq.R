# ropenaq
# which allows commands such as
# aq_latest(country = "US", city = "Chicago-Naperville-Joliet")
# or
# aq_measurements(city = "Chicago-Naperville-Joliet", date_from = "2018-12-01", date_to = "2018-12-31", parameter = "pm25")


current_date <- Sys.Date()
weekago_date <- current_date - 7

# latest data for openaq
openaq_data <- ropenaq::aq_latest(country = "US", city = "Chicago-Naperville-Joliet")

# weekly data for openaq
openaq_week_data <- ropenaq::aq_measurements(city = "Chicago-Naperville-Joliet", date_from = weekago_date, date_to = current_date)