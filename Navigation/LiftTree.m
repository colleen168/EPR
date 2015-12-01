function LiftTree()
global readyToLift dumpTree removeTree

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
    readyToLift = 0;
    removeTree = 0;
    dumpTree= 1;
end
end
