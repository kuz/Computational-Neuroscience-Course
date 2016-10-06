%
% Session: Single Neuron Models
% Exerise 4: Hodgkin-Huxley model
% Adopted from http://math.bu.edu/people/mak/MA665 course materials
%


%% The beginning
clear all
clf

% in the file HH0.m we have implementation of the Hodgkin-Huxley neuron
% model. You are welcome to open it and study what is in there.
% the rest of us will use it a black-box

% the function accepts two inputs: injected current and time to simulate
I0 = 5;
T0 = 400; %duration in ms

% and output bunch of timeseries
% V contains the membrane potential at all timesteps
% m  - %%%TODO%%% explain
% h  - %%%TODO%%% explain
% n  - %%%TODO%%% explain
% t  - the time axis of the simulation (useful for plotting)
[V,m,h,n,t] = HH0(I0, T0);


% here is how we plot it
plot(t,V)
xlabel('Time [ms]')
ylabel('Voltage [mV]')
ylim([-100 40])

%%% TODO %%% Add the figure to your report
% You are supposed to see only one spike in the very beginning, then some oscilations and then a stabilization at some voltage
% The initial spike is not representative of the neuron's behaviour at this amount of injected current - it happens because 
% at first timestep of the simulation we give variables m(1), n(1) and h(1) some default values which are actually not very valid.
% it takes time for the system to stabilize. This time is called "burn in" time. 


%% Current threshold

%%% TODO %%%
% Play with the current (variable I0)
% 1)Find the minimal current I0 strength that leads to at least one spike in the beginning of the simulation (during burn in)
% 2)Find the minimal current I0 strength that leads to continous spiking (spiking continues till the end of simulation)



disp('Press any key to continue')
pause


%% Relationship between the input current and the number of spikes
clear all
clf


% In the similar manner as we did with the Integrate-and-Fire neurons let's
% see how the number of spikes depends on the input current
% only that spike is not as discreete event we define - it happens as a consequence of NA and K conductances
% so we need to detect it by hand...


% time to simulate
T0 = 500;

% define the list of current to try
currents = [3:1:6 6.1:0.1:7 8:15];

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
    size(V) %just to ckeck

    %need to count spikes
    count = 0; % for counting spikes
    for j=1:length(V);
        if V(j)>0 %if voltage is high we count a spike
            count +=1;
            V(j:j+300) = -70.0; %if we crossed threshold at t, we do not expect new spike in next 3 ms
        end
    end
    spikes(i) = count;
    
end
disp(spikes)

% plot the results
plot(currents, spikes);
%%% TODO %%% add the axis names and title
%%% TODO %%% Add the figure to your report and explain what do you see


