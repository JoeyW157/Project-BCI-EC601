

% Basic setup 
clc; close all; clear;

%% This filter reorganized the recording for participant S001 into 4 csv files:
%  - S001_C1C2_datamatrix.csv   {contains test R04,08,12; in shape (60000,65) with label on last column}
%  - S001_C3C4_datamatrix.csv   {contains test R06,10,14; in shape (60000,65) with label on last column}
%  - S001_eyeclose_C0.csv       {contains test R02; in shape (9760,65) with label on last column}
%  - S001_eyeopen_C0.csv        {contains test R01; in shape (9760,65) with label on last column}



% ToDO: R01,R02: rm DC, sampling down

[datamatrix_R01, labelmatrix_R01] = data_reorganize("S001R01.edf");
datamatrix_R01 = [datamatrix_R01,labelmatrix_R01]; % this matrix will have shape 9760 * 65
writematrix(datamatrix_R01,"/projectnb/ece601/A2_EEGbased_BCI/S001_clean/S001_eyeopen_C0.csv");

[datamatrix_R02, labelmatrix_R02] = data_reorganize("S001R02.edf");
datamatrix_R02 = [datamatrix_R02,labelmatrix_R02]; % this matrix will have shape 9760 * 65
writematrix(datamatrix_R02,"/projectnb/ece601/A2_EEGbased_BCI/S001_clean/S001_eyeclose_C0.csv");



% ToDO: R04,08,12: rm DC, sampling down, T1 -> C1; T2 -> C2

[datamatrix_R04,labelmatrix_R04] = data_reorganize("S001R04.edf");
[datamatrix_R08,labelmatrix_R08] = data_reorganize("S001R08.edf");
[datamatrix_R12,labelmatrix_R12] = data_reorganize("S001R12.edf");

% concatenate matrices, put the label column after the 64-channel columns
datamatrix_R04 = [datamatrix_R04,labelmatrix_R04];
datamatrix_R08 = [datamatrix_R08,labelmatrix_R08];
datamatrix_R12 = [datamatrix_R12,labelmatrix_R12];

S001_C1C2 = [datamatrix_R04;datamatrix_R08;datamatrix_R12]; % has shape 60000*65

writematrix(S001_C1C2,"/projectnb/ece601/A2_EEGbased_BCI/S001_clean/S001_C1C2_datamatrix.csv");

% ToDO: R06,10,14: rm DC, sampling down, T1 -> C3; T2 -> C4

[datamatrix_R06,labelmatrix_R06] = data_reorganize("S001R06.edf");
[datamatrix_R10,labelmatrix_R10] = data_reorganize("S001R10.edf");
[datamatrix_R14,labelmatrix_R14] = data_reorganize("S001R14.edf");

% concatenate matrices, put the label column after the 64-channel columns
datamatrix_R06 = [datamatrix_R06,labelmatrix_R06];
datamatrix_R10 = [datamatrix_R10,labelmatrix_R10];
datamatrix_R14 = [datamatrix_R14,labelmatrix_R14];

S001_C3C4 = [datamatrix_R06;datamatrix_R10;datamatrix_R14];% has shape 60000*65

writematrix(S001_C3C4,"/projectnb/ece601/A2_EEGbased_BCI/S001_clean/S001_C3C4_datamatrix.csv");
