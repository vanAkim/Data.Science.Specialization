library(shiny)
library(leaflet)
library(RColorBrewer)

ui <- bootstrapPage(
    tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
    leafletOutput("map", width = "100%", height = "100%"),
    absolutePanel(top = 10, right = 10,
                  selectInput("codes", "Post codes types",
                              c("Postal Codes", "Township codes")
                  ),
                  checkboxInput("show_tls", "Highlight Toulouse area",
                                value = FALSE)
    )
)