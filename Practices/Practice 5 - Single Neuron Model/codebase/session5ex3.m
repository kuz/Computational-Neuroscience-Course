%
% Session 5: Signle Neuron Models
% Exerise 3: Integrate and Fire
% Adopted from http://math.bu.edu/people/mak/MA665 course materials
%


% The "TODO" marker will indicate the places where you have to do something:
% complete the code, plot and report a figure, give an interpretation, etc.


% How do we compute a numerical solution to the integrate and fire model?
% The basic idea is to rearrange the differential equation to get V(t+1) on
% the left hand side, and V(t) on the right hand side.  Then, if we know
% what's happening at time t, we can calculate what's happening at time t+1
% Then differential equation for Integrate-and-Fire will become
%
%       V(t+1) = V(t) + dt*(I/C)
%
% and we can use that to predict what the voltage would be at the next
% moment of time


%% The Beginning
clear all
clf

% first, let's set the values for the parameters I and C.
I = 3.0;
C = 1.0;

% we also need to set the value for dt.  This defines the time step in the
% problem.  We must choose it small enough so that we don't miss anything
% interesting.  We'll choose (in seconds):
dt = 0.001;

% we need to set some initial value, so let the voltage at the time 1 to be 0
V(1) = 0.0;

% now we have an equation and the the value at time 1, we can calculate the
% value at time 2 and 3
V(2) = %%% TODO %%% Calculate the value at the time 2
V(3) = %%% TODO %%% Calculate the value at the time 3

% but let's say that we want to simulate not 2 or 3 time moment, but a
% longer period of time, let's say 1 second
T = 1;

% for that we need to make 1000 steps (since our dt is 0.001 sec)
number_of_steps = T/dt;

% and now we can create a loop to predict all the values
for t=1:number_of_steps
    V(t+1) = %%% TODO %%% calculate the value a the time t
end

% and plot the result
t = (1:length(V))*dt;
plot(t, V);

%%% TODO %%% Add the figure to your report and explain what do you see


%% The threshold
clear all
clf

% now we have dealt with the "integrate" part, but what about "fire"?
% to simulate that we need to add a threshold, upon reaching which the
% neuron will fire and the potential will go bach to initial values
% let us define these two things
Vinit = 0.0;
Vth   = 1.0;

% redefine all the variables
I = 3.0;
C = 1.0;
dt = 0.001;
V(1) = 0.0;
T = 1;
number_of_steps = T/dt;

% and run the cycle again, but this time if values V(t) exceedes the
% threshold we will reset the voltage
for t=1:number_of_steps
    %%% TODO %%% Check whether currect value of V is larger then threshold
        V(t) = Vinit;
    end
    V(t+1) = %%% TODO %%% Calculate the value a the time t
end

% plot the result
t = (1:length(V))*dt;
plot(t, V);

%%% TODO %%% Add the figure to your report and explain what do you see


%% Count the spikes
clear all
clf

% we are very interested in the number of spikes, which will occur, thus we
% will will create separate counter for that
number_of_spikes = 0;

% redefine all the variables
I = 3.0;
C = 1.0;
dt = 0.001;
V(1) = 0.0;
T = 1;
number_of_steps = T/dt;
Vinit = 0.0;
Vth   = 1.0;

% and repeat the code we had before but this time we will increase the
% counter each time we reach the threshold
for t=1:number_of_steps
    %%% TODO %%% Check whether currect value of V is larger then threshold
        V(t) = Vinit;
        number_of_spikes = %%% TODO %%% Increase the counter by 1
    end
    V(t+1) = %%% TODO %%% calculate the value a the time t
end

% plot the result
t = (1:length(V))*dt;
plot(t, V);

% and output the counter
number_of_spikes


%% A different current
clear all
clf

% What will happen if we increase the current?
I = 10;

% redefine all the variables (except for the current I)
C = 1.0;
dt = 0.001;
V(1) = 0.0;
T = 1;
number_of_steps = T/dt;
Vinit = 0.0;
Vth   = 1.0;
number_of_spikes = 0;

%%% TODO %%% Run exaclty same loop as before an count the spikes
%%% TODO %%% Produce a plot add it to your report
%%% TODO %%% Output the number of spikes
%%% TODO %%% Descibe what happened in your report


%% The relationship between the current and the number of spikes
clear all
clf

% the next thing we wouls like to know is how the number of spikes depends
% on the current we put in

% redefine all the variables
C = 1.0;
I = 1.0;
dt = 0.001;
V(1) = 0.0;
T = 1;
number_of_steps = T/dt;
Vinit = 0.0;
Vth   = 1.0;

% we will check currents from 1 to 20
ncurrents = 20;

% and store number of spikes in the vector
spikes = zeros(1, ncurrents);

% for each current
for current = 1:ncurrents
    
    % prepare empty vector for storing values
    V = zeros(1, number_of_steps);
    
    % for each time moment
    for t = 1:number_of_steps
        
        %%% TODO %%% Check whether currect value of V is larger then threshold
            V(t) = Vinit;
            spikes(current) = %%% TODO %%% Increase the counter by 1
        end
        V(t+1) = %%% TODO %%% calculate the value a the time t
    end
end

% now we plot number of spikes for each of the currents
plot(1:ncurrents, spikes);

%%% TODO %%% Add the figure to your report and explain what do you see

%%% TODO %%% Play with I and T variables and report your observations


%% The Noise
clear all
clf

% The thing we have built here is nice, easy and works like a clock. But on
% the other hand you can recall that when we dealt with real spiking data
% then for same stimulus the firings appeared quite different times... our
% pretty model here does not simulate that, so let's make it more noisy.

% redefine all the variables
C = 1.0;
I = 10.0;
dt = 0.001;
V(1) = 0.0;
T = 1;
number_of_steps = T/dt;
Vinit = 0.0;
Vth   = 1.0;

% define the level of noise (higher means more noisy)
noise = 1.0; 

% clear the V variable
V = zeros(1, number_of_steps);

% and repeat the very same loop ...
for t=1:number_of_steps
    %%% TODO %%% Check whether currect value of V is larger then threshold
        V(t) = 0;
    end
    
    % ... but in addition to our usual equation we will add some noise
    V(t+1) = V(t) + dt*(I/C) + noise*sqrt(dt)*randn;
end

% plor the results
t = (1:length(V))*dt;
plot(t, V);

%%% TODO %%% Add the figure to your report and explain what do you see


%% Simulate piece of data
clear all
clf

% now let us simulate piece of real-looking spiking data, in the end we
% shall obtain the raster plot similar to what we had in the Session 3

% redefine some variables
C = 1.0;
dt = 0.001;
Vinit = 0.0;
Vth   = 1.0;

% noise level
noise = 1.0;

% prapare matrix to store voltages during 10 trials
voltage = zeros(10, 5001);

% prapare matrix to store spike data during 10 trials
spikes  = zeros(10, 5001);

for trial = 1:10
    
    % 1 second of pre-stimulus with current 0
    I = 0;
    for t = 1:1000
        if voltage(trial, t) > Vth
            voltage(trial, t) = 0;
            spikes(trial, t) = 1;
        else
            spikes(trial, t) = 0;
        end
        voltage(trial, t+1) = voltage(trial, t) + dt*(I/C) + noise*sqrt(dt)*randn;
    end
    
    % 3 seconds of the stimulus with current 5
    I = 5;
    for t = 1001:4000
        if voltage(trial, t) > Vth
            voltage(trial, t) = 0;
            spikes(trial, t) = 1;
        else
            spikes(trial, t) = 0;
        end
        voltage(trial, t+1) = voltage(trial, t) + dt*(I/C) + noise*sqrt(dt)*randn;
    end
    
    % 1 second of post-stimulus with current 0
    %%% TODO %%%
    % simaulte last 1000 ms of data with current 0 (analogous to
    % the first 1000 ms of our data)

end

% use raster plot from Seesion 3 to visualize generated data
for trial = 1:10
    for t = 1:size(spikes,2)
        if spikes(trial, t) == 1
            line([t t], [trial trial+0.5], 'Color', 'k');
        end
    end
end

% add labels to X and Y axis
xlabel('Time (ms)', 'FontSize', 16);
ylabel('Trial', 'FontSize', 16);

%%% TODO %%% Play with the noise parameter and post at least three figures
% 1) No noise
% 2) Moderate noise: spiking pattern is somewhat recognizible
% 3) Too much noise: data appears to be completely random
% Comment the results