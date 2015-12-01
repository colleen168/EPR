function ReleaseTree()
global readyToReleaseTree Ctask dumpTree command_Index newCommand...
    currentDisplay command_X command_Y command_Phi f_currentDisplay newStatus...
    serialConnection

if(newScoopCommand == 1)
    CommandScoop() %Give the position to tilt the scoop
    newScoopCommand = 0;
end
ReachDebrisTilting();
if(reachedDebrisTilting == 1)
    CommandRestPosition() %tilt back the scoop
    reachedDebrisTilting = 0;
end
RestPosition();

if(reachedRestPosition == 1)
    if(~strcmp(currentDisplay,'Tree Cleared'))
        currentDisplay = 'Tree Cleared';
        set(f_currentDisplay, 'String',currentDisplay);
        newCommand = 1;
    end
    
    if(newCommand == 1)
        %Call a function that outputs the commands to Go to
        %Roof Checkpoint through a way point
        command_X = 0;
        command_Y = 0;
        command_Phi = 0;
        
        if(~strcmp(currentDisplay,'Going To Roof Checkpoint'))
            currentDisplay = 'Going To Roof Checkpoint';
            set(f_currentDisplay, 'String',currentDisplay);
        end
        
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
                if(~strcmp(currentDisplay,'Reached Roof Checkpoint'))
                    currentDisplay = 'Reached Roof Checkpoint';
                    set(f_currentDisplay, 'String',currentDisplay);
                end
                Ctask = 3; %Initiate task 3
                dumpTree = 0; %Stop the tree clearing procedure
                readyToReleaseTree = 0; %Stop the tree clearing procedure
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
end