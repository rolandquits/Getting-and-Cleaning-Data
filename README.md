# Getting-and-Cleaning-Data

###### Course project repository for Getting and Cleaning Data


##### This is the README for my run_analysis.R script. This README will go step by step and explain my scripts. Please make sure to install the “reshape2” package before running my run_analysis.R script.
  
You can always refer to the data source for more questions regarding the data here: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  
  
##### Let us begin:

  
###### Sets the given URL for the data for this project as an object

```
fileUrl<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
```
  
###### Downloads file to user's working directory
```
download.file(fileUrl, destfile = "./files.zip")
```
  
###### Unzips File in working directory
```
unzip("./files.zip")
```
  
###### Stores test data from the unzipped files in objects
```
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")  
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")  
subjtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
```  
  
###### Stores training data from the unzipped files in objects
```
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")  
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")  
subjtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")  
```
  
###### Stores features and activity_labels data from the unzipped files in objects
```
features <- read.table("./UCI HAR Dataset/features.txt")  
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt") 
``` 
  
###### Names the columns in the activity_labels data.table for easy reference later
```
colnames(activity_labels) <- c("activity_no","Activity")  
```
  
###### Combines the xtest and xtrain data into 1 object
```
xdata <- rbind(xtrain,xtest)  
```
  
###### Combines the ytest and ytrain data into 1 object
```
ydata <- rbind(ytrain,ytest)  
```
  
###### Names the columns in the new ydata object for reference later
```
colnames(ydata) <- "activity_no"  
```
  
###### Combines the subject_test data and subject_train data into 1 object
```
subjdata <- rbind(subjtrain,subjtest)  
```
  
###### Names the subject data column
```
colnames(subjdata) <- "Subject"  
```
  
###### Provides column names to x data from the features file
```
colnames(xdata) <- features[,2]  
```
  
###### Stores the extracted data concerning mean and standard deviations in object
```
extr_data <- xdata[grep("mean\\(\\)|std\\(\\)",colnames(xdata))]  
```
  
###### Merges all data sets into one set
```
dataset <- cbind(extr_data,subjdata,ydata)  
```
  
###### Labels the activities in the data set from the activity_labels file
```
dataset2 <- merge(dataset,activity_labels,by="activity_no")  
```
  
###### This is to drop the no longer needed "activity_no" columnn
```
drop <- c("activity_no")  
dataset3 <- dataset2[,!(names(dataset2) %in% drop)]  
```
  
###### Make sure to install “reshape2” package. This is to call the package "reshape2" 
```
library(reshape2)  
```
  
###### This reshapes the data set such that the means of the variables are returned for every subject and activity combination  
```
datamelt <- melt(dataset3,id=c("Subject","Activity"))  
combmeans <- dcast(datamelt, Subject + Activity ~ variable, mean)  
```
  
###### Creates txt file of the final tidy set and saves to the working directory. The data is delimited by tab spacing
```
write.table(combmeans, file = "./combmeans.txt",row.names=FALSE, sep = "\t")  
```
  
