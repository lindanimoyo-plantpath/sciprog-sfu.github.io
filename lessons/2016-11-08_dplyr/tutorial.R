# import libraries
install.packages("dplyr")
library("dplyr")

# print version numbers for packages and more info
sessionInfo()

# load in data
surveys <- read.csv("data/combined.csv")
str(surveys)

# select columns
surveysSmall <- select(surveys,plot_id,species_id,weight,year)
str(surveysSmall)

# filter rows
surveysSmall1995 <- filter(surveysSmall,year==1995)
str(surveysSmall1995)

# AND = &
# OR = |
filter(surveysSmall,year==1995 & plot_id == 2)

# pipes to combine functions
# symbol %>% 
# the two commands below are identical, the second is stylistically preferred

filter(surveys, weight < 5) %>% select(species_id, sex, weight)

surveysLight <- surveys %>% 
  filter(weight <5) %>% 
  select(species_id,sex,weight)

# Challenge 1 
# using pipes subset the data to include individuals collected before 1995, and retain the columns year, sex and weight

# Mutate = create columns based on existing columns

surveys %>% mutate(weight_kg = weight/1000) %>% head()

surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg = weight/1000) %>% 
  head()

# split-apply-combine

weightBySex <- surveys %>% 
  group_by(sex) %>% 
  summarise(mean_weight = mean(weight,na.rm = TRUE))

weightBySex

surveys %>% group_by(sex) %>% print(n=15)

weightBySex <- surveys %>% 
  group_by(sex) %>% 
  summarise(mean_weight = mean(weight,na.rm = TRUE),
            min_weight = min(weight,na.rm=TRUE))

# get the number of rows in each group
# both commands do the same
surveys %>% group_by(sex) %>% tally()
surveys %>% count(sex)


surveys %>% group_by(sex,genus,year) %>% tally()


