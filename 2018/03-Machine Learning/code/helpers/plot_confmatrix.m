function plot_confmatrix(groundtruth, predictions)
%PLOT_CONFMATRIX Plots confusion matrix with text annotations.

[confmat, values] = confusionmat(groundtruth, predictions);
imagesc(confmat);
colormap jet;
%colorbar;

[x, y] = meshgrid(values);
text(x(:), y(:), num2str(confmat(:)), 'Color', 'white', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
set(gca, 'XTick', values);
set(gca, 'YTick', values);
xlabel('Predicted class');
ylabel('Actual class');
end

