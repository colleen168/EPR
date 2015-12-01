function ExcecuteTask2(newxPos, newyPos, newAngle)

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
if(~strcmp(currentTask,'Clear Tree'))
    currentTask = 'Clear Tree';
    set(f_currentTask, 'String', currentTask);
    %keeping the count of the passage in the loop to move on to
    %Task 2 at a certain point
    achievePosTree = 0;
end

%Move to Mt Simmons Collecting Snow Area
if(achievePosTree == 0)
    MoveToTree(newxPos, newyPos, newAngle);
else
    
    if(removeTree == 1)
        %Display on the GUI the current sub task
        if(~strcmp(currentSubTask,'Lift Tree'))
            currentSubTask = 'Lift Tree';
            set(f_currentSubTask, 'String', currentSubTask);
            readyToLift = 0; %Wait to have the good orientation to collect snow
            newCommand = 1; %Set the position commands to the Robot
        end
        
        if(readyToLift == 0)
            %Orientate the robot in front of the tree to lift
            TreeRobotOrientation(newxPos, newyPos, newAngle);
        else
            %Lift Tree
               LiftTree()
        end
    end
    
    if(dumpTree == 1)
        %Display on the GUI the current sub task
        if(~strcmp(currentSubTask,'Release Tree'))
            currentSubTask = 'Release Tree';
            set(f_currentSubTask, 'String', currentSubTask);
            newCommand = 1; %Set the position commands to the Robot
        end
        
%         if(SuccessLiftTree()==1)
            %Display on the GUI the current display
            if(~strcmp(currentDisplay,'Tree acquired'))
                currentDisplay = 'Tree acquired';
                set(f_currentSubTask, 'String', currentSubTask);
                readyToReleaseTree = 0; %Wait to have reached the good
                %area to release the tree
            end
            
            if(readyToReleaseTree == 0)
                %Orientate the robot to the tree clearance area
                TreeReleaseRobotOrientation(newxPos, newyPos, newAngle);
            else
                %Release Tree
                ReleaseTree()
            end
%         else
%             %Display on the GUI the current display
%             if(~strcmp(currentDisplay,'Tree not acquired'))
%                 currentDisplay = 'Tree not acquired';
%                 set(f_currentSubTask, 'String', currentSubTask);
%                 readyToClear = 0; %Wait to have the scoop in a
%                 %good configuration to clear the tree
%             end
%             
%             if(readyToClear == 0)
%                 %Orientate the robot to clear the tree
%                 TreeClearanceRobotOrientation(newxPos, newyPos, newAngle);
%             else
%                 %Release Tree
%                 ClearTree()
%             end
%         end
    end
end
end