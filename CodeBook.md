---
title: 'Getting and Cleaning Data : Course Project'
author: "Oleg Reznychenko , oleg.reznychenko@gmail.com"
output: pdf_document
fontsize: 11pt
documentclass: article
---

The document descibes all stages of the data downloading, unzipping and processing. The same description you can see in the script comments.

Check whether the package **'data.table'** is installed and install if needed
```{r}
list.of.packages <- c("data.table")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(data.table)
```
Download and unzip data
```{r}
print("Start downloading...\n")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","./UCI HAR Dataset.zip")
unzip("./UCI HAR Dataset.zip")
print("Data are donloaded and unpacked.\n")
```
Working directory supposed to contain unpacked **'UCR HAR Dataset'** - load data tables
```{r}
print("Start to load tables...\n")
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
print("Row data are ready\n")
```
Change the 2d column type to 'character' for **'activities'** and **'features'**
```{r}
features[,2]<-sapply(features[, 2], as.character)
activities[,2]<-sapply(activities[, 2], as.character)
```
Extract the columns names contain **'mean()'** or **'std()'**
```{r}
headers<-features[sort(c(grep("mean()", features$V2), grep("std()", features$V2))),]
```
Create data frames
```{r}
df_train<-data.frame(train_data)
df_test<-data.frame(test_data)
```
Keep only columns names contain **'mean()'** or **'std()'**                  
```{r}
df_train <- df_train[,headers$V1]
df_test <- df_test[,headers$V1]
```
Append columns with activity labels to **'train_data'** and **'test_data'**
```{r}
df_train <- cbind(data.frame(train_labels$V1), df_train)
df_test <- cbind(data.frame(test_labels$V1), df_test)
```
Set the same name for first column before merge 
```{r}
colnames(df_test)[1] <- colnames(df_train)[1] <- "labels"
```
Merge frames
```{r}
df_all<-rbind(df_train, df_test)
```
Set column headers
```{r}
colnames(df_all)<-c("ActivityLabel",headers$V2)
```
Add column with activity name using *'ActivityLabel'* as index
```{r}
df_all <- within(df_all, ActivityName <- activities$V2[ActivityLabel])
```
Move it to the first place
```{r}
df_all <- df_all[,c(ncol(df_all),1:(ncol(df_all)-1))]
```
And delete the *'ActivityLabel'* column 
```{r}
df_all$ActivityLabel <- NULL
print("Combined data are ready.\n")
```
Now - convert to **'data.table'** to calculate **'mean'** for each column with group by *'ActivityName'*
```{r}
dt_all <- as.data.table(df_all)
dt_final <- dt_all[, lapply(.SD,mean), by=ActivityName]
print("Summary data are ready.\n")
```
Return to **'data.frame'** type and show the 'left-top' corner of the data
```{r}
df_final <- as.data.frame(dt_final)
df_final[,1:4]
```
Save final data
```{r}
write.csv(file="./FinalDataSet_MeanValues.csv", x=df_final)
print("Data are stored in file FinalDataSet_MeanValues.csv\n")
```

