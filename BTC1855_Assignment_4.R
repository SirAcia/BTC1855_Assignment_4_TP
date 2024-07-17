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
#' Step 9: Create a new column where it only contains the dates of the sighting.
#' Step 10: Create a new column called report_delay. It should contain the time
#' differences in days between date of sighting and date reported.
#' Step 11: Remove the rows where the date of sighting > date reported.
#' Step 12: Extract all rows where there is no missing data in country, duration
#' seconds, and report_delay.
#' Step 13: Create a table with the average report_delay per country (Group by
#' country).
#' Step 14: Create a histogram using the 'duration seconds' column.

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

#' Convert values in sighting_datetime to datetime objects for easy manipulation
#' later on
ufo$sighting_datetime <- strptime(ufo[["sighting_datetime"]],"%Y-%m-%d %H:%M")
