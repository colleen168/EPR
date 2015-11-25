classdef ArmConfiguration
    % hide the details of angles and which motor activates what angle
    properties
        % looking from right, robot on the left
        % stretched scoop on the right
        theta1 = pi/2 % long link from base to vertical counterclockwise, 0 to pi/2 (pi?)
        theta2 = 0 % short link from base to vertical, clockwise
        phi  = 0% tilt of the scoop against base
    end
    methods
        function e = ArmConfiguration(t1, t2, tilt)
            e.theta1 = t1;
            e.theta2 = t2;
            e.phi = tilt;
        end
        function [t1, t2, tilt] = getConfig(obj)
            t1 = obj.theta1;
            t2 = obj.theta2;
            tilt = obj.phi;
        end
    end
    
end

