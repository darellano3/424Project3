# This file contains the UI body (visualizations) layout

# Enter your UI elements here

body<-dashboardBody(
              div(style = "font-size: 20px; padding: 5px 0px; margin:0%",
                    column(12,
                           box(title="Interactive Map of AOT Nodes",solidHeader = TRUE,status="primary",
                               column(width = 12, leafletOutput(outputId = "Map_nodes"))
                               ))
              )
                          
)
# end dashboard body layout