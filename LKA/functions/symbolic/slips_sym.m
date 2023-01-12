function [ k,alpha ] = slips_sym( Vx,Vy,omega,r )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Vth = 0.1;

Vsx = Vx - omega*r;
Vsy = Vy;

k = -Vsx/abs(Vx);
alpha = atan2(Vsy,abs(Vx));

% % smooth transition across 0
% if abs(Vx) < Vth
% k = -2*Vsx/(Vth + Vx^2/Vth);
% end
% 
% % saturation
% if abs(k) > 10
%     k = sign(k)*10;
% end

end

