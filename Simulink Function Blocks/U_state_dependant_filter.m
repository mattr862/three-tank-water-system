% Matthew Reaney, QUB
% April 2023
% https://github.com/mattr862/three-tank-water-system

function [AS, error, SC_out] = U_state_dependant_filter(as, y_hat, y, D_Info, T, A_Info,  SC_in)
%outputs = Attack Signal, error, Succcessful stealthy attack Count Out
%inputs = Attack Signal, Y_hat, Y, detector info, time, attack info,  Succcessful stealthy attack Count In
AS = zeros(4,1); % intialize attack signal

if A_Info(7) ~= 0
    %% Stealthy Attack Enabled
    % Succcessful stealthy attack Count (SC)
    if T == 0
        SC_in = 0;
    end
    SC_out = SC_in;

    % Stealty success console output
    if T == A_Info(6)
        fprintf('\nInput: Successfully preformed %i stealthy attacks out of a possible %.2i\n', int16(SC_out), int16((A_Info(6) - A_Info(5))*100)); 
    end
    
    % Mock Detector Responce
    difference = (y - y_hat);
    error = norm(difference, Inf);
    
    %If signal is stealthy use it
    if error < D_Info(1) && T >= A_Info(5) && T <= A_Info(6)
        AS = as;
        SC_out = SC_in + 1;
    end

else
    %% Stealthy Attack disabled
    AS = as;
    error = 0;
    SC_out = 0;
end


