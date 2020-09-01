---
title: "TidyTuesday - Chopped"
author: "wjtorres"
date: '2020-09-01'
output:
  html_document:
    keep_md: yes
  pdf_document: default
---

# TidyTuesday



# Load the weekly Data


```r
crops <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-01/key_crop_yields.csv')
```

```
## Parsed with column specification:
## cols(
##   Entity = col_character(),
##   Code = col_character(),
##   Year = col_double(),
##   `Wheat (tonnes per hectare)` = col_double(),
##   `Rice (tonnes per hectare)` = col_double(),
##   `Maize (tonnes per hectare)` = col_double(),
##   `Soybeans (tonnes per hectare)` = col_double(),
##   `Potatoes (tonnes per hectare)` = col_double(),
##   `Beans (tonnes per hectare)` = col_double(),
##   `Peas (tonnes per hectare)` = col_double(),
##   `Cassava (tonnes per hectare)` = col_double(),
##   `Barley (tonnes per hectare)` = col_double(),
##   `Cocoa beans (tonnes per hectare)` = col_double(),
##   `Bananas (tonnes per hectare)` = col_double()
## )
```

# Wrangle


```r
# clean variable names
colnames(crops) <- sub("\\ \\(.*\\)", "", colnames(crops))
colnames(crops)
```

```
##  [1] "Entity"      "Code"        "Year"        "Wheat"       "Rice"       
##  [6] "Maize"       "Soybeans"    "Potatoes"    "Beans"       "Peas"       
## [11] "Cassava"     "Barley"      "Cocoa beans" "Bananas"
```

```r
# data to long format
crops_long <- crops %>%
  pivot_longer(Wheat:Bananas,
               names_to = "Crop", values_to = "Yield",
               values_drop_na = TRUE)
```


# create and visualize continents df

```r
# filter for continents

cont <- crops_long %>%
  filter(Entity %in% c("Asia", "Americas", "Europe", "Australia", "Africa"))

# create gif
mygif <- cont %>%
  ggplot(aes(x = Year, y = Yield, color = Entity)) +
  geom_line() +
  geom_point() +
  facet_wrap(~Crop, scales = "free_y") +
  labs(
    title = "Crop Yields",
    subtitle = "(tonnes per hectare)",
    x = NULL, 
    y = NULL,
    color = "Continent",
    source = "Our World in Data") +
  theme_stata() +
  # animate
  transition_reveal(Year) +
  ease_aes('linear')


animate(mygif, duration = 10, fps = 20, width = 950, height = 750, renderer = gifski_renderer())
```

![](2020_09_01_tidy_tuesday_files/figure-html/unnamed-chunk-2-1.gif)<!-- -->

# Save gif


```r
# save gif
anim_save("mygif.gif")
```
