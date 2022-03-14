% data015a.mat
% 
% table [3x3068 uint32]: table of events?
% vw [2x2337 single]: Speed encoder and gyro data.
% scans [321x731 uint16]: LiDAR ranges with each pass.
% verify [1x1 struct]:
% 	poseL [3x731 single]: Truth for verification of platform poses over time (10 ms sampling).
% pose0 [3x1 single]: Initial platform pose (m, m, rad).
% n 3068: number of events
% LidarCfg [1x1 struct]: Info about LiDAR installation.
% 	Lx 0.4000: 
% 	Ly 0: 
% 	Alpha 0: 
% Walls [2x38 single]: Truth for verification of walls.
% Landmarks [2x26 single]: Truth for verification of landmarks.

load("data015a.mat");

% 
platform = Ackermann(data.pose0);
pose = data.pose0;
for 
    pose = platform.dead_reckoning(pose, 1.2, 0, 0.1);
    hold on
    plot(pose(1), pose(2), 'b')
end

% Truth data.
hold on
plot(data.verify.poseL(1, :), data.verify.poseL(2, :), 'r')