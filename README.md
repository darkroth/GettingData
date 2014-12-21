# Project 1 for "Getting and Cleaning Data"

The data used for creating the tidy data table here is taken from [the Machine Learning Repository at UC Irvine](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). For copyright information, see: *Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra* and *Jorge L. Reyes-Ortiz*, **Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine**, International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

### Design Specification
As per the provided specification, the code 'run_analysis.R' is required to do the following steps:

1. Merges the training and the test sets to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

### Implementation Notes
While the script meets all the requirements, *a few of the steps are merged as a result of the implemented design*. The script logic is explained below:

Step 0: load all the required information, which includes information about the subject, activity, and the processed information provided in the files "X_train.txt" and "X_test.txt". A couple of mapping files (activity names, column names) are also loaded. Additionally, as part of this step, the activity indicator is replaced by a descriptive label (item 3. above)

Step 1: merge the data loaded up in the prior step, first within each set ('training' or 'test'), and then across the sets

Step 2: identify the columns to extract from the entire list of 561 processed varialbles, and prepend these with the subject ID and activity columns. The columns extracted using this subset of the merged data set become the data set to be processed in Step 5 below

Step 3: note that this step has already been completed in Step 0 (preprocessing step)

Step 4: note that this step has already been completed in step 1 (merging step)

Step 5: process the subset to calculate the average values of each variable following grouping by each activity and each subject. This uses a temporary 3d array to store the values of the averages being calculated by tapply(), and this array is then "unrolled" to get the output into a 2-d layout.
