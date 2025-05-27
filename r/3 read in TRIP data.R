####################################
# Michael Strausz
# Read in TRIP data
# 2/20/2025 : 2/20/2025
####################################
library(tidyverse)
library(readxl)

df<-read_xlsx("data/TRIP Scores.xlsx")

df<-df %>% filter(year==2021)

#verify that the three letter IDs work
setdiff(df$country_text_id,world2025$countryID)

df<-df %>% select(country_text_id,trip_score)
colnames(df)<-c("countryID","tripScore")

world2025<-world2025 %>% left_join(df)

