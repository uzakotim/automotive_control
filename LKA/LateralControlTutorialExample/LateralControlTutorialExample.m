%% Lateral Control Tutorial
% This example shows how to control the steering angle of a vehicle that is
% following a planned path while changing lanes, using the 
% <docid:driving_ref#mw_c24d94d4-eda0-4afc-a933-ae8ccad7c525 Lateral
% Controller Stanley> block. 

%   Copyright 2018 The MathWorks, Inc.

%% Overview
% Vehicle control is the final step in a navigation system and is typically
% accomplished using two independent controllers:
%
% * *Lateral Controller*: Adjust the steering angle such that the vehicle 
% follows the reference path. The controller minimizes the distance between
% the current vehicle position and the reference path.
% * *Longitudinal Controller*: While following the reference path, maintain the 
% desired speed by controlling the throttle and the brake. The controller 
% minimizes the difference between the heading angle of the vehicle and the 
% orientation of the reference path.
% 
% This example focuses on lateral control in the context of path following
% in a constant longitudinal velocity scenario. In the example, you will:
%  
% # Learn about the algorithm behind the 
% <docid:driving_ref#mw_c24d94d4-eda0-4afc-a933-ae8ccad7c525 Lateral Controller Stanley> block.  
% # Create a driving scenario using the <docid:driving_ref#mw_07e6310f-b9c9-4f4c-b2f9-51e31d407766 Driving Scenario Designer>  
% app and generate a reference path for the vehicle to follow.
% # Test the lateral controller in the scenario using a closed-loop 
% Simulink(R) model.
% # Visualize the scenario and the associated simulation results using the
% <docid:driving_ref#mw_59742eb7-dce8-4938-9c2e-44d34c7b8891 Bird's-Eye
% Scope>.

%% Lateral Controller
% The Stanley lateral controller [1] uses a nonlinear control law to
% minimize the cross-track error and the heading angle of the front wheel 
% relative to the reference path. The <docid:driving_ref#mw_c24d94d4-eda0-4afc-a933-ae8ccad7c525 Lateral
% Controller Stanley> block computes the steering angle command 
% that adjusts a vehicle's current pose to match a reference pose.
%
% <<../latControllerCrosstrack.png>>
%
% Depending on the vehicle model used in deriving the control law, the
% Lateral Controller Stanley block has two configurations [1]: 
%
% * *Kinematic bicycle model*: The kinematic model assumes that the vehicle has 
% negligible inertia. This configuration is mainly suitable for low-speed 
% environments, where inertial effects are minimal. The steering command is  
% computed based on the reference pose, the current pose, and the velocity 
% of the vehicle. 
% * *Dynamic bicycle model*: The dynamic model includes inertia effects:
% tire slip and steering servo actuation. This more complicated, but more
% accurate, model allows the controller to handle realistic dynamics. In
% this configuration, the controller also requires the path curvature, the
% current yaw rate of the vehicle, and the current steering angle to compute
% the steering command.
%
% You can set the configuration through the *Vehicle model* parameter in
% the block dialog box. 
%
%% Scenario Creation
% The scenario was created using the 
% <docid:driving_ref#mw_07e6310f-b9c9-4f4c-b2f9-51e31d407766 Driving Scenario Designer> app. 
% This scenario includes a single, three-lane road and the ego vehicle.
% For detailed steps on adding roads, lanes, and vehicles, see 
% <docid:driving_ug#mw_e49e404a-0301-4634-b5c2-c8a6da2db9f6 Generate Synthetic Detections from an Interactive Driving Scenario>.
% In this scenario, the vehicle:
%
% # Starts in the middle lane.
% # Switches to the left lane after entering the curved part of the road.
% # Changes back to the middle lane. 
%
% Throughout the simulation, the vehicle runs at a constant velocity of 10 meters/second. 
% This scenario was exported from the app as a MATLAB(R) function using the
% *Export > Export MATLAB Function* button. The exported 
% function is named |<matlab:openExample('driving/LateralControlTutorialExample','supportingFile','helperCreateDrivingScenario.m') helperCreateDrivingScenario>|.
% The roads and actors from this scenario were saved to the scenario file
% |LateralControl.mat|.
%
% <<../LaneChangePathFollowing.PNG>>
%

%% Model Setup
% Open the Simulink tutorial model.
%
%   open_system('LateralControlTutorial')
%
open_system('LateralControlTutorial')
snapnow

%%
% The model contains the following main components:
%
% * A *Lateral Controller* <docid:simulink_ref#bsleobx-1 Variant Subsystem> 
% which contains two <docid:driving_ref#mw_c24d94d4-eda0-4afc-a933-ae8ccad7c525 Lateral Controller Stanley> 
% blocks, one configured with a kinematic bicycle model and the other one with 
% a dynamic bicycle model. They both can control the steering angle of the vehicle.
% You can specify the active one from the command line. For example, to 
% select the Lateral Controller Stanley Kinematic block, use the following
% command:
%    
%   variant = 'LateralControlTutorial/Lateral Controller';
%   set_param(variant, 'LabelModeActivechoice', 'Kinematic');
%
% * A |<matlab:openExample('driving/LateralControlTutorialExample','supportingFile','HelperPathAnalyzer.m') HelperPathAnalyzer>|
% block, which provides the reference signal for the lateral controller.
% Given the current pose of the vehicle, it determines the reference pose 
% by searching for the closest point to the vehicle on the reference path.
% * A *Vehicle and Environment* subsystem, which models the motion of the 
% vehicle using a <docid:vdynblks_ref#mw_663703c2-aa89-4eac-b073-421cdc5818bc Vehicle Body 3DOF>
% block. The subsystem also models the environment by using a  
% <docid:driving_ref#mw_0abe0f52-f25a-4829-babb-d9bafe8fdbf3 Scenario Reader> block
% to read the roads and actors from the LateralControl.mat scenario file.
variant = 'LateralControlTutorial/Lateral Controller';
set_param(variant, 'LabelModeActivechoice', 'Kinematic');
%%
% Opening the model also runs the 
% |<matlab:openExample('driving/LateralControlTutorialExample','supportingFile','helperLateralControlTutorialSetup.m') helperLateralControlTutorialSetup>|
% script, which initializes data used by the model. The script
% loads certain constants needed by the Simulink model, such as vehicle  
% parameters, controller parameters, the road scenario, and reference poses. 
% In particular, the script calls the previously exported function 
% |<matlab:openExample('driving/LateralControlTutorialExample','supportingFile','helperCreateDrivingScenario.m') helperCreateDrivingScenario>|
% to build the scenario. The script also sets up the buses required for the 
% model by calling |<matlab:openExample('driving/LateralControlTutorialExample','supportingFile','helperCreateLaneSensorBuses.m') helperCreateLaneSensorBuses>|.
%
% You can plot the road and the planned path using:
%
%   helperPlotRoadAndPath(scenario, refPoses)
%
helperPlotRoadAndPath(scenario, refPoses)

%% Simulate Scenario
% When simulating the model, you can open the 
% <docid:driving_ref#mw_59742eb7-dce8-4938-9c2e-44d34c7b8891 Bird's-Eye Scope>
% to analyze the simulation. After opening the scope, click *Find Signals*  
% to set up the signals. Then run the simulation to display the vehicle, 
% the road boundaries, and the lane markings. The image below shows the 
% Bird's-Eye Scope for this example at 25 seconds. At this instant, the 
% vehicle has switched to the left lane.
%
% <<../lateralControlBirdsEyeScope.PNG>>
%

%% 
% You can run the full simulation and explore the results using the 
% following command:
%
%   sim('LateralControlTutorial');
%
sim('LateralControlTutorial'); % Simulate to end of scenario

%%
% You can also use the Simulink(R) <docid:simulink_ref#f5-1117037 Scope> in 
% the *Vehicle and Environment* subsystem to inspect the performance of the 
% controller as the vehicle follows the planned path. The scope shows the  
% maximum deviation from the path is less than 0.3 meters and the largest  
% steering angle magnitude is less than 3 degrees.
%
%   scope = 'LateralControlTutorial/Vehicle and Environment/Scope';
%   open_system(scope)
%
scope = 'LateralControlTutorial/Vehicle and Environment/Scope';
open_system(scope);
snapnow

%% 
% To reduce the lateral deviation and oscillation in the steering 
% command, use the Lateral Controller Stanley Dynamic block and
% simulate the model again:
%
%   set_param(variant, 'LabelModeActivechoice', 'Dynamic');
%   sim('LateralControlTutorial'); 
%
set_param(variant, 'LabelModeActivechoice', 'Dynamic');
sim('LateralControlTutorial'); % Simulate to end of scenario
snapnow

close_system(scope);

%%
close_system('LateralControlTutorial', 0);
close all
clear


%% Conclusions
% This example showed how to simulate lateral control of a vehicle in a
% lane changing scenario using Simulink. Compared with the Lateral
% Controller Stanley Kinematic block, the Lateral Controller Stanley
% Dynamic block provides improved performance in path following with
% smaller lateral deviation from the reference path.
%
%% References
% [1] Hoffmann, Gabriel M., Claire J. Tomlin, Michael Montemerlo, and 
%     Sebastian Thrun. "Autonomous Automobile Trajectory Tracking for 
%     Off-Road Driving: Controller Design, Experimental Validation and 
%     Racing." _American Control Conference_. 2007, pp. 2296-2301.
%% Supporting Functions
%%%
% *helperPlotRoadAndPath* Plot the road and the reference path
%
%   function helperPlotRoadAndPath(scenario,refPoses)
%   %helperPlotRoadAndPath Plot the road and the reference path
%   h = figure('Color','white');
%   ax1 = axes(h, 'Box','on');
%   
%   plot(scenario,'Parent',ax1)
%   hold on
%   plot(ax1,refPoses(:,1),refPoses(:,2),'b')
%   xlim([150, 300])
%   ylim([0 150])
%   ax1.Title = text(0.5,0.5,'Road and Reference Path');
%   end
%
function helperPlotRoadAndPath(scenario,refPoses)
%helperPlotRoadAndPath Plot the road and the reference path
h = figure('Color','white');
ax1 = axes(h, 'Box','on');

plot(scenario,'Parent',ax1)
hold on
plot(ax1,refPoses(:,1),refPoses(:,2),'b')
xlim([150, 300])
ylim([0 150])
ax1.Title = text(0.5,0.5,'Road and Reference Path');
end
