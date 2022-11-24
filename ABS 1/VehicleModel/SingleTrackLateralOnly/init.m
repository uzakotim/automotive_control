%%
clear all;
close all;
warning off;
addpath('ModelWithSimulator\RealTime_Pacer'); % used for the simulator
addpath('Functions_and_scripts');

%% init 
initV = 10;
initBeta = 0;
initR = 0;

%% Select Car Configs
LoadCarConfigs;
car = Porsche911; 
clear Fabia BMW Porsche928 Porsche911 HalfStable

%% Select Pacejka Config
LoadPacejkaConfigurations;
car.Pacejka = Classic; % (Aggressive, Classic, AlmostSaturation)
clear Aggressive Classic AlmostSaturation

%% GC and Izz + forces on axles calculation
[car.LF, car.LR, car.PosGCProc, car.Fzf, car.Fzb, car.Iz] = subCalculations(car,Weights);
clear Weights

%% Param to simulator
car.Sl = 1.932/2-0.208; % distance from CG to positive Y
car.Sr = 1.932/2-0.208; % distance from CG to negative Y
car.Sz = 0.12; % distance from CG to the point where springs are anchored
car.Lv = 1.38625-0.375; % distance from CG to positive X
car.Lh = 1.38625+0.375; % distance from CG to negative X

car.r1 = [car.Lv , car.Sl , -car.Sz]';
car.r2 = [car.Lv , -car.Sr, -car.Sz]';
car.r3 = [-car.Lh, car.Sl , -car.Sz]';
car.r4 = [-car.Lh, -car.Sr, -car.Sz]';

%% stuff for model in function
busInfo = Simulink.Bus.createObject(car);
pom = Simulink.Bus.objectToCell({busInfo.busName});
pom2 = pom{1};
pom2{1} = 'car_bus';
pom{1} = pom2;
Simulink.Bus.cellToObject(pom);
