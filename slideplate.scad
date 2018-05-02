include <sharedparams.scad>

$fa = 3;
$fs = 0.5;

slidePlateHoleRadius = pinBottomRadius + slidePlatePinClearance / 2;
slideDistance = pinNotchDepth;

// Offset from edge of slide plate to center of first hole
// The "first" hole is the one the pin occupies in the unlocked position.  The "second" hole is moved slideDistance in the Y direction
holeEdgeOffsetX = (slidePlateWidth - (holeGridSizeX - 1) * holeSpacing) / 2;
holeEdgeOffsetY = (slidePlateDepth - (holeGridSizeY - 1) * holeSpacing) / 2 - slideDistance / 2;

// Place the plate in the same XY reference frame as the lid, as if the plate were in locked position
slidePlatePosX = lidSize[0] / 2 - slidePlateWidth / 2;
slidePlatePosYLocked = holeGridPosY - holeEdgeOffsetY - slideDistance;

union() {
    difference() {
        // Main rectangle
        translate([slidePlatePosX, slidePlatePosYLocked, 0])
            cube([slidePlateWidth, slidePlateDepth, slidePlateThick]);
        // Holes
        for (holeX = [0 : holeGridSizeX - 1], holeY = [0 : holeGridSizeY - 1]) {
            holePosX = slidePlatePosX + holeX * holeSpacing + holeEdgeOffsetX;
            holePosY = slidePlatePosYLocked + holeY * holeSpacing + holeEdgeOffsetY;
            // First hole
            translate([holePosX, holePosY, 0])
                cylinder(r=slidePlateHoleRadius, h=slidePlateThick);
            // Second hole
            translate([holePosX, holePosY + slideDistance, 0])
                cylinder(r=slidePlateHoleRadius, h=slidePlateThick);
            // Rectangle between the two
            translate([holePosX, holePosY + slideDistance / 2, slidePlateThick / 2])
                cube([slidePlateHoleRadius * 2, slideDistance, slidePlateThick], center=true);
        }
    };
    // Prongs
    prongLength = slideDistance - prongLengthClearance + slidePlatePinClearance / 2;
    prongWidth = pinNotchWidth - pinNotchClearance * 2;
    for (holeX = [0 : holeGridSizeX - 1], holeY = [0 : holeGridSizeY - 1]) {
        translate([
            slidePlatePosX + holeX * holeSpacing + holeEdgeOffsetX,
            slidePlatePosYLocked + holeY * holeSpacing + holeEdgeOffsetY - slidePlateHoleRadius + prongLength / 2,
            slidePlateThick / 2
        ])
            cube([prongWidth, prongLength, slidePlateThick], center=true);
    }
    // Button arm (minus button)
    buttonArmWidth = boxKeyholeWidth - 2 * keywayClearanceX; // width of the key part of the button arm
    buttonArmFrontYLocked = lidSideThick + 0.1; // Y of the front side of button arm in locked position, ideally
    buttonArmFrontYUnlocked = buttonArmFrontYLocked + slideDistance; // Y of front side of button arm in unlocked position, ideally
    buttonArmUnlockedBoxSpace = buttonArmFrontYUnlocked - lidSideThick - lidSideBoxClearance - boxTopThick; // space between button key and inside of box in unlocked position, ideally
    if (buttonArmUnlockedBoxSpace < buttonPressClearance) {
        echo("Slide distance insufficient to unlock box with buttonPressClearance.  Recalculating button arm length.");
        echo("slideDistance", slideDistance, "buttonArmUnlockedBoxSpace", buttonArmUnlockedBoxSpace, "buttonPressClearance", buttonPressClearance);
    } else {
        echo("When unlocked, button arm clears box by", buttonArmUnlockedBoxSpace);
    }
    buttonArmBaseLength = slidePlatePosYLocked - buttonArmFrontYLocked;
    buttonArmLength = (buttonArmUnlockedBoxSpace < buttonPressClearance) ?
        (buttonArmBaseLength - (buttonPressClearance - buttonArmUnlockedBoxSpace)) :
        buttonArmBaseLength;
    echo("buttonArmLength", buttonArmLength);
    
/*
    // buttonArmLength is the distance from the front edge of the sliding plate to the inner side of the front of the box (not the lid), minus buttonPressClearance, in unlocked position.
    //buttonArmLength = holeGridPosY - lidSideThick - lidSideBoxClearance * 2 - boxTopThick - buttonPressClearance - holeEdgeOffsetY;
*/
    translate([slidePlatePosX + slidePlateWidth / 2 - buttonArmWidth / 2 + keywayClearanceX, slidePlatePosYLocked - buttonArmLength, 0])
        cube([buttonArmWidth, buttonArmLength, slidePlateThick]);
    // Button
    // must be sufficiently long to extend out the front of the box buttonMinExtension in the unlocked position
    buttonLength = buttonPressClearance + boxTopThick + lidSideBoxClearance * 2 + lidSideThick + buttonMinExtension;
    translate([slidePlatePosX + slidePlateWidth / 2 - buttonWidth / 2 + keywayClearanceX, slidePlatePosYLocked - buttonArmLength - buttonLength, 0])
        cube([buttonWidth, buttonLength, slidePlateThick]);
};
