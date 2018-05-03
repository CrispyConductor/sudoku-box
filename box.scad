include <sharedparams.scad>

bottomWidth = boxSize[0];
bottomDepth = boxSize[1];
bottomHeight = boxSize[2] - boxTopSectionHeight - lidTopThick;
bottomThick = 1.5;

topWidth = bottomWidth - 2 * (lidSideThick + lidSideBoxClearance);
topDepth = bottomDepth - 2 * (lidSideThick + lidSideBoxClearance);
topHeight = boxTopSectionHeight;
topThick = boxTopThick;

connectingBrimThick = max(topThick, bottomThick) * 2;

keywayWidth = boxKeywayWidth;
keywayOffsetX = topWidth / 2;

keyholeWidth = boxKeyholeWidth;
keyholeHeight = slidePlateThick + 2 * keyholeClearanceZ;

// Offset from bottom of lid to bottom of keyhole slot
keywayOffsetZ = lidSize[2] - buttonTopOffset - slidePlateThick - keyholeClearanceZ;

union() {
    // Bottom shell
    difference() {
        // Box
        cube([bottomWidth, bottomDepth, bottomHeight]);
        // Cavity
        translate([bottomThick, bottomThick, bottomThick])
            cube([bottomWidth - bottomThick * 2, bottomDepth - bottomThick * 2, bottomHeight - bottomThick + 10]);
    };
    // Top shell
    translate([(bottomWidth - topWidth) / 2, (bottomDepth - topDepth) / 2, bottomHeight])
        difference() {
            // Box
            cube([topWidth, topDepth, topHeight]);
            // Cavity
            translate([topThick, topThick, 0])
                cube([topWidth - topThick * 2, topDepth - topThick * 2, topHeight + 10]);
            // Keyway slot
            translate([keywayOffsetX - keywayWidth / 2, 0, keywayOffsetZ])
                cube([keywayWidth, topThick, topHeight]);
            // Keyhole at bottom of slot
            translate([keywayOffsetX - keyholeWidth / 2, 0, keywayOffsetZ])
                cube([keyholeWidth, topThick, keyholeHeight]);
        };
    // Brim between top and bottom
    translate([0, 0, bottomHeight - connectingBrimThick])
        difference() {
            cube([bottomWidth, bottomDepth, connectingBrimThick]);
            translate([(bottomWidth - topWidth) / 2 + topThick, (bottomDepth - topDepth) / 2 + topThick, -5])
                cube([topWidth - topThick * 2, topDepth - topThick * 2, connectingBrimThick + 10]);
        };
    // Chamfer on brim
    chamferLegLenY = (bottomWidth - topWidth) / 2 + topThick - bottomThick;
    chamferLegLenX = (bottomDepth - topDepth) / 2 + topThick - bottomThick;
    translate([0, bottomThick, bottomHeight - connectingBrimThick])
        mirror([0, 1, 0])
            rotate([-90, 0, -90])
                linear_extrude(height=bottomWidth)
                    polygon([[0, 0], [chamferLegLenX, 0], [0, chamferLegLenX]]);
    translate([0, bottomDepth - bottomThick, bottomHeight - connectingBrimThick])
        mirror([0, 0, 0])
            rotate([-90, 0, -90])
                linear_extrude(height=bottomWidth)
                    polygon([[0, 0], [chamferLegLenX, 0], [0, chamferLegLenX]]);
    translate([bottomThick, 0, bottomHeight - connectingBrimThick])
        mirror([0, 0, 0])
            rotate([-90, 0, 0])
                linear_extrude(height=bottomDepth)
                    polygon([[0, 0], [chamferLegLenY, 0], [0, chamferLegLenY]]);
    translate([bottomWidth - bottomThick, 0, bottomHeight - connectingBrimThick])
        mirror([1, 0, 0])
            rotate([-90, 0, 0])
                linear_extrude(height=bottomDepth)
                    polygon([[0, 0], [chamferLegLenY, 0], [0, chamferLegLenY]]);
};
