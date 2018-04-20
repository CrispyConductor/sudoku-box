include <sharedparams.scad>

$fa = 3;
$fs = 0.5;

slidePlateHoleRadius = pinBottomRadius + slidePlatePinClearance / 2;
slideDistance = pinNotchDepth;

// Offset from edge of slide plate to center of first hole
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
        translate([holeX * holeSpacing + holeEdgeOffsetX, holeY * holeSpacing + holeEdgeOffsetY + slideDistance + slidePlateHoleRadius - prongLength / 2, slidePlateThick / 2])
            cube([prongWidth, prongLength, slidePlateThick], center=true);
    }
};
