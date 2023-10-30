%% Aim: Trying to create a matrix where each channel is a column

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







