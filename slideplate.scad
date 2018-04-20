include <sharedparams.scad>


slidePlateHoleRadius = pinBottomRadius + slidePlatePinClearance / 2;
slideDistance = pinNotchDepth;

// Offset from edge of slide plate to center of first hole
holeEdgeOffsetX = (slidePlateWidth - (holeGridSizeX - 1) * holeSpacing) / 2;
holeEdgeOffsetY = (slidePlateDepth - (holeGridSizeY - 1) * holeSpacing) / 2; // NOT GONNA WORK FIX ME

difference() {
    // Main rectangle
    cube([slidePlateWidth, slidePlateDepth, slidePlateThick]);
    // Holes
    for (holeX = [0 : holeGridSizeX - 1], holeY = [0 : holeGridSizeY - 1]) {
        translate([holeX * holeSpacing + holeEdgeOffsetX, holeY * holeSpacing + holeEdgeOffsetY, 0])
            cylinder(r=slidePlateHoleRadius, h=slidePlateThick);
    }
};
