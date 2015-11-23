function moveToStraight(ak, d, xd, yd)
% straight segment
% read current motor positions, calculate current x-y
th1Current = d.getCurrentAngle(Dynamixels.BottomRightMotorId);
th2Current = d.getCurrentAngle(Dynamixels.BottomLeftMotorId);
[xCur, yCur] = ak.findPosition(th1Current, th2Current);
% calculate angles for desired position
if ~ak.inWorkspace(xd, yd)
    display('ERROR: not in worspace');
    return;
end
% TODO it's a good way to store all speed constants in one place
%V = 0.05; % 5 cm/s is perfectly normal speed for linear movement
%phi = atan(yd - yCur, xd - xCur); % direction of speed vector
%vx = V*cos(phi);
%vy = V*sin(phi);

%L = sqrt((xd - xCur)^2 + (yd - yCur)^2); % distance
direction = [(xd - xCur); (yd - yCur)];
N = 20;
% for large strokes (210,210 to 420,0 for ex) 60-70 points provide
% smooth motions but still - closer to singularity jerkier the motion obvs
% so 5mm per step in the middle region (~45deg for both motors) is fine
%floor(t/dt) + 1; % number of checking points
step = direction./N;
%t = L / V; % time required for that
%dt = 0.1; % we will use 10 samples per second - debatable
x = zeros(N + 1, 1);
y = zeros(N + 1, 1); % intermediate points
for i = 1:1:N+1
    x(i) = xCur + step(1)*(i-1);
    y(i) = yCur + step(2)*(i-1);
end

for i = 1:1:N+1
    while Dynamixels.areMoving()
    end
    [th1, th2, res] = ak.findThetas(x(i),y(i));
    if res < 0
        display('ERROR: cant proceed with straight movement');
        break;
    end
    display('Moving to position '); display(th1); display(th2);
    d.setGoalAngle(Dynamixels.BottomRightMotorId, th1);
    d.setGoalAngle(Dynamixels.BottomLeftMotorId, th2);
    % TODO check errors!
end
display('Done');
end

