#loading tidyverse
require(tidyverse)
require(dplyr)

#Import and assign data to variable
MBT_ebird <- read_csv("Assignments/Data/MBT_ebird.csv")

#Looking at names of columns
glimpse(MBT_ebird)

# new variable with values grouped by year
bird_year_count <- group_by(MBT_ebird, year)

# checking out data
glimpse(bird_year_count)

# take a sum of count_tot
summarize(bird_year_count, sum_year = sum(count_tot,  na.rm=TRUE))

# create a variable containing only observations from 2014
only_2014 <- filter(MBT_ebird, year == 2014)

#glimpse again 
glimpse(only_2014)

#counts the number of each species (ex. there were 34 Canada Goose counted in 2014)
species_count <- count(only_2014, common_name, wt = NULL, sort = TRUE)

#counts the number of DIFFERENT species in the species_count variable
count(species_count, wt = NULL, sort = TRUE)

#separate country and state into two different columns
location_separate <- separate(MBT_ebird, location, into = c("country", "state"), sep = "-")

#did that work
glimpse(location_separate)

#create a variable containing only the rows for Red-winged Blackbirds
redwings_only <- filter(location_separate, scientific_name == "Agelaius phoeniceus")

#gotta check to see if I know what I'm doing
glimpse(redwings_only)

#count the number of rows for each state
count(redwings_only, state, wt = NULL, sort = TRUE)
#yay that answered question 3

#onto question 4
#filter out observations with duration greater than 200
duration_gt <- filter(MBT_ebird, duration < 200)
#and filter out observations with duration less than 5
duration_lf <- filter(duration_gt, duration > 5)

#I should've named it something better than "duration_lf" but oh well
glimpse(duration_lf)s

#defining a group where we take duration_lf and group it by the list IDs
bychecklist <- group_by(duration_lf, list_ID)

num_ea_species <- add_count(bychecklist, scientific_name, wt = NULL, sort = TRUE, name = "n") #add_count because it ADDS a new column with the count, unlike count which deleted all the other columns oops

#Created a column with the number of species for that list ID
#however each list ID is still listed more than once....
num_species_by_list <- mutate(num_ea_species, sum_species = sum(n,  na.rm=TRUE), .keep = "all")

# more terrible variable names whoops. Take the number of species in each list divided by duration.
species_math <- transmute(num_species_by_list, list_ID = list_ID, more_math = sum_species / duration, year = year)

#remove all those extra rows
distinct_math <- distinct(species_math)

# I've used group_by twice now and I'm still not quite sure if I truly understand what it does, but somehow I know when to use it. Weird. 
group_by_year <- group_by(distinct_math, year)

# almost there yay. Taking a mean by year
summarize(group_by_year, species_mean = mean(more_math))
#checked 2003 mean with calculator, I think it's okay! Question 4 done

# Question 5 start

#similar to before but not by list this time, just number of species with that scientific_name
total_ea_species <- add_count(MBT_ebird, scientific_name, wt = NULL, sort = TRUE, name = "n") 

# take away extraneous columns for now
fewer_col <- transmute(total_ea_species, scientific_name = scientific_name, n = n)

# terrible variable name
total_species <- distinct(fewer_col)

# here's the top ten
top_ten <- slice_max(total_species, order_by = n, n = 10)

#list of the top ten species
top_ten_list <- c("Cardinalis cardinalis", "Zenaida macroura", "Cyanocitta cristata", "Turdus migratorius", "Anas platyrhynchos", "Sturnus vulgaris", "Branta canadensis", "Spinus tristis", "Zonotrichia albicollis", "Melanerpes carolinus")

# filter entire dataset to observations only for the top ten species. Used %in% to make sure it checks all ten variables in the previous list against each rows because apparently == doesn't
filtered_ten <- filter(MBT_ebird, scientific_name %in% top_ten_list)

#Export as csv yay
write_csv(filtered_ten, "results.csv")



