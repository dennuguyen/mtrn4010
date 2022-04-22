
% Implementation, for solution of Question 3, Tutorial 9, MTRN4010
% Questions: You may ask the lecturer, j.guivant@unsw.edu.au


function Q3Tu9()
clc;
rng(3331);     % resetting random numbers generator, some seed  

Lx=0.45;        % parameter Lx (as in Projects 1 and 2, but different value)
Xa = [3;5;0.45]; % actual LiDAR's pose


% generate some case, synthetically.
z =  [ [5,8,9,12 ]; randn(1,4)*10 ];        % some 2D points (OOIs seen from LiDAR).
OOIs_LiCF = z+randn(size(z))*0.05;         % OOIs in Lidar CF;
% I add some noise, to simulate more realstic case.

Landmarks = TransformCF01(Xa,Lx,z);             % associated landmarks (in GCF)

disp('OOIs_LCF'); disp(OOIs_LiCF');
disp('landmarks'); disp(Landmarks');


% initial guess, to optimizer.
PoseGuess0=Xa*0.8;
% Initial guess.  Usually, we SHOULD propose a better one, not too far.

% from the solution; to reduce chances of getting trapped in a local minimum.
% Alternatively, we may use an optimizer better suited for nonconvex cost
% functions (e.g. a PSO based optimizer)

% If we used it in Project1.D, I would propose a better guessed pose, e.g.
% the last known pose, in recent times.






disp('Actual Pose (unknown to us)'); disp(Xa');
PoseS = EstimateLidarPoseAndLx(PoseGuess0,OOIs_LiCF,Landmarks);
% show solution.
disp('solution (estimated Pose)'); disp(PoseS');


figure(1); clf();

OOIs_GCF2 = TransformCF01(PoseS,Lx,OOIs_LiCF); 
plot(Landmarks(1,:),Landmarks(2,:),'b*'); hold on;
plot(OOIs_GCF2(1,:),OOIs_GCF2(2,:),'ro');




end

%...................................................
function PoseS = EstimateLidarPoseAndLx(PoseGuess0,OOIs_LiCF,Landmarks)

Op=optimset('TolFun',0.01);
tic();
[PoseS,fval,exitflag] = fminsearch(@(X) CostA(X,OOIs_LiCF,Landmarks), PoseGuess0,Op);  %Solution
%dt=toc()*1000

end
%...................................................

% Cost function, based on positions.
function c=CostA(poseV,OOIs_LCF,Landmarks)
% PoseV:  proposed vehicle's pose.
% parameters 
%OOIs_LCF:      Positions of detected OOIs, in Lidar's CF.
%Landmarks:     Positions of associated Landmarks in GCF.

%Express OOIs' positions in GCF, based on proposed LiDAR pose.
Lx=0.45;
OOIs_GCF = TransformCF01(poseV,Lx,OOIs_LCF);  

% evaluate discrepancy between Landmarks positions and those of the 
% proposed ones of OOIs in GCF.
d= Landmarks -OOIs_GCF;
d = (d.*d); d=sqrt(d(1,:)+d(2,:));    
c=sum(d);               
end

%...........................................
% Auxiliary function
function pp =  TransformCF01(X,Lx,pp)  
h=X(3);
c=cos(h); s=sin(h);
R= [ [ c,-s];[s,c]];
pp=R*pp;
T = [Lx;0];
T = T+X(1:2)+R*T;
pp(1,:)=pp(1,:)+T(1);
pp(2,:)=pp(2,:)+T(2);
end
%...........................................


