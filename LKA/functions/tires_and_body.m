function [ d_states,F_R,k,alpha,Mz,VTRi_steered,RiTV_steered,VTE,dl,ddl,drag,roll_resist ] ...
    = tires_and_body( car,states,delta_steering,moments,brake,reg_brake,disruption,use_resistances,bool_use_tire_dynamics )
% Inputs:
% car - structure with car parameters
% states - column vector of 16 states, [v;omega;euler;position_earth;dro]
% delta_steering - column vector of steering angles
% moments - column vector of input torques on individual wheels
% brake – brake_torques in form of vector [FL;FR;RL;RR]
% use_resistances - use rolling resistance and drag 
% recalculate some stuff from Init

% car.Lv = car.wheelbase/2 - car.CG_offset; % distance from CG to positive X
% car.Lh = car.wheelbase/2 + car.CG_offset; % distance from CG to negative X
% car.Jmat = diag([car.Jxx,car.Jyy,car.Jzz]);
% car.JmatInv = diag([1/car.Jxx,1/car.Jyy,1/car.Jzz]);
% car.r1 = [car.Lv , car.Sl , -car.Sz]';
% car.r2 = [car.Lv , -car.Sr, -car.Sz]';
% car.r3 = [-car.Lh, car.Sl , -car.Sz]';
% car.r4 = [-car.Lh, -car.Sr, -car.Sz]';


v = states(1:3);
omega = states(4:6);
euler = states(7:9);
position_earth  = states(10:12);
dro = states(13:16);

%--------------------------------------------------------------------------------
% euler angles 
%--------------------------------------------------------------------------------
phi = euler(1);
th = euler(2);
euler_mat = [1, sin(phi)*tan(th),cos(phi)*tan(th);...
            0, cos(phi),-sin(phi);...
            0, sin(phi)/cos(th), cos(phi)/cos(th) ];
euler_rates = euler_mat*omega;


%--------------------------------------------------------------------------------
% tires 
%--------------------------------------------------------------------------------

[ F_R,k,alpha,Fx,Mz,VTRi_steered,RiTV_steered,VTE,dl,ddl,My ] = ...
    tires_fun(car,v,omega,euler,euler_rates,delta_steering,dro,position_earth,bool_use_tire_dynamics,disruption);

%--------------------------------------------------------------------------------
% rigid body
%--------------------------------------------------------------------------------
[ v_dot,omega_dot ] = ...
    rigid_body_fun( car,v,omega,euler,F_R,disruption);


%--------------------------------------------------------------------------------
% velocity
%--------------------------------------------------------------------------------
dot_pos_earth = VTE'*v;

%--------------------------------------------------------------------------------
% wheel acceleration,  drag and roll resistance, braking
%--------------------------------------------------------------------------------
v=v(:);

% drag
drag = 1/2*car.rho*car.Cd*car.A  * (v.'*v);

f_r = car.fr;
Fz = F_R(3,:);
Fz = Fz(:);

% roll resist
dro_sign = dro;
dro_sign(dro_sign>1) = 1; % smoother sign function (no bullshit around 0)
dro_sign(dro_sign<-1) = -1;
% roll_resist = car.r*(dro_sign .* (f_r*Fz));
roll_resist = dro_sign.*My;


% ddro = (moments - car.r*Fx - use_resistances*(drag/4 + roll_resist) - Mb)./car.Jwheel;
ddro = ( moments - car.r*Fx - brake - reg_brake)./car.Jwheel; % - drag


%--------------------------------------------------------------------------------
% OUTPUT
%--------------------------------------------------------------------------------
% v_dot(2) = 0;
d_states = [v_dot;omega_dot;euler_rates;dot_pos_earth;ddro];


end

