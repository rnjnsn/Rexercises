# LOADS REQUIRED LIBRARIES
library(dplyr)
library(reshape2)

# SETS WORKING DIRECTORY AND LOADS DATA
# Sets the working directory to the folder containing the dataset
setwd("[INPUT YOUR WD]")

# Loads features and activity labels
features <- read.table("features.txt", col.names = c("Index", "Feature"))
activity_labels <- read.table("activity_labels.txt", col.names = c("ActivityID", "ActivityName"))
View(activity_labels)

# LOADS AND MERGES TRAINING AND TEST DATA
# Loads training data
X_train <- read.table("train/X_train.txt", col.names = features$Feature)
y_train <- read.table("train/y_train.txt", col.names = "ActivityID")
subject_train <- read.table("train/subject_train.txt", col.names = "SubjectID")

# Loads test data
X_test <- read.table("test/X_test.txt", col.names = features$Feature)
y_test <- read.table("test/y_test.txt", col.names = "ActivityID")
subject_test <- read.table("test/subject_test.txt", col.names = "SubjectID")

# Merges training and test data
train_data <- cbind(subject_train, y_train, X_train)
test_data <- cbind(subject_test, y_test, X_test)
merged_data <- rbind(train_data, test_data)

# EXTRACTS MEAN AND STANDARD DEVIATION MEASUREMENTS
# Extracts columns containing "mean" or "std"
mean_std_columns <- grep("mean|std", names(merged_data), ignore.case = TRUE, value = TRUE)
merged_data_mstd <- merged_data[, c("SubjectID", "ActivityID", mean_std_columns)]

# IMPROVES READABILITY OF THE DATASET
# Replaces ActivityID with the more descriptive ActivityName
md_desc_act <- merge(merged_data_mstd, activity_labels, by = "ActivityID")
md_desc_act_2 <- md_desc_act[, c("SubjectID", "ActivityName", setdiff(names(md_desc_act), c("SubjectID", "ActivityName")))]
md_desc_act_3 <- select(md_desc_act_2, -ActivityID)

# Applies transformations to column names of measurement variables
names(md_desc_act_3) <- gsub("^t", "Time", names(md_desc_act_3))
names(md_desc_act_3) <- gsub("^f", "Frequency", names(md_desc_act_3))
names(md_desc_act_3) <- gsub("Acc", "Acceleration", names(md_desc_act_3))
names(md_desc_act_3) <- gsub("Gyro", "Gyroscope", names(md_desc_act_3))
names(md_desc_act_3) <- gsub("Mag", "Magnitude", names(md_desc_act_3))
names(md_desc_act_3) <- gsub("-mean\\(\\)", "Mean", names(md_desc_act_3), ignore.case = TRUE)
names(md_desc_act_3) <- gsub("-std\\(\\)", "Std", names(md_desc_act_3), ignore.case = TRUE)
names(md_desc_act_3) <- gsub("-", "", names(md_desc_act_3))
names(md_desc_act_3) <- gsub("^a", "A", names(md_desc_act_3))
names(md_desc_act_3) <- gsub("Angle\\.t", "Angle.Time", names(md_desc_act_3))
names(md_desc_act_3) <- gsub("Angle\\.", "Angle", names(md_desc_act_3))
names(md_desc_act_3) <- gsub("\\.gravity", "Gravity", names(md_desc_act_3))
names(md_desc_act_3) <- gsub("gravityMean", "GravityMean", names(md_desc_act_3))
names(md_desc_act_3) <- gsub("\\.$", "", names(md_desc_act_3))

# CREATES TIDY DATASET WITH AVERAGE OF EACH VARIABLE
## Wanted to use melt() and dcast() as the instruction videos but I can't get it to work.

data <- md_desc_act_3
# Calculates the mean for each variable grouped by 'SubjectID' and 'ActivityName'
aggregated_data <- aggregate(. ~ SubjectID + ActivityName, data = data, FUN = function(x) mean(x, na.rm = TRUE))

# SAVES AND VIEWS RESULTS
# Writes the result to a text file
write.table(aggregated_data, file = "tidy_dataset.txt", row.names = FALSE)
