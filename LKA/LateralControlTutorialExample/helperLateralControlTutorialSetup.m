% Set up Script for the Lateral Control Tutorial example.
%
% This script initializes the Lateral Control Tutorial example model.
% It loads necessary control constants and sets up the buses required for 
% the model.
%
%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2018 The MathWorks, Inc.

%% Vehicle Parameters
wheelbase = 2.8;         % Wheelbase of the vehicle (m)

%% General Model Parameters
Ts = 0.05;               % Simulation sample time (s) 

%% Create scenario and road specifications
[scenario,roadCenters,laneSpecification,speed] = helperCreateDrivingScenario;

% You can use Driving Scenario Designer to explore the scenario
% drivingScenarioDesigner('LateralControl')

%% Generate data for Simulink simulation  
[refPoses,x0,y0,theta0,curvatures,cumLengths, simStopTime] = helperCreateReferencePath(scenario);

directions   = ones(size(refPoses, 1), 1);
speedProfile = ones(size(refPoses, 1), 1)*speed;

% clear BusActors bus if it exists
if exist('BusActors','var')
    clear BusActors
    clear BusActorsActors
end

%% Bus Creation
% Create the bus of actors from the scenario reader
modelName = 'LateralControlTutorial';
wasModelLoaded = bdIsLoaded(modelName);
if ~wasModelLoaded
    load_system(modelName)
end

% Create buses for lane sensor and lane sensor boundaries
helperCreateLaneSensorBuses;