% robot setup is as follows
% top view:
%      | - arm here
%      tilt motor (id#??) FIXME
% bottom left(id#3) - bottom right (id#1)
% side view:
% "back of right bottom motor" ---- tilt --- scoop
BottomRightMotorId = 1;
BottomLeftMotorId = 3;
%TODO TiltMotorId = ;
L1 = 210; % the longest link of 4-bar linkage
L2 = 210; % the length of second link from 4-bar linkage tip to scoop attachment
% ... all other constants should go here

%% initialiaze the motors and whole communication
%unloadlibrary('dynamixel'); % possible leftovers from previous runs
diary arm.log; % start the logging
COM = 12; %Dynamixels.DongleCom - use that
res = Dynamixels.connect(COM); % 2 motors for now, TODO add tilt later
if res < 0
    error('Cant connect to dynamixels');
end
Kinematics = ArmKinematics(L1, L2); % initialize the object for deriving arm kinematics


%% actual movements
while 1
    th1 = 0;
    th2 = 0;
    mode = input('Do you want to use inverse kinematics? Y/N/Q ', 's');
    if mode == 'Y' || mode == 'y'
        x = input('x:');
        y = input('y:');
        [th1, th2] = Kinematics.findThetas(x, y);
    elseif mode == 'Q' || mode == 'q'
        break; % end the loop
    else
        th1 = input('theta1,deg:');
        th1 = th1*pi()/180; % convert to radians
        th2 = input('theta2,deg:');
        th2 = th2*pi()/180;
    end
    if Kinematics.wrongTheta1(th1) || Kinematics.wrongTheta2(th2)
        display(th1); display(th2);
        break;
    end
    Dynamixels.setGoalPos(BottomRightMotorId, th1);
    if ~Dynamixels.wasSuccess()
        display('ERROR: bottom right dyno failure');
        break;        
    end
    Dynamixels.setGoalPos(BottomLeftMotorId, th2);
    if ~Dynamixels.wasSuccess()
        display('ERROR: bottom left dyno failure');
        break;        
    end
end
display('Dont forget to check errors');
Dynamixels.disconnect();
display('See ya!');
















