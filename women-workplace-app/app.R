library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
library(scales)
detach("package:dplyr", unload=TRUE)
library(dplyr)
theme_set(theme_minimal())

jobs_gender <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-05/jobs_gender.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Gender disparity explorer"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         selectInput("major_category",
                     "Occupation Category:",
                      choices = unique(jobs_gender$major_category))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotlyOutput("jobs_scatter", height = "700px")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$jobs_scatter <- renderPlotly({
     p <- jobs_gender %>%
       filter(major_category == input$major_category,
              total_workers >20000) %>%
       mutate(percent_female = workers_female / total_workers,
              wage_percent_female = total_earnings_female / total_earnings_male) %>%
       ggplot(aes(percent_female,
                  wage_percent_female,
                  size = total_workers,
                  color = minor_category,
                  label = occupation)) +
       geom_point(aes(frame = year)) +
       scale_size_continuous(range = c(1, 10), guide = F) +
       labs(size = "Total # of workers",
            x = "% of workforce reported as female",
            y = "% of median female salary / median male",
            title = "Gender disparity and pay gap",
            subtitle = "Only occupations with at least 20,000 workers total",
            color = "Minor Category") +
       scale_x_continuous(labels = percent_format()) +
       scale_y_continuous(labels = percent_format())
     
     ggplotly(p) %>%
       animation_slider(
         currentvalue = list(
           prefix = "Year: "
         )
       )
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

