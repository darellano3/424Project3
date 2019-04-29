# This file contains the UI body (visualizations) layout

# Define UI for application that draws a histogram
ui <- dashboardPage(
  
  #Dashboard Title
  dashboardHeader(title = "Array of Things Visualization",
                  titleWidth = 350),
  sidebar,
  dashboardBody(
    
    shinyDashboardThemes(
      theme = "purple_gradient"
    ),
    
    #tags$head(tags$style(HTML('
    # .skin-blue .main-sidebar {
    #                          background-color: #0072B2;
    #                          }
    #                          .skin-blue .sidebar-menu>li.active>a, .skin-blue .sidebar-menu>li:hover>a {
    #                          background-color: #444444;
    #                          }
    #                          '))),
    
    tabsetPanel(id = "tabs",
                
                tabPanel("Interactive Map", br(), value = "mapTab", 
                         
                         div(style = "font-size: 20px; padding: 5px 0px; margin:0%",
                             
                             fluidRow(width = 12,
                                      box( 
                                        width = 6, title="Graph of AOT Nodes",solidHeader = TRUE,
                                        plotlyOutput(outputId = "graph", height = 400)
                                      )
                             ),
                             fluidRow(width = 12,
                                      box( 
                                        width = 8, title="Interactive Map of AOT Nodes",solidHeader = TRUE,#status="success",
                                        leafletOutput(outputId = "Map_nodes", height = 800)
                                      ),
                                      box(
                                        width = 4, solidHeader = TRUE, height = 800, title = "Table of Nodes",
                                        tabsetPanel(
                                          tabPanel("Temperature",  dataTableOutput("tempTable", height = 800)),
                                          tabPanel("Humidity", dataTableOutput("humTable", height = 800)),
                                          tabPanel("Intensity", dataTableOutput("inteTable", height = 800)),
                                          tabPanel("NO2", dataTableOutput("NO2Table", height = 800)),
                                          tabPanel("CO", dataTableOutput("COTable", height = 800)),
                                          tabPanel("SO2", dataTableOutput("SO2Table", height = 800)),
                                          tabPanel("H2S", dataTableOutput("H2STable", height = 800)),
                                          tabPanel("OZone", dataTableOutput("OZoneTable", height = 800))
                                        )
                                      )
                             )
                         ) 
                ),
                tabPanel("Heat Map", br(), value = "BTab",
                         
                         div(style = "font-size: 20px; padding: 5px 0px; margin:0%",
                             box(
                               width = 12, solidHeader = TRUE, leafletOutput("heatMap", height = 1200)
                             )
                         )
                )
    )#end of tabsetPanel
  )
)
# end dashboard body layout