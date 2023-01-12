
syms m g Jxx Jyy Jzz Sl Sr Sz CG_offset len fr Cd rho A...
    wheel_vel_threshold Jwheel r caF daF caR daR...
    Bx Cx Dx Ex By Cy Dy Ey Bz Cz Dz Ez

% Parameters of the car
car_s.m = m; % mass of vehicle
car_s.g = g; % gravity acceleration
car_s.Jxx = Jxx; % inetria X
car_s.Jyy = Jyy; % inetria Y
car_s.Jzz = Jzz; % inertia Z
car_s.Sl = Sl; % distance from CG to positive Y
car_s.Sr = Sr; % distance from CG to negative Y
car_s.Sz = Sz; % distance from CG to to the point where springs are anchored

car_s.CG_offset = CG_offset;
car_s.length = len;

car_s.fr = fr; %roll resistance constant (should be function)
car_s.Cd = Cd; % front aerodynamic constant
car_s.rho = rho; % air density
car_s.A = A; % frontal area (for aerodynamics)

car_s.wheel_vel_threshold = wheel_vel_threshold; % If the wheel velocity is below this, use different slip calculation.
car_s.Jwheel = Jwheel; % wheel moment of inetria
car_s.r   = r; % wheel radius

% spring parameters, Front and Rear
car_s.caF = caF; % spring stiffness nekde z netu  %sedan 70000
car_s.daF = daF; % damper constant
car_s.caR = caR; % spring stiffness nekde z netu  %sedan 70000
car_s.daR = daR; % damper constant

% source = https://www.mathworks.com/help/physmod/sdl/ref/tireroadinteractionmagicformula.html
% 
car_s.Pac_const_x = [ Bx Cx Dx Ex ];
car_s.Pac_const_y = [ By Cy Dy Ey ];
car_s.Pac_const_mz =[ Bz Cz Dz Ez ];

syms Vx Vy Vz omega_x omega_y omega_z roll pitch yaw ...
    position_earth_x position_earth_y position_earth_z...
    dro_FL dro_FR dro_BL dro_BR

assume([Vx Vy Vz omega_x omega_y omega_z roll pitch ...
    yaw position_earth_x position_earth_y position_earth_z...
    dro_FL dro_FR dro_BL dro_BR],'real')

car_s_init = [Vx Vy Vz omega_x omega_y omega_z roll pitch ...
    yaw position_earth_x position_earth_y position_earth_z...
    dro_FL dro_FR dro_BL dro_BR]';c

syms delta M1 M2 M3 M4

assume([delta M1 M2 M3 M4],'real')


