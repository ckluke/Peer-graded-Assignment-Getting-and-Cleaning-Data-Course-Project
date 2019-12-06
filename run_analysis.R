url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
path <- "/Users/calvinkluke/Desktop/Coursera/Getting and Cleaning Data/runanalysis.zip"
download.file(url, path, method = "curl")
unzip(path)
UCIpath <- "/Users/calvinkluke/Desktop/Coursera/Getting and Cleaning Data/UCI HAR Dataset"
setwd(UCIpath)
#####################################################################################################
#####################################################################################################
testsub <- read.table("test/subject_test.txt")
xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
trainsub <- read.table("train/subject_train.txt")
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
features <- read.table("features.txt")
#####################################################################################################
#####################################################################################################
xmerge <- rbind(xtrain, xtest)
submerge <- rbind(trainsub, testsub)
ymerge <- rbind(ytrain, ytest)
#####################################################################################################
#####################################################################################################
names(submerge) <- c("subject")
names(ymerge) <- c("activity")
names(xmerge) <- features[, 2]

subymerge <- cbind(submerge, ymerge)
finmerge <- cbind(subymerge, xmerge) 

grepfeatures <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]

subdata <- c(as.character(grepfeatures), "subject", "activity" )
subdata <- subset(finmerge, select = subdata)

#####################################################################################################
#####################################################################################################

subdata$activity <- gsub(pattern = 1, replacement = "WALKING", subdata$activity)
subdata$activity <- gsub(pattern = 2, replacement = "WALKING_UPSTAIRS", subdata$activity)
subdata$activity <- gsub(pattern = 3, replacement = "WALKING_DOWNSTAIRS", subdata$activity)
subdata$activity <- gsub(pattern = 4, replacement = "SITTING", subdata$activity)
subdata$activity <- gsub(pattern = 5, replacement = "STANDING", subdata$activity)
subdata$activity <- gsub(pattern = 6, replacement = "LAYING", subdata$activity)
subdata$activity <- as.factor(subdata$activity)

names(subdata) <- gsub("^t", "time", names(subdata))
names(subdata) <- gsub("^f", "frequency", names(subdata))
names(subdata) <- gsub("Acc", "Accelerometer", names(subdata))
names(subdata) <- gsub("Gyro", "Gyroscope", names(subdata))
names(subdata) <- gsub("Mag", "Magnitude", names(subdata))
names(subdata) <- gsub("BodyBody", "Body", names(subdata))

#####################################################################################################
#####################################################################################################

subdata2 <- aggregate(. ~subject + activity, subdata, mean)
subdata2 <- subdata2[order(subdata$subject, subdata$activity), ]
write.table(subdata2, file = "tidydata.txt", row.names = FALSE)

subdata2 <- arrange(subdata2, subject)
subdata2 <- subdata2[1:180, ]



