%% init
addpath('./VehicleModel/SingleTrackFullModel');
addpath('./VehicleModel/SingleTrackFullModel/Functions_and_scripts');
run init;

%% params
brake_K = 0;
initV = 70;
abs_on = 1;
steer = 0;