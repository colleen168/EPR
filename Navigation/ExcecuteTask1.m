function ExcecuteTask1(newxPos, newyPos, newAngle)

global f f_manual f_automatic f_title f_robotPosTable f_BoardMap f_Video...
    f_textTask f_currentTask f_textRobotPos f_textLibrary f_dismantle ...
    f_controlPanel f_taskPanel f_snowCollection f_dumpsnow ...
    f_dumpdebris f_clearTree f_releaseTree f_liftTree f_clearRoof ...
    f_alignRoof f_clearSnow f_boardPanel f_textSubTask f_currentSubTask ...
    f_restPos f_textDisplay f_currentDisplay currentPos xPos yPos Phi mode...
    counter Ctask achievePosMt collectSnow command_X command_Y command_Phi...
    newCommand command_Index countCollectSnow currentTask currentSubTask...
    currentDisplay robotSize scaleFactor robotXCenter robotYCenter BoardMapData...
    blobColor VideoFeedData newStatus readyToCollect dumpSnow dumpDebris...
    readyToDumpSnow readyToDumpDebris achievePosTree removeTree readyToLift...
    readyToReleaseTree dumpTree readyToClear serialConnection...
    serialData xPosInit yPosInit PhiInit counterserial clearRoofLeft...
    readyToClearRoof clearRoofRight roofCleaned

%Display on the GUI the current task
if(~strcmp(currentTask,'Dismantle Mt Simmons'))
    currentTask = 'Dismantle Mt Simmons';
    set(f_currentTask, 'String', currentTask);
    achievePosMt = 0;
end

%Move to Mt Simmons Collecting Snow Area
if(achievePosMt == 0)
    MoveToMtSimmons(newxPos, newyPos, newAngle);
else
    
    %After we arrived to Mt Simmons
    if (collectSnow == 1)
        
        
        %Display on the GUI the current sub task
        if(~strcmp(currentSubTask,'Collecting Snow'))
            currentSubTask = 'Collecting Snow';
            set(f_currentSubTask, 'String', currentSubTask);
            readyToCollect = 0; %Wait to have the good orientation to collect snow
            newCommand = 1; %Set the position commands to the Robot
            %keeping the count of the passage in the loop to move on to
            %Task 2 at a certain point
            countCollectSnow = countCollectSnow + 1;
        end
        
        
        if(readyToCollect == 0)
            %Orientate the robot in front of the debris to collect
            DebrisRobotOrientation(newxPos, newyPos, newAngle);
        else
            %Collect Snow&Debris
            ScoopSnow();
        end
    end
    
    %Dump the scoop full of Snow&Debris
    if (dumpSnow == 1)
        %Display on the GUI the current sub task
        if(~strcmp(currentSubTask,'Dumping Snow'))
            currentSubTask = 'Dumping Snow';
            set(f_currentSubTask, 'String', currentSubTask);
            readyToDumpSnow = 0; %Wait to have the good orientation to dump snow
            newCommand = 1; %Set the position commands to the Robot
        end
        
        if(readyToDumpSnow == 0)
            %Move the robot in front of the Truck to Dump the Snow
            MoveToSnowTruck(newxPos, newyPos, newAngle);
        else
            %Dump the snow in the truck&shaking
            DumpSnow();
        end
    end
    
    if(dumpDebris == 1)
        %Display on the GUI the current sub task
        if(~strcmp(currentSubTask,'Dumping Debris'))
            currentSubTask = 'Dumping Debris';
            set(f_currentSubTask, 'String', currentSubTask);
            readyToDumpDebris = 0; %Wait to have the good orientation to dump debris
            newCommand = 1; %Set the position commands to the Robot
        end
        
        if(readyToDumpDebris == 0)
            %Move the robot in front of the Truck to Dump the
            %Debris and if there is no debris go back to Mt Simmons
            MoveToDebrisTruck(newxPos, newyPos, newAngle);
        else
            %Dump the debris in the truck & go back to Mt Simmons
            DumpDebris()
        end
    end
end

end