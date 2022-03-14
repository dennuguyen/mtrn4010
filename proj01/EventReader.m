classdef EventReader
    properties
    end
    methods
        %% Constructor.
        function obj = EventReader()
            for i=1:ne,
    
                XX(:,i)=X;

                event = table(:,i);
                sensorID=event(3);                         % source (i.e. which sensor?)
                t=0.0001*double(event(1));                  % when was that measurement taken?
                dt=t-t0;t0=t;                               % dt since last event (needed for predictions steps).
                % perform prediction X(t+dt) = f(X,vw,dt) ; vw model's inputs (speed and gyroZ) 


                here = event(2);                            % where to read it, from that sensor recorder.

                switch sensorID    %measurement is from?

                    case 1  %  it is a scan from  LiDAR#1!
                    %fprintf('LiDAR scan at t=[%d],dt=[%d]\n',t,dt); 
                    ranges = data.scans(:,here);  

                    processLiDAR(hh,X,ranges,etc);  % e.g. for showing scan in "global CF", etc. 
                    continue;  %"next!"

                    %...............................
                    case 2  %  it is speed encoder + gyro  (they are packed together)
                    vw=data.vw(:,here);    % speed and gyroZ, last updated copy.

                    fprintf('new measurement: v=[%.2f]m/s,w=[%.2f]deg/sec\n',vw.*[1;180/pi]);
                    continue;  %"next!"

                    otherwise  % It may happen if the dataset contains measurements from sensors 
                                 %which you had not expected to process.
                    %fprintf('unknown sensor, type[%d], at t=[%d]\n',sensorID, t);         
                    continue;
                end
             end 
        end
        %% 
        function read_data(obj)

        end
        %% Read LiDAR data.
        function process_lidar(obj)

        end
        %% Read IMU data.
        function process_imu(obj)

        end
    end
end