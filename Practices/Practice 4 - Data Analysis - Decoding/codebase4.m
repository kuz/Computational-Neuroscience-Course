%
% Practice session 4: Decoding
% Codebase


%% Exercise 2
%
% Based on the HC3 dataset
% https://crcns.org/data-sets/hc/hc-3/about-hc-3
%


%%  Load the data

% lets roll
load data/ec012ec.187.fet.1
load data/ec012ec.187.whl

% since those names are not very convinient, let us rename them
features = ec012ec_187_fet;

% our task will be to predict X and Y coordinates so lets put them into
% separate vectors. We are going to take (x, y) coordinates of the first led
xclass = ec012ec_187(:, 1);
yclass = % ... YOUR CODE HERE ...


%%  Prepare data
% When you work with real data it is always necessary to understand how
% this data was collected, composed and how to deal with it. The
% description of our data is here https://crcns.org/files/data/hc2/crcns-hc2-data-description.pdf
% read it and put correct values into following variables
video_rate   = % ... YOUR CODE HERE ...
spiking_rate = % ... YOUR CODE HERE ...

% have a look at the size of our feature matrix
size(features)

% and at the size of the vector with class values
size(xclass)

% we clearly have a problem: first is ~twice bigger, but we need that each
% instance has a class related to it...

% here is a magical piece of  code, which will add two empty columns
% to our feature vector
features  = [features zeros(size(features, 1), 2)];

% and fill them with corresponding (x, y) positions based on the timing
% if you specify video_rate and spiking_rate wrong then it most probably
% will fail or produce wrong results
% (running this piece of code might take a minute)
for frame = 1:size(xclass, 1)
    cutfrom = (frame-1) / video_rate * spiking_rate;
    cutto   = (frame)   / video_rate * spiking_rate;
    idx     = find((features(:,end-2) >= cutfrom) + (features(:,end-2) <= cutto) == 2)';
    if size(idx, 1) > 0
        for index = idx
            features(index, end-1:end) = [xclass(frame) yclass(frame)];
        end
    end
end

% now if you will have a look at it, then you will see that there are lots
% of instances which have (x, y) values of (-1, -1), we want to remove them
remove_idx = find(features(:,end) == -1)';
features(remove_idx, :) = [];

% and now let us put our class vectors into the variables
xclass = features(:, 30);
yclass = % ... YOUR CODE HERE ...

% finally we remove from the feature matrix columns corresponding to
% a) time of the spike, b) X coordinate, c) Y coordinate
% for example
features(:,29) = [];
% will remove 29th column
% ... YOUR CODE HERE ...

% as result feature matrix must have 28 columns
size(features)


%% Plot mouse movements
% Use scatter() to plot rat movements

% ... YOUR CODE HERE ...


%% Separate into training and test sets

% we define a split so that 66% of the data will be used as training set
% and the rest of is a training set
split = ceil(size(features,1) * 0.66);

% and this is how we can put part of our dataset into a subset
training  = features(1:split, :);

% in the similar manner fill in the following variables
test      = % ... YOUR CODE HERE ...
trainingx = % ... YOUR CODE HERE ...
trainingy = % ... YOUR CODE HERE ...
truex     = % ... YOUR CODE HERE ...
truey     = % ... YOUR CODE HERE ...


%% Classification
% we are finally ready to run a machine learning algorithm on our data
% we will use Matlab classify() function without thinking about what is
% actually does (you need to take a Machine Learning course for that)
% you use is as follows:
%   PREDICTED_CLASS = classify(TEST_DATA, TRAINING_DATA, TRAINING_CLASS)
predictedx = % ... YOUR CODE HERE ...
predictedy = % ... YOUR CODE HERE ...


%% Plot the results
% we do have a scatter plot with true positions of the rat, plot predicted
% positions on top of that, use
%   scatter(TRUE POSITIONS)
%   hold on
%   scatter(PREDICTED POSTITION)
% to draw one plot on top of the other

% ... YOUR CODE HERE ...


%% Calculate average error in distance
% use Eucledian distance http://en.wikipedia.org/wiki/Euclidean_distance to
% calculate how far away each of our predicted locations is from the
% corresponding true one

% to raise each element of a vector to a power do
powers = [1 2 3 4 5 6 7] .^ 2

% to take a square root of each element of a vector do
sqrt(powers)

% as a results you will get a vector of length
size(predictedx, 1)
% ... YOUR CODE HERE ...

% use hist() to see distribution of the errors we make
% ... YOUR CODE HERE ...




%% Exercise 3
%
% Based on the VIM1 dataset
% https://crcns.org/data-sets/vc/vim-1/about-vim-1
%

% Load the data
load data/EstimatedResponses.mat
load data/Stimuli.mat

% Prepare test & training for one pixel
training = dataTrnS1';
test     = % ... YOUR CODE HERE ...

% replace NaNs with 0
training(isnan(training)) = 0;
test(isnan(test))         = 0;

% Now we have a problem: we have data with 25000 features, and almost any
% machine learning algorithm will choke on such amount of combinations to
% try out.
% One easy thing we can do is to take each 5th voxel, probably we do need
% all of them
trainingsample = training(:, 1:5:size(training, 2));
testsamples    = % ... YOUR CODE HERE ...

% Now we have 5000 features, which is better, but still quite a lot.
% There is a very nice techinque called Principle Component Analysis (PCA).
% We will not talk about mathematics involved, I will just demonstrate what
% PCA can do and how it is useful in cases like ours.

% I will demonstate PCA on the images we have in our dataset
% we put all image together
images = reshape(stimTrn, 1750, 128*128);

% and train PCA on it (it will take minute or two)
[imgcoef, imgscore, imgvariance] = princomp(images);

% what it does is it finds how it is possible to describe same data with
% less features, those new features are called components
% Lets take 1000 most important componenets.
image_pc = 1000;

% and reduce our images from 16384-dimensional to 1000-dimensional
pca_train_images = imgscore(:, 1:image_pc)';
pca_test_images  = imgcoef' * reshape(stimVal, 120, 128*128)';
pca_test_images  = pca_test_images(1:image_pc, :)';

% we would like to know how much did we loose in the process, lets try to
% reconstruct one of the images and compare it before and after the
% reconstruction
reducedimage = zeros(1, 128*128);
reducedimage(1:image_pc) = pca_test_images(77, :)';
origimage = imgcoef * reducedimage';
colormap(gray);
subplot(1, 2, 1);
imagesc(reshape(stimVal(77, :, :), 128, 128));
subplot(1, 2, 2);
imagesc(reshape(origimage, 128, 128));
% as you can see we removed 15384 and we are still able to identify the
% image

% Natural question would be: how much can we get rid of without loosing
% any information? This question can be answered by cumulative plot of
% variance. On X axis we have components and on Y axis percentage of
% variance x components describe.
explained = 100*imgvariance/sum(imgvariance);
plot(cumsum(explained));

% Find out minimal number of components we need to preserve 100% of the
% data
% ... YOUR CODE HERE ...

% Take another image, decompose it to the number of components you have
% just found and reconstruct it back, produce the same plot as we have seen
% above
% ... YOUR CODE HERE ...



% This is all good, but we still have 5000 of features, right?
% your task is perform the same steps as we did above on image with our
% fMRI data.
% Currecntly we have 1750 instances with 5183 features
size(trainingsample)

% perform PCA on this data
% ... YOUR CODE HERE ...

% find the number of components you need to keep 100% of the data
% ... YOUR CODE HERE ...

% take any instance out of 1750 and show that it remains the same after
% transforming it to the PC space and back
% ... YOUR CODE HERE ...




%
% That is enough to get 1 point for this exercise.
%
% However, if you are bold enough, you can try to build a model to actually
% reconstruct the image from the brain data, for that you will need to
%   - perform the PCA on images
%   - perform the PCA on features
%   - tranform test data into PC space using coefficients
%     you obtained from PCA
%   - create a classifier
%   - evaluate results
%
% I must warn you, that on average laptop building such a model with naive
% approach might take one day or so (10 hours on my laptop with 500 features
% and full images)
%
% Sufficient effort will be awarded with 1 bonus point
%

% ... YOUR CODE HERE ...






%% Exercise 4*
%
% Based on the LGN1 dataset
% https://crcns.org/data-sets/lgn/lgn-1/about
%

% This is how usually you start working on the data: you have nothing and
% you need to come up with idea, code and interpretation on your own :)
% Good luck!



















