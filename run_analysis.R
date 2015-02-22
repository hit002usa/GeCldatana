## Step 1
## Load test data and train data first
## Extracts only the measurements on the mean and standard deviation for each measurement.

#### derive target test data
# load activity and features data
raw_activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_labels <- raw_activity_labels[ , 2]
raw_features <- read.table("./UCI HAR Dataset/features.txt")
features <- raw_features[ , 2]

# extract mean and std measurements
index_features <- grepl("mean|std", features)

# load X_test, y_test and subject test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# assign names to activities
names(X_test) = features

# extract X test data based on index_features.
X_test = X_test[ , index_features]

# load activity labels
y_test[ , 2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

##derive test data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

#####derive target train data
# load X_train, y_train and subject train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# assign names to activities
names(X_train) = features

# extract X_train data based on index_features
X_train = X_train[,index_features]

# load activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

#### derive train data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

##step 2 
## mergering test and train data and label the derived merged data set
data = rbind(test_data, train_data)
id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
mergeddata  = melt(data, id = id_labels, measure.vars = data_labels)

##step 3 create a tidy data set
# apply mean function to dataset using dcast function
tidy_data   = dcast(mergeddata, subject + Activity_Label ~ variable, mean)

## write a txt file
write.table(tidy_data, file = "./tidy_data.txt")