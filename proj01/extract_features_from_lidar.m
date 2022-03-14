function extract_features_from_lidar(lidar_ranges)

    % Convert lidar points into cartesian format.
    angles = deg2rad(-80:0.5:80);
    lidar_points = polar2cartesian_lidar(double(Z1.ranges), angles);
    plot(lidar_points(1, :), lidar_points(2, :))
    
    % Get OOI.
end