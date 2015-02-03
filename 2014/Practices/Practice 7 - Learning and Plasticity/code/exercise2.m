%
% Exercise 3: Oja learning rule
%

% clear workspace
clear

% set up some data points
xS = [5 3 5 2 1 6 3 3 2
      1 6 3 4 6 2 3 4 6];
  
% replicate them 5 times to make weights update more stable
xS = repmat(xS, 1, 5);
  
% number of data points
tt = max(size(xS));

% the center of the point cloud
mnX = mean(xS, 2);

% demean data to center the data around (0,0)
x = xS - mnX(:,ones(1,tt));
x = x';


%% Learning using Oja's rule

% learning rate
alf = 3e-2; 

% initialize weight vector (rows are time points, columns are weights)
w = zeros(tt+1,2);

% initialize the weights at the first time point to a random value
w(1,:) = 0.4*rand(1,2);

    
% loop over time (= number of data points)
for t = 1:tt

    % compute output of the neuron (McCulloch-Pitts without threshold)
    y = w(t, :) * x(t, :)';

    % loop over synapses (weights)
    for i = 1:2

        % first we try the usual Hebbian rule
        w(t+1, i) = w(t, i) + %%% ... TODO ... %%%
        
        % after observing the figures we update it the Oja's rule
        %%% ... TODO ... %%%
        
    end

end

% print out the final weights
ws = w(end,:)


%% Plot the trace of weight changes over time
figure(1)
subplot(1,2,1)
plot(w(:,1), w(:,2), '-', w(1,1), w(1,2), '>', ws(1), ws(2), '*'),
grid on
xlabel('w_1'), ylabel('w_2')
title('Evolution of the weight vector')


%% Plot length of the weight vector over time
subplot(1,2,2)
plot(0:tt, sqrt(sum(w'.^2)))
grid on
xlabel('learning steps, t'), ylabel('||w||')
title('Evolution of the length of the vector')


%% Plot the line corresponding to the weight vector over the data points
figure(2)
plot(x(:,1), x(:,2), 'd', 4*ws(1)*[-1 1], 4*ws(2)*[-1 1],'-', ws(1), ws(2),'*', 0, 0, '+k'),
grid on
title('The line corresponding to the weight vector')
text(ws(1)+0.2*abs(ws(1)), ws(2), 'w_s')
xlabel('x_1'), ylabel('x_2')
