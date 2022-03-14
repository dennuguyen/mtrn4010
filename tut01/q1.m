% P_B = R_A->B * P_A + T_A->B

object_of_interest_global = [8; 16];
observer_translation = [5; 6];
observer_rotation = deg2rad(45); % radians CCW

x_y_rotation = [[cos(observer_rotation) -sin(observer_rotation)];
                [sin(observer_rotation), cos(observer_rotation)]];

object_of_interest_local = inv(x_y_rotation) * (object_of_interest_global - observer_translation)