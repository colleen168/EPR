 function GPScorrection()
        global command_X command_Y command_Phi s1 GPS_X GPS_Y GPS_Phi...
            currentSubTask f_currentSubTask
        disp('GPScorrection');
        if(~strcmp(currentSubTask,'Correting GPS'))
            currentSubTask = 'Correting GPS';
            set(f_currentSubTask, 'String', currentSubTask);
        end
        
        [GPS_X, GPS_Y, GPS_Phi, timestamp] = getVals(s1);
        
        fwrite(serialConnection,num2str(command_X(command_Index)));
        fwrite(serialConnection,',');
        fwrite(serialConnection,num2str(command_Y(command_Index)));
        fwrite(serialConnection,',');
        fwrite(serialConnection,num2str(command_Phi(command_Index)));
        fwrite(serialConnection,',');
        fwrite(serialConnection,num2str(1));
        fwrite(serialConnection,',');
        fwrite(serialConnection,num2str(GPS_X));
        fwrite(serialConnection,',');
        fwrite(serialConnection,num2str(GPS_Y));
        fwrite(serialConnection,',');
        fwrite(serialConnection,num2str(GPS_Phi));
        fwrite(serialConnection,'\n');
        
        disp('GPS correction sent');
    end