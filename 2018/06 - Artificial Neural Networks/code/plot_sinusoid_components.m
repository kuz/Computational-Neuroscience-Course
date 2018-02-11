function plot_sinusoid_components(x, nn)
%PLOT_SINUSOID_COMPONENTS Plots contributions of each hidden node.

% calculate activations of hidden layer
a = sigm([ones(size(x, 1), 1) x] * nn.W{1}');
% calculate contribution to y value from each hidden node separately
y = bsxfun(@times, a, nn.W{2}(2:end));

figure;
% plot contributions from each hidden node
subplot(2,1,1);
plot(repmat(x, 1, size(y, 2)), y);
title('Hidden node contributions');
legend(strcat('node', num2str((1:size(y,2))')));
xlabel('x');
ylabel('sin(x)');
% plot sum of contributions + bias
subplot(2,1,2);
plot(x, sum(y, 2) + nn.W{2}(1));
title('Sum of hidden node contributions (+ bias)');
xlabel('x');
ylabel('sin(x)');

end
