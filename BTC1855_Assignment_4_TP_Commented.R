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

setwd(C:Users/zachery/BTC1855/Assignment_4)

# Read the dataset and save to `ufo`
ufo <- read.csv("/Users/zachery/BTC1855/Assignment_4/ufo_subset.csv")

#ZC - Really like the use of these summary functions to cleanly examine the dataset
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
#' ZC - Good comments, props for readability 
names(ufo)[names(ufo) == "datetime"] <- "sighting_datetime"

# Check if the name has been updated
colnames(ufo)

# Check if there are any missing values in sighting date and date of report.
any(is.na(ufo[["sighting_datetime"]]))
any(is.na(ufo[["date_posted"]]))
# There were none so we can now convert them into POSIXlt objects
# ZC - Could use a function here, ecspecially if your'e NA checking the rest of the variables 
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
#' 
#' ZC - Nice comments explaining why city was not factored

#' Missing values in `country` column are not saved as NA. Check if there are
#' any missing values by checking if there are any matches to empty strings. If
#' the length is > 0, then that would indicate that there are empty values in
#' the column.

missing_country <- which(ufo[["country"]] == "")
if (length(missing_country) > 0) {
# Change the values at the indices of where empty strings are found to NA.
  is.na(ufo[["country"]]) <- missing_country
} #ZC - could just use logical here by mathcing ___ == ""

# Extract only the rows where country is not missing
ufo_1 <- ufo %>% filter(!is.na(country)) 
# ZC - Nice to save as a seperate dataset 

#' Repeat the same steps for `duration.seconds` column.
missing_seconds <- which(ufo_1[["duration.seconds"]] == "")
if (length(missing_seconds) > 0){
  is.na(ufo_1[["duration.seconds"]]) <- missing_seconds
} 

# Extract only the rows where duration.seconds is not missing
ufo_2 <- ufo_1 %>% filter(!is.na(duration.seconds))
#ZC -  could use function here as well 

#' In the summary above, it was found that there was a huge range in the duration
#' of sighting in seconds. I am cleaning this variable by removing the outliers,
#' based on the interquartile range. 

#' Create a function that identifies and returns the upper and lower limits of 
#' a set of values.
limits_iqr <- function(x) {
  # Calculate the interquartile range
  iqr <- IQR(x)
  # Calculate the first and third quartiles
  quart1 <- quantile(x, probs = 0.25)
  quart3 <- quantile(x, probs = 0.75)
  # Calculate the upper and lower limits using the quartiles and interquartile
  # range
  upper_limit <-  quart3 + 1.5 * iqr
  lower_limit <- quart1 - 1.5 * iqr
  # Put the upper and lower limits together in a list
  limits <- list("upper" = upper_limit, "lower" = lower_limit)
  # Return the list containing the limits
  return(limits)
} #ZC - I partially take my earlier comments back, nice use of a function here

#' Create a function that returns a list of indices of where the values are
#' within the lower and upper limits. It takes in a column/set of values 
#' and a list of its calculated upper and lower limits. 
within_limits <- function(x, limits) {
  # Extract the upper and lower limits from the list of limits
  upper <- limits$upper
  lower <- limits$lower
  # Finds the indices where the value is greater than or equal to the lower 
  # limit AND less than or equal to the upper limit.
  indices <- which(x >= lower & x <= upper)
  return(indices)
} #ZC - Could you combine these two functions? 

# Calculate the upper and lower limits for duration.seconds
duration_sec_limit <- limits_iqr(ufo_2$duration.seconds)

# Remove outliers from duration.seconds based on IQR
duration_sec_within_limit <- within_limits(ufo_2$duration.seconds, 
                                         duration_sec_limit)
ufo_3 <- ufo_2[duration_sec_within_limit, ]

#' Missing values in `shape` column are not saved as NA. Check if there are
#' any missing values by checking if there are any matches to empty strings. If
#' the length is > 0, then that would indicate that there are empty values in
#' the column.

missing_shape <- which(ufo_3[["shape"]] == "")
length(missing_shape) > 0

#' Crete a new dataframe with a modified `shape` column, where the missing values
#' are imputed to `unknown`.
ufo_4 <- ufo_3 %>% mutate(shape = case_when(
  shape == "" ~ "unknown", .default = shape) 
)
# ZC - good catch on the missings in shape, could've run this earlier when sorting country, 
# that way you create less objects/less confusion with dataframes! 

#' Identify rows where where the 'comments' column contains 'NUFORC:'. This
#' indicates the reports that NUFORC officials believe may be a hoax. Remove
#' these rows.
hoax_rows <- which(grepl("NUFORC", ufo_4$comments))
ufo_5 <- ufo_4[-hoax_rows, ]
#ZC - there may be some rows that mention NURFORC, the NUFORC comments are contained within 
# ((____)), could also check for those 

#' Create a new column called report_delay. The values are populated by
#' determining the time differences in days between date of sighting and date 
#' reported.
ufo_6 <- ufo_5 %>% mutate(report_delay = date_posted - sighting_datetime)

#' Create a new dataframe that only includes the rows where report_delay is a 
#' positive value. This indicates that the date reported is after the date of 
#' the sighting.
ufo_7 <- ufo_6 %>% filter(report_delay > 0) 

# Create a table with the average report_delay per country.
avg_report_delay_country <- aggregate(ufo_7$report_delay ~ ufo_7$country, FUN = mean, 
                            na.rm = TRUE)
colnames(avg_report_delay_country) <- c("Country", "Avg Report Delay")
avg_rep_del_country_table <- as.table(as.matrix(avg_report_delay_country))
avg_rep_del_country_table
#ZC - this is preference, could convert seconds into days, makes it more understandable

# Create a histogram using the 'duration seconds' column. Note that the data
# used here does not include the outliers, as they were removed earlier.
hist(ufo_7$duration.seconds)
# This does not provide a good spread of the data. Thus, I decided to use the 
# log10 scale to improve this histogram.
# ZC - nice catch using log10! 
max_log_duration_sec <- max(log10(ufo_7$duration.seconds)) + 1
min_log_duration_sec <- min(log10(ufo_7$duration.seconds))
duration_sec_hist <- hist(log10(ufo_7$duration.seconds), 
                          main = "Logarithmic Distribution of UFO Sighting Durations (s)",
                          xlab = "Duration of the Sighting (s; log10 scale)", 
                          ylab = "Frequency", xlim = c(-1, 
                                                       max_log_duration_sec),
                          ylim = c(0, 8000))
