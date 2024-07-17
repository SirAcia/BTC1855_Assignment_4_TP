# Assignment 4 - Martians
# BTC1855
# By Trinley Palmo

# R version 4.4.0

# Plan
#' Step 1: Read the data into a dataframe
#' Step 2: Look at the data to check for any structural issues
#' Step 3: Correct any found strucutral issues.
#' Step 4: Check the class type of values in each column
#' Step 5: For values that are all numeric, change to integers.
#' Step 6: Identify any missing data in the column, 'country'. For missing data,
#' impute it to NA.
#' Step 7: Identify any missing data in the column, 'shape'. For missing data, 
#' impute them to 'unknown' instead.
#' Step 8: Identify any missing data in the column, 'duration seconds'. For 
#' missing data, impute it to NA.
#' Step 9: Identify the index numbers for rows where the 'comments' column 
#' contains 'NUFORC:'.
#' Step 10: Remove those specified rows.
#' Step 11: Create a new column where it only contains the dates of the sighting.
#' Step 12: Create a new column called report_delay. It should contain the time
#' differences in days between date of sighting and date reported.
#' Step 12: Remove the rows where the date of sighting > date reported.
#' Step 13: Extract all rows where there is no missing data in country, duration
#' seconds, and report_delay.
#' Step 14: Create a table with the average report_delay per country (Group by
#' country).
#' Step 15: Create a histogram using the 'duration seconds' column.