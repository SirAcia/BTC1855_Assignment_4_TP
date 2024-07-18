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
#' Step 11: Create a table with the average report_delay per country (Group by
#' country).
#' Step 12: Create a histogram using the 'duration seconds' column.

# Install packages if you don't already have them installed
# install.packages("dplyr")
# install.packages("lubridate")

# Load packages needed to clean and analyze data
library(dplyr)
library(lubridate)

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
names(ufo)[names(ufo) == "datetime"] <- "sighting_datetime"

# Check if the name has been updated
colnames(ufo)

# Check if there are any missing values in sighting date and date of report.
any(is.na(ufo[["sighting_datetime"]]))
any(is.na(ufo[["date_posted"]]))
# There were none so we can now convert them into POSIXlt objects

#' Convert values in sighting_datetime and date_posted to POSIXlt objects for 
#' easy manipulation later on
ufo$sighting_datetime <- parse_date_time(ufo[["sighting_datetime"]],
                                         "%Y-%m-%d %H:%M", exact = TRUE)
ufo$date_posted <- parse_date_time(ufo[["date_posted"]], "%d-%m-%Y",
                                   exact = TRUE)

# Check again to make sure that there are no missing values in sighting date and 
# date of report.
any(is.na(ufo[["sighting_datetime"]]))
any(is.na(ufo[["date_posted"]]))
# No missing values!

#' Although some of the missing values in the `country` column can be filled in
#' with the correct country based on the `city` column values, there are too many
#' missing values that represent countries all over the world. It would be 
#' difficult to interpret and fill in the missing values automatically and
#' manually. 

#' Missing values in `country` column are not saved as NA. Check if there are
#' any missing values by checking if there are any matches to empty strings. If
#' the length is > 0, then that would indicate that there are empty values in
#' the column.

missing_country <- which(ufo[["country"]] == "")
if (length(missing_country) > 0) {
# Change the values at the indices of where empty strings are found to NA.
  is.na(ufo[["country"]]) <- missing_country
}

# Extract only the rows where country is not missing
ufo_1 <- ufo %>% filter(!is.na(country)) 

#' Repeat the same steps for `duration.seconds` column.
missing_seconds <- which(ufo_1[["duration.seconds"]] == "")
if (length(missing_seconds) > 0){
  is.na(ufo_1[["duration.seconds"]]) <- missing_seconds
}

# Extract only the rows where duration.seconds is not missing
ufo_2 <- ufo_1 %>% filter(!is.na(duration.seconds))

#' Missing values in `shape` column are not saved as NA. Check if there are
#' any missing values by checking if there are any matches to empty strings. If
#' the length is > 0, then that would indicate that there are empty values in
#' the column.

missing_shape <- which(ufo_2[["shape"]] == "")
length(missing_shape) > 0

#' Crete a new dataframe with a modified `shape` column, where the missing values
#' are imputed to `unknown`.
ufo_3 <- ufo_2 %>% mutate(shape = case_when(
  shape == "" ~ "unknown", .default = shape) 
)

#' Identify rows where where the 'comments' column contains 'NUFORC:'. This
#' indicates the reports that NUFORC officials believe may be a hoax. Remove
#' these rows.
hoax_rows <- which(grepl("NUFORC", ufo_3$comments))
ufo_4 <- ufo_3[-hoax_rows, ]

#' Create a new column called report_delay. The values are populated by
#' determining the time differences in days between date of sighting and date 
#' reported.
ufo_5 <- ufo_4 %>% mutate(report_delay = date_posted - sighting_datetime)

#' Create a new dataframe that only includes the rows where report_delay is a 
#' positive value. This indicates that the date reported is after the date of 
#' the sighting.
ufo_6 <- ufo_5 %>% filter(report_delay > 0) 
