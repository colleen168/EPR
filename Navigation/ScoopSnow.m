function ScoopSnow()
global readyToCollect dumpSnow collectSnow

if(newScoopCommand == 1)
    CommandScoop() %Give the position of the scoop regarding the debris position
    newScoopCommand = 0;
end
ReachPositionScoop();
if(reachedPositionScoop == 1)
    CommandScoop()
    reachedPositionScoop = 0;
end
ReachPositionScoop();
if(reachedPositionSet == 1)
    readyToCollect = 0;
    collectSnow = 0;
    dumpSnow= 1;
end
end
