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

cols_to_extract <- as.vector(col_names_raw[,2])
cols_to_extract <- cols_to_extract[grepl("mean()",cols_to_extract) | grepl("std()",cols_to_extract)]
## cols_to_extract now contains the columns to extract
subset_merged <- merged_data[,c("subject","activity",cols_to_extract)]
rm(cols_to_extract)

##
## [Step 3] Descriptive activity names <- already done in pre-processing step (#0)
##

##
## [Step 4] Labeling of data set with descriptive variable names <- already done in merging step (#1)
##

##
## [Step 5] Calculation of average of each variable for each activity and each subject
##

## 5a. Calculate the averages required for each column and store it for later merging across columns
ncols_to_process <- ncol(subset_merged)-2
## Store the averages in a 3-dimensional matrix with axes for (subject, activity, processed_column)
## Each slice along the 3rd dimension represents the averages across a single column in the provided
## data
tmp_array = array(dim=c(30,6,ncols_to_process))

for (n in 3:(ncols_to_process+2)) {
  ## Create a temp data.frame to hold the average values for the column being processed
  ## The key is a combination of subject and activity
  tmp_df <- data.frame(paste(subset_merged$subject,subset_merged$activity,sep=" "), subset_merged[,n])
  names(tmp_df) <- c("key","value")
  tmp_avg <- tapply(tmp_df$value,tmp_df$key,FUN=sum)
  col_names <- names(tmp_avg)
  subject <- lapply(strsplit(col_names,split=" "),`[[`,1)
  subject <- as.numeric(unlist(subject))
  activity <- lapply(strsplit(col_names,split=" "),`[[`,2)
  activity <- unlist(activity)
  tmp_avg <- as.numeric(tmp_avg)
  for (m in 1:length(tmp_avg)) {
    i <- subject[[m]]
    j <- match(activity[[m]],actvty_map$label)
    tmp_array[i,j,n-2] = tmp_avg[[m]]
  }
}

## 5b. "Unroll" the array to get to a 2d data.frame, using the values stored in 'tmp_array'
if(!file.exists("output")) { dir.create("output") }

for (i in 1:30) {
  for (j in 1:6) {
    tmp_row <- list(subject=subject[[(i-1)*6+j]],
                    activity=activity[[(i-1)*6+j]])
    tmp_vector <- c(1:ncols_to_process)
    for (k in 1:ncols_to_process) {
      tmp_row <- c(tmp_row, tmp_array[i,j,k])
    }
    names(tmp_row) <- names(subset_merged)
    if(i==1 && j==1) {
      averages_df <- tmp_row
    } else {
      averages_df <- rbind(averages_df,tmp_row)
    }
  }
}

write.table(averages_df,"output\\output.txt",row.names=FALSE)
