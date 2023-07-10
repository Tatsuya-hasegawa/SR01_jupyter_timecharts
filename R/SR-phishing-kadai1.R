# Install required packages if not already installed
install.packages("ggplot2")
install.packages("tidyverse")
install.packages("lubridate")
install.packages("forcats")

# Load required libraries
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(forcats)
options(dplyr.summarise.inform = FALSE)

# Read the CSV file 
data <- read.csv("../merged_202204-202303_noduplabel.csv")#,header=T,fileEncoding = "utf8")
#data <- read_csv("../merged_202204-202303.csv",locale = locale(encoding = "utf8"),col_types = cols(.default = "c"))

# Convert the "date" column to Date format
data$date <- as.Date(data$date)

# Extract the last day of the week from the date
data$week <- floor_date(data$date, unit = "week")

# Calculate distinct count of URL by description and week
distinct_count <- data %>%
  group_by(description, week) %>%
  summarise(distinct_count = n_distinct(URL)) %>%
  ungroup()

# Get the top 30 descriptions
top_descriptions <- distinct_count %>%
  group_by(description) %>%
  summarise(total_count = sum(distinct_count)) %>%
  arrange(desc(total_count)) %>%
  top_n(30)

# Modify the description column
distinct_count_modified <- distinct_count %>%
  mutate(description = fct_other(description, keep = top_descriptions$description, other_level = "OTHERS"))

# Create the line chart with multiple legends
options(repr.plot.width = 20, repr.plot.height =10)
ggplot(distinct_count_modified, aes(x = week, y = distinct_count, color = description, linetype = description, group = interaction(description, week))) +
  geom_line(aes(group=factor(description)),linetype="solid",size=2) +
  labs(x = "Week", y = "Distinct Count of URLs", color = "Description", linetype = "Description") +
  scale_fill_brewer(palette = "Spectral") +
  theme(text = element_text(size = 20),element_line(size =1), panel.grid = element_line(linetype="solid",size=1), legend.position = "bottom", legend.direction = "horizontal") +
  theme_gray (base_family = "HiraKakuPro-W3")
