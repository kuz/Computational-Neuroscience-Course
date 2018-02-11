% Function approximation example, inspired by this Java applet:
% http://neuron.eng.wayne.edu/bpFunctionApprox/bpFunctionApprox.html

% clear workspace and switch off paging in Octave
clear;
more off;

% use Gnuplot for plotting in Octave
%graphics_toolkit gnuplot;

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

% add DeepLearnToolbox folder to function search path
addpath(genpath('DeepLearnToolbox'));

% set up neural network
nn = nnsetup([1 5 1]);             % One input, one output, ten hidden nodes
% nn = nnsetup([1 NUMBER_OF_HIDDEN 1]); %TODO Q3 change the number of hidden nodes            
nn.activation_function = 'sigm';    % Use sigmoid activation function
nn.learningRate = 0.1;              % Learning rate
nn.momentum = 0.9;                  % Momentum
nn.output = 'linear';               % Output is real value


disp('Press any key to continue');
pause;


% loop to animate learning
loss = [];
for k = 1:20
    % set up training parameters
    opts.batchsize = num_samples;   % Entire dataset is a batch
    opts.numepochs = min(k * 10,200);        % Initially train shorter time
                                             % to make animation more interesting
    %randomize the order of samples
    random_o = randperm(length(train_y))
    % train the network
    [nn, L] = nntrain(nn, train_x(random_o), train_y(random_o), opts);
    % collect loss
    loss = [loss; L];

    % use fine-grained range for testing
    test_x = [-4*pi:0.1:4*pi]';
    % calculate predictions on testing range - we willnot use this actually
    test_y = nnpredict2(nn, test_x);
    
    % plot training examples and approximation
    plot_sinusoid(train_x, train_y, test_x, test_y);
    
    % pause 50ms for animation
    pause(0.1);
end


%This would plot the contributions of each hidden node - how much is the output*weight that 
%  this node sends to the output fro any given x.
%plot_sinusoid_components(test_x, nn)  

% plot loss
figure;
plot(loss);
title('Evolution of loss during learning');
xlabel('Training Epoch nr');
ylabel('Loss on training set');
ylim([0 max(loss(100:end))]);

