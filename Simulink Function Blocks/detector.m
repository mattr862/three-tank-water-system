% Matthew Reaney, QUB
% April 2023
% https://github.com/mattr862/three-tank-water-system

function [flag, difference, error, out_buffer] = detector(flag, D_Info, y, y_hat, T, in_buffer)
%% prevent flags during intialising system
if T < 1 
    flag = 0;
    difference = y - y_hat;
    error = norm(difference, Inf);
    in_buffer = zeros(100,1);
    out_buffer = in_buffer;
    out_buffer(1) = error;
else
    %% Calculate error/flag status for current iteration
    difference = y - y_hat; %difference between x and x^
    error = norm(difference, Inf); %absolute of infinity norm of error
    
    %% Store error in buffer
    out_buffer = in_buffer;
    out_buffer(1) = error;
    for i = 1:99
         out_buffer(i+1) = in_buffer(i);
         i = i + 1;
    end

    %% Evaluating error in buffer
    if flag == 0
        % calculate number of consecutive errors exceeding the threshold
        consecutive = 0; i = 0;
        for i = 1:D_Info(3)
            if  out_buffer(i) >= D_Info(1)
                consecutive = consecutive + 1;
            end
            i = i + 1;
        end
        if consecutive >= D_Info(3) && flag == 0 % consecutive errors check 
            flag = T;
            fprintf(['\nAnomaly detector flag raised at %f\n' ...
                'Due to sufficent consecutive errors exceeding the threshold\n'], T);
        end
        
        % calculate number of total errors exceeding the threshold
        total = 0; i = 0;
        for i = 1:D_Info(2)
            if  out_buffer(i) >= D_Info(1)
                total = total + 1;
            end
            i = i + 1;
        end
        if total >= D_Info(4) && flag == 0 % total errors check
            flag = T;
            fprintf(['\nAnomaly detector flag raised at %f\n' ...
                'Due to sufficent total errors exceeding the threshold\n'], T);
        end
    end
end