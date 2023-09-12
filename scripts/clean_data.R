# PHS Scottish stroke statistics
# this script contains code to clean and prep raw data derived from PHS
# source: https://www.opendata.nhs.scot/dataset/scottish-stroke-statistics

# see below 'NRS data' for cleaning and wrangling steps of population estimate 
# datafiles derived from NRS.

## open libraries
library(tidyverse)
library(skimr)
library(readxl)

#####################
## first dataset: Stroke Activity By Health Board
#######

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
#######
 
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
#######

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
#######

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

##############################
# NRS data
############################
# clean dataset: 
# Mid-Year Population Estimates for Scotland, mid-2021: Time series data
# Source: NRS
# https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/population/population-estimates/mid-year-population-estimates/population-estimates-time-series-data


# we only need table 2:
# Mid-year population estimates by NHS health board, sex and single year of age, 1981-2021 [note 2]

pop_estimates <- read_excel("raw_data/mid-year-pop-est-21-time-series-data.xlsx", 
                            sheet = "Table_2",
                            range = cell_rows(6:1851))

pop_estimates <- pop_estimates %>% 
  janitor::clean_names() 
 
# only select the rows and columns we need:
# year: 2012-2021
# health boards

pop_estimates <- pop_estimates %>% 
  filter(year %in% c(2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021)) %>% 
  rename("hbr" = "area_code") %>% 
  mutate(sex = recode(sex, "Persons" = "All"))

# add population estimates into age bins similar as the NHS bins:
# 0-44 years, 45-64 years, 65-74 years, 75plus years

pop_estimates_age_bins <- pop_estimates %>% 
  mutate(age_bin_1 = rowSums(pop_estimates[6:50], na.rm = TRUE)) %>% 
  mutate(age_bin_2 = rowSums(pop_estimates[51:70], na.rm = TRUE)) %>% 
  mutate(age_bin_3 = rowSums(pop_estimates[71:80], na.rm = TRUE)) %>% 
  mutate(age_bin_4 = rowSums(pop_estimates[81:96], na.rm = TRUE)) %>% 
  select(hbr, area_name, sex, year, all_ages, age_bin_1, age_bin_2, age_bin_3, age_bin_4)

population_estimates_nhs_format <- pop_estimates_age_bins %>% 
  pivot_longer(cols = c("age_bin_1", "age_bin_2", "age_bin_3", "age_bin_4", "all_ages"),
               names_to = "age_group",
               values_to = "population_size") %>% 
  mutate(age_group = recode(age_group,
                            "age_bin_1" = "0-44 years",
                            "age_bin_2" = "45-64 years",
                            "age_bin_3" = "65-74 years",
                            "age_bin_4" = "75plus years",
                            "all_ages" = "All"))
  
# 4. write cleaned file to new csv:

write.csv(population_estimates_nhs_format, file = "clean_data/pop_est_nhs_format.csv")





