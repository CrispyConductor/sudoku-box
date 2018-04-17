lidWidth = 150; // corresponds to bottomWidth on box
lidDepth = 150; // corresponds to bottomHeight on box
lidHeight = 30+5; // corresponds to topHeight on box, plus lidTopThick

lidTopThick = 5;
lidSideThick = 4; // Must be less than (bottomWidth-topWidth)/2 from box

holeGridSizeX = 9;
holeGridSizeY = 9;
holeRadius = 2.25;
holeSpacing = holeRadius * 6;

holeGridPosX = (lidWidth - (holeGridSizeX - 1) * holeSpacing) / 2;
holeGridPosY = (lidDepth - (holeGridSizeY - 1) * holeSpacing) / 2;

difference() {
    // Main body of lid
    cube([lidWidth, lidDepth, lidHeight]);
    // Lid cavity
    translate([lidSideThick, lidSideThick, 0])
        cube([lidWidth - lidSideThick * 2, lidDepth - lidSideThick * 2, lidHeight - lidTopThick]);
    
    // Top holes
    union() {
        for (holeX = [0 : holeGridSizeX - 1], holeY = [0 : holeGridSizeY - 1]) {
            translate([holeX * holeSpacing + holeGridPosX, holeY * holeSpacing + holeGridPosY, lidHeight - lidTopThick])
                cylinder(h=lidTopThick, r=holeRadius);
        }
    };
};

