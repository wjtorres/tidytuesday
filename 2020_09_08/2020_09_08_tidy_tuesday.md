---
title: "TidyTuesday - Chopped"
author: "wjtorres"
date: '2020-09-08'
output:
  html_document:
    keep_md: yes
  pdf_document: default
---



```r
library(tidyverse)
```

```
## -- Attaching packages -------------------------------------------------------------------------------------------------- tidyverse 1.3.0 --
```

```
## v ggplot2 3.3.2     v purrr   0.3.4
## v tibble  3.0.3     v dplyr   1.0.1
## v tidyr   1.1.1     v stringr 1.4.0
## v readr   1.3.1     v forcats 0.5.0
```

```
## -- Conflicts ----------------------------------------------------------------------------------------------------- tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
library(tidytuesdayR)
library(ggthemes)
```

# Get data


```r
tuesdata <- tidytuesdayR::tt_load('2020-09-08')
```

```
## --- Compiling #TidyTuesday Information for 2020-09-08 ----
```

```
## --- There are 3 files available ---
```

```
## --- Starting Download ---
```

```
## 
## 	Downloading file 1 of 3: `friends.csv`
## 	Downloading file 2 of 3: `friends_info.csv`
## 	Downloading file 3 of 3: `friends_emotions.csv`
```

```
## --- Download complete ---
```

```r
friends_info <- tuesdata$friends_info
```


# Wrangle Data


```r
friends_info$imdb_rating_group <- cut(
  friends_info$imdb_rating,
  breaks = quantile(friends_info$imdb_rating, c(0, 0.25, 0.5, 0.75, 1)),
  labels = c("7.2 to 8.1", "8.2 to 8.3", "8.4 to 8.6", "8.7 to 9.7"),
  right  = FALSE,
  include.lowest = TRUE
)
```

# Plot Data


```r
friends_info %>%
  ggplot(aes(x = as.factor(season), y = as.factor(episode), fill = imdb_rating_group)) +
  geom_tile() +
  labs(
    title = "IMDB Ratings for Every Episode of Friends",
    subtitle = "(10 Seasons, 236 Episodes)",
    x = "Season #",
    y = "Episode #",
    fill = "Rating",
    caption = "source: friends R package \n graph by @wjtorres"
  ) +
  scale_fill_brewer(palette = "BuPu") +
  theme_few()
```

![](2020_09_08_tidy_tuesday_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

