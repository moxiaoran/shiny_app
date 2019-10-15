library(shiny)
library(shinydashboard)

server <- function(input, output, session) {}




header <- dashboardHeader()


ui <- dashboardPage(body = body,
                    sidebar = sidebar,
                    header = header)


shinyApp(ui, server)
