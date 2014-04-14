%
% Exercise 2: ECoG data
% From the "IV BCI Competition"
%

% clear all previous data
clear all
clf


%% Load data
% Note: the sampling rate is 1000Hz
% you will have 4 matrices:
%   train_data - ECoG data we use for training, 64 channels, 400 seconds
%   train_dg   - Finger flexion data we use for training, 5 fingers, 400 seconds
%   test_data  - ECoG data we use for testing, 64 channels, 200 seconds
%   test_dg    - Finger flexion data we use for testing, 5 fingers, 200 seconds
load sub1_comp
load sub1_testlabels


%% Plot some of it to get an idea how it looks
% Plot 1 second of 1 channel ECoG data

%%% TODO %%%

% Plot the thumb (1st finger) flexion over the whole
% period of training (400 seconds)

%%% TODO %%%


%% The main part

% set up some parameters
window_size = 1000;
finger = 1;

% initialize variable to store Fourier-transformed training data
training_data_ft = [];
training_labels_ft   = [];
    
% perform DFT on training data
for w = 1:window_size:size(train_data(:, finger), 1)
    
    % define start end points of the window
    window_start = w;
    window_end   = w + window_size - 1;
    
    % take signal from the window
    signal = train_data(window_start:window_end, finger);
    
    % perform DFT on this signal
    pow = abs(fft(signal));
    
    % create three features
    %   1-60 Hz average powers
    %   61-100 Hz average powers
    %   100-200 Hz average powers
    % and put them into a feature vector
    training_data_ft = [training_data_ft; mean(pow(1:60)), mean(pow(60:100)), mean(pow(100:200))];
    
    % store corresponding label into vector with training labels
    training_labels_ft = [training_labels_ft; mean(train_dg(window_start:window_end, finger))];
end

% initialize variable to store Fourier-transformed training data
test_data_ft = [];
test_labels_ft   = [];

% perform DFT on test data
for w = 1:window_size:size(test_data(:, finger), 1)
    
    % define start end points of the window
    window_start = w;
    window_end   = w + window_size - 1;
    
    % take signal from the window
    signal = test_data(window_start:window_end, finger);
    
    % perform DFT on this signal
    pow = abs(fft(signal));
    
    % create three features
    %   1-60 Hz average powers
    %   61-100 Hz average powers
    %   100-200 Hz average powers
    % and put them into a feature vector
    test_data_ft = [test_data_ft; mean(pow(1:60)), mean(pow(60:100)), mean(pow(100:200))];
    
    % store corresponding label into vector with training labels
    test_labels_ft = [test_labels_ft; mean(test_dg(window_start:window_end, finger))];
end

% Create a classifier to predict labels from the test dataset
predicted_labels_ft = classify(test_data_ft, training_data_ft, training_labels_ft);

% we have reduced the legnth of our dataset by window_size
% now we want to restore the origial size
% we do that by replicating predictions window_size times
predicted_dg = [];
for i = 1:size(predicted_labels_ft, 1)
    predicted_dg = [predicted_dg repmat(predicted_labels_ft(i), 1, window_size)];
end
predicted_dg = predicted_dg';

% Plot the original time series vs. predicted
clf
plot(test_dg(:, finger), 'g')
hold all
plot(predicted_dg, 'r')
xlabel('Time', 'FontSize', 16)
ylabel('Flexion', 'FontSize', 16)
    
%   Compute and output correlation
corr(predicted_dg, test_dg(:, finger))
