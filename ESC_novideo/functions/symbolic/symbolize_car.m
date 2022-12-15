clc,clear
Init_symbolic
Init

delta = 0;
M3 = 0;
M4 = 0;
f = tires_and_body_sym(car,car_s_init,delta,[0;0;M3;M4]);