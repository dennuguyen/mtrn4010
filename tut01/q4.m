%% Get data.
Z1 = load("LiDAR_data_001.mat").Z;
Z2 = load("LiDAR_data_002.mat").Z;
Z3 = load("LiDAR_data_003.mat").Z;
Z4 = load("LiDAR_data_004.mat").Z;
Z5 = load("LiDAR_data_005.mat").Z;

%% Convert data from polar to cartesian in local frames.
angles = deg2rad(-80:0.5:80);

figure(1)
local1 = polar2cartesian_lidar(double(Z1.ranges), angles);
local2 = polar2cartesian_lidar(double(Z2.ranges), angles);
local3 = polar2cartesian_lidar(double(Z3.ranges), angles);
local4 = polar2cartesian_lidar(double(Z4.ranges), angles);
local5 = polar2cartesian_lidar(double(Z5.ranges), angles);

subplot(321)
plot(local1(1, :), local1(2, :), 'b.')
subplot(322)
plot(local2(1, :), local2(2, :), 'r.')
subplot(323)
plot(local3(1, :), local3(2, :), 'g.')
subplot(324)
plot(local4(1, :), local4(2, :), 'k.')
subplot(325)
plot(local5(1, :), local5(2, :), 'c.')

%% Convert all points from their local to global frames.
global1 = local2global_frames(local1, Z1.X);
global2 = local2global_frames(local2, Z2.X);
global3 = local2global_frames(local3, Z3.X);
global4 = local2global_frames(local4, Z4.X);
global5 = local2global_frames(local5, Z5.X);

figure(2)
hold on
plot(global1(1, :), global1(2, :), 'b.');
plot(global2(1, :), global2(2, :), 'r.');
plot(global3(1, :), global3(2, :), 'g.');
plot(global4(1, :), global4(2, :), 'k.');
plot(global5(1, :), global5(2, :), 'c.');
hold off