---
title: "TidyTuesday - Himalayan Climbing Expeditions"
author: "wjtorres"
date: '2020-09-22'
output:
  html_document:
    keep_md: yes
  pdf_document: default
---

# TidyTuesday




# Load the weekly Data

Download the weekly data and make available in the `tt` object.


```r
tt <- tt_load("2020-09-22")
```

```
## --- Compiling #TidyTuesday Information for 2020-09-22 ----
```

```
## --- There are 3 files available ---
```

```
## --- Starting Download ---
```

```
## 
## 	Downloading file 1 of 3: `peaks.csv`
## 	Downloading file 2 of 3: `members.csv`
## 	Downloading file 3 of 3: `expeditions.csv`
```

```
## --- Download complete ---
```


# Readme

Take a look at the readme for the weekly data to get insight on the dataset.
This includes a data dictionary, source, and a link to an article on the data.


```r
tt
```

# Pull Available Datasets


```r
members <- tt$members
```


# Glimpse Data

Take an initial look at the format of the data available.


```r
members %>%
  glimpse()
```

```
## Rows: 76,519
## Columns: 21
## $ expedition_id        <chr> "AMAD78301", "AMAD78301", "AMAD78301", "AMAD78...
## $ member_id            <chr> "AMAD78301-01", "AMAD78301-02", "AMAD78301-03"...
## $ peak_id              <chr> "AMAD", "AMAD", "AMAD", "AMAD", "AMAD", "AMAD"...
## $ peak_name            <chr> "Ama Dablam", "Ama Dablam", "Ama Dablam", "Ama...
## $ year                 <dbl> 1978, 1978, 1978, 1978, 1978, 1978, 1978, 1978...
## $ season               <chr> "Autumn", "Autumn", "Autumn", "Autumn", "Autum...
## $ sex                  <chr> "M", "M", "M", "M", "M", "M", "M", "M", "M", "...
## $ age                  <dbl> 40, 41, 27, 40, 34, 25, 41, 29, 35, 37, 23, 44...
## $ citizenship          <chr> "France", "France", "France", "France", "Franc...
## $ expedition_role      <chr> "Leader", "Deputy Leader", "Climber", "Exp Doc...
## $ hired                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALS...
## $ highpoint_metres     <dbl> NA, 6000, NA, 6000, NA, 6000, 6000, 6000, NA, ...
## $ success              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALS...
## $ solo                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALS...
## $ oxygen_used          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALS...
## $ died                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALS...
## $ death_cause          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
## $ death_height_metres  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
## $ injured              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALS...
## $ injury_type          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
## $ injury_height_metres <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
```



```r
# create df to use for plotting
members2 <- members %>%
  filter(!is.na(age)) %>%
  group_by(age, success) %>%
  dplyr::summarise(count = n())
```

```
## `summarise()` regrouping output by 'age' (override with `.groups` argument)
```

```r
## barplots for success = FALSE goes to the left (needs negative sign)

members2$count <- ifelse(members2$success == "FALSE", -1*members2$count, members2$count)

## pyramid charts = two barcharts with axes flipped
ggplot(members2, aes(x = age, y = count, fill = success)) + 
  geom_bar(data = subset(members2, success == "FALSE"), stat = "identity") +
  geom_bar(data = subset(members2, success == "TRUE"), stat = "identity") +
  scale_y_continuous(breaks = c(-2000, -1000, 0, 1000, 2000),
                     labels = paste0(as.character(c("2000", "1000", "0", "1000", "2000")))) +
  scale_x_continuous(breaks = seq(0, 90, 5)) +
  labs(title = "Success in Summitting a Main Peak or Sub-Peak by Age",
       x = "Age",
       y = "Number of Summits",
       caption = "source = The Himalayan Database \n graph by @wjtorres") +
  coord_flip() +
  scale_fill_discrete(name = NULL,
                      breaks = c("FALSE", "TRUE"),
                      labels = c("Unsuccessful", "Successful")) +
  theme_bw() +
  theme(legend.position = "bottom")
```

![](2020_09_22_tidy_tuesday_files/figure-html/unnamed-chunk-2-1.png)<!-- -->
