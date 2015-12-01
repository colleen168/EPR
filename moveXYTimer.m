function res = moveXYTimer(timer, timerinfo, ac, ak, x, y, vx, vy)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    i = get(timer, 'TasksExecuted');
    res = moveXY(ac, ak, x(i), y(i), vx, vy);
end

