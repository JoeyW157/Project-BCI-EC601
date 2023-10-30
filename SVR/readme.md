files and what they do

## T1_5.m
Aim: Takes a file path, creates a matrix and an array. The columns of the matrix corresponds to the output of each channel. The array contains labels for each sample of the signal. Note that the samples produced here are the same as that of the original ones. It'll have to be converted to our labels

status: completed

## T1_7.m
Aim:
	Read a file
	Make channels out of it
	Find their correlations
	Make heatmap

Notes:
	I haven't labeled the heatmap but I feel it should be intuitive if you know how the table looks

Status: Completed

## T1_8.m
Aim:
	Read file
	Make channels out of it
	Plots containing signals and where each class occur
	Finding average correlations between signals of different classes

Notes:
	The average correlations are rather low. 
	But Nawab addressed that problems saying its because there's too much noise. 
	But I suppose this is something we can present as investigations (failed)

Status: Completed

## T1_11.m
Aim:
	Read the file
	Make channels out of it
	Separate signals based on their class.
	Use a signal strip from each class to calculate welch's spectrum

Note
	The parameters I've used to calculate the welch's spectrum aren't optimal. 
	As of they're just numbers I picked out of my brain. 
	Similarly with the window. The window parameters haven't provided. Currently, its the default. 
	This is just a preliminary analysis. I'll iterate it and make em better. 
Status: Completed 


# T1_13.m
Aim:
	Read downsampled files.
	Separate signals based on their classes
	Calculate welch's spectrum from one particular occurence of each events.
Note: 
	The parameters used to calculate the welch's spectrum aren't the standard ones.
	They're random values I came up with.
	SImilarly with the window. I've implemented them using a chebyshev window. 
	We'll ask the professor about what kind of window to use

Status: Completed


# T1_15.m
Aim:
	Read downsampled files
	Separate signals based on their classes
	Calculate welch's spectrum for each class
	Here, we're reading two files to get all the classes

Note:
	We're considering the baseline in file 2 as a separate class.
Status: completed.
