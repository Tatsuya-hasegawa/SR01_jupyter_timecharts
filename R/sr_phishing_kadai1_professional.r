#install.packages("pacman")
pacman::p_load(tidyverse, scales)

# Retrieve csv files and make a data frame
base_url <- "https://github.com/JPCERTCC/phishurl-list/raw/main/"
files <- 
  seq(ymd("2022-04-01"), ymd("2023-03-31"), by="month") |> 
  strftime("%Y/%Y%m.csv")

urls <- str_c(base_url, files)
data <- map_dfr(urls, read_csv)

# Make some columns
data_mod <- 
  data |> 
  mutate(
    date = as_date(date),
    week = floor_date(date, unit = "week"),
    desc = fct_lump_n(description, n = 30, w = NULL, other_level = "Others")
  )

# Plot
data_mod |> 
  ggplot(aes(x = week, color = desc)) +
  geom_line(stat = "count", alpha = 0.5) +
  scale_x_date(date_breaks = "week",
               minor_breaks = NULL,
               limits = c(ymd("2022-03-25"), ymd("2023-03-28")),
               expand = c(0.01, 0.01),
               labels = label_date_short(format = c("%Y", "%b.", "%e", "%H"), sep = "\n")
  ) +
  labs(x = "Week", y = "Distinct Count of URLs", color = "Description")
