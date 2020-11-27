# packages
library(shiny)
library(tidyverse)
library(gt)
library(showtext)
library(tidytuesdayR)
library(here)

# Use a fluid layout
fluidPage(theme = "my_theme2.css",
          
          tags$head(
            tags$style(HTML("
                    @import url('https://fonts.googleapis.com/css2?family=Long+Cang&display=swap');
                    @import url('https://fonts.googleapis.com/css2?family=Annie+Use+Your+Telescope&display=swap');
                    @import url('https://fonts.googleapis.com/css2?family=Fredericka+the+Great&display=swap')"))
            ),
          
          # Give the page a header
          
          h1("Washington Trails Randomizer"),
          
          sidebarLayout(
            
            sidebarPanel(
              
              h2("The trails shown here are rated 4 stars or higher and allow pups on a leash!"),
              
              # Choose a random button
              
              actionButton("goButton", "randomize!"),
              
              br(),
              
              br(),
              
              img(src = "my_image.png", height = 300, width = 300),
              
              h4("visit www.wta.org/go-outside/hikes"),
              
              h4("data source: #TidyTuesday | app by: wjtorres")),
              
              mainPanel(
                
                gt_output(outputId = "table")
                
                )
)
)