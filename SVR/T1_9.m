%% Aim: Separating signals based on class but appropriately
%{
The classes available in this code are (all imaginary btw)
1. C0 = Baseline
2. C1 = left fist
3. C2 = right fist
%}

% Basic setup 
clc; close all; clear;

% Reading first file
file_path = "/Users/vrsreeganesh/Desktop/BUClasses/EC601/FinalProjectEC601/Data/files/S001/S001R04.edf";
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

% finding the size 
size(var20)

% correction, in case it is needed
if(size(var20,1)~=size(MatrixContainingAllChannels,1))
    % finding the number of samples we need to fill up
    num_samples_that_needs_filling = size(MatrixContainingAllChannels,1) - size(var20,1);

    % filling up the empty values with the final value
    var20 = [var20;
             repmat(var20(end,1), num_samples_that_needs_filling, 1)];

end

% printing the size
size(var20)

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

% plotting
figure(1);
subplot(3,1,1); plot(var00); hold on; plot(c0_label); legend('baseline'); title("where baseline occurs");
subplot(3,1,2); plot(var00); hold on; plot(c1_label); legend('left fist'); title("where left fist occurs");
subplot(3,1,3); plot(var00); hold on; plot(c2_label); legend('right fist'); title("where right fist occurs");
hold off;

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
c0_signal = buffer(c0_signal, c0_duration); fprintf("size(c0_signal) = [%d,%d] \n", size(c0_signal,1), size(c0_signal,2));
c1_signal = buffer(c1_signal, c1_duration); fprintf("size(c1_signal) = [%d,%d] \n", size(c1_signal,1), size(c1_signal,2));
c2_signal = buffer(c2_signal, c2_duration); fprintf("size(c2_signal) = [%d,%d] \n", size(c2_signal,1), size(c2_signal,2));


%% finding the correlation between themselves

% normalising the columns
c0_signal = c0_signal - mean(c0_signal,1);     % subtracting mean
c0_signal = c0_signal./vecnorm(c0_signal,1);   % dividing by variance
% c0_signal = c0_signal./var(c0_signal);       % dividing by variance

c1_signal = c1_signal - mean(c1_signal, 1); 
c1_signal = c1_signal./vecnorm(c1_signal,1);
% c1_signal = c1_signal./var(c1_signal);

c2_signal = c2_signal - mean(c2_signal,1);
c2_signal = c2_signal./vecnorm(c2_signal,1);
% c2_signal = c2_signal./var(c2_signal);

% finding the heatmap for each signals
c0_self_heatmap = transpose(c0_signal)*c0_signal;
c1_self_heatmap = transpose(c1_signal)*c1_signal;
c2_self_heatmap = transpose(c2_signal)*c2_signal;

figure(2);
subplot(3,1,1); imagesc(c0_self_heatmap); colorbar; title("c0 self correlation");
subplot(3,1,2); imagesc(c1_self_heatmap); colorbar; title("c1 self correlation");
subplot(3,1,3); imagesc(c2_self_heatmap); colorbar; title("c2 self correlation");


%% finding correlation across different channels

%{
    In order to take the correlation between two signals, they must have
    the same length. Since our signals are stored in matrices, we shall
    make sure to trim the dim = 0.
%}

%% Finding correlation between c0 and c1

% trimming signal
numrowsc0c1 = min(size(c0_signal,1), size(c1_signal,1));
var00 = c0_signal(1:numrowsc0c1, :);
var01 = c1_signal(1:numrowsc0c1, :);

% normalising them
var00 = NormalizeMatrix(var00, 0);
var01 = NormalizeMatrix(var01, 0);
corr01 = transpose(var00)*var01;

%% Finding correlation between c0 and c1

% trimming signal
numrowsc0c2 = min(size(c0_signal,1), size(c2_signal,1));
var00 = c0_signal(1:numrowsc0c2, :);
var01 = c2_signal(1:numrowsc0c2, :);

% normalising them
var00 = NormalizeMatrix(var00, 0);
var01 = NormalizeMatrix(var01, 0);
corr02 = transpose(var00)*var01;

%% Finding correlation between c0 and c1

% trimming signal
numrowsc1c2 = min(size(c1_signal,1), size(c2_signal,1));
var00 = c1_signal(1:numrowsc1c2, :);
var01 = c2_signal(1:numrowsc1c2, :);

% normalising them
var00 = NormalizeMatrix(var00, 0);
var01 = NormalizeMatrix(var01, 0);
corr12 = transpose(var00)*var01;


%% Finding the mean and variance of each correlations to see if there are differences

% mean correlation between signals in class 0 and class 1
mean_corr01 = sum(sum(corr01, "omitnan"));
mean_corr01 = mean_corr01/(size(corr01,1)*(size(corr01,2)-1));

% mean correlation betweens signals in class 0 and class 2
mean_corr02 = sum(sum(corr02));
mean_corr02 = mean_corr02/numel(corr02);

% mean correlation between signals in class 1 and class 2
mean_corr12 = sum(sum(corr12, "omitnan"));
mean_corr12 = mean_corr12/((size(corr12,1)-1)*size(corr12,2));

% printing correlations
fprintf("mean_corr01 = %0.5f \n", mean_corr01);
fprintf("mean_corr02 = %0.5f \n", mean_corr02);
fprintf("mean_corr12 = %0.5f \n", mean_corr12);

fprintf("Done \n");





















