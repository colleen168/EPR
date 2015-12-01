function TreeClearanceRobotOrientation(newxPos, newyPos, newAngle)
global readyToClear command_X command_Y...
    command_Phi newCommand command_Index currentDisplay...
    secondAttemptPos dropScoop f_currentDisplay newStatus...
    serialConnection

%Display on the GUI the current display
if(~strcmp(currentDisplay,'Clearing Second Attempt'))
    currentDisplay = 'Clearing Second Attempt';
    set(f_currentDisplay, 'String',currentDisplay);
    secondAttemptPos = 0; %Wait to reposition before trying again
    newCommand = 1; %Set the position commands to the Robot
end

if(secondAttemptPos == 0)
    %Set the waypoints commands to the robot to move back
    if(newCommand == 1)
        command_X = 0;
        command_Y = 0;
        command_Phi = 0;
        
        command_Index = 1; %Start looking from the beginning of the Commands
        newCommand = 0; %Command set won't go back in that loop
        command_update = 1; %Send the command to Arduino
    end
    
    %If the position of the Robot has changed regarding its encoders update the
    %waypoint to follow.
    if (newStatus ~= 0)
        if ((abs(command_X(command_Index) - newxPos) <= 0.05) && ...
                (abs(command_Y(command_Index) - newyPos) <= 0.05) &&...
                (abs(command_Phi(command_Index) - newAngle) <= 5))
            if command_Index < length(command_X)
                command_Index = command_Index + 1;
                command_update = 1;
            else
                if(~strcmp(currentDisplay,'Reached Clearance Area'))
                    currentDisplay = 'Reached Clearance Area';
                    set(f_currentDisplay, 'String',currentDisplay);
                end
                secondAttemptPos = 1; %Start Scoop motion to lift the tree
            end
        end
    end
    
    %Send the new waypoint/command to the Arduino to follow
    if  (command_update == 1)
        fwrite(serialConnection,num2str(command_X(command_Index)));
        fwrite(serialConnection,',');
        fwrite(serialConnection,num2str(command_Y(command_Index)));
        fwrite(serialConnection,',');
        fwrite(serialConnection,num2str(pi/180*command_Phi(command_Index)));
        fwrite(serialConnection,'\n');
        pause(1); %pause for the serial communication
        command_update = 0;
    end
    
else
    
    %Display on the GUI the current display
    if(~strcmp(currentDisplay,'Robot Orientation'))
        currentDisplay = 'Robot Orientation';
        set(f_currentDisplay, 'String',currentDisplay);
        dropScoop = 0; %Wait to have the good orientation to collect snow
        newCommand = 1; %Set the position commands to the Robot
    end
    if(dropScoop == 0)
        %Set the waypoints commands to the robot
        if(newCommand == 1)
            DetectTree(); %%%%%%%Change to fit Yi's code
            %Call a function that outputs the commands to orientate the robot
            %in front of the tree through a way point
            command_X = 0;
            command_Y = 0;
            command_Phi = 0;
            
            command_Index = 1; %Start looking from the beginning of the Commands
            newCommand = 0; %Command set won't go back in that loop
            command_update = 1; %Send the command to Arduino
        end
        
        %If the position of the Robot has changed regarding its encoders update the
        %waypoint to follow.
        if (newStatus ~= 0)
            if ((abs(command_X(command_Index) - newxPos) <= 0.05) && ...
                    (abs(command_Y(command_Index) - newyPos) <= 0.05) &&...
                    (abs(command_Phi(command_Index) - newAngle) <= 5))
                if command_Index < length(command_X)
                    command_Index = command_Index + 1;
                    command_update = 1;
                else
                    if(~strcmp(currentDisplay,'Good Robot Orientation'))
                        currentDisplay = 'Good Robot Orientation';
                        set(f_currentDisplay, 'String',currentDisplay);
                    end
                    dropScoop = 1; %Start Scoop motion to lift the tree
                end
            end
        end
        
        %Send the new waypoint/command to the Arduino to follow
        if  (command_update == 1)
            fwrite(serialConnection,num2str(command_X(command_Index)));
            fwrite(serialConnection,',');
            fwrite(serialConnection,num2str(command_Y(command_Index)));
            fwrite(serialConnection,',');
            fwrite(serialConnection,num2str(pi/180*command_Phi(command_Index)));
            fwrite(serialConnection,'\n');
            pause(1); %pause for the serial communication
            command_update = 0;
        end
    else
        if(newScoopCommand == 1)
            CommandScoop() %Give the position of the scoop regarding the Tree position
            newScoopCommand = 0;
        end
        ReachPositionScoop();
        if(reachedPositionScoop == 1)
            CommandScoop()
            reachedPositionScoop = 0;
        end
        ReachPositionScoop();
        if(reachedPositionSet == 1)
            dropScoop = 0;
            readyToClear= 1;
        end
    end
    
end
end