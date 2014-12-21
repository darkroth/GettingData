##
## [Step 0] Preprocessing of required files
##

## List of all raw files used.
## 0. Mapping file
str_actvty_map <- "UCI HAR Dataset\\activity_labels.txt"
str_colnames <- "UCI HAR Dataset\\features.txt"
## 1. Training data files
str_train_data <- "UCI HAR Dataset\\train\\X_train.txt"
str_train_actvty <- "UCI HAR Dataset\\train\\y_train.txt"
str_train_subject <- "UCI HAR Dataset\\train\\subject_train.txt"

## 2. Test data files
str_test_data <- "UCI HAR Dataset\\test\\X_test.txt"
str_test_actvty <- "UCI HAR Dataset\\test\\y_test.txt"
str_test_subject <- "UCI HAR Dataset\\test\\subject_test.txt"

## Open all raw files listed
## 0a. Map of activity number to descriptivity name
actvty_map <- read.table(str_actvty_map,stringsAsFactors=FALSE)
names(actvty_map) <- c("index","label")
## 0b. Measurement names, and drop first column
col_names_raw <- read.table(str_colnames)

## 1. Training data objects
if (!exists("train_data_raw")) { train_data_raw <- read.table(str_train_data) }
train_actvty <- read.table(str_train_actvty)
##Replace with descriptive label using a temp vector object
tmp_vector <- train_actvty[,1] 
train_actvty <- as.data.frame(actvty_map$label[tmp_vector[tmp_vector %in% actvty_map$index]])
names(train_actvty) <- "V1"
rm(tmp_vector)
train_subject <- read.table(str_train_subject)

## 2. Test data objects
if (!exists("test_data_raw")) { test_data_raw <- read.table(str_test_data) }
test_actvty <- read.table(str_test_actvty)
##Replace with descriptive label using a temp vector object
tmp_vector <- test_actvty[,1]
test_actvty <- as.data.frame(actvty_map$label[tmp_vector[tmp_vector %in% actvty_map$index]])
names(test_actvty) <- "V1"
rm(tmp_vector)
test_subject <- read.table(str_test_subject)


##
## [Step 1] Merge the data
##
col_names <- c("subject","activity",as.vector(col_names_raw[ ,2]))
train_data <- data.frame(train_subject,train_actvty,train_data_raw)
names(train_data) <- col_names

test_data <- data.frame(test_subject,test_actvty,test_data_raw)
names(test_data) <- col_names

merged_data <- rbind(train_data,test_data)

##
## [Step 2] Extract the mean() and std() values
##

tmp_vector <- as.vector(col_names_raw[,2])
tmp_vector <- tmp_vector[grepl("mean()",tmp_vector) | grepl("std()",tmp_vector)]
## tmp_vector now contains the columns to extract
subset_merged <- merged_data[,c("subject","activity",tmp_vector)]

##
## [Step 3] Descriptive activity names <- already done in pre-processing step (#0)
##

##
## [Step 4] Labeling of data set with descriptive variable names <- already done in merging step (#1)
##

##
## [Step 5] Calculation of average of each variable for each activity and each subject
##



if(!file.exists("output")) { dir.create("output") }
