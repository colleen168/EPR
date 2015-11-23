% 2.12 2-Link Inverse Kinematics
% Steven Keyes - srkeyes@mit.edu
% Oct. 2015
%
% This class represents a 2-link arm and performs inverse kinematics for it

classdef ArmKinematics
    properties
        % lengths of the first link (l1) and the second (l2) in mm
        l1
        l2
    end
    
    methods
        function obj = ArmKinematics(l1, l2)
            % initialize the object with the link lengths
            obj.l1 = l1;
            obj.l2 = l2;
        end
        
        % forward kinematic equations are
        % xe = l1*c1 + l2*c2
        % ye = l1*s1 - l2*s2
        % Jacobian is
        % 1 / l1*l2*sin(th1 + th2) times
        % | -l2*c2  l2*s2  |
        % | -l1*c1  -l1*s1 |
        % singularity configurations: th2 = -th1 (lots of them) - arm stretched out with
        % 180 degrees between long and short link
        function res = getJointVelocities(obj, th1, th2, vx, vy)
            %TODO singularity check
            invJ = [-obj.l2*cos(th2), obj.l2*sin(th2); -obj.l1*cos(th1), -obj.l1*sin(th1)]; %prepare inverse Jacobian
            invJ = invJ./(obj.l1*obj.l2*sin(th1 + th2)); %division by det(J)
            res = invJ*[vx; vy];
        end
        % method to check if a point x,y is in the workspace of the arm
        function isIn = inWorkspace(obj, x, y)
            % we can't go past L1 + L2 and don't need to retract to
            % negative
            if (x < 0 || x > obj.l1 + obj.l2)
                isIn = false;
            else
                % restrict theta1 for 0-pi/2 for now - TODO debatable
                % then if we allow theta2 to be negative y varies in
                % following region
                if (y < 0 || y > obj.l1 + obj.l2)
                    isIn = false;
                else
                    isIn = true;
                end
            end
        end
        
        % inverse kinematics function to calculate servo positions (thetas)
        % from a x,y point in global coordinates. Thetas is an array of two
        % elements: [theta1, theta2] where theta1 is for the first servo,
        % etc.
        function res = wrongTheta1(obj, th1)
            % FIXME ex: move from (0,420) to (210,210) straight
            % can't do that than - straight line is below the circle =>
            % theta1 should go into pi/2 + smth and thats prohibited
            if th1 >= 0 && th1 <= pi/2
                res = 0;
            else
                % something is definitely wrong
                display('E-Kin: check your kinematics');
                disp(th1)
                res = 1;
            end 
        end
        function res = wrongTheta2(obj, th2)
            if th2 >= -pi()/2 && th2 <= pi()/2 % allow second link to rotate downward
                res = 0;
            else
                % something is definitely wrong
                display('E-Kin: check your kinematics');
                disp(th2)
                res = 1;
            end 
        end
        % TODO tilt angle check
        function [theta1, theta2, res] = findThetas(obj, x, y)
            r = sqrt(x^2 + y^2);
            alpha = atan2(y,x);
            beta = acos((obj.l1^2 + r^2 - obj.l2^2)/(2*r*obj.l1));
            theta1 = beta + alpha;
            theta2 = atan2(obj.l1*sin(theta1) - y, x - obj.l1*cos(theta1));
            if wrongTheta1(obj, theta1) || wrongTheta2(obj, theta2)
                res = -1;
            else
                res = 0;
            end
        end
        function [x,y] = findPosition(obj, th1, th2)
            x = obj.l1*cos(th1) + obj.l2*cos(th2);
            y = obj.l1*sin(th1) - obj.l2*sin(th2);
        end
    end
end

