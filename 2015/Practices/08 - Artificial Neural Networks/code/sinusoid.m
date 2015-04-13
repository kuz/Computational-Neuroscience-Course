% Function approximation example, inspired by this Java applet:
% http://neuron.eng.wayne.edu/bpFunctionApprox/bpFunctionApprox.html

% clear workspace and switch off paging in Octave
clear;
more off;

% define input range and number of samples
range_start = -2*pi;
range_end = 2*pi;
num_samples = 20;
step = (range_end - range_start) / (num_samples - 1);

% define x, calculate y and plot sinusoid
% - green line is sinusoid function
% - red circles are samples we use
train_x = [range_start:step:range_end]';
train_y = sin(train_x) + 0.1 * randn(size(train_x));    % add some noise
plot_sinusoid(train_x, train_y);
pause;

% add DeepLearnToolbox folder to function search path
addpath(genpath('DeepLearnToolbox'));

% set up neural network
nn = nnsetup([1 10 1]);             % One input, one output, ten hidden nodes
nn.activation_function = 'sigm';    % Use sigmoid activation function
nn.learningRate = 0.1;              % Learning rate
nn.momentum = 0.9;                  % Momentum
nn.output = 'linear';               % Output is real value

% loop to animate learning
loss = [];
for k = 1:30
    % set up training parameters
    opts.batchsize = num_samples;   % Entire dataset is a batch
    opts.numepochs = k * 10;        % Initially train shorter time
                                    % to make animation more interesting
    % train the network
    [nn, L] = nntrain(nn, train_x, train_y, opts);
    % collect loss
    loss = [loss; L];

    % use fine-grained range for testing
    test_x = [range_start:0.1:range_end]';
    % calculate prediction on testing range
    test_y = nnpredict2(nn, test_x);
    
    % plot training examples and approximation
    plot_sinusoid(train_x, train_y, test_x, test_y);
    
    % pause 100ms for animation
    pause(0.1);
end

% plot loss
figure;
plot(loss);
title('Loss history');
xlabel('Epoch');
ylabel('Loss');
ylim([0 max(loss(100:end))]);

% Answer following questions in your report:

% Q1: Why we don't always get the same result during training?
%     Why sometimes the approximation is better and sometimes worse?

% Q2: What is the minimum number of hidden nodes to approximate sinusoid 
%     with four bumps (like in the example)? Include figure with your 
%     report. I’m asking for occasional (or theoretical) possibility,
%     not that it approximates reliably with that many hidden nodes. 
%     Bonus: why that might be? Following function might give you some
%     hints - plot_sinusoid_components(test_x, nn).

% Q3: If you have got good enough approximation, try to apply the network
%     on wider range, for example from -4pi to 4pi. How well it generalizes
%     to data outside of its training range?
