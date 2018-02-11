% Author: Ardi Tampuu, University Of Tartu
%
% Session: Single Neuron Models
% Exerise on Integrate and Fire with synapses
% Spike currents adopted from http://math.bu.edu/people/mak/MA665 course materials
%
%
%

%%%%%%%%%%%%%%%%
addpath "."
clear all
clf

T = 2; %duration of simulation in sec
dt=0.001;
number_of_steps = T/dt


%Neuron Parameters
%----------
I_const = [80.0 0.0]; % injected current to each cell
params.C = 0.1; % capacity
params.R = 1; % resistance
params.spike_strength = [-500.0 100.0]; % how incoming synapses influence the receiving neuron
params.taus = [15 2]; % how fast does the synaptic current decay? (half life)

Vr =  -75.0; % reset potential in mV
V0 = -70.0; % resting potential in mV



tc = -100000; 
th = -55.0; %the neuron threshold
noise = [10.0 0.0]; %no noise for inhibitory



n_neurons = 2

last_spike = [-100 -100];
connectivity = [0 1;1 0]; %A connects to be and B to A

spikes = zeros(T/dt,2);
Vm = zeros(T/dt,2);
Vm(1,:) = [V0+randn*5 V0+randn*5]; %initialize Vm randomly around 70

g_leak= [0.2,0.1]

for i=2:(number_of_steps-1)
   for n=1:n_neurons
        if(Vm(i-1,n) >= th)   %generate spike
          last_spike(n) = i-1 ;%synaptic currents want to know the last output spike time		  
          Vm(i-1,n) = Vr;
          spikes(i-1,n) = 1;
	end
   end

   for n=1:n_neurons
      neighbours = find(connectivity(n,:)==1);
      incoming_spikes=[];
      for ngh=neighbours
        incoming_spikes = [incoming_spikes ; find(spikes(1:i,ngh)==1)]; #find past timepoints where there was spikes in the neighbour
      end
      seps = synaptic_input(n,incoming_spikes, i , last_spike(n),params);

      I_syn = params.spike_strength(n) * 1/(1-params.taus(n)/(params.R*params.C))*seps; 
      I_noise = noise(n)*sqrt(dt)*randn;
      I_injected = dt*I_const(n)/params.C;
      I_leak = g_leak(n)*dt*(V0 - Vm(i-1,n))/(params.R*params.C);

      Vm(i,n) = Vm(i-1,n) + I_leak + I_injected + I_syn + I_noise;
   end 	

end 

disp(sprintf("first neuron spike count %d", sum(spikes(:,1))))
disp(sprintf("second neuron spike count %d", sum(spikes(:,2))))
%disp(find(spikes(:,1)==1)) %will print spiketimes
%disp(find(spikes(:,2)==1))

%%% TODO always%%%
%plot neuron 1 membrane potential vs time
t = (1:length(Vm(:,1)));
plot(t, Vm(:,1));
hold on
ylim([-100.0,-50.0])
xlabel('time [ms]');
ylabel('Vm(t)  [mV]')  
hold on

%plot neuron 2 membrane potential vs time
t = (1:length(Vm(:,1)));
plot(t, Vm(:,2), 'color','r');
legend('neuron A','neuron B')
scatter(find(spikes(:,1)==1),ones(sum(spikes(:,1)),1)*-55,'b','filled')
scatter(find(spikes(:,2)==1),ones(sum(spikes(:,2)),1)*-55,'r','filled')
hold off

