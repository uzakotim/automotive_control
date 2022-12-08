m = 1000;
b = 50;
os = 10;
T = 5;

%damp = (-log(os/100))/(sqrt((pi^2) + (log(os/100))^2))
damp = 1
omega = 4/(damp*T)

a = 1
b1 = 2*damp*omega
c = omega^2

Kp = b1*m-b
Ki = c*m
C_ACC = tf([Kp Ki], [1 0])
% Ki = 3034.3
% Kp = Ki*2.4
% C_ACCRL = tf([Kp Ki], [1 0])
%%
os1 = 2.5;
T1 = 30;

%damp = (-log(os/100))/(sqrt((pi^2) + (log(os/100))^2))
damp1 = 1
omega1 = 4/(damp1*T1)

a = 1
b1 = 2*damp1*omega1
c = omega1^2

Kp1 = b1*m-b
Ki1 = c*m

