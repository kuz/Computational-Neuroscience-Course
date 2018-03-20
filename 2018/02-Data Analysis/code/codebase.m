%
% Practice session: Data Analysis: Spiking Data
% Codebase for Matlab/Octave
%



%% Load data

% prepare empty structure
data = {};

% for every neuron
for n = 1:72
    
    % load the data file and store it in the data structure under the
    % number n
    data{n} = load(['../data/lgn/matlab/mlgnori_' sprintf('%02d', n) '.mat']);
    
end



%% Exercise 3

%
% here is an example of how you can plot raster plot for a single trial
%

% from the data for the neuron number 5 we take variable spktimes
% it is a 3D matrix, we take 3rd stimiulus and trial number 8
spikes = data{5}.mlgn.spktimes(3,5,:);

% have a look at the size of the resulting variable: it is still a 3D matrix
size(spikes)

% we reshape it into usual 2-dimensional matrix with only one row
spikes = reshape(spikes, 1, []);

% so that you can access element number 1078 just as
spikes(1078)

% now we are ready to plot it

% for each moment of time (we have 3500 of them)
for t = 1:size(spikes,2)
    
    % if there is a spike at this time moment
    if spikes(t) == 1
        
        % draw a vertical line
        line([t t], [7 7.5], 'Color', 'k');
    end
end

% add labels to X and Y axis
xlabel('Time (ms)', 'FontSize', 16);
ylabel('Trial', 'FontSize', 16);

% specify range for the Y axis so that the plot would resemble the real thing
ylim([0 10])

% add title to your plot
title('10 trials', 'FontSize', 20)

% and specify font size for numbers on the axis
set(gca,'FontSize', 14)


%
% your task is to create similar plot not for only one trial, but for as
% many as are there under the neuron N and stimulus S
% if we take N = 43 and S = 7 then there are
size(data{43}.mlgn.spktimes(7,:,:),2)
% trials
%

% CODE FOR FIRST RASTER PLOT GOES HERE!


% second plot will have time on X axis and 72 neurons on Y axis for one
% particular simulus S (choose any from 2 to 13)

% among other things you will need to average over trials
% for example you have chosen stimulus 7 and now you are going to plot
% neuron 43
S = 7;
N = 43;

% which has 5 trials for stimulus 7 as we have seen before
% to average we add all trials together (it might sound like chinese, but it's explained below)
spikes = sum(reshape(data{N}.mlgn.spktimes(S,:,:), size(data{N}.mlgn.spktimes(S,:,:), 2), []));

% magical, isnt it?
% let me explain what is going on there
% this part 
data{N}.mlgn.spktimes(S,:,:)
% selects all the data available for neuron N and stimulus S

% let us store all this data so separate variable
data_we_need = data{N}.mlgn.spktimes(S,:,:);

% but its shape is very strange, look at it
size(data_we_need)

% we want to reshape it into the matrix where rows are trials and columns
% are time moments. For that we will use reshape function()
% this function would like to know into which dimensions we would like to
% resphape our 3D matrix. The answer is 5x1501 (5 trials and 1501 time
% momenets). So we record those numbers into variables
number_of_trials = size(data{N}.mlgn.spktimes(S,:,:), 2)
number_of_time_moments = size(data{N}.mlgn.spktimes(S,:,:), 3)

% and now we can call reshape()
spikes = reshape(data_we_need, number_of_trials, number_of_time_moments)

% if we put it all together we will obtain almost all the monstrocity
% you saw on the line 93:
spikes = reshape(data{N}.mlgn.spktimes(S,:,:), size(data{N}.mlgn.spktimes(S,:,:), 2), [])
% comment: instead of giving the last parameter we can tell Matlab to think a
% little bit and figure out that if we have 5*1501=7505 data points and we
% want to put it into 5 equally-sized vectors, then there is no other way
% for the second parameter other than to be equal to 1501
% Matlab is smart enough to figure that on its own, so we can write []
% instead of 1501 as the last parameter of the reshape() function

% and the last operation we do on the line 93 is sum()
% once we have 5x1501 matrix M we can call sum(M) and it will sum this
% matrix column-wise giving us one vector of length 1501
spikes = sum(spikes)

% because we summed everything together it might happen, that in two separate trials
% the spike occured on the same time moment, this will result in having
% values greater than 1 in our final vector, which is bad, bacause for the raster plot the
% data should have 0 if there is not spike, 1 is there is a spike and
% no other values are allowed
% to deal with it we replace all values which are greater that one with one
spikes(spikes > 1) = 1;

% now you can confirm that the largest value in this array is one
max(spikes)


%
% your task is to perform this operation 72 times (for each of the neurons)
% and one stimulus (choose any from 2 to 13) and plot all 72 on the same
% plot, each neuron on its own line, this is very similar to the Plot nr 1
%

%
% your second task is to perform analogous operations to extract the data
% needed to plot stimuli on the Y axis and time on the X axis
% if for the first plot you had a loop over neurons then in this plot you
% will have a loop over stimuli
%

% Do not forget to give an interpretation of the plots in your report

% SECOND AND THIRD RASTER PLOTS GO HERE ...



%% Exercise 4
% the rose diagram, as mentioned in the exercise sheet, is a neat way of
% visualizing the data we have
% the rose() function expects to get two arrays as an input:
%   1. array with value to put into histogram (orentations in our case)
%   2. bin angles: length of the array is treated as the number of bins,
%      each value indicates the direction of that bin in 360 degree chart
% values in both arrays should be in radians

% the second input is
rads = degtorad([0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330]);

% the first one you have to prepare yourself by following the instruciton
% in the PDF


% EXERCISE 2 CODE GOES HERE ...


% once that is done you can plot you rose diagram as
rose(deg2rad(orientations), rads);




