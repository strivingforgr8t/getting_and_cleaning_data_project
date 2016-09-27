library(data.table)

## load activity labels
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

## load column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

## only mean and std are needed
needed_features <- grepl("mean|std", features)

## load test data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## column names
names(x_test) <- features

## select only mean and std features
x_test <- x_test[,needed_features]

## load activity labels
y_test[,2] <- activity[y_test[,1]]
names(y_test) <- c("Activity_ID", "Activity_Label")
names(subject_test) <- "subject"

## bind data
test_data <- cbind(subject_test, y_test, x_test)

## load train data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## column names for train data
names(x_train) <- features

## select necessary columns
x_train <- x_train[,needed_features]

y_train[,2] = activity[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

## bind data
train_data <- cbind(subject_train, y_train, x_train)

dt <- rbind(train_data, test_data)

id_labels <- c("subject","Activity_ID","Activity_Label")
data_labels <- setdiff(colnames(dt), id_labels)
melted <- melt(dt, id = id_labels, measure.vars = data_labels)

## dataset with mean
tidy_data <- dcast(melted, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")


