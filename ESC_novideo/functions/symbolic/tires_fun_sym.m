function [ F_R,k,alpha,Fx,Mz,VTRi_steered,RiTV_steered,VTE,za ] = tires_fun_sym(car,v,omega,euler,euler_rates,deltas_steer,dro,position_earth)
%UNTITLED2 Summary of this function goes here
% Inputs
%   car = structure containing the car parameters
%   v = [vx;vy;vz]              vehicle-fixed coordinates
%   omega = [wx;wy;wz]          vehicle-fixed coordinates
%   euler = [roll;pitch;yaw]    inertial-fixed coordinates
%   deltas_l
%   d_deltas_l
%   deltas_steer
%   dro = 1x4 vector of vehicle speeds

VTE =  Rot_VTE(euler);  % earth -> vehicle
ETV = VTE'; % TODO can I really just transpose this?

RiTV = sym(nan(3,3,4));
for i=1:4
    RiTV(:,:,i) = Rot_RiTV(euler(1),euler(2),deltas_steer(i));
end
RiTV_steered = RiTV(:,:,1);
VTRi_steered = RiTV_steered';
%--------------------------------------------------------------------------------
% spring displacement and its velocity
%--------------------------------------------------------------------------------
A1_new = (ETV*car.r1 - car.r1);
A2_new = (ETV*car.r2 - car.r2);
A3_new = (ETV*car.r3 - car.r3);
A4_new = (ETV*car.r4 - car.r4);
% anchor points displacements (from initial position) in earth coordinates
deltas_l = [A1_new(end);A2_new(end);A3_new(end);A4_new(end)] + position_earth(3);
za = [A1_new(end);A2_new(end);A3_new(end);A4_new(end)];

A = [omega,omega,omega,omega];
B = [ car.r1, car.r2, car.r3, car.r4];
d_ri = ETV*(cross(A,B,1) + [v,v,v,v]); % TODO can I use this matrix for velocities? 
% Shouldnt I differentiate it and use dETV*cross + ETV*d_cross?

% anchor points velocities in earth coordinates
d_deltas_l = d_ri(3,:);

%--------------------------------------------------------------------------------
% spring-damper
%--------------------------------------------------------------------------------
ca = [car.caF,car.caF,car.caR,car.caR];
da = [car.daF,car.daF,car.daR,car.daR];
V_FF = sym(nan(3,4));    % spring force
F_load = sym(nan(1,4));  % load o wheels

for i=1:4
    pom = -((ca(i) * deltas_l(i)) + (da(i)*d_deltas_l(i)));
    V_FF(:,i) = pom*VTE*sym([0;0;1]);
    F_load(i) = pom;
end


%--------------------------------------------------------------------------------
% weight distribution magic for roll centers
%--------------------------------------------------------------------------------
% Wf = F_load(1) + F_load(2);
% Wr = F_load(3) + F_load(4);
% Kf = car.caF*1.2;
% Kr = car.caR*1.2;
% W = car.m*car.g;
% h1 = 0;
% hf = car.zrf;
% hr = car.zrr;
% sumFy = 0;
% tf = 2*car.Sl;
% tr = 2*car.Sl;
% bool_left = sign(euler_rates(3));
% [ W1,W2,W3,W4 ]= weight_distrib( Kf,Kr,W,Wf,Wr,h1,hf,hr,sumFy,tf,tr,bool_left );
% F_load(1) = W1;
% F_load(2) = W2;
% F_load(3) = W3;
% F_load(4) = W4;




rA = [car.r1,car.r2,car.r3,car.r4];

V_r_Ri = sym(nan(3,4));  % Vehicle fixed position of wheel center
V_v_Ri = sym(nan(3,4));  % Vehicle fixed velocity of wheel center
R_v_Ri = sym(nan(3,4));  % Wheel   fixed velocity of wheel center
k = sym(nan(4,1));       % longitudal slips
alpha = sym(nan(4,1));   % slip angles
Fx = sym(nan(4,1));      % actual Fx in wheel coordinates
Fy = sym(nan(4,1));      % actual Fy in wheel coordinates
Fx0 = sym(nan(4,1));     % Fx0 = Fx WITHOUT considering friction elipse
Fy0 = sym(nan(4,1));     % Fy0 = Fy WITHOUT considering friction elipse
Mz = sym(nan(4,1));      % returning moment Mz
F_R = sym(nan(3,4));     % Force vector in vehicle coordinates
Vx = sym(nan(4,1));
Vy = sym(nan(4,1));



for i = 1:4
    V_r_Ri(:,i) = rA(:,i) + VTE*[0;0;-deltas_l(i)];
    V_v_Ri(:,i) = v + cross(omega,V_r_Ri(:,i)) + VTE*[0;0;-d_deltas_l(i)];
    R_v_Ri(:,i) = RiTV(:,:,i)*V_v_Ri(:,i);
    
    Vx(i) = R_v_Ri(1,i); Vy(i) = R_v_Ri(2,i);
    [ k(i),alpha(i) ] = slips_sym( Vx(i),Vy(i),dro(i),car.r );
    
    [ Fx(i),Fy(i),Fx0(i),Fy0(i),Mz(i) ] = pacejka_combined_slip_sym(...
        k(i),alpha(i),F_load(i),Vx(i),car.r*dro(i),...
        car.Pac_const_x,car.Pac_const_y,car.Pac_const_mz);

    
    F_R(:,i) =  RiTV(:,:,i)'*[Fx(i);Fy(i);0] + V_FF(:,i);
end






end

