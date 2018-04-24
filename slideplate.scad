include <sharedparams.scad>

$fa = 3;
$fs = 0.5;

slidePlateHoleRadius = pinBottomRadius + slidePlatePinClearance / 2;
slideDistance = pinNotchDepth;

// Offset from edge of slide plate to center of first hole
// The "first" hole is the one the pin occupies in the unlocked position.  The "second" hole is moved slideDistance in the Y direction
holeEdgeOffsetX = (slidePlateWidth - (holeGridSizeX - 1) * holeSpacing) / 2;
holeEdgeOffsetY = (slidePlateDepth - (holeGridSizeY - 1) * holeSpacing) / 2 - slideDistance / 2;

union() {
    difference() {
        // Main rectangle
        cube([slidePlateWidth, slidePlateDepth, slidePlateThick]);
        // Holes
        for (holeX = [0 : holeGridSizeX - 1], holeY = [0 : holeGridSizeY - 1]) {
            // First hole
            translate([holeX * holeSpacing + holeEdgeOffsetX, holeY * holeSpacing + holeEdgeOffsetY, 0])
                cylinder(r=slidePlateHoleRadius, h=slidePlateThick);
            // Second hole
            translate([holeX * holeSpacing + holeEdgeOffsetX, holeY * holeSpacing + holeEdgeOffsetY + slideDistance, 0])
                cylinder(r=slidePlateHoleRadius, h=slidePlateThick);
            // Rectangle between the two
            translate([holeX * holeSpacing + holeEdgeOffsetX, holeY * holeSpacing + holeEdgeOffsetY + slideDistance / 2, slidePlateThick / 2])
                cube([slidePlateHoleRadius * 2, slideDistance, slidePlateThick], center=true);
        }
    };
    // Prongs
    prongLength = slideDistance - prongLengthClearance + slidePlatePinClearance / 2;
    prongWidth = pinNotchWidth - pinNotchClearance * 2;
    for (holeX = [0 : holeGridSizeX - 1], holeY = [0 : holeGridSizeY - 1]) {
        translate([holeX * holeSpacing + holeEdgeOffsetX, holeY * holeSpacing + holeEdgeOffsetY - slidePlateHoleRadius + prongLength / 2, slidePlateThick / 2])
            cube([prongWidth, prongLength, slidePlateThick], center=true);
    }
    // Button arm (minus button)
    buttonArmWidth = boxKeyholeWidth - 2 * keywayClearanceX;
    // buttonArmLength is the distance from the front edge of the sliding plate to the inner side of the front of the box (not the lid), minus buttonPressClearance, in unlocked position.
    buttonArmLength = holeGridPosY - lidSideThick - lidSideBoxClearance * 2 - boxTopThick - buttonPressClearance - holeEdgeOffsetY;
    translate([slidePlateWidth / 2 - buttonArmWidth / 2 + keywayClearanceX, -buttonArmLength, 0])
        cube([buttonArmWidth, buttonArmLength, slidePlateThick]);
    // Button
    // must be sufficiently long to extend out the front of the box buttonMinExtension in the unlocked position
    buttonLength = buttonPressClearance + boxTopThick + lidSideBoxClearance * 2 + lidSideThick + buttonMinExtension;
    translate([slidePlateWidth / 2 - buttonWidth / 2 + keywayClearanceX, -buttonArmLength - buttonLength, 0])
        cube([buttonWidth, buttonLength, slidePlateThick]);
};
