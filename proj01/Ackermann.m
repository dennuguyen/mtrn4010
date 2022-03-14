classdef Ackermann
    properties
        global_pose = [0 0 0]; % [x, y, heading]
    end
    methods
        %% Constructor.
        function obj = Ackermann(global_pose)
            if length(global_pose) ~= 3
                throw(MException("Passed in pose has %d fields instead of 3.", length(global_pose)))
            end
            obj.global_pose = global_pose;
        end
        %% Calculate the next pose from previous pose based on velocities and change in time.
        function global_pose = dead_reckoning(obj, linear_velocity, angular_velocity, change_in_time)
             global_velocity = [linear_velocity * cos(obj.global_pose(3));
                                linear_velocity * sin(obj.global_pose(3));
                                angular_velocity];
            obj.global_pose = obj.global_pose + global_velocity * change_in_time; % s_f - s_i = v * dt
            global_pose = obj.global_pose;
        end
    end
end