% Author: Ardi Tampuu, University Of Tartu
%
% Session: Single Neuron Models
% Exerise on Integrate and Fire with synapses
% Spike currents adopted from http://math.bu.edu/people/mak/MA665 course materials
%
%
%

%%%%%%%%%%%%%%%%

clear all
clf

T = 0.6; %duration of simulation in sec
dt=0.001;
number_of_steps = T/dt


%Neuron Parameters
%----------
I_const = 0.0; % we are looking into synapses, so no injected current
C = 0.1; % capacity
R = 1; % resistance

Vr =  -75.0; % reset potential in mV
V0 = -70.0; % resting potential in mV

spike_strength = 70.0; % this will modify how strong the effect of spikes are
                       %%% TODO 1.3 %%% increase the strength. 
                       % !!NB!! set it back to 70 afterwards!!

tc = -100000; 
th = -55.0; %the neuron threshold
taus = 5; % this defines the shape of the spike (how long the tail is)
          %%% TODO 1 %%% relate it to the I_syaptic shape


%Vm = ones(number_of_steps,1)*-70.0; %membrane potential
Vm(1) = V0;
I_syn(1) = 0;


f = [300]; %%% TODO 1 %%% In the first task the neuron receives just one spike. 
           % Uncomment plotting function below. Describe the shape and duration of the incoming current 
           % and the shape of its effect on the membrane potential. 
           % Q1 In how much time is I_syn reduced to half of its initial strength? What does it tell you about the "taus" parameter?
           % Q2 How high does the membrane potential reach at its maximum after receiving only one spike?
           % Q3 How strong should the "spike_strenght" (above) so that only one incoming spike would suffice to generate a postsynaptic spike?
           % always add the plots to pdf

%f = [50 100 150 200 250 300 350 400 450 500 550]; %the spike times of the presynaptic neuron(s)
           %%% TODO 2 %%% (set the spike strenght back to 70.0) Plot the behaviour. Describe what happens. 
           % Why does the neuron not spike even though it receives plenty of incoming spikes?
%f = [100 101 t3]; %%% TODO 3 %%% Find the lowest possible t3 so that the postsynaptic neuron would not spike.


seps = 0;

for i=1:(number_of_steps-1)	
        if(Vm(i) >= th)   %generate spike
          tc = i %synaptic currents want to know the last spike time		  
          Vm(i) = Vr;
	end
		
        %The following stuff has to do with shape of incoming current caused by spikes		 
	seps = 0;
	for j=1:length(f);
          eps = 0;
          if (tc <= f(j) && f(j) <= i)
            eps = exp(-(i -f(j))/(R*C)) - exp(-(i-f(j))/taus);
          end
	   
          if (f(j) < tc && tc <= i)
            eps = exp(-(tc-f(j))/taus)*(exp(-(i-tc)/(R*C)) - exp(-(i-tc)/taus));
          end
          seps = seps + eps; %current from spikes at time t
          % end of spike current calculation
	
	end
	I_syn(i) = spike_strength * 1/(1-taus/(R*C))*seps; %we keep track of this for TODO 1
        %i_leak = dt*(V0-Vm(i))/(R*C);
        %i_injected = dt*I_const/C;
        Vm(i+1) = Vm(i) + dt*(V0 - Vm(i) )/(R*C) + (dt*I_const/C) + spike_strength * 1/(1-taus/(R*C))*seps;	
end 

%%% TODO 1 %%% uncomment the lines below and plot the shape of synaptic current in time
%t = (1:length(Vm)-1);
%plot(t, I_syn);
%xlim([290.0,350.0])
%pause 

%%% TODO always%%%
%plot membrane potential vs time
t = (1:length(Vm));
plot(t, Vm);
ylim([-80.0,-50.0])

xlabel('time [ms]');
ylabel('Vm(t)  [mV]')   

