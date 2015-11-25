L1 = 220; % the longest link of 4-bar linkage
L2 = 210; % the length of second link from 4-bar linkage tip to scoop attachment
% ... all other constants should go here

%% initialiaze the motors and whole communication
%unloadlibrary('dynamixel'); % possible leftovers from previous runs
diary arm.log; % start the logging
% CRUTCH for use with my (ASh) PC
COM = 6; %FIXME Dynamixels.DongleCom - use that. th
res = Dynamixels.connect(COM); % 2 motors for now, TODO add tilt later
if res < 0
    error('Cant connect to dynamixels');
end
Kinematics = ArmKinematics(L1, L2); % initialize the object for deriving arm kinematics

%%
testLoop(Kinematics, Dynamixels)
















