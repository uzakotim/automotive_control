%% Weights
% Engine, AxleFront, AxleRare, Gearing, Transmission, Tank, Coachbuilder
% in kg
Names = ["Engine", "AxleFront", "AxleRare", "Gearing", "Transmission", "Tank", "Coachbuilder"]; % mass parts
Weights = [170, 220, 220, 60, 150, 70, 300]; %their weights

%% Configs of the car
% 1 - Engine
% 2 - AxleFront
% 3 - AxleRare
% 4 - Gearing
% 5 - Transmission
% 6 - Tank
% 7 - Coachbuilder (with position in the center by default)

Fabia.Front = [1, 2, 4, 5]; %parts, placed in the front
Fabia.Back = [3, 6]; % in back
Fabia.Center = [7]; %in the center of car
Fabia.Dist = 1.5; % m % dist from the center of car to the front or rear axle
Fabia.Mass = sum(Weights);
Fabia.RR = 0.33; % radius of the rear wheel
Fabia.RF = 0.33; % radius of the front wheel
Fabia.JR = 1; % moment of inertia of the rear wheel
Fabia.JF = 1; % moment of inertia of the front wheel

BMW.Front = [1, 2, 5];
BMW.Back = [3, 4, 6];
BMW.Center = [7];
BMW.Dist = 1.5; % m
BMW.Mass = Fabia.Mass;
BMW.RR = 0.33;
BMW.RF = 0.33;
BMW.JR = 1;
BMW.JF = 1;

Porsche928.Front = [1, 2];
Porsche928.Back = [3, 4, 5, 6];
Porsche928.Center = [7];
Porsche928.Dist = 1.5; % m
Porsche928.Mass = Fabia.Mass;
Porsche928.RR = 0.33;
Porsche928.RF = 0.33;
Porsche928.JR = 1;
Porsche928.JF = 1;

RCcar.Front = [1, 2];
RCcar.Back = [3, 4, 5, 6];
RCcar.Center = [7];
RCcar.Dist = 0.3; % m
RCcar.Mass = 15;
RCcar.RR = 0.05;
RCcar.RF = 0.05;
RCcar.JR = 1;
RCcar.JF = 1;

Porsche911.Front = [2];
Porsche911.Back = [1, 3, 4, 5, 6];
Porsche911.Center = [7];
Porsche911.Dist = 1.5; % m
Porsche911.Mass = Fabia.Mass;
Porsche911.RR = 0.33;
Porsche911.RF = 0.33;
Porsche911.JR = 1;
Porsche911.JF = 1;

HalfStable.Front = [2];
HalfStable.Back = [3];
HalfStable.Center = [1, 4, 5, 6, 7];
HalfStable.Dist = 1.5; % m
HalfStable.Mass = Fabia.Mass;
HalfStable.RR = 0.33;
HalfStable.RF = 0.33;
HalfStable.JR = 1;
HalfStable.JF = 1;