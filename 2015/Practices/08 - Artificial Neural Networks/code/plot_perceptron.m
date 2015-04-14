function plot_perceptron(data, targets, weights)
%PLOT_PERCEPTRON Plots perceptron inputs data and decision boundary.

% if weights argument was given, calculate predictions
if exist('weights','var')
    predictions = ((data * weights) >= 0);
else
    predictions = targets;
end

% partition data into four groups
pos_data_correct   = data((targets == 1) & (predictions == 1),:);
pos_data_incorrect = data((targets == 1) & (predictions == 0),:);
neg_data_correct   = data((targets == 0) & (predictions == 0),:);
neg_data_incorrect = data((targets == 0) & (predictions == 1),:);

% open figure window, clear it, and set overwriting on
figure(1);
clf;
hold on;

% plot positive examples classified correctly as blue crosses
scatter(pos_data_correct(:,1), pos_data_correct(:,2), 20, 'b', '+');
% plot positive examples classified incorrectly as red crosses
scatter(pos_data_incorrect(:,1), pos_data_incorrect(:,2), 20, 'r', '+');
% plot negative examples classified correctly as green circles
scatter(neg_data_correct(:,1), neg_data_correct(:,2), 20, 'g', 'o');
% plot negative examples classified incorrectly as red circles
scatter(neg_data_incorrect(:,1), neg_data_incorrect(:,2), 20, 'r', 'o');

% if weights were given, plot decision boundary
if exist('weights','var')
    plot([-5 5], ...
        [-(weights(3)-5*weights(1))/weights(2) ...
        -(weights(3)+5*weights(1))/weights(2)], 'k');
end

% fix limits for both axes and stop overwriting
title('Perceptron classification');
xlim([-1,1]);
ylim([-1,1]);
hold off;

end