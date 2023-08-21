# PHS Scottish stroke statistics
# this script contains code to clean and prep raw data derived from PHS
# source: https://www.opendata.nhs.scot/dataset/scottish-stroke-statistics

## open libraries
library(tidyverse)
library(skimr)

#####################
## first dataset: Stroke Activity By Health Board

activity_hb <- read_csv("raw_data/stroke_activity_by_health_board.csv")

# 1. initial exploration
head(activity_hb)
dim(activity_hb)
glimpse(activity_hb)
# data has 43200 rows, 16 columns
# data is aggregated per health board, age group, sex and diagnosis type
# number of incidences within discharges

# 2. clean names
activity_hb <- activity_hb %>% 
  janitor::clean_names()

# each variable has a qualifier column, I will leave it in for now as it might be
# helpful to filter data during analysis steps based on this.
# 3. check for NA's

activity_hb %>% 
  summarise(across(.fns = ~sum(is.na(.x))))
#NA's only present in the qualifier columns

# 4. write cleaned file to new csv:

write.csv(activity_hb, file = "clean_data/stroke_activity_healthboard.csv")

####################
## second dataset: Stroke Activity By Council Area
  
activity_ca <- read_csv("raw_data/stroke_activity_by_council_area.csv")

# 1. initial exploration
head(activity_ca)
dim(activity_ca)
glimpse(activity_ca)
colnames(activity_ca)
# data has 95040 rows, 16 columns
# data is aggregated per council area, age group, sex and diagnosis type
# number of incidences within discharges

# 2. clean names
activity_ca <- activity_ca %>% 
  janitor::clean_names()

# each variable has a qualifier column, I will leave it in for now as it might be
# helpful to filter data during analysis steps based on this.
# 3. check for NA's

activity_ca %>% 
  summarise(across(.fns = ~sum(is.na(.x))))
#NA's only present in the qualifier columns

# 4. write cleaned file to new csv:

write.csv(activity_ca, file = "clean_data/stroke_activity_council.csv")

####################
## third dataset: Stroke Mortality By Health Board

mortality_hb <- read_csv("raw_data/stroke_mortality_by_healthboard.csv")

# 1. initial exploration
head(mortality_hb)
dim(mortality_hb)
glimpse(mortality_hb)
colnames(mortality_hb)
# data has 8100 rows, 14 columns
# data is aggregated per health board, age group, sex and diagnosis type
# mortality rates is given in number of deaths

# 2. clean names
mortality_hb <- mortality_hb %>% 
  janitor::clean_names()

# each variable has a qualifier column, I will leave it in for now as it might be
# helpful to filter data during analysis steps based on this.
# 3. check for NA's

mortality_hb %>% 
  summarise(across(.fns = ~sum(is.na(.x))))
#NA's present in the qualifier columns and number_of_deaths column.
# I will leave them in for now, and filter during analysis steps.

# 4. write cleaned file to new csv:

write.csv(mortality_hb, file = "clean_data/stroke_mortality_healthboard.csv")

####################
## fourth dataset: Stroke Mortality By Council Area

mortality_ca <- read_csv("raw_data/stroke_mortality_by_council_area.csv")

# 1. initial exploration
head(mortality_ca)
dim(mortality_ca)
glimpse(mortality_ca)
colnames(mortality_ca)
# data has 17820 rows, 14 columns
# data is aggregated per health board, age group, sex and diagnosis type
# mortality rates is given in number of deaths

# 2. clean names
mortality_ca <- mortality_ca %>% 
  janitor::clean_names()

# each variable has a qualifier column, I will leave it in for now as it might be
# helpful to filter data during analysis steps based on this.
# 3. check for NA's

mortality_ca %>% 
  summarise(across(.fns = ~sum(is.na(.x))))
#NA's present in the qualifier columns and number_of_deaths column.
# I will leave them in for now, and filter during analysis steps.

# 4. write cleaned file to new csv:

write.csv(mortality_ca, file = "clean_data/stroke_mortality_council.csv")



