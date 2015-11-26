function res = moveToStraight(ak, d, xd, yd)
res = 0;
% straight segment
% read current motor positions, calculate current x-y
ac = d.getArmConfig();
th1Current = ac.theta1;
th2Current = ac.theta2;
[xCur, yCur] = ak.findPosition(th1Current, th2Current);
% calculate angles for desired position
if ~ak.inWorkspace(xd, yd)
    res = -1;
    display('E-Kin: not in workspace');
    return;
end
% TODO it's a good way to store all speed constants in one place
V = 50; % 5 cm/s is perfectly normal speed for linear movement
phi = atan2(yd - yCur, xd - xCur); % direction of speed vector
vx = V*cos(phi);
vy = V*sin(phi);

direction = [(xd - xCur); (yd - yCur)];
N = 10; % number of waypoints
% for large strokes (210,210 to 420,0 for ex) 60-70 points provide
% smooth motions but still - closer to singularity jerkier the motion obvs
% so 5mm per step in the middle region (~45deg for both motors) is fine
x = zeros(N + 1, 1);
y = zeros(N + 1, 1); % intermediate points

for i = 1:1:N+1
    x(i) = xCur + direction(1)*(i-1)/N;
    y(i) = yCur + direction(2)*(i-1)/N;
end
tic
for i = 1:1:N+1
    while Dynamixels.areMoving()
    end
    ac = Dynamixels.getArmConfig();
    curTh1 = ac.theta1;
    curTh2 = ac.theta2;
    curTilt = ac.phi;
    [th1, th2, tilt, res] = ak.findThetas(x(i),y(i));
    if res < 0
        display('E-Kin: cant proceed with straight movement');
        break;
    end
    res = ak.getJointVelocities(curTh1, curTh2, vx, vy);
    w1 = abs(res(1));
    w2 = abs(res(2));
    acNew = ArmConfiguration(th1, th2, 0);
    acNew.w1 = w1;
    acNew.w2 = w2;
    res = Dynamixels.setArmConfig(acNew);
    if res < 0
        Display('E-Dyn: arm config setup failed');
        display(i);
        break;
    end
end
toc
display('Done');
end

