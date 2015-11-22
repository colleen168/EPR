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
        function [theta1, theta2] = findThetas(obj, x, y)
            r = sqrt(x^2 + y^2);
            alpha = atan2(y,x);
            beta = acos((obj.l1^2 + r^2 - obj.l2^2)/(2*r*obj.l1));
            theta1 = beta + alpha;
            theta2 = atan2(obj.l1*sin(theta1) - y, x - obj.l1*cos(theta1));
        end
        function res = wrongTheta1(obj, th1)
            if th1 >= 0 && th1 <= pi()/2
                res = 0;
            else
                % something is definitely wrong
                display('ERROR: check your kinematics');
                res = 1;
            end 
        end
        function res = wrongTheta2(obj, th2)
            if th2 >= -pi()/2 && th2 <= pi()/2 % allow second link to rotate downward
                res = 0;
            else
                % something is definitely wrong
                display('ERROR: check your kinematics');
                res = 1;
            end 
        end
        % TODO tilt angle check
    end
end

