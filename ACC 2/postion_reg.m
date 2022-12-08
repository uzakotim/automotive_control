m = 1000;
b = 50;
os = 10;
T = 15;

% damp = (-log(os/100))/(sqrt((pi^2) + (log(os/100))^2))
% %damp = 1
omega = 4/(damp*T)
x = 0.05 
% alpha = ((b/m)-2*damp*omega)/omega;
% 
% %omega = b/(m*(alpha + 2*damp))
% Kpp = m*((2*alpha*damp*(omega^2)) + (omega^2))
% Kip = m*alpha*omega^3

Kdp = (m*(2*omega + x)) - b
Kpp = m*(omega^2 + 2*x*omega)
Kip = m*x*omega^2