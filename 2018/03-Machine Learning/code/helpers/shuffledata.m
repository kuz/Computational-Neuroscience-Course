%
% Shuffle a dataset
%
function [s_features, s_labels] = shuffledata(features, labels)
newidx = randperm(length(labels));
s_labels = labels(newidx);
s_features = features(newidx, :);
