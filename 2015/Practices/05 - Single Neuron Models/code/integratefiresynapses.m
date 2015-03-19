%
% Session: Signle Neuron Models
% Exerise 5: Integrate and Fire with synapses
% Adopted from http://math.bu.edu/people/mak/MA665 course materials
%
%
%

clear all
clf

t = (0:600); %duration of simulation 600 time steps

%Neuron Parameters
%----------
C = 2; %capa
R = 10; %resistance

ur =  -0.5; %reset potential
u0 = 0; % resting potential

q = 1.3; %total charge

tc = -100000; 
th = 1; %the neuron threshold
taus = 5;
tauc = 10;

u = zeros(length(t), 1); %membrane potential

%%% TODO %%%
% Change the vector of incoming spikes to achieve the following:
%   1. Inside the time window from 0 to 200 ms there will be 4 incoming
%      spikes and 1 output spike.
%   2. Inside the time window from 200 to 400 ms there will 5 incoming
%      spikes and 0 output spikes.
%   3. Is is possible to produce 2 output spikes with 5 incoming spikes?
%      If yes, then produce it in time window 400 to 600 ms, if not show
%      the maximal voltages you can achieve with 5 input spikes.
%
f = [10 20 30 50 60]; %the spike times of the presynaptic neuron
seps = 0;

for i=1:length(t);					 
	
	seps = 0;
	for j=1:length(f);
		
        eps = 0;
	  
        if (tc <= f(j) && f(j) <= i)
            eps = exp(-(i -f(j))/(R*C)) - exp(-(i-f(j))/taus);
        end
	   
        if (f(j) < tc && tc <= i)
            eps = exp(-(tc-f(j))/taus)*(exp(-(i-tc)/(R*C)) - exp(-(i-tc)/taus));
        end
	   
        seps = seps + eps;
		
	end;
	
	u(i) = u0 + (ur - u0) * exp(-( i - tc) / (R*C))  +q/C * 1/(1-taus/(R*C))*seps; 
  
	if(u(i) >= th)   %generate spike			  
        tc = i;
        u(i) = ur;
	end
	
end 



%plot membrane potential vs time
plot(t,u);
hold on; plot([0 600],[1 1],'--');
axis([0 600 -2 1.5])
xlabel('time [\tau]');
ylabel('u(t)')   
