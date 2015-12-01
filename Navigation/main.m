%2.12 EPRTeam
function SnowChallenge
global task prevTask VideoFeedData

task = 1;
prevTask = 1;

TaskPlanningGUI

% 
% 
% task = 0;
% 
% MoveTo(MountSimons);
% 
% task = 1;
% 
% while(task == 1)
%     
%     CollectSnow();
%     MoveTo(SnowDump);
%     SnowRelease();
%     MoveTo(DebrisDump);
%     DebrisRelease();
%     MoveTo(MountSimons);
%     DetectDebris();
%     
% end
% 
% if(task == 2)
%     DetectTree();
%     MoveTo(Tree);
%     LiftTree();
%     if(TreeSuccess)
%         MoveTo(TreeSide);
%         TreeRelease();
%     else
%         MoveTo(Tree);
%         PutDownManipulator();
%         MoveTo(EndSide);
%     end
%     RestPosition();
%     MoveTo(TreeCheckPoint);
% end
% 
% task=3;
% 
% MoveTo(HouseBegin);
% MoveUpManipulator();
% PullDownSnow();
% MoveTo(HouseCenter);
% MoveUpManipulator();
% PullDownSnow();
% MoveTo(HouseEnd)
% MoveUpManipulator();
% PullDownSnow();
% 
% StepBackHouse();
% GoBackInit();
% 
end