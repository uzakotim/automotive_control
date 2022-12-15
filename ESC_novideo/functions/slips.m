function [ k,alpha ] = slips( Vx,Vy,omega,r )
%SLIPS calculate slip on a wheel
%   [ k,alpha ] = slips( Vx,Vy,omega,r )
%   In:
%   Vx,Vy - wheel velocities, in wheel-fixed coordinate system! [m/s]
%   omega - rotational velocity [rad/s]
%   r - radius of the wheel [m]
%
%   Out:
%   k,alpha - longitudinal slip and sideslip
Vth = 0.1;

Vsx = Vx - omega*r;
Vsy = Vy;

k = -Vsx/abs(Vx); %previous!
%k = -Vsx/Vx;
alpha = atan2(Vsy,abs(Vx)); %previous!
%alpha = atan2(Vsy,Vx);

% smooth transition across 0
% if abs(Vx) < Vth
% k = -2*Vsx/(Vth + Vx^2/Vth);
% end

if abs(Vx) < Vth
k = -Vsx/(abs(Vx)+0.1); %previous!
%k = -Vsx/(sign(Vx)*(abs(Vx)+0.1));
end

% saturation
if abs(k) > 10
    k = sign(k)*10;
end

end

