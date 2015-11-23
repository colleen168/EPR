L1 = 210; % the longest link of 4-bar linkage
L2 = 210; % the length of second link from 4-bar linkage tip to scoop attachment
% ... all other constants should go here

%% initialiaze the motors and whole communication
%unloadlibrary('dynamixel'); % possible leftovers from previous runs
diary arm.log; % start the logging
% CRUTCH for use with my (ASh) PC
COM = 12; %FIXME Dynamixels.DongleCom - use that. th
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
    invKres = 0;
    if mode == 'Y' || mode == 'y'
        x = input('x:');
        y = input('y:');
        [th1, th2, invKres] = Kinematics.findThetas(x, y);
    elseif mode == 'Q' || mode == 'q'
        break; % end the loop
    else
        th1 = input('theta1,deg:');
        th1 = th1*pi()/180; % convert to radians
        th2 = input('theta2,deg:');
        th2 = th2*pi()/180;
    end
    if invKres < 0
        display(th1); display(th2);
        break;
    end
    % TODO Refactor - hide motor ids inside Dynamixels
    Dynamixels.setGoalAngle(Dynamixels.BottomRightMotorId, th1);
    if ~Dynamixels.wasSuccess()
        display('ERROR: bottom right dyno failure');
        break;        
    end
    Dynamixels.setGoalAngle(Dynamixels.BottomLeftMotorId, th2);
    if ~Dynamixels.wasSuccess()
        display('ERROR: bottom left dyno failure');
        break;        
    end
end
display('Dont forget to check errors');
Dynamixels.disconnect();
display('See ya!');
















