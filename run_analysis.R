library(data.table)
library('dplyr')

#Downloading zip archive

zipUrl = "https://d396qusza40orc.cloudfront.net/
getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zipUrl, 'getdata_projectfiles_UCI HAR Dataset.zip')
unzip('getdata_projectfiles_UCI HAR Dataset.zip')


#Reading data

activity_labels = read.table('UCI HAR Dataset/activity_labels.txt',
                             sep = ' ')
features = read.table('UCI HAR Dataset/features.txt',
                      sep = ' ', stringsAsFactors = F)

fnames = c('subject', features[,2], 'activity')
dataset = as.data.frame(setNames(replicate(nrow(features) + 2,
                                           numeric(0), simplify = F),
                                 fnames))

#Reading data(X, y and labels) from train and test folders 
#and merging them together in one data.frame

folders = c('train', 'test')
for (folder in folders) {
    x = fread(paste0('UCI HAR Dataset/', folder,'/X_', folder, '.txt'))
    y = fread(paste0('UCI HAR Dataset/', folder,'/y_', folder, '.txt'))
    l = fread(paste0('UCI HAR Dataset/', folder,'/subject_', folder, '.txt'))
    lxy = cbind(l, x, y)
    names(lxy) = fnames
    dataset = rbind(dataset, as.data.frame(lxy))
}

#Extracting only the measurements on the mean and standard deviation 
#for each measurement

dataset = dataset[, c(1, grep('mean\\(\\)|std\\(\\)', fnames), ncol(dataset))]

#Using descriptive activity names to name the activities in the data set

dataset$activity = activity_labels[dataset$activity, 2]

#Labeling the data set with descriptive variable names. 

fnames1 = gsub('[^A-Za-z]+', '.', names(dataset))
fnames1 = gsub('^t', 'time', fnames1)
fnames1 = gsub('^f', 'frequency', fnames1)
fnames1 = gsub('Acc', 'Accelerometer', fnames1)
fnames1 = gsub('Gyro', 'Gyroscope', fnames1)
fnames1 = gsub('Mag', 'Magnitude', fnames1)
fnames1 = gsub('mean', 'Mean', fnames1)
fnames1 = gsub('std', 'Std', fnames1)
fnames1 = gsub('\\.$', '', fnames1)
fnames1 = gsub('Mean\\.(.){1}', '\\1\\.Mean', fnames1)
fnames1 = gsub('Std\\.(.){1}', '\\1\\.Std', fnames1)
fnames1 = gsub('BodyBody', 'Body', fnames1)
fnames1 = gsub('\\.', '', fnames1)
names(dataset) = fnames1

#Creating a tidy data set with the average of each variable 
#for each activity and each subject

gr = group_by(dataset, subject, activity, add = TRUE)
summary_data = summarize_each(gr, funs(mean))
names(summary_data) = gsub('((Std|Mean)$){1}', 
          '\\1Avg', names(summary_data))

#Saving the second tidy dataset

write.table(summary_data, 'averaged_features.txt', row.names = F, quote = F)


