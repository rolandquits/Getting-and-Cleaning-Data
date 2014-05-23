## Sets URL as an object
fileUrl<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Downloads file 
download.file(fileUrl, destfile = "./files.zip")

## Unzips File
unzip("./files.zip")

## Stores test data in objects
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Stores training data in objects
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## Stores features and activity_labels in objects
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels) <- c("activity_no","Activity")

## Merges x data into 1 object
xdata <- rbind(xtrain,xtest)

## Merges y data into 1 object
ydata <- rbind(ytrain,ytest)
colnames(ydata) <- "activity_no"

## Merges subject data into 1 object
subjdata <- rbind(subjtrain,subjtest)
colnames(subjdata) <- "Subject"

## Provides column names to x data from features
colnames(xdata) <- features[,2]

## Stores extracted data concerning mean and standard deviations in object
extr_data <- xdata[grep("mean\\(\\)|std\\(\\)",colnames(xdata))]

## Merges all data sets into one
dataset <- cbind(extr_data,subjdata,ydata) 

## Labels the activities in the data set
dataset2 <- merge(dataset,activity_labels,by="activity_no")
drop <- c("activity_no")
dataset3 <- dataset2[,!(names(dataset2) %in% drop)]

## Make sure to install “reshape2” package. 
library(reshape2)
datamelt <- melt(dataset3,id=c("Subject","Activity"))
combmeans <- dcast(datamelt, Subject + Activity ~ variable, mean)

## Creates CSV of the second tidy set
write.table(combmeans, file = "./tidyset.txt",row.names=FALSE, sep = "\t")

