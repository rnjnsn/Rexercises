This R script tidies up the Human Activity Recognition Using Smartphones Dataset by calculating the mean of each variable for each subject across different activities.

# Procedure

1. **Load Required Libraries**: 
   The script starts by loading the dplyr library.

2. **Set Working Directory and Load Data**:
   - Sets the working directory to the folder containing the dataset.
   - Loads the features and activity labels.

3. **Load and Merge Training and Test Data**:
   - Loads the training and test data separately.
   - Merges the training and test sets to create one data set.

4. **Extract Mean and Standard Deviation Measurements**:
   - Extracts only the measurements on the mean and standard deviation for each measurement.

5. **Improve Readability of the Dataset**:
   - Uses descriptive activity names to name the activities in the data set.
   - Removes the ActivityID column as it's no longer needed.

6. **Rename Variables for Better Descriptiveness**:
   - Appropriately labels the data set with descriptive variable names.
   - Applies a series of transformations to clean up and clarify variable names.

7. **Create Tidy Dataset with Average of Each Variable**:
   - Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

8. **Save Results**:
   - Writes the resulting tidy dataset to a text file named "tidy_dataset.txt".

## Output

The result of the script is a text file named "tidy_dataset.txt" in the working directory, containing the dataset with the mean of each variable by subject and activity
