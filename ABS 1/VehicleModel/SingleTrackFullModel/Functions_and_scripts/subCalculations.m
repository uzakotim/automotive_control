function [LF, LR, PosGCProc, Fzf, Fzb, Iz] = subCalculations(car, Weights)
%% GC calculation
up = 0;
down = 0;
for i=1:length(car.Front)
    up = up + Weights(car.Front(i)) * -car.Dist;
    down = down + Weights(car.Front(i));
end
for i=1:length(car.Back)
    up = up + Weights(car.Back(i)) * car.Dist;
    down = down + Weights(car.Back(i));
end
for i=1:length(car.Center)
    down = down + Weights(car.Center(i));
end

delta_x = up/down;
totalLength = 2*car.Dist;
LF = totalLength/2 + delta_x; % From front
LR = totalLength - LF;
PosGCProc = 100*LF/totalLength; % From front in %

%% Front and rear axles forces
Fzf = car.Mass * (1-LF/totalLength)* 9.81;
Fzb = car.Mass * LF/totalLength * 9.81;

%% Izz
Iz = 0;
for i=1:length(car.Front)
    Iz = Iz + Weights(car.Front(i))*(car.Dist+delta_x)^2;
end
for i=1:length(car.Back)
    Iz = Iz + Weights(car.Back(i))*(car.Dist+delta_x)^2;
end
for i=1:length(car.Center)
    Iz = Iz + Weights(car.Center(i))*delta_x^2;
end