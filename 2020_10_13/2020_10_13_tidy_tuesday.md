---
title: "TidyTuesday - datasauRus dozen"
author: "wjtorres"
date: '2020-10-13'
output:
  html_document:
    keep_md: yes
  pdf_document: default
---

# TidyTuesday




# Load the weekly Data


```r
tt <- tt_load("2020-10-13")
```

```
## --- Compiling #TidyTuesday Information for 2020-10-13 ----
```

```
## --- There is 1 file available ---
```

```
## --- Starting Download ---
```

```
## 
## 	Downloading file 1 of 1: `datasaurus.csv`
```

```
## --- Download complete ---
```

# Pull Data


```r
datasaurus <- tt$datasaurus
```


# Wrangle


```r
datasaurus2 <- datasaurus %>%
  group_by(dataset) %>%
  mutate(x_mean = mean(x),
         y_mean = mean(y))
```

# Visualize


```r
datasaurus2 %>%
  ggplot(aes(x, y, color = x)) +
  geom_point(size = 1, alpha = .8) +
  geom_smooth(method = "lm", se = FALSE, color = "snow1") +
  geom_point(aes(x_mean, y_mean),
             shape = 15, color = "#e9c46a", size = 3) +
  facet_wrap( ~dataset) +
  labs(
    title = "DatasauRus Dozen",
    subtitle = "Each with similar summary statistics (e.g., trend line and mean shown)",
    x = NULL,
    y = NULL,
    caption = "source =  datasauRus R package \ngraph by @wjtorres"
  ) +
   scale_colour_viridis_c(option = "D") +
  theme_minimal() +
  theme(
    legend.position = 'none',
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text = element_text(color = "white", size = 11),
    plot.caption = element_text(color = "white", size = 11),
    plot.title = element_text(color = "white", size = 20),
    plot.subtitle = element_text(color = "white", size = 11),
    strip.text.x = element_text(color = "white", size = 11),
    plot.background = element_rect(fill = "#111111"))
```

```
## `geom_smooth()` using formula 'y ~ x'
```

![](2020_10_13_tidy_tuesday_files/figure-html/Visualize-1.png)<!-- -->

# Save Image

Save your image for sharing. Be sure to use the `#TidyTuesday` hashtag in your post on twitter! 


```r
# This will save your most recent plot
ggsave(
  filename = "My TidyTuesday Plot.png",
  device = "png")
```

```
## Saving 7 x 5 in image
```

```
## `geom_smooth()` using formula 'y ~ x'
```
