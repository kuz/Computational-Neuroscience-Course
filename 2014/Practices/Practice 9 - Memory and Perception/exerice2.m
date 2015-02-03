%
% Introduction to Computational Neuroscience
% Session 9: Memory and Perception
% Exercise 2: Statistical significance
%

%% Load the data
load data/deg1.mat
load data/deg2.mat


%% Plot average activity
% Each figure has 72 * 33 = 2376 boxes: (frequncy, time)-pairs
% each box is averaged over 79 (77) trials

% tell Matlab that we are going to put two picture on the same figure
subplot(1, 2, 1)

% compute average over trials for deg1 condition
deg1_average = mean(deg1, 1);

% drop extra dimension from the resuling matrix
deg1_average = squeeze(deg1_average);

% compute baseline as average for each frequency inside
% time window -400 to -100 ms
baseline = mean(deg1_average(:, 9:15), 2);

% divide each row of the matrix by the corresponding baseline value
deg1_baseline = bsxfun(@rdivide, deg1_average, baseline);

% plot the matrix as heatmap
imagesc([-0.8:0.05:0.8], [8:2:150], deg1_baseline, [0 10])

% display color scale which explain the color code
colorbar

% flip the image upwars to that higer frequencies are on top
% (this is common way to draw such kind of plots)
axis xy

% add vertical line which indicates the moment when the stimulus was shown
line([0 0], [0 200], 'LineWidth', 1, 'Color', [0 0 0])

% set font size
set(gca,'FontSize', 14)

% add labels
xlabel('Time', 'FontSize', 18)
ylabel('Frequency', 'FontSize', 18)

% perform analogous plotting procedure for the second condition (deg2)
subplot(1, 2, 2)
deg2_average = mean(deg2, 1);
deg2_average = squeeze(deg2_average);
baseline = mean(deg2_average(:, 9:15), 2);
deg2_baseline = bsxfun(@rdivide, deg2_average, baseline);
imagesc([-0.8:0.05:0.8], [8:2:150], deg2_baseline, [0 10])
colorbar
axis xy
line([0 0], [0 200], 'LineWidth', 1, 'Color', [0 0 0])
set(gca,'FontSize', 14)
xlabel('Time', 'FontSize', 18)
ylabel('Frequency', 'FontSize', 18)


%% T-test

% perform 2376 t-tests on each of the 2376 boxes 
%%% ... TODO ... %%%

% check which of 2376 (frequency, time)-pairs are significanlty different
% using alpha = 0.05
%%% ... TODO ... %%%


%% FDR

% perform False Discovery Rate correction on the p-values form the previous
% part of the exercise
%%% ... TODO ... %%%

% check how many of the of the 2376 boxes are now can be considered to be
% significantly different using alpha = 0.05
%%% ... TODO ... %%%


%% Average & T-test again

% Consider only the time of interest 150ms - 600ms, in the trial matrix 
% deg1(trial, :, :) these are columns 19-27. For each of these columns
% compute average over frequencies. You will obtain one number for each
% trial for each time range. So now you have 8 vectors of length 79 for
% deg1 and 8 vectors of length 77 for deg2.
%%% ... TODO ... %%%

% perform 8 t-tests
%%% ... TODO ... %%%

% apply FDR correction
%%% ... TODO ... %%%

% check which of 8 vectors are statistically significant using alpha = 0.05
%%% ... TODO ... %%%

