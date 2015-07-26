#Read data from files
testData <- read.table("./test/X_test.txt")
trainData <- read.table("./train/X_train.txt")
subject_test <- read.table("./test/subject_test.txt")
subject_train <- read.table("./train/subject_train.txt")

#Bind test and train data
allData <- rbind(testData,trainData)

#Add column names
features <- read.table("./features.txt")[,2]
colnames(allData) <- features

#Bind subject data
subject <- rbind(subject_test,subject_train)
colnames(subject) <-c("subject")

#Read labels from files
testLabel <- read.table("./test/y_test.txt")
trainLabel <- read.table("./train/y_train.txt")
allLabel <- rbind(testLabel,trainLabel)
colnames(allLabel)=c("id")

#Merge with labels descriptions
activity_labels <- read.table("./activity_labels.txt")
colnames(activity_labels) <- c("id", "description")
mergedLabels <- merge(allLabel, activity_labels, by.x="id", by.y="id")
colnames(mergedLabels) <- c("label_id", "label_description")

#Extract only the measurements on the mean and standard deviation for each measurement
extract_features <- grepl("mean|std", features)
allData <- allData[,extract_features]

#Bind data
data <- cbind(subject,mergedLabels,allData)

id_labels   = c("subject", "label_id", "label_description")
data_labels = setdiff(colnames(data), id_labels)
melt_data = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data = dcast(melt_data, subject + label_description ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt",row.name=FALSE)
