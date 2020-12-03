library(shiny)
library(dplyr)
library(leaflet)
library(geojsonio)
library(htmltools)


# LOAD AND READ DATA

## Download data if needed
if (!file.exists("data")){
    dir.create("data")
    
    url_tlsTown = "https://data.toulouse-metropole.fr/explore/dataset/communes/download/?format=geojson&timezone=Europe/Berlin&lang=fr"
    url_tlsPostal = "https://data.toulouse-metropole.fr/explore/dataset/codes-postaux-de-toulouse/download/?format=geojson&timezone=Europe/Berlin&lang=fr"
    
    download.file(url_tlsPostal, destfile = "./data/codes-postaux-de-toulouse.geojson")
    
    download.file(url_tlsTown, destfile = "./data/communes.geojson")
}

## Read data
tlsPostal <- geojson_read("./data/codes-postaux-de-toulouse.geojson", what = "sp")
tlsTown <- geojson_read("./data/communes.geojson", what = "sp")

lat_tls = 43.6016
lng_tls = 1.4407

## Set polygons labels variables (unfortunately different due to datasets form)
town_labels <- sprintf(
    "<strong>%s</strong><br/> Township Code : %g",
    tlsTown$libelle, tlsTown$code_insee
) %>% lapply(HTML) # only tls = 31555

postal_labels <- sprintf(
    "Postal Code : %g",
    tlsPostal$code_postal
) %>% lapply(HTML) # only tls = 31555

#-------------------------------------------------------------------------------
# SHINY APP

server <- function(input, output, session) {
    
    #----------------------------------------------
    # Related to buttons
    
    ## Reactive expression for the data subsetted to what the user selected
    filteredData <- reactive({
        if(input$codes == "Postal Codes") {tlsPostal} else {tlsTown}
    })
    
    # Reactive expr to set a color array to higlight Toulouse area with
    # a different color from areas nearby
    selectiveColor <- reactive({
        if(input$show_tls){

            activeData <- if(input$codes == "Postal Codes")
                {tlsPostal$code_postal} else {tlsTown$libelle}
            
            filt <- activeData %in% c(31000,31100,31200,31300,31400,31500) | activeData == 'Toulouse'
            tls_col <- rep('#96D3FF', length(filt))
            tls_col[filt] <- '#FAC67A'
            tls_col

        } else {
            tls_col <- '#96D3FF'
            tls_col
        }
    })
    
    ## Reactive expression for the change in polygons labels variable
    ## to pass through during map generation
    labels <- reactive({
        if(input$codes == "Postal Codes"){postal_labels} else {town_labels}
    })
    
    #----------------------------------------------
    # Related to the background map
    
    output$map <- renderLeaflet({
        ## Base map without changing elements
        leaflet(tlsPostal) %>% setView(lat = lat_tls, lng = lng_tls, 11) %>% 
            addProviderTiles(providers$CartoDB.Positron) %>%
            addPolygons(fillOpacity = 0.4, fillColor = '#96D3FF',
                        color = 'white', opacity = 0.7, dashArray = "5", weight = 3,
                        highlight = highlightOptions(
                            weight = 5,
                            color = "#666",
                            dashArray = "",
                            fillOpacity = 0.7,
                            bringToFront = TRUE),
                        label = postal_labels,
                        labelOptions = labelOptions(
                            style = list("font-weight" = "normal", padding = "3px 8px"),
                            textsize = "15px",
                            direction = "auto"))
    })
    
    #----------------------------------------------
    # Related to the dynamic objects add to the map
    
    # Incremental changes to the map should be performed in an observer.
    observe({
        leafletProxy("map", data = filteredData()) %>%
            clearShapes() %>%
            addPolygons(fillOpacity = 0.4, fillColor = selectiveColor(),
                        color = 'white', opacity = 0.7, dashArray = "5", weight = 3,
                        highlight = highlightOptions(
                            weight = 5,
                            color = "#666",
                            dashArray = "",
                            fillOpacity = 0.7,
                            bringToFront = TRUE),
                        label = labels(),
                        labelOptions = labelOptions(
                            style = list("font-weight" = "normal", padding = "3px 8px"),
                            textsize = "15px",
                            direction = "auto"))
    })
}