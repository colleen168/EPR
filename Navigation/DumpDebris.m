function DumpDebris()
global readyToDumpDebris  collectSnow dumpDebris command_Index newCommand...
    currentDisplay command_X command_Y command_Phi f_currentDisplay...
    serialConnection newStatus


if(readyToDumpDebris == 1)
    if(newScoopCommand == 1)
        CommandScoop() %Give the position to tilt the scoop
        newScoopCommand = 0;
    end
    ReachDebrisTilting();
    if(reachedDebrisTilting == 1)
        CommandRestPosition() %Close the filter and tilt back
        reachedDebrisTilting = 0;
    end
    RestPosition();
    if(reachedRestPosition == 1)
        if(newCommand == 1)
            %Call a function that outputs the commands to Go to
            %Mount Simmons through a way point
            command_X = [1.3];
            command_Y = [0.15];
            command_Phi = [0];
            
            command_Index = 0; %Start looking from the beginning of the Commands
            newCommand = 0; %Command set won't go back in that loop
            command_update = 0; %Send the command to Arduino
            
            if(~strcmp(currentDisplay,'Going Back To Mt Simmons'))
                currentDisplay = 'Going Back To Mt Simmons';
                set(f_currentDisplay, 'String', currentDisplay);
            end
            
        end
        
        %If the position of the Robot has changed regarding its encoders update the
        %waypoint to follow.
        
        if (newStatus == 1)
            pause(0.1);
            if command_Index < length(command_X)
                command_Index = command_Index + 1;
                command_update = 1;
            else
                
                if(~strcmp(currentDisplay,'Reached Mt Simmons'))
                    currentDisplay = 'Reached Mt Simmons';
                    set(f_currentDisplay, 'String', currentDisplay);
                end
                collectSnow = 1; %Start Collecting Snow procedure
                dumpDebris = 0; %Stop the debris dumping procedure
                readyToDumpDebris = 0; %Stop the debris dumping procedure
            end
        end
    end
end

%Send the new waypoint/command to the Arduino to follow
if  (command_update == 1)
    disp('command_sent');
    disp(command_Index);
    fwrite(serialConnection,num2str(command_X(command_Index)));
    fwrite(serialConnection,',');
    fwrite(serialConnection,num2str(command_Y(command_Index)));
    fwrite(serialConnection,',');
    fwrite(serialConnection,num2str(command_Phi(command_Index)));
    fwrite(serialConnection,',');
    fwrite(serialConnection,num2str(0));
    fwrite(serialConnection,',');
    fwrite(serialConnection,num2str(GPS_X));
    fwrite(serialConnection,',');
    fwrite(serialConnection,num2str(GPS_Y));
    fwrite(serialConnection,',');
    fwrite(serialConnection,num2str(GPS_Phi));
    fwrite(serialConnection,'\n');
    command_update = 0;
    pause(1);
end
end