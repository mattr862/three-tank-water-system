% Matthew Reaney, QUB
% April 2023
% https://github.com/mattr862/three-tank-water-system

function [Rout, AS] = Y_attack_generator(Rin, A_Info, T, TS) 
%outputs = Recording Outout, Attack Signal
%inputs = Recording input, attack info, time, target signal
AS = zeros(3,1); % intialize attack signal

%% Replay attack buffer
if T == 0
    Rin = zeros(100, 3);
    Rout = Rin;
    Rout(1,:) = transpose(TS);
else
    Rout = Rin;
    Rout(1,:) = transpose(TS);
    for i = 1:99
         Rout(i+1,:) = Rin(i,:);
         i = i + 1;
    end
end

%% Attack Modeling
if T >= A_Info(5) && T <= A_Info(6) % attack time period
    i = 1;
    for i = 1:3
        switch A_Info(i)
            case 1 % FDI
                AS(i) = A_Info(8)*rand(1);
            case 2 % Bias
                AS(i) = A_Info(9); 
            case 3 % Dos
                AS(i) = -TS(i);
            case 4 % Sign_alt
                AS(i) = -2*TS(i); 
            case 5 % Rerouting
                TSR = [TS(2); TS(1); TS(3)]; % swaps values
                AS(i) = -TS(i) + TSR(i); % Combine with blank signal
            case 6 % Replay
                ti = uint16((A_Info(6)-A_Info(5))*100); % convert time to index value
                AS(i) = -TS(i) + Rin(ti,i);
            otherwise % None
                AS(i) = 0;
        end
        i = i + 1;
    end
end      

%% Console output
if T == 0 && (A_Info(1) ~= 0 || A_Info(2) ~= 0 || A_Info(3) ~= 0)
    if A_Info(7) == 1
        fprintf('Attempting Stealthy Attacks on Output from %f to %.2f\n', A_Info(5), A_Info(6));
    else
        fprintf('Attacking Output from %f to %.2f\n', A_Info(5), A_Info(6));
    end
    i = 1;
    for i = 1:3
        switch A_Info(i)
            case 1 % FDI
                fprintf('Output %i: FDI Attack\n', int8(i));
            case 2 % Bias
                fprintf('Output %i: Bias Attack\n', int8(i));
            case 3 % Dos
                fprintf('Output %i: Dos Attack\n', int8(i));
            case 4 % Sign_alt
                fprintf('Output %i: Sign_alt Attack\n', int8(i));
            case 5 % Rerouting
                fprintf('Output %i: Rerouting Attack\n', int8(i));
            case 6 % Replay
                fprintf('Output %i: Replay Attack\n', int8(i));
                if A_Info(5)-(A_Info(6)-A_Info(5)) < 0
                    fprintf('Warning: Not enough time to record for replay attack duration\n');
                end
            otherwise
        end
        i = i + 1;
    end
end