---
title: "TidyTuesday - Canadian Wind Turbines"
author: "wjtorres"
date: '2020-10-27'
output:
  html_document:
    keep_md: yes
  pdf_document: default
---

# TidyTuesday



# Load the weekly Data


```r
tt <- tt_load("2020-10-27")
```

```
## --- Compiling #TidyTuesday Information for 2020-10-27 ----
```

```
## --- There is 1 file available ---
```

```
## --- Starting Download ---
```

```
## 
## 	Downloading file 1 of 1: `wind-turbine.csv`
```

```
## --- Download complete ---
```
# Pull Data


```r
turbines <- tt$`wind-turbine`
```

# Wrangle


```r
height <- turbines %>%
  group_by(manufacturer) %>%
  summarise(accumulated_height = sum(hub_height_m)) %>%
  arrange(desc(accumulated_height))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

# Visualize

Using your processed dataset, create your unique visualization.


```r
height %>%
  ggplot(aes(x = reorder(manufacturer, accumulated_height), y = accumulated_height, label = accumulated_height)) +
  geom_point(color = "chartreuse", size = 9, alpha = .4) + 
  geom_segment(aes(x = manufacturer, xend = manufacturer, y = 0, yend = accumulated_height), color = "#add528", size = 1) +
  geom_text(nudge_y = 10000, size = 3, check_overlap = T, color = "white") +
  labs(title = "Canadian Wind Turbines", 
       subtitle = "Accumulated hub height (in meters) by manufacturer for turbines commissioned between 1993 and 2019",
       x = NULL,
       y = NULL,
       caption = "source = open.canada.ca \n#TidyTuesday \ngraph by @wjtorres") +
  theme_minimal() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text = element_text(color = "white", size = 12),
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(color = "white", size = 20),
    plot.subtitle = element_text(color = "white", size = 16),
    plot.caption = element_text(color = "white", size = 12),
    plot.background = element_rect(fill = "#63a1c4"))
```

![](2020_10_27_tidy_tuesday_files/figure-html/Visualize-1.png)<!-- -->

# Save Image

Save your image for sharing. Be sure to use the `#TidyTuesday` hashtag in your post on twitter! 


```r
# This will save your most recent plot
ggsave(
  filename = "My TidyTuesday Plot.png",
  width = 12,
  device = "png")
```

```
## Saving 12 x 5 in image
```
