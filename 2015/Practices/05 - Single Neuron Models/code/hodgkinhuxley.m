%
% Session: Signle Neuron Models
% Exerise 4: Hodgkin-Huxley model
% Adopted from http://math.bu.edu/people/mak/MA665 course materials
%
% SOLUTIONS
%
    
%% The beginning
clear all
clf

% in the file HH0.m we have implementation of the Hodgkin-Huxley neuron
% model. You are welcome to open it and study what is in there.
% the rest of us will use it a black-box

% the function accepts two inputs: current and time to simulate
I0 = 5;
T0 = 200;

% and output bunch of data, we are interested only in V, which is the
% voltage fluctuations and spikes of the neuron
[V,m,h,n,t] = HH0(I0, T0);

% here is how we plot it
plot(t,V)
xlabel('Time [ms]')
ylabel('Voltage [mV]')
ylim([-100 40])

%%% TODO %%% Add the figure to your report and explain what do you see


%% Input current threshold to elicit one spike

%%% TODO %%%
% Play with the current (variable I0) to find the minimal current which
% produces a spike. Report the value and the figure.


%% Current threshold before spike appears

%%% TODO %%%
% Play with the current (variable I0) to find the maximal voltage
% neuron can reach without producing a spike. Report the value and the figure.


%% Input current threshold to elicit non-dying series of spikes

%%% TODO %%%
% Play with the current (variable I0) to find the minimal current which
% initiates series of non-dying spikes. Report the value and the figure.



%% Relationship between the input current and the number of spikes
clear all
clf

% we will use findpeaks function, which likes to generate warnings, this
% instruction will suppress them
warning('off', 'signal:findpeaks:largeMinPeakHeight')

% In the similar manner as we did with the Integrate-and-Fire neurons let's
% see how the number of spikes depends on the input current

% time to simulate
T0 = 2000;

% define the list of current to try
currents = [1:0.5:10];

% prepare the variable to store spike counts
spikes = zeros(1, size(currents, 2));

% start the loop (will run for couple of minutes)
for i = 1:size(currents, 2)
    
    % take the next current value
    I0 = currents(i);
    
    % report progrss
    disp(['Simulating input current I = ' mat2str(I0)])
    
    % run the simulation
    [V,m,h,n,t] = HH0(I0, T0);
    
    % use Matlab buit-in function findpeaks to find the peaks, pay
    % attention to the MINPEAKHEIGHT parameter. It will output some warning
    % messages, do not pay attention to those
    spikes(i) = size(findpeaks(real(V), 'MINPEAKHEIGHT', 20), 1);
    
end

% plot the results
plot(currents, spikes)

%%% TODO %%% Add the figure to your report and explain what do you see

%%% TODO %%% Play with different T0 and current ranges, report your findings

