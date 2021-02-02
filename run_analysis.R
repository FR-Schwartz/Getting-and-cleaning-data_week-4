#Load the dataset from coursera
filename <- "UCI HAR Dataset.zip"

# Checking if the archive already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) {
  unzip(filename)
}

#Assigning the data frames
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merging training and test sets, creating one dataset to be tidied
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subjects <- rbind(subject_train, subject_test)
Merged_Dataset <- cbind(Subjects, Y, X)

#Make a tidy dataset with only the measurements of mean and SD
Final_data <- Merged_Dataset %>% select(subject, code, contains("mean"), contains("std"))

#Naming activities in dataset descriptively
Final_data$code <- activities[Final_data$code, 2]

#Label dataset with descriptive variable names
names(Final_data)[2] = "activity"
names(Final_data)<-gsub("Acc", "Accelerometer", names(Final_data))
names(Final_data)<-gsub("Gyro", "Gyroscope", names(Final_data))
names(Final_data)<-gsub("BodyBody", "Body", names(Final_data))
names(Final_data)<-gsub("Mag", "Magnitude", names(Final_data))
names(Final_data)<-gsub("^t", "Time", names(Final_data))
names(Final_data)<-gsub("^f", "Frequency", names(Final_data))
names(Final_data)<-gsub("tBody", "TimeBody", names(Final_data))
names(Final_data)<-gsub("-mean()", "Mean", names(Final_data), ignore.case = TRUE)
names(Final_data)<-gsub("-std()", "STD", names(Final_data), ignore.case = TRUE)
names(Final_data)<-gsub("-freq()", "Frequency", names(Final_data), ignore.case = TRUE)
names(Final_data)<-gsub("angle", "Angle", names(Final_data))
names(Final_data)<-gsub("gravity", "Gravity", names(Final_data))

# From the Final_data set, creating a second, independent tidy data set with the average of each variable for each activity and each subject.
Tidy_Data <- Final_data %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(Tidy_Data, "Tidy_Data.txt", row.name=FALSE)

#Checking the variable names
str(Tidy_Data)

#Inspecting the tidy dataset
Tidy_Data
