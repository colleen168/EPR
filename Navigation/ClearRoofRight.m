function ClearRoofRight()
global clearRoofRight roofCleaned

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
    roofCleaned = 1;
    clearRoofRight = 0;
end
end
