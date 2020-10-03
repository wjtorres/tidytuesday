---
title: "TidyTuesday - Taylor Swift"
author: "wjtorres"
date: '2020-09-29'
output:
  html_document:
    keep_md: yes
  pdf_document: default
---

# TidyTuesday



# Load the weekly Data


```r
swift <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-29/taylor_swift_lyrics.csv')
```

```
## Parsed with column specification:
## cols(
##   Artist = col_character(),
##   Album = col_character(),
##   Title = col_character(),
##   Lyrics = col_character()
## )
```

# Wrangle


```r
tidy_lyrics <- swift %>%
  unnest_tokens(word, Lyrics)

data(stop_words)

tidy_lyrics <- tidy_lyrics %>%
  anti_join(stop_words)
```

```
## Joining, by = "word"
```

```r
tidy_lyrics %>%
  count(word, sort = TRUE)
```

```
## # A tibble: 2,579 x 2
##    word      n
##    <chr> <int>
##  1 love    248
##  2 time    225
##  3 wanna   158
##  4 baby    153
##  5 ooh     127
##  6 yeah    105
##  7 stay    100
##  8 gonna    98
##  9 night    96
## 10 bad      80
## # ... with 2,569 more rows
```

# Visualize


```r
tidy_lyrics %>%
  group_by(word) %>%
  summarise(count = n()) %>%
  filter(count >= 50) %>%
  ggplot(aes(reorder(word,count), count)) +
  geom_col(fill="plum3") +
  labs(title = "Top 50 Words in Taylor Swift Lyrics",
      x = NULL,
      y = "Count",
      caption = "source =  Rosie Baillie and Dr. Sara Stoudt \n graph by @wjtorres") +
  coord_flip() +
  theme_minimal()
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

![](2020_09_29_tidy_tuesday_files/figure-html/Visualize-1.png)<!-- -->

# Save Image


```r
# This will save your most recent plot
# ggsave(
  # filename = "My TidyTuesday Plot.png",
  # device = "png")
```
