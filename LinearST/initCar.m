car.m = 1463; % [kg] vehicle mass
car.Iz = 1968; % [kg m2] moment of inertia of the vehicle
car.lf = 0.971; % [m] CG-front axle distance
car.lr = 1.566; % [m] CG-rear axle distance
car.Caf = 11.9*car.m*9.81*car.lr/(car.lf+car.lr); % [N rad-1] cornering stiffness of the front axle
car.Car = 13.6*car.m*9.81*car.lf/(car.lf+car.lr); % [N rad-1] cornering stiffness of the rear axle
car.v_const = 22.2;
