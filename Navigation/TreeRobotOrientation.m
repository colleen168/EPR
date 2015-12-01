function TreeRobotOrientation(newxPos, newyPos, newAngle)
global newStatus readyToLift command_X command_Y f_currentDisplay...
    command_Phi newCommand command_Index currentDisplay serialConnection...
    


%Set the waypoints commands to the robot
if(newCommand == 1)
    [Region_xc,Region_yc]=DetectionDebris(3, I);%detect debris;I is the corrent image from the kinect
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
            readyToLift = 1; %Start Scoop motion to lift the tree
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

end