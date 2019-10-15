library(shiny)
library(ggplot2)

ui <- pageWithSidebar(
    tags$h1("Dynamic multiple plots"),
    sidebarPanel(
        # shiny::selectInput 
        shinyWidgets::pickerInput("x", "x", names(iris)),
        shinyWidgets::pickerInput("y", "y", names(iris), multiple = TRUE)
    ),
    mainPanel(uiOutput("plots"))
)

server <- function(input, output, session) {
    observe( 
        for(.y in input$y) {
            local({
                y <- .y 
                output[[y]] <- renderPlot(
                    qplot(!!sym(input$x), !!sym(y), data = iris)
                )
            }
            )}
    )
    
    output$plots <- renderUI(
        lapply(
            lapply(input$y, plotOutput, height = "200", width = "200"),
            div,
            style = htmltools::css(display = "inline-block")
        )
    )
}

shinyApp(ui, server)

# reference: https://blog.atusy.net/2019/08/09/shiny-dynamic-numer-of-plots/









