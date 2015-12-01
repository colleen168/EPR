function ClearRoofLeft()
global clearRoofRight clearRoofLeft

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
    clearRoofLeft = 0;
    clearRoofRight = 1;
end
end
