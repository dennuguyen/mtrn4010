%% Read LiDAR data from a file and convert it to cartesian format.
function lidar_points = polar2cartesian_lidar(lidar_ranges, lidar_angles)
    % Get valid data.
    valid_data = find((lidar_ranges > 0) & (lidar_ranges < 2^16-1));
    lidar_angles = lidar_angles(valid_data);
    lidar_ranges = lidar_ranges(valid_data) * 0.01;

    % Convert polar coordinates to cartesian.
    [lidar_points(1, :), lidar_points(2, :)] = pol2cart(lidar_angles, lidar_ranges);
end