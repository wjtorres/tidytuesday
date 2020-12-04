library(shiny)
library(tidyverse)
library(here)
library(lubridate) # to fix dates
library(gt) # for tables
library(glue)

# Define UI ----
ui <- fluidPage(
  theme = "my_theme.css",
  tags$head(tags$style(
    HTML(
      "@import url('https://fonts.googleapis.com/css2?family=Montserrat&display=swap')"
    )
  )),
  fluidRow(column(
    width = 12,
    h1("Number of People Served in Toronto Shelters (2017-2019)"),
    align = "center"
  )),
  fluidRow(column(
    width = 12,
    h4("Data source: City of Toronto’s Open Data Portal"),
    align = "center"
  )),
  fluidRow(column(
    width = 12,
    align = "center",
    selectInput(
      "checkOrganization",
      width = '325px',
      h3("Select Organization:"),
      choices = list(
        "COSTI Immigrant Services" = "COSTI Immigrant Services",
        "Christie Ossington Neighbourhood Centre"	= "Christie Ossington Neighbourhood Centre",
        "Christie Refugee Welcome Centre, Inc." = "Christie Refugee Welcome Centre, Inc.",
        "City of Toronto" = "City of Toronto",
        "Cornerstone Place" = "Cornerstone Place",
        "Covenant House Toronto" = "Covenant House Toronto",
        "Dixon Hall" = "Dixon Hall",
        "Eva's Initiatives" = "Eva's Initiatives",
        "Fife House Foundation" = "Fife House Foundation",
        "Fred Victor Centre" = "Fred Victor Centre",
        "Good Shepherd Ministries" = "Good Shepherd Ministries",
        "Homes First Society" = "Homes First Society",
        "Horizon for Youth" = "Horizon for Youth",
        "Kennedy House Youth Services" = "Kennedy House Youth Services",
        "Na-Me-Res (Native Men's Residence)" = "Na-Me-Res (Native Men's Residence)",
        "Native Child & Family Services Toronto" = "Native Child & Family Services Toronto",
        "Second Base (Scarborough) Youth Shelter" = "Second Base (Scarborough) Youth Shelter",
        "Society of St.Vincent De Paul" = "Society of St.Vincent De Paul",
        "St. Simon's Shelter Inc." = "St. Simon's Shelter Inc.",
        "Street Haven At The Crossroads" = "Street Haven At The Crossroads",
        "The MUC Shelter Corporation"	= "The MUC Shelter Corporation",
        "The Salvation Army of Canada" = "The Salvation Army of Canada",
        "The Scott Mission Inc." = "The Scott Mission Inc.",
        "Toronto Community Hostel" = "Toronto Community Hostel",
        "Touchstone Youth Centre" = "Touchstone Youth Centre",
        "Turning Point Youth Services" = "Turning Point Youth Services",
        "University Settlement" = "University Settlement",
        "WoodGreen Red Door Family Shelter" = "WoodGreen Red Door Family Shelter",
        "YMCA of Greater Toronto" = "YMCA of Greater Toronto",
        "YWCA Toronto" = 	"YWCA Toronto",
        "Youth Without Shelter" = "Youth Without Shelter",
        "YouthLink" = "YouthLink"
      ),
      selected = "The MUC Shelter Corporation"
    ),
  ), ),
  br(),
  fluidRow(column(width = 4, gt_output("sheltersTable")),
           column(width = 8, plotOutput("sheltersPlot")))
)

# Define server logic ----

# upload data

shelters <- readr::read_csv(here::here("shelters.csv"))

server <- function(input, output) {
  
  # data manipulation
  shelters_plot <- reactive({
    shelters %>%
      mutate(
        occupancy_date = as.Date(occupancy_date),
        month_yr = format_ISO8601(occupancy_date, precision = "ym"),
        yr = year(occupancy_date),
        organization_name = replace(
          organization_name,
          which(organization_name == "Woodgreen Red Door Family Shelter"),
          "WoodGreen Red Door Family Shelter"
        )
      ) %>%
      group_by(organization_name, month_yr, yr) %>%
      summarize(people_served = sum(occupancy, na.rm = TRUE)) %>%
      filter(organization_name == input$checkOrganization)
  })
  
  shelters_table <- reactive({
    shelters %>%
      mutate(
        organization_name = replace(
          organization_name,
          which(organization_name == "Woodgreen Red Door Family Shelter"),
          "WoodGreen Red Door Family Shelter"
        )
      ) %>%
      select(organization_name,
             shelter_name,
             shelter_city,
             shelter_province,
             sector) %>%
      distinct() %>%
      arrange(sector) %>%
      mutate(sector2 = sector) %>%
      pivot_wider(names_from = sector, values_from = sector2) %>%
      unite("sector_list",
            `Co-ed`:Youth,
            sep = ", ",
            na.rm = T) %>%
      arrange(organization_name,
              shelter_name,
              shelter_city,
              shelter_province,
              sector_list) %>%
      filter(organization_name == input$checkOrganization) %>%
      select(shelter_name, shelter_city, sector_list) %>%
      gt() %>%
      tab_header(# add table
        title = glue("{input$checkOrganization}: Shelters")) %>%
      
      # rename columns
      cols_label(
        shelter_name = "Shelter",
        shelter_city = "City",
        sector_list = "Sector"
      ) %>%
      
      # use style tables to modify more targeted table parts
      tab_style(
        style = list(
          cell_fill(color = "#549aab"),
          cell_text(
            color = "#f6f6f6",
            size = px(20),
            font = "Montserrat"
          )
        ),
        locations = cells_title(groups = "title")
      ) %>%
      
      tab_style(
        style = list(
          cell_fill(color = "#549aab"),
          cell_text(
            color = "#f6f6f6",
            size = px(16),
            font = "Montserrat"
          )
        ),
        locations = cells_column_labels(columns = vars(
          shelter_name, shelter_city, sector_list
        ))
      ) %>%
      
      tab_style(
        style = list(
          cell_fill(color = "#f6f6f6"),
          cell_text(
            color = "#123740",
            size = px(16),
            font = "Montserrat"
          )
        ),
        locations = cells_body(columns = vars(
          shelter_name, shelter_city, sector_list
        ))
      )
  })
  
  # Fill in the spot we created for a plot
  output$sheltersPlot <- renderPlot({
    # create my custom theme
    my_theme <-  theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      plot.title = element_text(
        family = "Montserrat",
        size = 20,
        hjust = .5,
        color = "#f6f6f6"
      ),
      axis.text = element_text(
        family = "Montserrat",
        size = 12,
        color = "#f6f6f6"
      ),
      axis.title = element_text(
        family = "Montserrat",
        size = 12,
        color = "#f6f6f6"
      ),
      strip.text.x = element_text(
        family = "Montserrat",
        size = 12,
        color = "#f6f6f6"
      ),
      strip.background.x = element_rect(fill = "#123740"),
      plot.background = element_rect(fill = "#549aab"),
      panel.background = element_rect(fill = "#549aab"),
      legend.position = "none"
    )
    
    
    month_labels <-
      rep(c('J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'), 3)
    
    
    # plot 1
    ggplot(data = shelters_plot(),
           aes(x = month_yr, y = people_served, fill = organization_name)) +
      geom_col(fill = "#123740",
               color = "#f6f6f6",
               size = .5) +
      scale_y_continuous() +
      scale_x_discrete(labels = month_labels) +
      facet_wrap( ~ yr, scales = "free_x", strip.position = "bottom") +
      
      # specify labs
      labs(
        title = glue("{input$checkOrganization}: Number of People Served"),
        x = NULL,
        y = NULL,
        fill = NULL
      ) +
      
      # use my theme
      my_theme
    
    
  })
  
  gt_tbl <- reactive ({
    shelters_table()
  })
  
  
  
  output$sheltersTable <-
    render_gt(expr = gt_tbl())
  
  
}

# Run the app ----
shinyApp(ui = ui, server = server)