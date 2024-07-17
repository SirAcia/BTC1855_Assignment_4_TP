# Assignment 4 - Martians
# BTC1855
# By Trinley Palmo

# R version 4.4.0

# Plan
#' Step 1: Read the data into a dataframe
#' Step 2: Look at the data to check for any structural issues
#' Step 3: Correct any found structural issues.
#' Step 4: Identify any missing data in the column, 'country'. For missing data,
#' impute it to NA.
#' Step 5: Identify any missing data in the column, 'shape'. For missing data, 
#' impute them to 'unknown' instead.
#' Step 6: Identify any missing data in the column, 'duration seconds'. For 
#' missing data, impute it to NA.
#' Step 7: Identify the index numbers for rows where the 'comments' column 
#' contains 'NUFORC:'.
#' Step 8: Remove those specified rows.
#' Step 9: Create a new column called report_delay. It should contain the time
#' differences in days between date of sighting and date reported.
#' Step 10: Remove the rows where the date of sighting > date reported.
#' Step 11: Extract all rows where there is no missing data in country, duration
#' seconds, and report_delay.
#' Step 12: Create a table with the average report_delay per country (Group by
#' country).
#' Step 13: Create a histogram using the 'duration seconds' column.

# Load packages needed to clean and analyze data
library(dplyr)

# Set the working directory for where you can find the ufo dataset
setwd("C:/Users/tpalm/Downloads/")

# Read the dataset and save to `ufo`
ufo <- read.csv("ufo_subset.csv")

# Check if it is a dataframe
class(ufo)

# Check the number of rows and columns of the dataframe
dim(ufo)

# Check the names of the dataframe
names(ufo)

# View the structure of the dataframe
str(ufo)

# Check summary statistics for the different variables in the dataframe
summary(ufo)

#' Change the datetime column name to `sighting_datetime`. Currently it is called
#' `datetime`, which is an ambiguous name. It should reflect what it contains,
#' which is the date and time of sighting.
names(ufo)[names(ufo) == 'datetime'] <- 'sighting_datetime'

#' Convert values in sighting_datetime and date_posted to POSIXlt objects for 
#' easy manipulation later on
ufo$sighting_datetime <- strptime(ufo[["sighting_datetime"]],"%Y-%m-%d %H:%M")
ufo$date_posted <- strptime(ufo[["date_posted"]], "%d-%m-%Y")

#' Although some of the missing values in the `country` column can be filled in
#' with the correct country based on the `city` column values, there are too many
#' missing values that represent countries all over the world. It would be 
#' difficult to interpret and fill in the missing values automatically and
#' manually. Instead, I decided to set them as NA. The missing values in 
#' `country` is not labelled as NA. Change the values at the indices of where 
#' empty strings are found to NA.
is.na(ufo[["country"]]) <- which(ufo[["country"]] == "") 


