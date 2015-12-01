function RoofLeftRobotOrientation(newxPos, newyPos, newAngle)
global currentSubTask readyToClearRoof command_X command_Y...
    command_Phi newCommand command_Index currentDisplay f_currentSubTask...
    serialConnection f_currentDisplay xPos yPos newStatus Phi 

%Display on the GUI the current sub task
if(~strcmp(currentSubTask,'Moving to Left Roof'))
    currentSubTask = 'Moving to Left Roof';
    set(f_currentSubTask, 'String', currentSubTask);
    newCommand = 1; %Set the position commands to the Robot
end

%Set the waypoints commands to the robot
if(newCommand == 1)
    %Call a function that outputs the commands to Go to
    %Left Part of the roof through a way point
    command_X = 0;
    command_Y = 0;
    command_Phi = 0;
    
    command_Index = 1; %Start looking from the beginning of the Commands
    newCommand = 0; %Command set won't go back in that loop
    command_update = 1; %Send the command to Arduino
end

%If the position of the Robot has changed regarding its encoders update the
%waypoint to follow.
if(~newStatus~= 0)
    if ((abs(command_X(command_Index) - xPos(end)) <= 0.15) && ...
            (abs(command_Y(command_Index) - yPos(end)) <= 0.15))
        if command_Index < length(command_X)
            command_Index = command_Index + 1;
            command_update = 1;
        else
            if(~strcmp(currentDisplay,'Reached Left Roof'))
                currentDisplay = 'Reached Left Roof';
                set(f_currentDisplay, 'String', currentDisplay);
            end
            readyToClearRoof = 0; %We arrived in front of the left part  of the roof
        end
    end
end

%Send the new waypoint/command to the Arduino to follow

if  (command_update == 1)
    fwrite(serialConnection,num2str(command_X(command_Index)));
    fwrite(serialConnection,',');
    fwrite(serialConnection,num2str(command_Y(command_Index)));
    fwrite(serialConnection,',');
    fwrite(serialConnection,num2str(command_Phi(command_Index)));
    fwrite(serialConnection,'\n');
    command_update = 0;
end

end