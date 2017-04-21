## Loading Relevant Libraries
library(RODBC)
library(dplyr)
library(readr)
library(ggplot2)

dbconnect <- odbcConnect("Mettl_DB_Copy", uid = "techSupport", pwd = "Mettl123")
IR_query <- read_file("D:/Mettl Advantage Team/5. SQL Queries/SkillName_IR.txt")
x <- readline(prompt = "Enter Assessment ID")
IR_query <- gsub("000000",x,IR_query)

assessment_data_IR <- sqlQuery(dbconnect, IR_query)
odbcClose(dbconnect)

assessment_data_IR_cleaned <- filter(assessment_data_IR, isattempted == 1)

difficulty_level <- assessment_data_IR_cleaned %>% group_by(assessment_id, Item_ID) %>% summarise(Difficulty = sum(Marks_Obtained)/sum(MaxMarks))
