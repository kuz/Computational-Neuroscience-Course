% Classification of MNIST handwritten digits, based on DeepLearnToolbox
% examples: https://github.com/rasmusbergpalm/DeepLearnToolbox

% clear workspace and switch off paging in Octave
clear;
more off;

% use Gnuplot for plotting in Octave
%graphics_toolkit gnuplot;

% add DeepLearnToolbox folder to function search path
addpath(genpath('DeepLearnToolbox'));
% load data
load mnist_uint8;

% convert data to doubles and scale input between 0 and 1
train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
% output has 1 or 0 for each number, a.k.a. one-of-N coding
train_y = double(train_y);
test_y  = double(test_y);

% visualize some handwritten digits
figure;
visualize(train_x(1:100,:)');
title('Example handwritten characters');
axis off;
disp('Press any key to continue');
pause;

% set up neural network
nn = nnsetup([784 50 10]);  % 28x28 input, 50 hidden nodes, 10 outputs
nn.learningRate = 1;        % Learning rate, i.e. 1, 0.1, 0.001, 0.0001
nn.momentum = 0.9;          % Momentum, try 0.5 or 0.9
nn.weightPenaltyL2 = 0;     % L2 weight decay, i.e. 0, 0.1, 0.001, 0.0001
nn.activation_function = 'sigm';    % Use sigmoid activation function
nn.output = 'softmax';              % Use softmax as final layer

% set up parameters and train
opts.numepochs = 5;    %  Number of full sweeps through data
opts.batchsize = 100;  %  Take a mean gradient step over this many samples
opts.plot = 1;         %  Enable plotting
disp('Starting training...');
nn = nntrain(nn, train_x, train_y, opts, test_x, test_y);

% calculate error on test set
predictions = nnpredict(nn, test_x);
[~, groundtruth] = max(test_y,[],2);
incorrect = (predictions ~= groundtruth);
disp(sprintf('Test error %.2f%%.', sum(incorrect) / size(incorrect, 1) * 100));
disp('Press any key to continue');
pause;

% visualize misclassified digits
figure;
plot_misclassified(test_x, groundtruth, predictions);
title('Examples of misclassified digits');
axis off;
disp('Press any key to continue');
pause;

% distribution of misclassified digits between classes
figure;
hist(groundtruth(incorrect));
title('Distribution of misclassified digits');
set(gca, 'XTickLabel', 0:9);
disp('Press any key to continue');
pause;

% plot confusion matrix
figure;
plot_confmatrix(groundtruth, predictions);
title('Confusion matrix');
set(gca, 'XTickLabel', 0:9);
set(gca, 'YTickLabel', 0:9);
disp('Press any key to continue');
pause;

% visualize first level weights
figure;
visualize(nn.W{1}(:, 1:784)');
title('First layer weights');
axis off;
disp('Press any key to continue');
pause;
