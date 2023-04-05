% Matthew Reaney, QUB
% April 2023
% https://github.com/mattr862/three-tank-water-system

clear all
close all

%% Runtime Variables
st = 5; % stop time of model (s)
intialStates = [10; 15; 20]; % intial states of system
intialStates2 = [9.5; 14.5; 19.5]; % intial states of estimator
mn = [-0.15, 0.15, randi(1000)]; % Measurement Noise min, max, seed
in = [-0.05, 0.05, randi(1000)]; % Input Noise min, max, seed
D_Info = [1;5;3;3]; % anomaly detector configuration
AU_Info = zeros(9,1); % U attack configuration = off
AY_Info = zeros(9,1); % Y attack configuration = off
out.flag = 0; % intialise detector flag

%% Plant Variables
A = [0.96 0 0; 0.04 0.97 0; -0.04 0 0.90];
B = [8.8 -2.3 0 0; 0.20 2.2 4.9 0; -0.21 -2.2 1.9 21];
C = eye(3);
D = 0;
T = 0.01; % sample time

% open loop variables
Ad = expm(A*T);
Bd = pinv(A)*(Ad - eye(3))*B;
[k,s,e] = dlqr(Ad,Bd,eye(3),eye(4)); % k = gain

%closed loop varibles
K2d = place(Ad',C',e); 
Ad2 = Ad - K2d*C;
Bd2 = [Bd K2d];