
require(tidyverse)
require(dplyr)

#import data
dataset1 <- read_csv("Assignments/Assignment-5/assignment6part1.csv")
dataset2 <- read_csv("Assignments/Assignment-5/assignment6part2.csv")

glimpse(dataset1)

# Pivot to create new separate columns for Sample, Gender, and Group
test_dataset1 <- dataset1 %>% pivot_longer(
  cols = "Sample1_Male_Control":"Sample20_Female_Treatment", # range of columns to pivot
  names_to = c("Sample", "Gender", "Group"), # Name of new columns
  names_pattern = "Sample(.*)_(.*)_(.*)", # Separating name into variables
  values_to = "Value")
  
# Create new columns for body_length and age
cleandataset1 <- test_dataset1 %>%
  pivot_wider(names_from = ID, values_from = Value)

# Now to work on dataset2

glimpse(dataset2)

# Pivot to create new columns for Sample and Group
cleandataset2 <- dataset2 %>% pivot_longer(
  cols = "Sample16.Treatment":"Sample13.Control",
  names_to = c("Sample", "Group"), 
  names_pattern = "Sample(.*)\\.(.*)", 
  values_to = "Mass")

# Remove that leftover ID column
cleandataset2 <- select(cleandataset2, -ID)

# Join the two datasets. left_join to take matching datapoints from cleandataset2 and add it to cleandataset1
merged_dataset <- left_join(cleandataset1,cleandataset2)

# Export as .csv
write_csv(merged_dataset, "Assignments/Assignment-5/Results/clean_data.csv")

# Moving on to Question 2

# Add column for residual mass
merged_resid <- transmute(merged_dataset, Sample = Sample, Gender = Gender, Group = Group, resid_mass = Mass / body_length) 

# Grouping by gender
sample_gender <- group_by(merged_resid, Gender)

# Finding mean and SD of resid_mass
gender_math <- summarize(sample_gender, mean_resid = mean(resid_mass,  na.rm=TRUE), SD =sd(resid_mass,  na.rm=TRUE))

# Grouping by treatment
sample_group <- group_by(merged_resid, Group)

# Finding mean and SD of resid_mass again
group_math <- summarize(sample_group, mean_resid = mean(resid_mass,  na.rm=TRUE), SD =sd(resid_mass,  na.rm=TRUE))

# Giving that first column in each table the same name before merging
group_math <- rename(group_math, Category = Group)
gender_math <- rename(gender_math, Category = Gender)

# Combining the two tibbles!
# I really am terrible at variable names
gendergroup_math <- rbind(group_math, gender_math)

# Columns for Mean +/- SD
math_meanSD <- mutate(gendergroup_math, Mean_minus_SD = mean_resid - SD, Mean_plus_SD = mean_resid + SD)

# Import as .csv
write_csv(gendergroup_math, "Assignments/Assignment-5/Results/Means-SD.csv")
