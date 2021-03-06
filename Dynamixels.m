% 2.12 Dynamixel interface code
% Zack Bright - zbright@mit.edu
% Steven Keyes - srkeyes@mit.edu
% Oct. 2015
%
% This class represents a set of Dynamixel servos connected to the computer

classdef Dynamixels
    properties (Constant)
        % Dynamixel library constants
%         ERRBIT_VOLTAGE     = 1;
%         ERRBIT_ANGLE       = 2;
%         ERRBIT_OVERHEAT    = 4;
%         ERRBIT_RANGE       = 8;
%         ERRBIT_CHECKSUM    = 16;
%         ERRBIT_OVERLOAD    = 32;
%         ERRBIT_INSTRUCTION = 64;
        
        COMM_TXSUCCESS     = 0;
        COMM_RXSUCCESS     = 1;
        COMM_TXFAIL        = 2;
        COMM_RXFAIL        = 3;
        COMM_TXERROR       = 4;
        COMM_RXWAITING     = 5;
        COMM_RXTIMEOUT     = 6;
        COMM_RXCORRUPT     = 7;
        % and our port constants
        DongleCom = 7; %
        DongleBaud = 4; % should be like that
    end
    methods (Static)
        function res = wasSuccess()
            result = calllib('dynamixel','dxl_get_result');
            if result == Dynamixels.COMM_TXSUCCESS
                res = 1;
            elseif result == Dynamixels.COMM_RXSUCCESS
                res = 1;
            elseif result == Dynamixels.COMM_TXFAIL
                display('Serial sending error');
                res = 0;
            elseif result == Dynamixels.COMM_RXFAIL
                display('Serial receiving error');
                res = 0;
            elseif result == Dynamixels.COMM_TXERROR
                display('Instruction packet is wrong');
                res = 0;
            elseif result == Dynamixels.COMM_RXWAITING
                display('Waiting for smth');
                res = 0;
            elseif result == Dynamixels.COMM_RXTIMEOUT
                display('Not responding');
                res = 0;
            elseif result == Dynamixels.COMM_RXCORRUPT
                display('Bad packet');
                res = 0;
            end
        end
        % method to connect to the dongle and identify its servos
        % returns a list of the IDs of all the servos
        function res = connect(COM)
            loadlibrary('dynamixel','dynamixel.h')
            % 1 is success, 0 is failure in lib...
            % return negative values for any error goddamnit!
            res = -1 + calllib('dynamixel','dxl_initialize', COM, Dynamixels.DongleBaud);
        end
        
        % set the position of a single servo -- range 0 to 4095, centered
        % at 2047
        function setGoalPos(Id, angle)
            % motor angle is different from kinematic one because of
            % physical setup
            % TODO for tilt - check before using!
            motor = 3*pi()/2 - angle;
            % convert angle in radians to angle in Dynamixel values (0-4095)
            Pos = round(motor * 4095 / (2*pi));
            % never ever write values of of 2048 - 4096 range
            % we only work with left half plane angles for both motors
            if Pos < 2048 || Pos >= 4096
                display('ERROR: Check your values');
                display(Pos);
                return;
            end
            % this is the Register on the Servo that corresponds to the goal pos
            P_GOAL_POSITION = 30;
            % write it
            calllib('dynamixel','dxl_write_word', Id, P_GOAL_POSITION, Pos);
        end
        
        function pos = getCurrentPos(Id)
            % this is the Register on the Servo that corresponds to the current pos
            P_CURRENT_POSITION = 36;
            % read it
            pos = calllib('dynamixel','dxl_read_word', Id, P_CURRENT_POSITION);
        end
      
        function disconnect()
            calllib('dynamixel','dxl_terminate');
            unloadlibrary('dynamixel');
        end    
end
end