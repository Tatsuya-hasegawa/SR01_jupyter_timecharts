install.packages("pacman")
pacman::p_load(tidyverse, scales)

# Retrieve csv files and make a data frame
base_url <- "https://github.com/JPCERTCC/phishurl-list/raw/main/"
file_name <- c("2022/202204.csv",
               "2022/202205.csv",
               "2022/202206.csv",
               "2022/202207.csv",
               "2022/202208.csv",
               "2022/202209.csv",
               "2022/202210.csv",
               "2022/202211.csv",
               "2022/202212.csv",
               "2023/202301.csv",
               "2023/202302.csv",
               "2023/202303.csv")

file_list <- str_c(base_url, file_name)
data <- map_dfr(file_list, read_csv)

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
