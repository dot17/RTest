## Loading Relevant Libraries
library(RODBC)
library(dplyr)
library(readr)
library(ggplot2)

## Connecting to the Mettl DB
dbconnect <- odbcConnect("Mettl_DB_Copy", uid = "techSupport", pwd = "Mettl123")

## Reading the text file which contains Item Response Query
IR_query <- read_file("D:/Mettl Advantage Team/5. SQL Queries/SkillName_IR.txt")

## User input for the assessment ID
x <- readline(prompt = "Enter Assessment ID")

## Updating Item Response Query with the user input assessment ID 
IR_query <- gsub("000000",x,IR_query)

## Extracting SQL query output to a data frame
assessment_data_IR <- sqlQuery(dbconnect, IR_query)

##Closing connection to the DB
odbcClose(dbconnect)

## Removing unattempted data
assessment_data_IR_cleaned <- filter(assessment_data_IR, isattempted == 1)


## Calculating Difficulty Level for the Items
difficulty_level <- assessment_data_IR_cleaned %>% group_by(assessment_id, Item_ID) %>% summarise(Difficulty = sum(Marks_Obtained)/sum(MaxMarks))
