%% This one is to test the evolutionary algorithm. The problem lies on that the proportion
% does not coneverge when the number of UAV is too small.

% author: Mi 

clc;clear;
%% params
 N = 1000;    % number of UAVs
 K= 3;     % number of BS
 B = 40; % the available bandwidth for each all UAVs
 b = 4;  % the minimum bandwidth allocation for UAVs of each BS
 
kn = 1; % price coeff
iter = 10;
flag = 0;
% ergodic rate: a function of distance between BS and UAV
Rng = [0.4885, 0.1456, 0.0307]; 
pn = [1,0.3,0.1];  % the price of each BS
 %% algorithm
 %Nng = randi(K, N,1);  % initialize
 Nng(1:300) = 1; 
 Nng(301:400) = 2; 
 Nng(401:1000) = 3; 
 
 Bn = [B/3;B/3;B/3];
 Bn_new = zeros(K,1);
 Bn_iter = [];
 Nng_iter = [];
 xng_iter = [];
 EU = [];

payoff_ave_whole = [];
 for it=1:iter
     %% evolutionary game
     for i=1:N
         Payoff_UAV(i) = log(1+kn*Bn(Nng(i))*Rng(Nng(i))/(pn(Nng(i))*length(find(Nng==Nng(i)))));   % calculate the payoff when a UAV choose a BS
     end
     
     payoff_ave_whole = [payoff_ave_whole;mean(Payoff_UAV)];
     
     a1 = 0;
     a2 = 0;
     a3 = 0;
     for i=1:N
         if Nng(i)==1
             a1 = a1+1;
         end
         if Nng(i)==2
             a2=a2+1;
         end
         if Nng(i)==3
             a3 =a3+1;
         end
     end
     xng = [a1/N,a2/N,a3/N];
     xng_iter = [xng_iter;xng];
     
     %% switch to another BS if a UAV has a better choice
     for i=1:N
         Payoff_UAV(i) = log(1+kn*Bn(Nng(i))*Rng(Nng(i))/(pn(Nng(i))*length(find(Nng==Nng(i)))));  
         if Payoff_UAV(i)< mean(Payoff_UAV)
             %switch to another base station   (will change it to another better payoff BS)
             for op = 1:K
                 payoff_switch = log(1+kn*Bn(op)*Rng(op)/(pn(op)*length(find(Nng==op))));
                 if payoff_switch > Payoff_UAV(i)
                     op_best = op;
                     break;
                 else
                     op_best = Nng(i);
                 end    
             end
             Nng(i) = op_best;
         end
     end
end

 %% figure
figure(2); set(gca,'FontSize',20,'FontName','Times');grid on;hold on
plot(0:9,xng_iter(:,1),'--go','Linewidth',2);hold on;
plot(0:9,xng_iter(:,2),'--b*','Linewidth',2);hold on;
plot(0:9,xng_iter(:,3),'--ms','Linewidth',2)
xlabel('Number of iteration');ylabel('Propotion of MDs connect to UAV');
legend('#MDs connect to UAV1','#MDs connect to UAV2','#MDs connect to UAV3');
%  
 figure(3);set(gca,'FontSize',20,'FontName','Times');grid on;hold on
 plot(0:9,payoff_ave_whole,'--o','Linewidth',2);
 xlabel('Number of iteration');
 ylabel('Average payoff');
 


