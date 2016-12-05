if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")


# Reading trainings tables:
X_Train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Y_Train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
Subject_Train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
X_Test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
Y_Test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
Subject_Test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
Features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
Activity_Labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')


  
colnames(X_Train) <- Features[,2] 
colnames(Y_Train) <-"activityId"
colnames(Subject_Train) <- "subjectId"

colnames(X_Test) <- Features[,2] 
colnames(Y_Test) <- "activityId"
colnames(Subject_Test) <- "subjectId"

colnames(Activity_Labels) <- c('activityId','activityType')


  
Mrg_Train <- cbind(Y_Train, Subject_Train, X_Train)
Mrg_Test <- cbind(Y_Test, Subject_Test, X_Test)
setAllInOne <- rbind(Mrg_Train, Mrg_Test)


  
colNames <- colnames(setAllInOne)


  
  mean_and_std <- (grepl("activityId" , colNames) | 
                     grepl("subjectId" , colNames) | 
                     grepl("mean.." , colNames) | 
                     grepl("std.." , colNames) 
  )


  
  setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]


  
  setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                                by='activityId',
                                all.x=TRUE)



secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]



write.table(secTidySet, "Tidy.txt", row.name=FALSE)

