function res = moveTimed(ak, d, xd, yd)
ac = d.getArmConfig();
th1Current = ac.theta1;
th2Current = ac.theta2;
[xCur, yCur] = ak.findPosition(th1Current, th2Current);
% calculate angles for desired position
% TODO it's a good way to store all speed constants in one place
V = 5; % 5 cm/s is perfectly normal speed for linear movement
dt = 0.2;
step = V*dt;
phi = atan2(yd - yCur, xd - xCur); % direction of speed vector
vx = V*cos(phi);
vy = V*sin(phi);

direction = [(xd - xCur); (yd - yCur)];
N = floor(norm(direction)/step) + 1; % number of waypoints
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
t = timer;
t.TimerFcn = {@moveXYTimer, Dynamixels.getArmConfig(), ak, x, y, vx, vy};
t.Period = dt;
t.TasksToExecute = N;
t.ExecutionMode = 'fixedRate';
start(t)
end