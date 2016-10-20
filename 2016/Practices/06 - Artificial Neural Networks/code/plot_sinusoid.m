function plot_sinusoid(train_x, train_y, test_x, test_y)
%PLOT_SINUSOID Plots sinusoid with target points and approximation.

if exist('test_x', 'var')
    minx = min(test_x);
    maxx = max(test_x);
else
    minx = min(train_x);
    maxx = max(train_x);
end

figure(2);
clf;
hold on;

sinx = (minx:0.1:maxx);
siny = sin(sinx);

plot(sinx, siny, 'g');
scatter(train_x, train_y, 'r');
if exist('test_x', 'var') && exist('test_y', 'var')
    plot(test_x, test_y, 'b');
end

title('Sinusoid approximation');
xlabel('x');
ylabel('sin(x)');
ylim([-2,2]);
hold off;

end

