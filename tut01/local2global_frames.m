%% Transform a cartesian coordinates.
function global_points = local2global_frames(local_points, transform_vector)
    x_translation = transform_vector(1);
    y_translation = transform_vector(2);
    rotation = transform_vector(3);
    R = [cos(rotation) -sin(rotation); sin(rotation) cos(rotation)];
    x_y_rotated = R * [local_points(1, :); local_points(2, :)];
    global_points(1, :) = x_y_rotated(1, :) + x_translation;
    global_points(2, :) = x_y_rotated(2, :) + y_translation;
end