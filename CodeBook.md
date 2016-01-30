#Course Project CodeBook

##Original dataset

###Source

**Name:** Human Activity Recognition Using Smartphones Dataset

**Data:**
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

**Full description:**
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones> 

###Description

The experiments have been carried out with a group of 30 volunteers. Each person performed six activities: 

* WALKING
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING
* STANDING
* LAYING

,wearing a smartphone (Samsung Galaxy S II) on the waist. Raw signals from embedded accelerometer and gyroscope were captured, pre-processed, sampled in fixed-width sliding windows and then processed using various signal processing techniques.

For each record(window sample) in the dataset it is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope.
* A 561-feature vector with time and frequency domain variables.
* Its activity label.
* An identifier of the subject who carried out the experiment. 

The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

###Files

In this work there were used following files:

* 'README.txt'
* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 


##Data transformations

Downloading original data from the source and unzip it.
As a result, in current working directory appears 'UCI HAR Dataset' folder, containing files, described above.

Reading data from 'activity_labels.txt' into ```activity_labels``` variable
and from 'features.txt' into ```features``` variable using ```read.table``` function.

For checking correctness of reading we can use:
```
> head(activity_labels)
  V1                 V2
1  1            WALKING
2  2   WALKING_UPSTAIRS
3  3 WALKING_DOWNSTAIRS
4  4            SITTING
5  5           STANDING
6  6             LAYING
```

```
> head(features)
  V1                V2
1  1 tBodyAcc-mean()-X
2  2 tBodyAcc-mean()-Y
3  3 tBodyAcc-mean()-Z
4  4  tBodyAcc-std()-X
5  5  tBodyAcc-std()-Y
6  6  tBodyAcc-std()-Z
```


**1. Merges the training and the test sets to create one data set.**

Creating empty data.frame ```dataset``` with column names = ```c('subject', features[,2], 'activity')```, i.e. number of columns in it is equal to 563(1+561+1)

Then reading X, y and subject data from train and test folders and append them to dataset, using ```cbind``` and ```rbind```

As a result, we get 10299 rows (7352 from train and 2947 from test).
```
> dim(dataset)
[1] 10299   563
```

**2. Extracts only the measurements on the mean and standard deviation for each measurement.**

As follows from 'features_info.txt', 'features.txt', we want to extract from dataset only columns, which names contain either 'mean()' or 'std()' 

There were 68(1+66+1) columns, remained in ```dataset```:

```
> names(dataset)
 [1] "subject"                     "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"          
 [4] "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"            "tBodyAcc-std()-Y"           
 [7] "tBodyAcc-std()-Z"            "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
[10] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"         "tGravityAcc-std()-Y"        
[13] "tGravityAcc-std()-Z"         "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"      
[16] "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"        "tBodyAccJerk-std()-Y"       
[19] "tBodyAccJerk-std()-Z"        "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
[22] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"          
[25] "tBodyGyro-std()-Z"           "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"     
[28] "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"       "tBodyGyroJerk-std()-Y"      
[31] "tBodyGyroJerk-std()-Z"       "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
[34] "tGravityAccMag-mean()"       "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"     
[37] "tBodyAccJerkMag-std()"       "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"         
[40] "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"      "fBodyAcc-mean()-X"          
[43] "fBodyAcc-mean()-Y"           "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"           
[46] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"      
[49] "fBodyAccJerk-mean()-Y"       "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
[52] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"        "fBodyGyro-mean()-X"         
[55] "fBodyGyro-mean()-Y"          "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"          
[58] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"           "fBodyAccMag-mean()"         
[61] "fBodyAccMag-std()"           "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"  
[64] "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-mean()"
[67] "fBodyBodyGyroJerkMag-std()"  "activity"  
```

**3. Uses descriptive activity names to name the activities in the data set.**

Replacing ```dataset$activity``` by activity name from ```activity_labels```

After this step activity column becomes factor type.
```
> head(dataset$activity)
[1] STANDING STANDING STANDING STANDING STANDING STANDING
Levels: LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS WALKING_UPSTAIRS
```

**4. Appropriately labels the data set with descriptive variable names.**

Changing names of 66 measurments' features from previous step:

* Replacing all sequences of non alphabetical characters by symbol '.'.
* Replacing start 't' and 'f' symbols by 'time' and 'frequency' (from 'features_info.txt': "prefix 't' to denote time", "Note the 'f' to indicate frequency domain signals".
* Replacing short names 'Acc','Gyro' and 'Mag' by 'Accelerometer', 'Gyroscope' and 'Magnitude' respectively.
* Replacing 'mean' by 'Mean', 'std' by 'Std' and deleting dots at the end of names.
* Changing the order of 'X','Y','Z' and following 'Mean' or 'Std'. (for example, 'Mean.Y' becomes 'Y.Mean')
* Deleting twice repeated word 'Body' in few features' names(i think, it's an error) and deleting all dots '.'.

As a result, we get more meaningful names:
```
> names(dataset)
 [1] "subject"                                     "timeBodyAccelerometerXMean"                 
 [3] "timeBodyAccelerometerYMean"                  "timeBodyAccelerometerZMean"                 
 [5] "timeBodyAccelerometerXStd"                   "timeBodyAccelerometerYStd"                  
 [7] "timeBodyAccelerometerZStd"                   "timeGravityAccelerometerXMean"              
 [9] "timeGravityAccelerometerYMean"               "timeGravityAccelerometerZMean"              
[11] "timeGravityAccelerometerXStd"                "timeGravityAccelerometerYStd"               
[13] "timeGravityAccelerometerZStd"                "timeBodyAccelerometerJerkXMean"             
[15] "timeBodyAccelerometerJerkYMean"              "timeBodyAccelerometerJerkZMean"             
[17] "timeBodyAccelerometerJerkXStd"               "timeBodyAccelerometerJerkYStd"              
[19] "timeBodyAccelerometerJerkZStd"               "timeBodyGyroscopeXMean"                     
[21] "timeBodyGyroscopeYMean"                      "timeBodyGyroscopeZMean"                     
[23] "timeBodyGyroscopeXStd"                       "timeBodyGyroscopeYStd"                      
[25] "timeBodyGyroscopeZStd"                       "timeBodyGyroscopeJerkXMean"                 
[27] "timeBodyGyroscopeJerkYMean"                  "timeBodyGyroscopeJerkZMean"                 
[29] "timeBodyGyroscopeJerkXStd"                   "timeBodyGyroscopeJerkYStd"                  
[31] "timeBodyGyroscopeJerkZStd"                   "timeBodyAccelerometerMagnitudeMean"         
[33] "timeBodyAccelerometerMagnitudeStd"           "timeGravityAccelerometerMagnitudeMean"      
[35] "timeGravityAccelerometerMagnitudeStd"        "timeBodyAccelerometerJerkMagnitudeMean"     
[37] "timeBodyAccelerometerJerkMagnitudeStd"       "timeBodyGyroscopeMagnitudeMean"             
[39] "timeBodyGyroscopeMagnitudeStd"               "timeBodyGyroscopeJerkMagnitudeMean"         
[41] "timeBodyGyroscopeJerkMagnitudeStd"           "frequencyBodyAccelerometerXMean"            
[43] "frequencyBodyAccelerometerYMean"             "frequencyBodyAccelerometerZMean"            
[45] "frequencyBodyAccelerometerXStd"              "frequencyBodyAccelerometerYStd"             
[47] "frequencyBodyAccelerometerZStd"              "frequencyBodyAccelerometerJerkXMean"        
[49] "frequencyBodyAccelerometerJerkYMean"         "frequencyBodyAccelerometerJerkZMean"        
[51] "frequencyBodyAccelerometerJerkXStd"          "frequencyBodyAccelerometerJerkYStd"         
[53] "frequencyBodyAccelerometerJerkZStd"          "frequencyBodyGyroscopeXMean"                
[55] "frequencyBodyGyroscopeYMean"                 "frequencyBodyGyroscopeZMean"                
[57] "frequencyBodyGyroscopeXStd"                  "frequencyBodyGyroscopeYStd"                 
[59] "frequencyBodyGyroscopeZStd"                  "frequencyBodyAccelerometerMagnitudeMean"    
[61] "frequencyBodyAccelerometerMagnitudeStd"      "frequencyBodyAccelerometerJerkMagnitudeMean"
[63] "frequencyBodyAccelerometerJerkMagnitudeStd"  "frequencyBodyGyroscopeMagnitudeMean"        
[65] "frequencyBodyGyroscopeMagnitudeStd"          "frequencyBodyGyroscopeJerkMagnitudeMean"    
[67] "frequencyBodyGyroscopeJerkMagnitudeStd"      "activity"
```

**5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.**

Creating data.frame ```summary_data``` with the average of each variable for each activity and each subject using ```group_by``` and ```summarize_each``` functions.

Also append 'Avg' to all measurment features' names.

We get table with 180 (30 persons * 6 activities) rows and 68 columns:
```
> dim(summary_data)
[1] 180  68
```

Finally saving ```summary_data``` to a file 'averaged_features.txt', using ```write.table```.



