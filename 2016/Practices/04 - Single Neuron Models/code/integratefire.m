%
% Session: Signle Neuron Models
% Exerise 2: Integrate and Fire
% Adopted from http://math.bu.edu/people/mak/MA665 course materials
%


% The "TODO" marker will indicate the places where you have to do something:
% complete the code, plot and report a figure, give an interpretation, etc.


% THEORY: How do we compute a !!numerical solution!! to the integrate and fire model?

% In course materials we had:
% Cm*(dV/dt)= I_total, where I_total is the sum of I_l (leak current) 
% and I_input (current injected to the cell)

% For solving this equation numerically we first notice that dV is the change in V during timeperiod dt, so for any moment in time t:
% dV = V(t+dt)-V(t)

% For clarity, from here onwards we will count time in units equal to dt, so time t+3 means t+3*dt
% dV = V(t+1)-V(t)

% From there we to rearrange the differential equation to get the new voltage V(t+1) on
% the left hand side, and V(t) on the right hand side.  This means that if we know
% what's happening at time t, we can calculate what's happening at time t+1. Then knowing 
% what happened at t+1, we can find t+2 and so on. We will calculate V for consequtive timepoints
% separated by dt.
% The differential equation for Integrate-and-Fire will become
%
%       V(t+1) = V(t) + dt*(I/Cm)
%
% we can use that to predict what the voltage would be at the next
% moment of time



%% The Beginning - how to calculate one timestep
clear all
clf

% first, let's set the values for the parameters I (sum total current) and C (capaticy of membrane).
% notice we are not talking about units, because its the relative proportion of I and C that matters
% this is a common practice, not our laziness.
I = 3.0;
C = 1.0;

% we also need to set the value for dt. This defines the time step we take
% when numerically solving the problem. 
% If dt is too small we will need to do too many calculations.
% If dt is too big, say 10ms, our result is not precise and does not reflect reality because the changes
% in membrane potential actually happen a lot faster.
% We'll choose (in seconds):
dt = 0.001;
%(If you are interested try with bigger dt too.. see how it messes up the system)

% we need to set some initial value, so let the voltage at the time 1 to be -70 mV	
Vinit= -70.0
V(1) = Vinit;

% now we have an equation and the the value at time 1, we can calculate the
% value at time 2 and 3
V(2) = %%% TODO 1 %%% Calculate the value at the time 2
V(3) = %%% TODO 2 %%% Calculate the value at the time 3

% but let's say that we want to simulate not 2 or 3 time moment, but a
% longer period of time, let's say 1 second
T = 1;
% for that we need to make 1000 steps (since our dt is 0.001 sec)
number_of_steps = T/dt;



%%%%%%% Main part of the exercise begins here %%%%%%%%

%Let's summarize the variables again, and add some other we will need later on
T = 1; %in seconds 
dt = 0.001;
number_of_steps = T/dt;
Vinit= -70.0
I = 3.0; %%% TODO 6 %%% set I to 10.0, plot and count the spikes again
         %%% TODO 7 %%% set I to 5.0, to 10.0, 20.0, 50.0, 100.0 Count the spikes. What is the relationship between input and nr of spikes?
C = 0.1; % Capacity of the membrane
Vth= -55.0 %threshold above which the neuron spikes
number_of_spikes = 0; 
noise = 1.0

for t=1:number_of_steps %for all timesteps

    if 0 %%% TODO 4 %%% replace the "if 0" with "if V(t) is above threshold voltage" 
      V(t) = Vinit; % reset V
      number_of_spikes = 0; %%% TODO 5 %%% (replace the 0) add 1 to number_of_spikes every
                            % time we reach this line (every time there is a spike) 
    end
    % the main operation -- what is V(t+1) equal to?
    V(t+1) = %%% TODO 3 %%%
             %%% TODO 8 %%% add noise term to the equation V(t+1)= .... + noise*sqrt(dt)*randn.
end

disp(sprintf("Number of spikes is %d",number_of_spikes))

% PLOT the results
t = (1:length(V))*dt;
plot(t, V);
xlabel('write x axis name here')
ylabel('write y axis name here')
%%% TODO after updates 3-8 %%% 
% Add the figure to your report and explain what you see and dont see(you can explain by comparing two plots)



disp("To proceed to second part, TODO9, press any key") %you need to press a key in your octave command window
pause
%%% TODO 9 %%%
%% Simulate some data and plot a rasterplot

clear all
clf

% Now let us simulate some real-looking spiking data, in the end we
% shall obtain raster plots for a neuron for 10 trials similar to what we had in the Session 3

% redefine some variables
C = 0.1;
dt = 0.001;
Vinit = -70.0;
Vth   = -55.0;

% noise level
noise = 1.0; %%% TODO 9 %%% change the noise level to get different behvaviour

% prapare matrix to store voltages during 10 trials
voltage = zeros(10, 5001);
voltage(:,1) = Vinit;
% prapare matrix to store spike data during 10 trials
spikes  = zeros(10, 5001);


% We will now generate data with our IAF neuron. Our "experiment" has 3 phases. 
% During first second there is no input current (I=0), then for 3 sec there is a current (stimulus),
% and finaly again a second without input

for trial = 1:10
    % 1 second of pre-stimulus with current 0
    I = 0;
    for t = 1:1000
        if voltage(trial, t) > Vth
            voltage(trial, t) = Vinit;
            spikes(trial, t) = 1;
        else
            spikes(trial, t) = 0;
        end
        voltage(trial, t+1) = voltage(trial, t) + dt*(I/C) + noise*sqrt(dt)*randn;
    end
    
    % 3 seconds of the stimulus with current 5
    I = 5.0;
    for t = 1001:4000
        if voltage(trial, t) > Vth
            voltage(trial, t) = Vinit;
            spikes(trial, t) = 1;
        else
            spikes(trial, t) = 0;
        end
        voltage(trial, t+1) = voltage(trial, t) + dt*(I/C) + noise*sqrt(dt)*randn;
    end
    
    for t = 4001:5001
        if voltage(trial, t) > Vth
            voltage(trial, t) = Vinit;
            spikes(trial, t) = 1;
        else
            spikes(trial, t) = 0;
        end
        voltage(trial, t+1) = voltage(trial, t) + dt*(I/C) + noise*sqrt(dt)*randn;
    end

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
ylim([0.9 10.6])
xlabel('Time (ms)', 'FontSize', 16);
ylabel('Trial', 'FontSize', 16);


%%% TODO 9 %%% Play with the noise parameter and add at least three figures to the pdf
% 1) No noise
% 2) Moderate noise: spiking pattern is somewhat recognizible
% 3) Too much noise: data appears to be completely random
% Comment the results

