%% Get data.
Z1 = load("LiDAR_data_001.mat").Z;

%% Convert data from polar to cartesian in local frames.
angles = deg2rad(-80:0.5:80);

figure(1)
lidar_points = polar2cartesian_lidar(double(Z1.ranges), angles);
plot(lidar_points(1, :), lidar_points(2, :), 'b.');

%% Convert all points from their local to global frames.
figure(2)
global_points = local2global_frames(lidar_points, Z1.X);
plot(global_points(1, :), global_points(2, :), 'r.');