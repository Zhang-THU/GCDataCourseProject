#Explanations in details can refer to README.Rmd file
#read train data
xtrain <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
ytrain <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
subject_train <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")
#read test data
xtest <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
ytest <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
subject_test <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
#merge train and test data
x <- rbind(xtest,xtrain)
y <- rbind(ytest,ytrain)
subject <- rbind(subject_test,subject_train)
#read feature file and create column names
feature <- read.table(".\\UCI HAR Dataset\\features.txt")
feature <- feature[,2]
feature <- as.character(feature)
names(x) <- feature
names(subject) <- "Subject"
names(y) <- "Activity"
#select mean and std data
select <- grepl("std",feature) | grepl("mean",feature)
x <- x[,select]
#merge data
data <- cbind(subject,x)
data <- cbind(y,data)
#subset activity label
labels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt")
labels[,2] <- as.character(labels[,2])
data$Activity <- gsub(labels[1,1],labels[1,2],data$Activity)
data$Activity <- gsub(labels[2,1],labels[2,2],data$Activity)
data$Activity <- gsub(labels[3,1],labels[3,2],data$Activity)
data$Activity <- gsub(labels[4,1],labels[4,2],data$Activity)
data$Activity <- gsub(labels[5,1],labels[5,2],data$Activity)
data$Activity <- gsub(labels[6,1],labels[6,2],data$Activity)
#refine column names
names(data) <- gsub("\\()","",names(data))
names(data) <- gsub("-"," ",names(data))
names(data) <- gsub("Acc","Accelerometer ",names(data))
names(data) <- gsub("Gyro","Gyroscope ",names(data))
names(data) <- gsub("Mag","magnitude ",names(data))
names(data) <- gsub("tBody","Time domain body ",names(data))
names(data) <- gsub("tGravity","Time domain gravity ",names(data))
names(data) <- gsub("fBodyBody","fBody",names(data))
names(data) <- gsub("fBody","Frequency domain body ",names(data))
names(data) <- gsub("mean","mean value ",names(data))
names(data) <- gsub("std","standard deviation ",names(data))
names(data) <- gsub("  "," ",names(data))
#step5
library(reshape2)
datamelt <- melt(data,id=c("Activity","Subject"))
newdata <- dcast(datamelt,Activity + Subject ~ variable,mean)
#write result
write.table(newdata,"data.txt",col.names=FALSE)