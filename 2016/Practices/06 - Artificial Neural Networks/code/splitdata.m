%
% Split dataset into training, validation and test subsets
%
function [train_features, train_labels, val_features, val_labels] = splitdata(features, labels, proportion)

  % pick random indices for the training subset
  shuffled_idx = randperm(length(labels));
  train_idx = shuffled_idx(1:floor(length(labels) * proportion));

  % split the rest between the validation and the test subset
  val_idx = shuffled_idx(floor(length(labels) * proportion):length(labels));

  % split the feature matrix
  train_features = features(train_idx, :);
  val_features = features(val_idx, :);

  % split the class label vector
  train_labels = labels(train_idx,:);
  val_labels = labels(val_idx,:);
end

