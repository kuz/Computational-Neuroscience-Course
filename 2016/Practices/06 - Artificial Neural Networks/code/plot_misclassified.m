function plot_misclassified(test_x, groundtruth, predictions)
%PLOT_MISCLASSIFIED Plots misclassified digits with predicted labels.

% collect 10 misclassified samples of each digit
bad_x = [];
bad_y = [];
for i = 1:10
    x = test_x((groundtruth == i & groundtruth ~= predictions), :);
    y = predictions((groundtruth == i & groundtruth ~= predictions), :);
    num_bad = size(x, 1);
    if num_bad < 10
        bad_x = [bad_x; x; zeros(10 - num_bad, size(x, 2))];
        bad_y = [bad_y; y; zeros(10 - num_bad, 1)];
    else
        bad_x = [bad_x; x(1:10, :)];
        bad_y = [bad_y; y(1:10)];
    end
end

% visualize misclassified digits (have to denormalize them first)
visualize(bad_x');

% add predicted labels
[x, y] = meshgrid(1:10);
text(x(:)*29-1, y(:)*29+1, num2str(bad_y - 1), 'Color', 'white', ...
    'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');

end
