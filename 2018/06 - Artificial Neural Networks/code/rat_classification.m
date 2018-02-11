% clear workspace and add DeepLearnToolbox to search path
clear all;
addpath(genpath('DeepLearnToolbox'));

% turn off paging in Octave
more off;

% load data

load('../data/rat_data.mat');
% loaded variables:
% spikes - count of spikes for each neuron at each timestep
% blocks - region where the rat is at each timestep

% calculate sizes of training and validation set
nr_samples = size(spikes, 1);
nr_train = 10000;               % must be divisible by batch size
nr_val = nr_samples - nr_train;

% randomly split samples into training and validation set,
% because our samples are not evenly distributed
perm = randperm(nr_samples);
train_idx = perm(1:nr_train);
val_idx = perm((nr_train + 1):(nr_train + nr_val));

train_x = spikes(train_idx, :);
train_y = blocks(train_idx);
val_x = spikes(val_idx, :);
val_y = blocks(val_idx);

% install package nan in Octave
% in Ubuntu terminal: sudo apt-get install octave-nan
% in Octave command window: pkg install -auto -forge nan

% load package nan in Octave (not needed if you installed with -auto)
%pkg load nan;

% try linear classifier with default parameters for baseline
val_predy = classify(val_x, train_x, train_y);
correct = (val_y == val_predy);
disp('LDA classification accuracy is:')
disp('Press any key to start trining the network:')
linear_accuracy = sum(correct) / size(correct,1)

pause
% prepare data for DeepLearnToolbox

% normalize input to have zero mean and unit variance
[train_x, mu, sigma] = zscore(train_x);
val_x = normalize(val_x, mu, sigma);

% DeepLearnToolbox expects one-of-N coding for classes (onehot vectors)
train_y = one_of_n(train_y);
val_y = one_of_n(val_y);

% initialize neural network
rand('state',0);                % use fixed random seed to make results comparable
nn = nnsetup([71 100 16]);  % number of nodes in layers - input, hidden, output
                                % 71 is the number of neurons we have recordings for
                                % 100 is just arbitrary number and you should change that
                                % 16 is the number of areas with 1-of-N coding
nn.learningRate = 1.0;          % multiply gradient by this when changing weights
nn.momentum = 0.0;              % inertia - add this much of previous weight change

nn.scaling_learningRate = 0.95;    % multiply learning rate by this after each epoch
nn.activation_function = 'tanh_opt';   % activation function: tanh_opt, sigm or relu
nn.dropoutFraction = 0.0;         % disable this much hidden nodes during each iteration
nn.weightPenaltyL2 = 0;         % penalize big weights by subtracting 
                                % fraction of weights at each training iteration
nn.output = 'softmax';          % use softmax output for classification -> cross entropy loss
opts.numepochs = 30;            % number of full sweeps through data
opts.batchsize = 200;           % take a mean gradient step over this many samples
opts.plot = 1;                  % enable plotting

% train neural network and also plot validation error
nn = nntrain(nn, train_x, train_y, opts, val_x, val_y);
% neural network final accuracy
disp('Prediction accuracy with NNetwork is:')
accuracy = 1 - nntest(nn, val_x, val_y)

% plot confusion matrix for the classes
val_predy = nnclassify(nn, val_x);
val_truth = blocks(val_idx);
figure;
plot_confmatrix(val_truth, val_predy);
