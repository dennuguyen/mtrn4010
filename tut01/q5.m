%% Get data.
Z1 = load("LiDAR_data_001.mat").Z;
Z2 = load("LiDAR_data_002.mat").Z;
Z3 = load("LiDAR_data_003.mat").Z;
Z4 = load("LiDAR_data_004.mat").Z;
Z5 = load("LiDAR_data_005.mat").Z;

%% Convert data from polar to cartesian in local frames.
angles = deg2rad(-80:0.5:80);

lidar_points1 = polar2cartesian_lidar(double(Z1.ranges), angles);
lidar_points2 = polar2cartesian_lidar(double(Z2.ranges), angles);
lidar_points3 = polar2cartesian_lidar(double(Z3.ranges), angles);
lidar_points4 = polar2cartesian_lidar(double(Z4.ranges), angles);
lidar_points5 = polar2cartesian_lidar(double(Z5.ranges), angles);

%% Check if vehicle is going to crash.

velocity = 1.2; % m/s
safety_radius = 1.0; % m
safety_time = 2.0; % s

fprintf("LiDAR_data_001.mat: ")
check_collision_later_from_lidar(X1, Y1, velocity, safety_radius, safety_time)

fprintf("LiDAR_data_002.mat: ")
check_collision_later_from_lidar(X2, Y2, velocity, safety_radius, safety_time)

fprintf("LiDAR_data_003.mat: ")
check_collision_later_from_lidar(X3, Y3, velocity, safety_radius, safety_time)

fprintf("LiDAR_data_004.mat: ")
check_collision_later_from_lidar(X4, Y4, velocity, safety_radius, safety_time)

fprintf("LiDAR_data_005.mat: ")
check_collision_later_from_lidar(X5, Y5, velocity, safety_radius, safety_time)

% Assumes lidar data is in local frame.
function is_collision = check_collision_now_from_lidar(lidar_points, pose_x, pose_y, boundary_radius)
    min_lidar_range = min(norm([lidar_x(:); lidar_y(:)]));
    if min_lidar_range - norm([pose_x; pose_y]) <= boundary_radius
        is_collision = 1;
        return
    end
    is_collision = 0;
end

% Assumes lidar data is in local frame.
function check_collision_later_from_lidar(lidar_x, lidar_y, velocity, safety_radius, safety_time)
    dt = 0.1;
    curr_x = 0;
    curr_y = 0;
    for t = 0:dt:safety_time
        curr_pose = [curr_x; curr_y] + [curr_x + dt * velocity; curr_y];
        if check_collision_now_from_lidar(lidar_x, lidar_y, curr_pose(1), curr_pose(2), safety_radius)
            fprintf("crashes at %f s\n", dt)
            return
        end
    end
    fprintf("\n")
end