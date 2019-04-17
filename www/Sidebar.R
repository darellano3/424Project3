# This file containts the sidebar for user input 

sidebar <- dashboardSidebar(width=350,
                            br(),br(),br(),br(),br(),br(),br(),br(),
                            br(),br(),br(),br(),br(),br(),br(),
                            sidebarMenu(
                              menuItem('Visualizations',tabName='visualizations',startExpanded = TRUE,
                                       menuSubItem("Real-Time AQI",tabName='real-time')
                              ),
                              menuItem('Info',tabName='info')
                            )
)
# end sidebar