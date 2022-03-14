
%Example, showing how to read the data which is used in some problems in
%Tutorial 2, MTRN4010.T1.2022
% if you have questions, ask the lecturer, via Moodle or email(
% j.guivant@unsw.edu.au)

function MyMain()
    data=load('Data_Tu02Q4.mat'); data=data.data;
    ExploreData(data);
end

function ExploreData(data)
% Here, sensors' measurements are ordered by timestamp.
% as they had ocurred, chronologically, when the data was collected/generated
% (in a real experiment o in simulation).
% Each line of this table contains an entry which describes:
% --> The sampling time of the measurement, the sensor type, and an index to the buffer of that
% sensor data. So, we use that index to point to the spacific measurement.

hL=InitCertainPartOfMyStuff();

X=data.pose0;
%platform's initial pose; [x;y;heading]   [meters;meters;radians]
disp(X);

% I "copy" variables, for easy ascces (btw: Matlab copies vars "by reference", if used for reading)
n=data.n;
table=data.table;
t0=table(1,1);
etc=[];  %dummy variable.

ka=180/pi; %scaling constant.

% Loop: read entries, one by one, for sequential processing.
for i=1:n,
    item = table(:,i);
    sensorID=item(3);           % source (i.e. which sensor?)
    t=item(1);                  % when was that measurement taken?
    % time is given as an integer, in which 1 count = 0.1millisecond.
    % you may express that time in seconds :  ts=double(t)*0.0001; 
    
    dt=t-t0;t0=t;               % certain "dt", if needed.
    here = item(2);             % position of data record in list of records, produced by that particular sensor.
    dtS=double(dt)/10000;       % "dt" now in seconds;
    pause(dtS/3);   % not necessarily, just to allow some slow motion visualization.
    
    
    switch sensorID    %measurement is from?
        
        case 1  %  it is a scan from  LiDAR#1!
        fprintf('LiDAR scan at t=[%d]\n',t); 
        ranges = data.scans(:,here);  
        processLiDAR(hL,X,ranges,etc);  % e.g. for showing scan in "global CF", etc. 
        continue;  %"next!"
        
        %...............................
        case 2  %  encoder/gyro  (come together)
        vw=data.vw(:,here);    % speed and gyroZ
        fprintf('DR sample at t=[%d],(%.1fm/s, %.1fº/s)\n',t,vw(1),vw(2)*ka); 
        %measurements from sensors which we may use for dead reckoning, "DR"!
        
        % Some processing should be performed here.
        % "result=processVW(X,vw,dt,etc);"  
        %  e.g.  X=MyProcessModel(X,vw,dt) for implementing your kinematic model
        continue;  %"next!"
        
        otherwise  % It may happen if the dataset contains measurements from sensors 
                     %which you had not expected to process.
        %fprintf('unknown sensor, type[%d], at t=[%d]\n',sensorID, t);         
        continue;
    end;
end;    
disp('Done. BYE');

end
% --------------------------------------------------------------------------------

function h=InitCertainPartOfMyStuff()
    % you may initialize things you need.
    % e.g.: context for some dynamic plots,e etc.
    figure(10); clf();       % create a figure, or clear it if it does exist.
    r0=zeros(321,1);         % dummy lidar scan.
    h=plot(r0,'.');          % h: handle to this graphic object, for subsequent use.  
    axis([1,321,0,15]);  % my region of interest, to show.
    hold on;     plot([1,321],[10,10],'--r');  % just some line.
    zoom on;     % by defult, allow zooming in/out
    title('LiDAR scans (polar)');  
end
            
% --------------------------------------------------------------------------------

function processLiDAR(h,X,ranges,etc)
    %e.g. here I show all ranges, but saturate those to 15m.
    r=single(ranges)*0.01;   % I use meters...
    r=min(r,15);
    set(h,'ydata',r);  %refresh plot.
end
% in certain cases, you will actually do some processing, e.g. for
% estimating the platform's pose by exploiting LiDAR scans; however, we do not do it now.
% --------------------------------------------------------------------------------
% if you have questions, ask the lecturer, via Moodle or email(j.guivant@unsw.edu.au)
% -------------------------------------------------------------------------------- 
