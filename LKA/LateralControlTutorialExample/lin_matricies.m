cf = 12e+03; %[N/rad]
cr = 11e+03; %[N/rad]
m = 2000;  %[kg]
v = 10;   %[m/s]
Iz = 4000;  %[kg m2]
lf = 1.4;  %[m]
lr = 1.6;  %[m]

lp = lf;

A = [-(cr+cf)/m/v, (lr*cr-lf*cf)/m/v/v-1, 0, 0;
    (lr*cr-lf*cf)/Iz, -(lr^2*cr+lf^2*cf)/Iz/v, 0, 0;
    v, lp, 0, v;
    0, 1, 0, 0];
B = [cf/m;
    cf*lf/Iz;
    0;
    0];
d = [0;0;0;-v];
C = [0 0 0 1];
D = 0;
sys = ss(A,B,C,D);
% rltool(sys)
% 
pid1 = pid(1.5,0.4,0.4);
% 
new_sys = feedback(-pid*sys, -1);
rltool(new_sys)

