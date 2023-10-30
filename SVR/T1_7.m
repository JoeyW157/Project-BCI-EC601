%% Aim: Basic procedures

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

%% Normalising all the columns

% column wise norms
colnorms = vecnorm(MatrixContainingAllChannels, 2, 1);

% column wise mean
colmeans = mean(MatrixContainingAllChannels, 1);

% subtracting mean and dividing norm
var00 = MatrixContainingAllChannels - colmeans; fprintf("size(var00) = [%d, %d] \n", size(var00,1), size(var00,2));
var00 = var00./colnorms; fprintf("size(var00) = [%d,%d] \n", size(var00,1), size(var00,2));

% plotting just for the sake of it
% figure(1); plot(transpose(var00)); title("Each channels");

%% Finding the pair-wise correlations
CorrMatrix = transpose(var00)*var00;

% plotting the heatmap
figure(2); imagesc(CorrMatrix); colormap("hot"); colorbar;