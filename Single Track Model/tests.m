function [af, ar, vxf, vxr] = wheel_kinematics(x, u, car)
    % inputs: x - model states
    %         u - model inputs
    %         car - car parameters    

    % TIP: to avoid numerical problems, use atan2
    % x = [v, beta, r, wf, wr, xpos, ypos, psi] - states of the model
    % u = [df, dr, Tdf, Tbf, Tdr, Tbr] - inputs of the model
    % car = vehicle parameters see initCar.m for a description
    beta = x(2);
    df = u(1);
    dr = u(2);
    lf = car.lf;
    lr = car.lr;
    r  = x(3);
    v  = x(1);
    A_f = [cos(df) sin(df); -sin(df) cos(df)];
    B_f = [v*cos(beta);v*sin(beta)+lf*r];

    A_r = [cos(dr) sin(dr); -sin(dr) cos(dr)];
    B_r = [v*cos(beta);v*sin(beta)+lr*r];

    v_f = A_f*B_f;
    v_r = A_r*B_r;

    vxf = v_f(1);
    vyf = v_f(2);
    vxr = v_r(1);
    vyr = v_r(2);
    af = -atan2(vyf,abs(vxf));
    ar = -atan2(vyr,abs(vxr));
end
