---
title: "TidyTuesday - NCAA"
author: "wjtorres"
date: '2020-10-06'
output:
  html_document:
    keep_md: yes
  pdf_document: default
---

# TidyTuesday




# Load the weekly Data


```r
tt <- tt_load("2020-10-06")
```

```
## --- Compiling #TidyTuesday Information for 2020-10-06 ----
```

```
## --- There is 1 file available ---
```

```
## --- Starting Download ---
```

```
## 
## 	Downloading file 1 of 1: `tournament.csv`
```

```
## --- Download complete ---
```

```r
tournament <- tt$tournament
```


```r
champs <- tournament %>%
  filter(tourney_finish == "Champ")
```


# Visualize


```r
champs %>% 
  ggplot(aes(x = forcats::fct_infreq(school))) +
  geom_bar(fill = "blue") +
  scale_y_continuous(breaks = c(2, 4, 6, 8, 10)) +
  labs(title = "Women's NCAA Division I Basketball Champions",
       x = NULL,
       y = "Count",
       caption = "source =  FiveThirtyEight \n graph by @wjtorres") +
  coord_flip() +
  theme_bw()
```

![](2020_10_06_tidy_tuesday_files/figure-html/Visualize-1.png)<!-- -->

# Save Image


```r
# This will save your most recent plot
# ggsave(
  # filename = "My TidyTuesday Plot.png",
  # device = "png")
```
