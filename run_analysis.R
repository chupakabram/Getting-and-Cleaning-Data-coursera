#
# Course Project, Getting and Cleaning Data, coursera.org , June 2015
#
# oleg.reznychenko@gmail.com
#

#
# The purpose of this project is to demonstrate your ability to collect, 
# work with, and clean a data set. The goal is to prepare tidy data 
# that can be used for later analysis. You will be graded by your peers 
# on a series of yes/no questions related to the project. You will be 
# required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, and 
# 3) a code book that describes the variables, the data, and any 
# transformations or work that you performed to clean up the data 
# called CodeBook.md. 
# 
# You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.  
# 
# One of the most exciting areas in all of data science right now is 
# wearable computing - see for example this article . Companies like 
# Fitbit, Nike, and Jawbone Up are racing to develop the most advanced 
# algorithms to attract new users. The data linked to from the course 
# website represent data collected from the accelerometers from the 
# Samsung Galaxy S smartphone. A full description is available at the 
# site where the data was obtained: 
# 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# 
# Here are the data for the project: 
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# You should create one R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with 
#    the average of each variable for each activity and each subject.
#

#
# Script to combine data sets ------------------------------------------------------
#

# Check whether the package 'data.table' is installed
list.of.packages <- c("data.table")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# Install if need
if(length(new.packages)) install.packages(new.packages)

library(data.table)

# Download and unzip data
print("Start downloading...\n")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","./UCI HAR Dataset.zip")
unzip("./UCI HAR Dataset.zip")
print("Data are donloaded and unpacked.\n")

# Working directory supposed to contain unpacked 'UCR HAR Dataset'
print("Start to load tables...\n")
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
print("Row data are ready\n")

# Change the 2d column type to 'character' for 'activities' and 'features'
features[,2]<-sapply(features[, 2], as.character)
activities[,2]<-sapply(activities[, 2], as.character)

# Extract the columns names contain 'mean()' or 'std()'
headers<-features[sort(c(grep("mean()", features$V2), grep("std()", features$V2))),]

# Create data frames
df_train<-data.frame(train_data)
df_test<-data.frame(test_data)

# Keep only columns names contain 'mean()' or 'std()'                  
df_train <- df_train[,headers$V1]
df_test <- df_test[,headers$V1]

# Append columns with activity labels to 'train_data' and 'test_data'
df_train <- cbind(data.frame(train_labels$V1), df_train)
df_test <- cbind(data.frame(test_labels$V1), df_test)
# Set the same name for first column before merge 
colnames(df_test)[1] <- colnames(df_train)[1] <- "labels"

# Merge frames
df_all<-rbind(df_train, df_test)

# Set column headers
colnames(df_all)<-c("ActivityLabel",headers$V2)

# Add column with activity name using 'ActivityLabel' as index
df_all <- within(df_all, ActivityName <- activities$V2[ActivityLabel])
# Move it to the first place
df_all <- df_all[,c(ncol(df_all),1:(ncol(df_all)-1))]
# And delete the 'ActivityLabel' column 
df_all$ActivityLabel <- NULL

print("Combined data are ready.\n")

# Now - convert to 'data.table' to calculate 'mean' for each column 
# with group by 'ActivityName'
dt_all <- as.data.table(df_all)
dt_final <- dt_all[, lapply(.SD,mean), by=ActivityName]

print("Summary data are ready.\n")

# Return to 'data.frame' type and show the 'left-top' corner of the data
df_final <- as.data.frame(dt_final)
View(df_final[,1:7])

# Save final data
write.csv(file="./FinalDataSet_MeanValues.csv", x=df_final)
print("Data are stored in file FinalDataSet_MeanValues.csv\n")

write.table(dt_final,file="./FinalDataSet_MeanValues.txt", row.name=FALSE)
print("Data are stored in file FinalDataSet_MeanValues.txt\n")

# ---------------- EOF ----------------------------



