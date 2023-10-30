%% Aim: FFT method of paper

% Basic setup 
clc; close all; clear;

% Reading first file
file_path = "projectnb/ece601/A2_EEGbased_BCI/S001_clean/S001_C1C2_125hz.csv";
MatrixContainingAllChannels = csvread(file_path);

%% separating signals by just taking continuous intervals

% Getting the labels
SampleLevelLabels = MatrixContainingAllChannels(:, end);
availablelabels = unique(SampleLevelLabels);

% Taking a channel out
var00 = MatrixContainingAllChannels(:, 10);

% Here, we take a channel and separate the signals based on their class
% onto large arrays. 
c0_signal = var00(SampleLevelLabels == 0);
c1_signal = var00(SampleLevelLabels == 1);
c2_signal = var00(SampleLevelLabels == 2); 

% the class durations
fs = 125; % sampling frequency               
c0_duration = floor(4.2*fs); % the number of samples for each duration
c1_duration = floor(4.1*fs); % the number of samples for each duration
c2_duration = floor(4.1*fs); % the number of samples for each duration

% Splitting the large arrays into a matrix where each column represents the
% signals occuring at different times. 
c0_signal = buffer(c0_signal, c0_duration); %fprintf("size(c0_signal) = [%d,%d] \n", size(c0_signal,1), size(c0_signal,2));
c1_signal = buffer(c1_signal, c1_duration); %fprintf("size(c1_signal) = [%d,%d] \n", size(c1_signal,1), size(c1_signal,2));
c2_signal = buffer(c2_signal, c2_duration); %fprintf("size(c2_signal) = [%d,%d] \n", size(c2_signal,1), size(c2_signal,2));

% removing the mean from all the columns
c0_signal = c0_signal - mean(c0_signal, 1);
c1_signal = c1_signal - mean(c1_signal, 1);
c2_signal = c2_signal - mean(c2_signal, 1);
 
%% Parameters for calculating welch's window
windowlength = 180;
windowstride = 150;
overlapbetweensignals = windowlength - windowstride;

wpsmatrixforallclass = [];

%% Welch's spectrum for class 0
%{
    Reference: https://www.hindawi.com/journals/isrn/2014/730218/
%}

% Choosing one strip
strip = sum(c0_signal,2); 
strip = strip - mean(strip);
fprintf("length(strip) = %d \n", length(strip));

% choosing subsets of the signal
stripmatrix = buffer(strip, windowlength, overlapbetweensignals);
fprintf("size(stripmatrix) = [%d,%d] \n", size(stripmatrix,1), size(stripmatrix,2));

% choosing the window
% sticking to uniform box for now
window0 = ones([size(stripmatrix,1), 1]); % uniform window
window0 = chebwin(size(stripmatrix,1));
uvalue = (vecnorm(window0)^2)/length(window0);

% multiply each column with the window
stripmatrix = stripmatrix.*repmat(window0, [1, size(stripmatrix,2)]);

% taking the fft
stripmatrixfft = fft(stripmatrix, 1024);

% taking the absolute of the value
stripmatrixfftabs = abs(stripmatrixfft);

% dividing the matrix with both the U value and the M value
stripmatrixfftabs = stripmatrixfftabs/(uvalue*length(window0));

% finding welch's power spectrum
wpsmatrix = sum(stripmatrixfftabs, 2);
wpsmatrixforallclass = [wpsmatrixforallclass, wpsmatrix];
fprintf("size(wpsmatrix) = [%d,%d] \n", size(wpsmatrix,1), size(wpsmatrix,2));

% setting up x axis
zerototwopi = linspace(0, 2*pi, length(wpsmatrix));

% Plotting welch spectrum
figure(1); subplot(3,1,1); plot(zerototwopi, wpsmatrix, 'LineWidth', 2); title("Welch's spectrum for class 0")

%% Welch's spectrum for class 1
%{
    Reference: https://www.hindawi.com/journals/isrn/2014/730218/
%}

% Choosing one strip
strip = sum(c1_signal,2);

% removing the DC component
strip = strip - mean(strip);
fprintf("length(strip) = %d \n", length(strip));

% choosing subsets of the signal
stripmatrix = buffer(strip, windowlength, overlapbetweensignals);
fprintf("size(stripmatrix) = [%d,%d] \n", size(stripmatrix,1), size(stripmatrix,2));

% choosing the window
% sticking to uniform box for now
window0 = ones([windowlength, 1]);
window0 = chebwin(windowlength);
uvalue = (vecnorm(window0)^2)/length(window0);

% multiply each column with the window
stripmatrix = stripmatrix.*repmat(window0, [1, size(stripmatrix,2)]);

% taking the fft
stripmatrixfft = fft(stripmatrix, 1024);

% taking the absolute of the value
stripmatrixfftabs = abs(stripmatrixfft);

% dividing the matrix with both the U value and the M value
stripmatrixfftabs = stripmatrixfftabs/(uvalue*length(window0));

% finding welch's power spectrum
wpsmatrix = sum(stripmatrixfftabs, 2);
wpsmatrixforallclass = [wpsmatrixforallclass, wpsmatrix];
fprintf("size(wpsmatrix) = [%d,%d] \n", size(wpsmatrix,1), size(wpsmatrix,2));

% Plotting welch spectrum
figure(1); subplot(3,1,2); plot(zerototwopi, wpsmatrix, 'LineWidth', 2); title("Welch's spectrum for class 1")

%% Welch's spectrum for class 2
%{
    Reference: https://www.hindawi.com/journals/isrn/2014/730218/
%}

% Choosing one strip
strip = sum(c2_signal,2); 

% removing DC component by subtracting mean
strip = strip - mean(strip);
fprintf("length(strip) = %d \n", length(strip));

% choosing subsets of the signal
stripmatrix = buffer(strip, windowlength, overlapbetweensignals);
fprintf("size(stripmatrix) = [%d,%d] \n", size(stripmatrix,1), size(stripmatrix,2));

% choosing the window
% sticking to uniform box for now
window0 = ones([windowlength, 1]);
window0 = chebwin(windowlength);
uvalue = (vecnorm(window0)^2)/length(window0);

% multiply each column with the window
stripmatrix = stripmatrix.*repmat(window0, [1, size(stripmatrix,2)]);

% taking the fft
stripmatrixfft = fft(stripmatrix, 1024);

% taking the absolute of the value
stripmatrixfftabs = abs(stripmatrixfft);

% dividing the matrix with both the U value and the M value
stripmatrixfftabs = stripmatrixfftabs/(uvalue*length(window0));

% finding welch's power spectrum
wpsmatrix = sum(stripmatrixfftabs, 2);
wpsmatrixforallclass = [wpsmatrixforallclass, wpsmatrix];
figure(1); subplot(3,1,3); plot(zerototwopi, wpsmatrix, 'LineWidth', 2); title("Welch's spectrum for class 2")

%% reading second file
% Reading first file
file_path = "/Users/vrsreeganesh/Desktop/BUClasses/EC601/FinalProjectEC601/Data/S001_C3C4_125hz.csv";
MatrixContainingAllChannels = csvread(file_path);

%% separating signals by just taking continuous intervals

% Getting the labels
SampleLevelLabels = MatrixContainingAllChannels(:, end);
SampleLevelLabels(SampleLevelLabels==1) = 0;
SampleLevelLabels(SampleLevelLabels==2) = 0;
MatrixContainingAllChannels(:,end) = SampleLevelLabels;


availablelabels = unique(SampleLevelLabels);

% Taking a channel out
var00 = MatrixContainingAllChannels(:, 10);

% Here, we take a channel and separate the signals based on their class
% onto large arrays. 
c0_signal = var00(SampleLevelLabels == 0);
c3_signal = var00(SampleLevelLabels == 3);
c4_signal = var00(SampleLevelLabels == 4); 

% the class durations
fs = 125; % sampling frequency               
c0_duration = floor(4.2*fs); % the number of samples for each duration
c3_duration = floor(4.1*fs); % the number of samples for each duration
c4_duration = floor(4.1*fs); % the number of samples for each duration

% Splitting the large arrays into a matrix where each column represents the
% signals occuring at different times. 
c0_signal = buffer(c0_signal, c0_duration); %fprintf("size(c0_signal) = [%d,%d] \n", size(c0_signal,1), size(c0_signal,2));
c3_signal = buffer(c3_signal, c3_duration); %fprintf("size(c1_signal) = [%d,%d] \n", size(c1_signal,1), size(c1_signal,2));
c4_signal = buffer(c4_signal, c4_duration); %fprintf("size(c2_signal) = [%d,%d] \n", size(c2_signal,1), size(c2_signal,2));

% removing the mean from all the columns
c0_signal = c0_signal - mean(c0_signal, 1);
c3_signal = c3_signal - mean(c3_signal, 1);
c4_signal = c4_signal - mean(c4_signal, 1);
 

%% Welch's spectrum for class 0
%{
    Reference: https://www.hindawi.com/journals/isrn/2014/730218/
%}

% Choosing one strip
strip = sum(c0_signal,2); 
strip = strip - mean(strip);
fprintf("length(strip) = %d \n", length(strip));

% choosing subsets of the signal
stripmatrix = buffer(strip, windowlength, overlapbetweensignals);
fprintf("size(stripmatrix) = [%d,%d] \n", size(stripmatrix,1), size(stripmatrix,2));

% choosing the window
% sticking to uniform box for now
window0 = ones([size(stripmatrix,1), 1]); % uniform window
window0 = chebwin(size(stripmatrix,1));
uvalue = (vecnorm(window0)^2)/length(window0);

% multiply each column with the window
stripmatrix = stripmatrix.*repmat(window0, [1, size(stripmatrix,2)]);

% taking the fft
stripmatrixfft = fft(stripmatrix, 1024);

% taking the absolute of the value
stripmatrixfftabs = abs(stripmatrixfft);

% dividing the matrix with both the U value and the M value
stripmatrixfftabs = stripmatrixfftabs/(uvalue*length(window0));

% finding welch's power spectrum
wpsmatrix = sum(stripmatrixfftabs, 2);
wpsmatrixforallclass = [wpsmatrixforallclass, wpsmatrix];
fprintf("size(wpsmatrix) = [%d,%d] \n", size(wpsmatrix,1), size(wpsmatrix,2));

% setting up x axis
zerototwopi = linspace(0, 2*pi, length(wpsmatrix));

%% Welch's spectrum for class 1
%{
    Reference: https://www.hindawi.com/journals/isrn/2014/730218/
%}

% Choosing one strip
strip = sum(c3_signal,2);

% removing the DC component
strip = strip - mean(strip);
fprintf("length(strip) = %d \n", length(strip));

% choosing subsets of the signal
stripmatrix = buffer(strip, windowlength, overlapbetweensignals);
fprintf("size(stripmatrix) = [%d,%d] \n", size(stripmatrix,1), size(stripmatrix,2));

% choosing the window
% sticking to uniform box for now
window0 = ones([windowlength, 1]);
window0 = chebwin(windowlength);
uvalue = (vecnorm(window0)^2)/length(window0);

% multiply each column with the window
stripmatrix = stripmatrix.*repmat(window0, [1, size(stripmatrix,2)]);

% taking the fft
stripmatrixfft = fft(stripmatrix, 1024);

% taking the absolute of the value
stripmatrixfftabs = abs(stripmatrixfft);

% dividing the matrix with both the U value and the M value
stripmatrixfftabs = stripmatrixfftabs/(uvalue*length(window0));

% finding welch's power spectrum
wpsmatrix = sum(stripmatrixfftabs, 2);
wpsmatrixforallclass = [wpsmatrixforallclass, wpsmatrix];
fprintf("size(wpsmatrix) = [%d,%d] \n", size(wpsmatrix,1), size(wpsmatrix,2));

%% Welch's spectrum for class 2
%{
    Reference: https://www.hindawi.com/journals/isrn/2014/730218/
%}

% Choosing one strip
strip = sum(c4_signal,2); 

% removing DC component by subtracting mean
strip = strip - mean(strip);
fprintf("length(strip) = %d \n", length(strip));

% choosing subsets of the signal
stripmatrix = buffer(strip, windowlength, overlapbetweensignals);
fprintf("size(stripmatrix) = [%d,%d] \n", size(stripmatrix,1), size(stripmatrix,2));

% choosing the window
% sticking to uniform box for now
window0 = ones([windowlength, 1]);
window0 = chebwin(windowlength);
uvalue = (vecnorm(window0)^2)/length(window0);

% multiply each column with the window
stripmatrix = stripmatrix.*repmat(window0, [1, size(stripmatrix,2)]);

% taking the fft
stripmatrixfft = fft(stripmatrix, 1024);

% taking the absolute of the value
stripmatrixfftabs = abs(stripmatrixfft);

% dividing the matrix with both the U value and the M value
stripmatrixfftabs = stripmatrixfftabs/(uvalue*length(window0));

% finding welch's power spectrum
wpsmatrix = sum(stripmatrixfftabs, 2);
wpsmatrixforallclass = [wpsmatrixforallclass, wpsmatrix];


%% plotting everything

figure(1);
subplot(6,1,1); plot(wpsmatrixforallclass(:,1), 'LineWidth', 1.2); title("class 0 file 1");
subplot(6,1,2); plot(wpsmatrixforallclass(:,2), 'LineWidth', 1.2); title("class 1 file 1");
subplot(6,1,3); plot(wpsmatrixforallclass(:,3), 'LineWidth', 1.2); title("class 2 file 1");
subplot(6,1,4); plot(wpsmatrixforallclass(:,4), 'LineWidth', 1.2); title("class 0 file 2");
subplot(6,1,5); plot(wpsmatrixforallclass(:,5), 'LineWidth', 1.2); title("class 3 file 2");
subplot(6,1,6); plot(wpsmatrixforallclass(:,6), 'LineWidth', 1.2); title("class 4 file 2");