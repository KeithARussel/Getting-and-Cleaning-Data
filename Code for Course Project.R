#---
#  title: 'Getting And Cleaning Data Assignment #1'
#author: "Keith Russel"
#date: "September 27, 2016"
#output: html_document
#---

# -----------------------------------------------------
# Enter the location of the Samsung Files here
# root <- "C:/Users/Admin/Desktop/Coursera/Datasets/HAR Dataset/UCI HAR Dataset"
root <- "C:/Users/Admin/Desktop/Coursera/Assignments/C - Getting and Cleaning Data/UCI HAR Dataset"
# ------------------------------------------------------

# No additional user input is required...  

library(plyr)
library(dplyr)
library(reshape2)

## Requirements

#R1

# "Merges the training and the test sets to create one data set."

# Met by opening individual components of both dataset and combining. 
#Fun dataset facts:
  
#  - Each dataset is contained in a directory. 
#- At the main level of the directory, there are three files (subject_train, X_train, and y_train) and the "Inertial Signals" sub-directory.
#- The "Intertial Signals" sub-directory contains 9 files.

#So 2 datasets X (3 files + 9 files) = 24 separate open commands. Too many. 

#Instead:
  
#   1. At the "same"UCI HAR Dataset"" directory level, create a sister directory to "test" and "train" called "combined" 
#   2. Point to one of the directories and generate a list of its contents. Include the sub-directories. Call this list A.
#   3. Point to the other directory and generate a list of its contents. Include the sub-directories. Call this list B.
#   4. Loop through each item on list A, comparing it to each item on list B.
#   5. When A and B match: (a) open both files (b) merge contents (c) write results to directory "combined"

combined <- paste(root, "combined", sep = "/")
test <- paste(root, "test", sep = "/")                  
train <- paste(root, "train", sep = "/")

dir.create(combined)

# setwd("C:/Users/Admin/Desktop/Coursera/Datasets/HAR Dataset/UCI HAR Dataset/train")
A <- dir(train, pattern = "*.txt$", full.names = TRUE, recursive = TRUE)

#setwd("C:/Users/Admin/Desktop/Coursera/Datasets/HAR Dataset/UCI HAR Dataset/test")
B <- dir(test, pattern = "*.txt$", full.names = TRUE, recursive = TRUE)

for (a in 1 :length(A)) {
  for (b in 1:length(B)) {
    f1 <- substr(basename(A[a]), 1, nchar(basename(A[a])) - 10)
    f2 <- substr(basename(B[b]), 1, nchar(basename(B[b])) - 9)
    
    if(f1 == f2) {
      S1 <- read.table(A[a])
      S2 <- read.table(B[b])
      S3 <- bind_rows(S1, S2)
      setwd(combined)
      write.table(S3, file = f1)
      
    }
    
  }
  
}

rm(S1, S2, S3, A, a, B, b, f1, f2)


#R2 "Extracts only the measurements on the mean and standard deviation for each measurement."

#It is assumed that this is referring to the individual vector measurements.  There are nine files (body, gyro, and total) which contain the 128 element vector requested.  The other files (X, y, and subject) contain either the dimensional information or can't be aggregated. 

#1. Within the combined directory, get the proper files.  All 9 of the files have a name that longer than 7 characters.
#2. Open the file, then append both the file name and the contents to a collector dataset. 
#3. Melt the Collector dataset
#4. Apply the summarize function. 


setwd("C:/Users/Admin/Desktop/Coursera/Datasets/HAR Dataset/UCI HAR Dataset/combined")
Z <- dir(getwd(), full.names = TRUE)
Z <- Z[nchar(basename(Z))>7]

collector <- read.table(Z[1])
collector <- mutate(collector, measurement = basename(Z[1]))

for (x in 2:length(Z)) {
nextdata <- read.table(Z[x])
nextdata <- mutate(nextdata, measurement =  basename(Z[x]))
collector <- bind_rows(collector, nextdata)

}

summary <- melt(collector, varnames = 1:128)
summary <- summarize(group_by(summary, measurement), mean = mean(value), sd = sd(value))
R2 <- summary
rm(Z, collector, nextdata, x, summary)


#R3 "Uses descriptive activity names to name the activities in the data set"

# Calling the unique of y$V1, there are six levels shown on in signal.  
# This is assumed to tie to the six activities shown in the activity labels dimension table. 
# This is a straight join using the numeric key (1-6). 
# The subjectsactivity dataset contains the subject's id (1-30) and the 
# actitiy being performed (walking, standing, etc.)  

setwd(root)
activity_labels <- read.table("activity_labels.txt", quote="\"", comment.char="")
features <- read.table("features.txt", quote="\"", comment.char="")

setwd(combined)
subject <- read.table("subject", sep="")
subject <- rename(subject, subject = V1)
X <- read.table("X", sep="")
y <- read.table("y", sep="")

subjectsactivity <- inner_join(activity_labels, y, by = "V1")
subjectsactivity <- select(subjectsactivity, activity = V2)
subjectsactivity <- bind_cols(subject, subjectsactivity)
R3 <- subjectsactivity
rm(subject)

#R4 "Appropriately labels the data set with descriptive variable names"

# Met by applying the 561 item long list "features.txt" to the column names of each of the 
# columns in the X dataset.  To preserve the integrity of the original X dataset, a copy, X1, is used instead.

X1 <- X
colnames(X1) <- features$V2
R4 <- X1

#R5 "From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject."

#From CRAN: 
#  In tidy data:
#  * Each variable forms a column.
#  * Each observation forms a row.
#  * Each type of observational unit forms a table.

# Which makes for one really wide table (combinations of the 561 variables from X and the six activites) 
# with 30 rows. Ouch!  Author also wishes to note that some of these variables should not be aggregated 
# in this manner. Anyhow, here we go! 
subjectsactivity <- R3

X2 <- bind_cols(subjectsactivity, X1)
X3 <- melt(X2, id.vars = c("subject", "activity"))
R5 <- tbl_df(with(X3, tapply(value, list(subject, activity, variable), mean)))
output <- paste(root, "Tidy_Data.txt", sep = "/")
write.table(R5, output, row.name=FALSE)
rm(X, X2, X3)
rm(activity_labels, features, X1, y, subjectsactivity)

