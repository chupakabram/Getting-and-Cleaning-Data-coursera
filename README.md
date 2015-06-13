# Getting-and-Cleaning-Data-coursera
**Storage for course project script, data and documents, course "Getting and Cleaning Data", coursera.org, June 2015**

+ download the 'run_analysis.R' script and run it using your R
+ files 'FinalDataSet_MeanValues.csv' and 'FinalDataSet_MeanValues.txt' contain results of the script's activity (the same data in different formats)
+ document 'CodeBook.md' contains of comments to the script

**Final data summary:**
* Data contains 6 rows and 80 columns
* First column contains the activity name
* Other columns contain mean value of the accelerometer and gyroscope 3-axial value for each type of activity
* Prefix 't' means the measurement in time domain
* Prefix 'f' means the measurement in frequency domain (time domain after FFT transformation)
* For instance : cell's (1,1) value is 0.279153494050367, it corresponds to activity "STANDING" and to measurement "tBodyAcc-mean()-X" - mean value of the body accelerometer in the direction X
