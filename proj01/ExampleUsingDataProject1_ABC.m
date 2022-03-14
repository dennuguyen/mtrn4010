
%Example, showing how to read the data which is used in some problems in
%Tutorial2.problem 4, and in Project1/parts A,B,C.
%MTRN4010.T1.2022

% if you have questions, ask the lecturer, via Moodle or email(
% j.guivant@unsw.edu.au)

% ---------------------------------------------------------------------------------
function Main()

% load data, to be played back.
file='.\data015a.mat';   %one of the datasets we can use (simulated data, noise free, for Project 1).
load(file); % will load a variable named data (it is a structure)  
ExploreData(data);
end

function ExploreData(data)
% Here, sensors' measurements are ordered by timestamp.
% as they had occurred, chronologically, when the data was collected/generated
% (in a real experiment o in simulation).
% Each line of this table contains an entry which describes a particular event (e.g. a measurement):
% --> The sampling time of the measurement, the sensor type, and an index to a record in the list of the recorded measurements of that
% particular sensor. So, we use that index to read to the specific measurement.

%Y you may initialize your program, before iterating through the list of events.
hh=InitCertainPartOfMyProgram(data);


X=data.pose0;   %platform's initial pose; [x0;y0;heading0]   [meters;meters;radians]
% it is necessary,for out task.

% I "copy" variables, for easy access (btw: Matlab copies vars "by reference", if used for reading)
ne=data.n;                   % how many events?
table=data.table;           % table of events.
event = table(:,1);         % first event.

t0=event(1) ; t0=0.0001*double(t0); % initial time.


vw=[0;0];  % To keep last [speed,heading rate] measurement.
XX=zeros(3,ne,'single');     % a buffer for my results.  size=3xne.
%................
etc=data.LidarCfg;  %Info about LiDAR installation (position and orientation, ..
% .. in platform's coordinate frame.). 

% info: 'LiDAR's pose in UGV's CF=[Lx;Ly;Alpha], in [m,m,°]'
% It needs to be considered in your calculations.
%................

% Loop: read entries, one by one, for sequential processing.
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
    end;
end;    


%plot( data.verify.poseL(1,:), data.verify.poseL(2,:),'m+');
disp('Loop of events ends.');
disp('Showing ground truth (you would not achieve that, exactly.)');
ShowVerification1(data);
end
% --------------------------------------------------------------------------------

function hh=InitCertainPartOfMyProgram(data)
    % you may initialize things you need.
    % E.g.: context for some dynamic plots,etc.
    
    % for local CF.
    
    %figure(10); clf();       % create a figure, or clear it if it does exist.
    %r0=zeros(321,1);         % dummy lidar scan.
    %h1=plot(r0,'.');          % h: handle to this graphic object, for subsequent use.  
    %axis([1,321,0,15]);  % my region of interest, to show.
    %hold on;     plot([1,321],[10,10],'--r');  % just some line.
    %zoom on;     % by default, allow zooming in/out
    %title('LiDAR scans (polar)(removed from this demo)');  
    %ylabel('ranges (m)');
    

    % for global CF.
    
figure(11); clf();    % global CF.

% show the map landmarks and, if it is of interest to verify your solution, the
% walls/infrastructure present there.
% (All of them are provided in Global CF)

Landmarks=data.Landmarks;
% plot centres of landmarks. 
%plot(Landmarks(1,:),Landmarks(2,:),'+');
%hold on;
plot(Landmarks(1,:),Landmarks(2,:),'o' ,'color',0*[0,1/3,0])
% some pixels will appear close to some of these crosses. It means he LiDAR scan is
% detecting the associated poles (5cm radius).


% plot interior of walls (they have ~20cm thickness; but the provided info just includes the ideal center of the walls
% your LiDAR scans will appear at ~ 10cm from some of those lines.    
% Wall transversal section:  :  wall left side [<--10cm-->|<--10cm-->] the other  wall side. 
hold on;
plot(data.Walls(1,:),data.Walls(2,:),'color',[0,1,0]*0.7,'linewidth',3);
legend({'Centers of landmarks','Walls (middle planes) '});

title('Global CF (you should show some results here)');
xlabel('X (m)'); 
ylabel('Y (m)');
p0=data.pose0;
plot(p0(1),p0(2),'bs');
legend({'Landmarks','Walls (middle planes)','initial pose'});



hh=[];  % array of handles you may want to use in other parts of the program.
% empty now.
end

function ShowVerification1(data)

% plot some provided verification points (of platfom's pose).
% those are the ground truth.
% Do not expect your solution path to intesect those points, as those are
% the real positions, and yours are approximate ones, based on
% predictions, and using sampled inputs. 
% The discrepancy should be just fraction of cm, as the inputs are not
% polluted by noise, and the simulated model is the nominal analog model.
% The errors are mostly due to time discretization and sampled inputs.
% Inputs were sampled @100Hz (10ms) (you can infer that from "dt".
figure(11)
hold on;
p=data.verify.poseL;
plot(p(1,:),p(2,:),'r.');
h=legend({'Landmarks','Walls (middle planes)','Initial pose','Ground truth (subsampled)'});
end


% ---------------------------------------------------------------------------------

function processLiDAR(hh,X,ranges,etc)
% process LiDAR scan.
% your implementation.    
% You decide the input and ouput variables, etc.
% showing the LiDAR in local CF, was shown in the tutorial explanation. You
% may copy that from there to here.
% I am not refreshing scans now, so you do not need to wait for the
% animation to end. This example source code has other purposes.

% You may introduce a delay (using pause(...) ), here; if we are showing some dynamic plots.

end

% ---------------------------------------------------------------------------------

% if you have questions, ask the lecturer, via Moodle or email(
% j.guivant@unsw.edu.au)
% or ask the demonstrators.
