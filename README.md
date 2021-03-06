# Getting-and-Cleaning-Data
Assignment for Getting and Cleaning Data


Summary:
--------
This code will manipulate the files used in this exercise to create a combined dataset. 
The combined dataset will then be manipulated such that the requirements may be met. 


To Use: 
-------
(1) On line 11 of the code, specify the directory where the files are kept locally. 
(2) Execute all the code


What will happen: 
-----------------
Requirement 1 is met by creating a sister dataset for test and train called combined. 
Each file in test and train are then paired together, opened, merged, and saved in the combined 
directory with the original file name (i.e., not containing the "_test" or "_train" suffix).
These may be verified by checking the directory. 

Requirement 2 is met by opening each of the nine measurement files that were combined in step 1. 
Summation is taken across the nine measurements for average (mean) and standard deviation (sd).
Dataset R2 is provided to meet Requirement 2. 

Requirement 3 is met by joining the activity description (walking, standing, etc. on to the y 
dataset. As the order of y dataset is not disturbed by this operation, subsequent joins using
the resulting dataset (R3) will include the English description of the subject's activity. 
The R3 dataset is used downstream as part of Requirement 5. 

Requirement 4 is met using the colnames() function and the 561 element feature.txt file. The 
resulting dataset is presented as R4. 

Requirement 5 is met by binding R3 and R4 together, creating a tidy dataset which allows for
eay reporting across the 30 Subjects, 6 Activities, and 561 named feature measurements. 

Data Dictionary:
----------------
Req      |Variable  |Description
---------|----------|------------
R2|measurement|the 128 element vector measurement taken in the 9 measurement files. 
R2|mean|the average of the measurement, summarized at measure file level. 
R2|sd|the standard deviation of the measurement, summarized at the measure file level.
R3|subject|the subject id (domain is 1-30, each corresponding to one of the 30 subjects)
R3|activity|the activity being performed (domain is WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING )
R4||The 561 columns shown in R4 may be traced to the features file, which was included in the package. 
R5||The columns shown in R5 are inherited from R4 and R3.
