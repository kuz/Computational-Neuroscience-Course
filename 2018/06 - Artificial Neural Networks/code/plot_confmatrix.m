function plot_confmatrix(groundtruth, predictions)
%PLOT_CONFMATRIX Plots confusion matrix with text annotations.

confmat = confusionmat(groundtruth, predictions);
imagesc(confmat);
colormap jet;
%colorbar;

[x, y] = meshgrid(1:16);
text(x(:), y(:), num2str(confmat(:)), 'Color', 'white', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

end

