classdef ABS < matlab.System
    % Untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        % Maximum slip ratio that shouldn't be excessed. Maximally 1 [-] 
        lambda_max = 0; 
        % Slip ratio to leave relaxation phase. Maximally 1, lower than Maximum slip ratio [-] 
        lambda_min_relaxing = 0;
        % Minimum slip ratio for ABS to work. If below only the fast ramp will be used. Maximally 1, lower than relaxation slip ratio [-] 
        lambda_min = 0; 
        % Fast ramp slope
        fast_ramp = 0;
        % Slow ramp slope
        slow_ramp = 0;
        % Threshold to switch from fast to slow ramp in percentage of last torque peak. Maximally 1 [-]
        fast_to_slow_slope_threshold = 0;
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)
        Brake_Nm;
        prevLag;
        isRelaxing;
        firstPeak;
        T_opt_last;
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.Brake_Nm = 0;
            obj.prevLag = 0;
            obj.isRelaxing = false;
            obj.firstPeak = true;
            obj.T_opt_last = 70;
        end

        function brake = stepImpl(obj,rpm,max_brake,car_speed,T_opt)
            brake = 0;
            if obj.T_opt_last ~= T_opt
                obj.T_opt_last = T_opt;                             % Change of surface
                obj.firstPeak = true;
                obj.Brake_Nm = T_opt;
            end
            if car_speed > 0.1                                      % Vehicle is moving
                if obj.isRelaxing == false                          % no relaxation phase
                    if rpm > (1-obj.lambda_max) * car_speed
                        if obj.firstPeak == true                    % no boundry to follow on the first peak
                            if (obj.Brake_Nm < T_opt) || (rpm > (1-obj.lambda_min) * car_speed)                 % If the optimal torque is known
                                obj.Brake_Nm = obj.Brake_Nm + obj.fast_ramp;% 5/5
                            else
                                obj.Brake_Nm = obj.Brake_Nm + obj.slow_ramp;
                            end
                        else
                            if (obj.Brake_Nm < obj.fast_to_slow_slope_threshold * obj.prevLag) || (rpm > (1-obj.lambda_min) * car_speed)     % After relaxation brake hard
                                obj.Brake_Nm = obj.Brake_Nm + obj.fast_ramp; % 5/5
                            else
                                obj.Brake_Nm = obj.Brake_Nm + obj.slow_ramp; % Brake softer
                            end
                        end
                    else
                        obj.prevLag = obj.Brake_Nm;                 % Wheels have got locked
                        obj.Brake_Nm = obj.Brake_Nm *0; % *k           
                        obj.isRelaxing = true;
                        obj.firstPeak = false;
                    end
                else                                                % relaxation phase
                    if rpm > (1-obj.lambda_min_relaxing) * car_speed
                        obj.isRelaxing = false;
                    end
                end
                obj.Brake_Nm = min(max(obj.Brake_Nm,0),max_brake);
                brake = obj.Brake_Nm;
            end
        end
    end
end
