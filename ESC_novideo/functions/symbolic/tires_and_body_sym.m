function [ d_states,F_R,k,alpha,Mz,VTRi_steered,RiTV_steered,VTE,za ] ...
    = tires_and_body_sym( car,states,delta_steering,moments )
% Inputs:
% car parameters:
% car - structure with car parameters
% states - column vector of 16 states, [v;omega;euler;position_earth;dro]
% car inputs:
% delta_steering - steering angle
% moments column vector of moments on individual wheels

% recalculate some stuff from Init
car.Lv = car.length-car.CG_offset; % distance from CG to positive X
car.Lh = car.length+car.CG_offset; % distance from CG to negative X
car.Jmat = diag([car.Jxx,car.Jyy,car.Jzz]);
car.JmatInv = diag([1/car.Jxx,1/car.Jyy,1/car.Jzz]);
car.r1 = [car.Lv , car.Sl , -car.Sz]';
car.r2 = [car.Lv , -car.Sr, -car.Sz]';
car.r3 = [-car.Lh, car.Sl , -car.Sz]';
car.r4 = [-car.Lh, -car.Sr, -car.Sz]';



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
deltas_steer = [delta_steering;delta_steering;0;0];

[ F_R,k,alpha,Fx,Mz,VTRi_steered,RiTV_steered,VTE,za ] = ...
    tires_fun_sym(car,v,omega,euler,euler_rates,deltas_steer,dro,position_earth);

%--------------------------------------------------------------------------------
% rigid body
%--------------------------------------------------------------------------------
[ v_dot,omega_dot ] = ...
     rigid_body_fun( car,v,omega,euler,F_R );


%--------------------------------------------------------------------------------
% position
%--------------------------------------------------------------------------------
dot_pos_earth = VTE'*v;

%--------------------------------------------------------------------------------
% wheel acceleration,  drag and roll resistance
%--------------------------------------------------------------------------------
v=v(:);
drag = 1/2*car.rho/car.g*car.Cd*car.A  * (v'*v);

f_r = car.fr;
Fz = F_R(3,:);
Fz = Fz(:);

% smooth saturation
dro_sign = sign(dro);
% dro_sign(dro_sign>1) = 1;
% dro_sign(dro_sign<-1) = -1;
roll_resist = car.r*(dro_sign .* (f_r*Fz));

% !!!!!! nasobim 0 aby to bylo continuous
ddro = moments - car.r*Fx - (drag+roll_resist);


%--------------------------------------------------------------------------------
% OUTPUT
%--------------------------------------------------------------------------------
d_states = [v_dot;omega_dot;euler_rates;dot_pos_earth;ddro];


end

