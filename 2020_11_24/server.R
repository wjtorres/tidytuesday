# Prep data

tt <- tt_load("2020-11-24")

trails <- tt$hike_data

trails$rating[trails$rating == 0] <- NA


# Define a server for the Shiny app
function(input, 
         output,
         session) {
  observeEvent(input$goButton, {
  
  gt_tbl <- trails %>%
    mutate(rating = as.numeric(rating),
           gain = as.numeric(gain),
           highpoint = as.numeric(highpoint),
           length2 = parse_number(length)) %>% 
    unnest(cols = c(features)) %>%
    separate(location, into = c("location", "location2"), sep=" -- ", remove = F) %>%
    filter(features != "Dogs allowed on leash") %>%
    filter(description != "") %>%
    filter(rating >= 4) %>%
    select(name, location, length, description, rating) %>%
    distinct() %>%
    sample_n(1) %>%
    gt() %>%
  
  # tab options
  tab_options(
    column_labels.font.size = 25) %>%
    
  # rename columns
  cols_label(name = "hike",
             location = "location",
             length = "length",
             description = "description",
             rating = "rating") %>%
  
  # align columns
  cols_align("center") %>%
    
  # specify column width
    cols_width(
      vars(name) ~ px(150),
      vars(location) ~ px(150),
      vars(length) ~ px(100),
      vars(description) ~ px(400),
      vars(rating) ~ px(100)
    ) %>%
    
    tab_style(
      style = list(
        cell_fill(color = "#F56E64"),
        cell_text(color = "#FFFFFF", font = "Fredericka the Great")),
      locations = cells_column_labels( # modify certain column labels
        columns = vars("name", "location", "length", "description", "rating")
      )) %>%
    
    tab_style(
      style = list(
        cell_fill(color = "#EFEFEF"),
        cell_text(font = "Annie Use Your Telescope", size = px(25))),
      locations = cells_body( # modify certain cells
        columns = vars("name", "location", "length", "description", "rating")
      ))


    output$table <- 
    render_gt(
      expr = gt_tbl,
      height = px(900),
      width = px(900))
    
})
  
}