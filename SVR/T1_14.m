%% Aim: FFT method of paper

% Basic setup 
clc; close all; clear;

% Reading first file
file_path = "/Users/vrsreeganesh/Desktop/BUClasses/EC601/FinalProjectEC601/Data/S001_C1C2_125hz.csv";
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
 
%% Welch's spectrum for class 0
%{
    Reference: https://www.hindawi.com/journals/isrn/2014/730218/
%}

% Choosing one strip
strip = sum(c0_signal,2); 
strip = strip - mean(strip);
fprintf("length(strip) = %d \n", length(strip));

% choosing subsets of the signal
windowlength = 180;
windowstride = 150; % the difference between starting points of signals made from thisi
overlapbetweensignals = windowlength - windowstride;
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
fprintf("size(wpsmatrix) = [%d,%d] \n", size(wpsmatrix,1), size(wpsmatrix,2));

% setting up x axis
zerototwopi = linspace(0, 2*pi, length(wpsmatrix));

% Plotting welch spectrum
figure(1); subplot(3,1,1); plot(zerototwopi, wpsmatrix, 'LineWidth', 2); title("Welch's spectrum for class 0")

%% Parameters for welch's spectrum
% windowlength = 512;

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
windowlength = 180; % length of the window
windowstride = 150; % the difference between starting points of signals made from thisi
overlapbetweensignals = windowlength - windowstride; 
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
windowlength = 180;
windowstride = 150; % the difference between starting points of signals made from thisi
overlapbetweensignals = windowlength - windowstride;
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
figure(1); subplot(3,1,3); plot(zerototwopi, wpsmatrix, 'LineWidth', 2); title("Welch's spectrum for class 2")
