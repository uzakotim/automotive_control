load('two_cars_with_radar.mat');

global Ts b m max_motor_force max_break_force Ref pre_gain;
Ts = 0.05;
Ref = 200;
b = 50;
m = 1000;
max_motor_force = 15000;
max_break_force = 30000;
pre_gain = -15;

% %VW passat
% b1 = 0.29*2.26;
% vmax1 = 193/3.6;
% m1 = 1422;
% 
% %Audi A4
% b2 = 0.29*2.14;
% vmax2 = 228/3.6;
% m2 = 1450;

% %regulator
% ki = 3.2045e-9;
% kp = ki*3.1e4;

sign_max_break_force = -max_break_force;
% prenosova fce systemu auta
H = tf([0 1/m], [1 b/m]);

global H;
global Gnum;
global Gden;

G = c2d(H, Ts, 'tustin')
[Gnum, Gden] = tfdata(G);
Gnum = cell2mat(Gnum)
Gden = cell2mat(Gden)

global int;
global Inum;
global Iden;

int = tf([0 1], [1 0])
int_d = c2d(int, Ts, 'tustin')
[Inum, Iden] = tfdata(int_d);
Inum = cell2mat(Inum)
Iden = cell2mat(Iden)

a = [31 1];
b_pol = [65 1];
global num
global den
num = 0.081941*conv(a,b_pol);
den = [0.054 1 0];

global C;
global Cnum;
global Cden;

C = tf(num, den)
Cd = c2d(C, Ts, 'tustin')

[Cnum, Cden] = tfdata(Cd);
Cnum = cell2mat(Cnum)
Cden = cell2mat(Cden)

global num_v;
global den_v;

a_v = [5.7 1];
b_v = [0.3 1];
num_v = 154.46*a_v;
den_v = [1 0];

global Cnum_v;
global Cden_v;

C_v = tf(num_v, den_v);
C_vd = c2d(C_v, Ts, 'tustin');
[Cnum_v, Cden_v] = tfdata(C_vd);
Cnum_v = cell2mat(Cnum_v);
Cden_v = cell2mat(Cden_v);

run('velocity_reg.m');
run('postion_reg.m');
open_system('two_cars_with_radar_20a.slx');






