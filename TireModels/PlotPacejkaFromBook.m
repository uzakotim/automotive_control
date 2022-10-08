% combined slip grid
lambda = -1:0.05:1;
alpha = -pi/2:0.05:pi/2;

%% in case of 0 change in Fz (dFz = 0)

Fz = 1;
Dx = -1;
Cx = -1.1;
Bx = 30;
Ex = -0.1;
Shx = 0.000233272373115809; %(0.000233272373115809 + 0.00115950515263055*dfz)*lambdaHx % lambdaHx = 1 (user settings), dfz = (Fz - lambda_Fz0*Fz0)/lambda_Fz0*Fz0, kde Fz0 - nominal load, lambda_Fz0 = 1 (user settings)
Svx = 0; % 

[X,Y] = meshgrid(lambda,alpha);

Cxa = 1.02796280922059; 
Bxa = 12.7633329850276*cos(atan(9.5787123658471*X));
Exa = -0.45202516851367; 
Shxa = 0.000233272373115809;

lambda_shifted = X + Shx;
Fx0 = Dx*Fz*sin(Cx*atan(Bx*lambda_shifted-Ex*(Bx*lambda_shifted-atan(Bx*lambda_shifted))))+Svx;

alpha_shifted = Y + Shxa;
Gxa0 = cos(Cxa*atan(Bxa*Shxa-Exa*(Bxa*Shxa-atan(Bxa*Shxa))));
Gxa = cos(Cxa*atan(Bxa.*alpha_shifted-Exa*(Bxa.*alpha_shifted-atan(Bxa.*alpha_shifted))));

Fx = Fx0.*Gxa./Gxa0;

set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');
surf(X,Y,Fx)
xlabel('$\lambda$ [-]', 'interpreter', 'latex')
ylabel('$\alpha$ [rad]', 'interpreter', 'latex')
zlabel('$F_{\rm x}/F_{\rm z}$ [-]', 'interpreter', 'latex')


