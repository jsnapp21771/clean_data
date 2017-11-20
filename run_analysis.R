#! /usr/bin/Rscript
library(data.table)

##  You should create one R script called run_analysis.R that does the
##  following.

##  Step 1. Merges the training and the test sets to create one data set.

##  Step 2. Extracts only the measurements on the mean and standard deviation
##  for each measurement.

##  Step 3. Uses descriptive activity names to name the activities in the data
##  set

##  Setp 4. Appropriately labels the data set with descriptive variable names.

##  Step 5. From the data set in step 4, creates a second, independent tidy
##  data set with the average of each variable for each activity and
##  each subject.  


datadir = './UCI HAR Dataset'
setwd(datadir)


##  Merge the X datasets

print("merge X train and test into one table")
train_x <- read.table("train/X_train.txt")
test_x <- read.table("test/X_test.txt")

X <- rbind(train_x, test_x)


## merge the subject sets

print("merge subject train and test into one table")
train_subject <- read.table("train/subject_train.txt")
test_subject <- read.table("test/subject_test.txt")
S <- rbind(train_subject, test_subject)


## merge the y train and test datasets

print("merge y train and test into one table")
train_y<- read.table("train/y_train.txt")
test_y <- read.table("test/y_test.txt")
Y <- rbind(train_y, test_y)


##  Part 2. Extract only the measurements on the mean and standard
##  deviation for each measurement.

print("read all elements from features files")
features <- read.table("features.txt")
print("use regex to extract just the features of interest")
wanted_features <- grep("mean\\(\\)|std\\(\\)", features[, 2])
X <- X[, wanted_features]


##  Part 3. Use descriptive activity names to name the activities in
##  the data set.

print("read the activities tables")
activities <- read.table("activity_labels.txt")
Y[,1] = activities[Y[,1], 2]


##  Part 4. Appropriately label the data set with descriptive activity names.

names <- features[wanted_features,2]
names(X) <- names
names(S) <- "SubjectID"
names(Y) <- "Activity"
lab_s <-cbind(S, Y, X)



##  Part 4. Create a 2nd, independent tidy data set with the average of each
##  variable for each activity and each subject.

clean_data <- data.table(lab_s)
tidy_data <- clean_data[, lapply(.SD, mean), by = 'SubjectID,Activity']
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)
