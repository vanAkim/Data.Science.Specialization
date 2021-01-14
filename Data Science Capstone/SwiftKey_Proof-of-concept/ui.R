library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("SwiftKey Project - Proof of Concept: Next word prediction"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            textInput(inputId = "txtbox",
                      label = "Type to get the top 3 next word prediction:")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tableOutput("top3Pred")
        )
    )
))
