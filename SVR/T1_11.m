%% Aim: FFT method of paper

% Basic setup 
clc; close all; clear;

% Reading first file
file_path = "/projectnb/ece601/A2_EEGbased_BCI/S001/S001R04.edf";
[tt, annotations] = edfread(file_path);

%% Reading events
labels = annotations{:,1}; % getting the labels
times = annotations{:,2}; % getting the annotations
times = seconds(times); % typecasting to make it double

% preparing variables
var30 = []; % to store the concatenated output of each channel
var31 = []; % to store all channel outputs in a single matrix

% Loop through the whole set of channels
for channel_index = 1:size(tt,2)

    var30 = []; % emptying befor each start

    % looping through each time step
    for time_index = 1:size(tt,1)
        
        % extracting the channel
        var00 = tt(time_index,channel_index); % fetching channel and duration
        var01 = var00{1,1};
        var02 = var01{:,1}; % the output of i-th channel at j-th time duration

        % appending to object representing channel output (axis = 0)
        var30 = [var30; var02];
    end

    % appending to larger output (axis = 1)
    var31 = [var31, var30];
end

% renaming for sanity
MatrixContainingAllChannels = var31;


%% SampleLevel labelling

% the final array that contains the label
var20 = [];

% filling it up 
for i=1:size(labels,1)
    var20 = [var20;
             repmat(labels(i,1), 160*times(i,1),1)];
end

% correction, in case it is needed
if(size(var20,1)~=size(MatrixContainingAllChannels,1))
    % finding the number of samples we need to fill up
    num_samples_that_needs_filling = size(MatrixContainingAllChannels,1) - size(var20,1);

    % filling up the empty values with the final value
    var20 = [var20;
             repmat(var20(end,1), num_samples_that_needs_filling, 1)];

end

% renaming for sanity
SampleLevelLabels = var20;

%% Changing the SampleLevelLabels

% getting the run number (the experiment run)
file_path = convertStringsToChars(file_path);
file_num = str2double(file_path(end-5:end-4));

% rules for file_num == 4
if file_num==4
    
    % converting label T0 to C0
    SampleLevelLabels(SampleLevelLabels=="T0") = "C0";

    % Converting label T1 to C1
    SampleLevelLabels(SampleLevelLabels=="T1") = "C1";
    
    % Converting label to T2 to C2
    SampleLevelLabels(SampleLevelLabels=="T2") = "C2";

end


%% separating them 

% the electrode from which we'll be taking the signal
var00 = MatrixContainingAllChannels(:,5);

% making an array for each label to indicate int he signal where they are
c0_label = zeros(size(var00)); c0_label(SampleLevelLabels == "C0") = max(var00);
c1_label = zeros(size(var00)); c1_label(SampleLevelLabels == "C1") = max(var00);
c2_label = zeros(size(var00)); c2_label(SampleLevelLabels == "C2") = max(var00);


%% separating signals by just taking continuous intervals
c0_signal = var00(SampleLevelLabels == "C0");
c1_signal = var00(SampleLevelLabels == "C1");
c2_signal = var00(SampleLevelLabels == "C2");

% the class durations
fs = 160;               % sampling frequency
c0_duration = 4.2*fs;
c1_duration = 4.1*fs;
c2_duration = 4.1*fs;

% splitting them to form matrices
c0_signal = buffer(c0_signal, c0_duration); %fprintf("size(c0_signal) = [%d,%d] \n", size(c0_signal,1), size(c0_signal,2));
c1_signal = buffer(c1_signal, c1_duration); %fprintf("size(c1_signal) = [%d,%d] \n", size(c1_signal,1), size(c1_signal,2));
c2_signal = buffer(c2_signal, c2_duration); %fprintf("size(c2_signal) = [%d,%d] \n", size(c2_signal,1), size(c2_signal,2));


%% setup for using welch's spectrum


%% Welch's spectrum for class 0
%{
    Reference: https://www.hindawi.com/journals/isrn/2014/730218/
%}

% Choosing one strip
strip = c0_signal(:,1);
fprintf("length(strip) = %d \n", length(strip));

% choosing subsets of the signal
lengthofsubstrip = 180;
D = 150; % the difference between starting points of signals made from thisi
p = lengthofsubstrip - D;
stripmatrix = buffer(strip, lengthofsubstrip, p);
fprintf("size(stripmatrix) = [%d,%d] \n", size(stripmatrix,1), size(stripmatrix,2));

% choosing the window
% sticking to uniform box for now
window0 = ones([size(stripmatrix,1), 1]); % uniform window
window0 = chebwin(size(stripmatrix,1));
uvalue = (vecnorm(window0)^2)/length(window0);

% multiply each column with the window
stripmatrix = stripmatrix.*repmat(window0, [1, size(stripmatrix,2)]);

% taking the fft
stripmatrixfft = fft(stripmatrix);

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

%% Welch's spectrum for class 1
%{
    Reference: https://www.hindawi.com/journals/isrn/2014/730218/
%}

% Choosing one strip
strip = c1_signal(:,1);
fprintf("length(strip) = %d \n", length(strip));

% choosing subsets of the signal
lengthofsubstrip = 180;
D = 150; % the difference between starting points of signals made from thisi
p = lengthofsubstrip - D;
stripmatrix = buffer(strip, lengthofsubstrip, p);
fprintf("size(stripmatrix) = [%d,%d] \n", size(stripmatrix,1), size(stripmatrix,2));

% choosing the window
% sticking to uniform box for now
window0 = ones([size(stripmatrix,1), 1]);
window0 = chebwin(size(stripmatrix,1));
uvalue = (vecnorm(window0)^2)/length(window0);

% multiply each column with the window
stripmatrix = stripmatrix.*repmat(window0, [1, size(stripmatrix,2)]);

% taking the fft
stripmatrixfft = fft(stripmatrix);

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
strip = c2_signal(:,1);
fprintf("length(strip) = %d \n", length(strip));

% choosing subsets of the signal
lengthofsubstrip = 180;
D = 150; % the difference between starting points of signals made from thisi
p = lengthofsubstrip - D;
stripmatrix = buffer(strip, lengthofsubstrip, p);
fprintf("size(stripmatrix) = [%d,%d] \n", size(stripmatrix,1), size(stripmatrix,2));

% choosing the window
% sticking to uniform box for now
window0 = ones([size(stripmatrix,1), 1]);
window0 = chebwin(size(stripmatrix,1));
uvalue = (vecnorm(window0)^2)/length(window0);

% multiply each column with the window
stripmatrix = stripmatrix.*repmat(window0, [1, size(stripmatrix,2)]);

% taking the fft
stripmatrixfft = fft(stripmatrix);

% taking the absolute of the value
stripmatrixfftabs = abs(stripmatrixfft);

% dividing the matrix with both the U value and the M value
stripmatrixfftabs = stripmatrixfftabs/(uvalue*length(window0));

% finding welch's power spectrum
wpsmatrix = sum(stripmatrixfftabs, 2);
figure(1); subplot(3,1,3); plot(zerototwopi, wpsmatrix, 'LineWidth', 2); title("Welch's spectrum for class 2")
















