% clear workspace and add DeepLearnToolbox to search path
clear all;
addpath(genpath('DeepLearnToolbox'));


% turn off paging in Octave
more off;

% load data
load('../data/rat_data.mat');
% loaded variables:

% spikes - count of spikes for each neuron at each timestep
% coords - coordinates of the rat at each timestep

% Predefine sizes of training and validation set
nr_samples = size(spikes, 1);
nr_train = 10000;              % must be divisible by batch size !!! otherwise error
nr_val = nr_samples - nr_train;

% randomly split samples into training and validation set,
% because our samples are not evenly distributed
perm = randperm(nr_samples);
train_idx = perm(1:nr_train);
val_idx = perm((nr_train + 1):(nr_train + nr_val));

train_x = spikes(train_idx, :);
train_y = coords(train_idx, :);
val_x = spikes(val_idx, :);
val_y = coords(val_idx, :);

% install package statistics in Octave
% in Ubuntu terminal: sudo apt-get install octave-statistics
% in Octave command window: pkg install -auto -forge statistics

% load package statistics in Octave (not needed if you installed with -auto)
%pkg load statistics;

% try linear regression with default parameters for baseline

% add bias term for regression
train_x_bias = [ones(size(train_x, 1), 1) train_x];
val_x_bias = [ones(size(val_x, 1), 1) val_x];
% predict X values
coeff1 = regress(train_y(:,1), train_x_bias);
val_pred(:,1) = val_x_bias * coeff1;
% predict Y values
coeff2 = regress(train_y(:,2), train_x_bias);
val_pred(:,2) = val_x_bias * coeff2;
% calculate mean Euclidian distance between actual and predicted coordinates
linear_mean_dist = mean(sqrt(sum((val_y - val_pred).^2, 2)));
disp(['Baseline (linear model) average error: ' num2str(linear_mean_dist) 'cm']);
pause
disp('press any key to start training the network')
% prepare data for DeepLearnToolbox

% normalize input to have zero mean and unit variance (otherwise we might get very big values as output)
[train_x, mu, sigma] = zscore(train_x);
val_x = normalize(val_x, mu, sigma);

% initialize neural network
rand('state',0)                 % use fixed random seed to make results comparable
nn = nnsetup([71 400 2]);       % number of nodes in layers - input, hidden, output
nn.learningRate = 0.001;        % multiply gradient by this when changing weights
nn.momentum = 0.9;              % inertia - add this much of previous weight change
nn.scaling_learningRate = 1;    % multiply learning rate by this after each epoch
nn.activation_function = 'tanh_opt';   % activation function: tanh_opt, sigm or relu
nn.dropoutFraction = 0.3;         % disable this much hidden nodes during each iteration
nn.weightPenaltyL2 = 0;         % penalize big weights by subtracting 
                                % fraction of weights at each training iteration
nn.output = 'linear';           % use linear output for regression
opts.numepochs = 50;             % number of full sweeps through data
opts.batchsize = 200;           % take a mean gradient step over this many samples
opts.plot = 1;                  % enable plotting

% train neural network and also plot validation error
nn = nntrain(nn, train_x, train_y, opts, val_x, val_y);

% predict coordinates on validation set
val_pred = nnpredict2(nn, val_x);
disp(val_y(1:10,:))
disp(val_pred(1:10,:))

% calculate mean Euclidian distance between actual and predicted coordinates
mean_dist = mean(sqrt(sum((val_y - val_pred).^2, 2)));
disp(['Average error on TEST SET: ' num2str(mean_dist) 'cm']);

% compare actual and predicted mouse locations
sim_idx = 1:10:1000;              % dataset slice to use - 100 with step 10
sim_x = spikes(sim_idx, :);       % spikes from original dataset
sim_y = coords(sim_idx, :);       % actual coordinates from original dataset
sim_pred = nnpredict2(nn, sim_x);  % predicted coordinates from spikes
f = figure;
for i=1:size(sim_x,1)
    figure(f);
    % plot actual (blue) and predicted (red) locations
    plot(sim_y(i,1), sim_y(i,2), 'b*', sim_pred(i,1), sim_pred(i,2), 'r*', 'MarkerSize', 10);
    xlim([80 270]);
    ylim([20 220]);
    xlabel('cm');
    ylabel('cm');
    legend('actual', 'predicted', 'Location', 'northeastoutside');
    title('Rat location');
    drawnow;
end
