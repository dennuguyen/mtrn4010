clear; clc;

%% Setup
figure(1); clf(); hold on;
ph = [plot(0, 0, '*b'); plot(0, 0, '.r'); plot(0, 0, '-b')];
axis([-25, 25, -25, 25])

%% Load data
data = load("Data_Tu02Q4.mat").data;
all_ranges = data.scans;
num_data = data.n;
table = data.table;

%% Initialise values
pose = data.pose0;
index = 1;
t0 = 0.0001*double(table(1,1));
vw = [0; 0];
pp = [0; 0];

%% Simulation
for i = 1:num_data
    
    % Parse data
    t = 0.0001 * double(table(1, i));
    index = table(2, i);
    sensorID = table(3, i);

    % Plots everything, pause, and get new pose
    plot_everything(ph, pose, pp);
    dt = t - t0; t0 = t; pause(dt/10);
    pose = get_pose(pose, vw, dt);


    % If 1, then update pose
    if sensorID == 1
        [rr, aa] = get_polar(all_ranges(:, index));
        pp = polar_to_cartesian(rr, aa);
        pp = local_to_global(pose, pp);
    
    % If 2, then update velocity / yaw rate
    elseif sensorID == 2
        vw = data.vw(:, index);
    end
end

%% For getting the next pose given the current pose
function pose_next = get_pose(pose_curr, vw, dt)
    h = pose_curr(3);
    dpose = [vw(1)*cos(h); vw(1)*sin(h); vw(2)];
    pose_next = pose_curr + dt*dpose;
end

%% Get polar coordinates of LiDAR scan
function [rr, aa] = get_polar(ranges)
    rr = single(ranges)*0.01; % cm to m
    aa = deg2rad(-80:0.5:80); % 321 points
    ii = find((rr > 1) & (rr < 20));
    rr = rr(ii)';
    aa = aa(ii);
end

%% Convert polar to cartesian
function pp = polar_to_cartesian(rr, aa)
    xx = rr.*cos(aa);
    yy = rr.*sin(aa);
    pp = [xx; yy];
end

%% Converts local frame to global frame
function pp = local_to_global(pose, pp)
    h  = pose(3);
    R  = [[cos(h), -sin(h)]; [sin(h), cos(h)]];
    pp = R * pp;
    pp(1, :) = pp(1, :) + pose(1);
    pp(2, :) = pp(2, :) + pose(2);
end

%% Plots everything
function plot_everything(ph, pose, pp)
    set(ph(1), 'xdata', pose(1), 'ydata', pose(2));
    set(ph(2), 'xdata', pp(1, :), 'ydata', pp(2, :));
    heading = [pose(1), 3*cos(pose(3))+pose(1); pose(2), 3*sin(pose(3))+pose(2)];
    set(ph(3), 'xdata', heading(1, :), 'ydata', heading(2, :));
end