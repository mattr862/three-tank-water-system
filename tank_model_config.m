% Matthew Reaney, QUB
% April 2023
% https://github.com/mattr862/three-tank-water-system

%% General Runtime Variables
st = 5; % stop time of model (s)
intialStates = [ % intial states of system
    10; % x1 = Tank 3 volume
    15; % x2 = Tank 2 volume
    20 % x3 = Tank 2 temperature
    ]; 
intialStates2 = [ % intial states of estimator
    9.5; % x1 = Tank 3 volume
    14.5; % x2 = Tank 2 volume
    19.5 % x3 = Tank 2 temperature
    ]; 

%% Noise/Uncertainties
mn = [ % Measurement Noise
    -0.15, ... % min
    0.15, ... % max
    randi(1000) % seed
    ]; 
in = [ % Input Noise
    -0.05, ... % min
    0.05, ... % max 
    randi(1000) % seed
    ];  

%% Anomaly Detector Configuration
D_Info = [
    1; % error threshold
    5; % buffer size (max 100)
    3; % consecutive errors required to raise alarm
    3; % total errors in buffer required to raise alarm
    ];

%% Input (U) Attack Configuration 
AU_Info = [
    1; % Attack type, u1 = flow rate of pump 2
    1; % Attack type, u2 = openness of value
    1; % Attack type, u3 = flow rate of pump 1
    1; % Attack type, u4 = power of heater
    2; % Start time (s)
    4; % End time (s)
    0; % Stealth filter (0=off)
    1; % FDI attack scaler for random numbers
    0; % Bias attack offset value
    ];

%% Output (Y) Attack Configuration
AY_Info = [
    0; % Attack type, Y1 = Tank 3 volume
    0; % Attack type, Y2 = Tank 2 volume
    0; % Attack type, Y3 = Tank 2 temperature
    0; % Unused
    0; % Start time (s)
    0; % End time (s)
    0; % Stealth filter (0=off) % not working
    0; % FDI attack scaler for random numbers
    0; % Bias attack offset value
    ];

%% Attack types
% 0 = None
% 1 = FDI
% 2 = Bias
% 3 = Dos
% 4 = Sign_alt
% 5 = Rerouting
% 6 = Replay
% please note for using replay attacks you may need to run the unattacked
% model beforehad to ensure the recording storage is operating correctly.