include <sharedparams.scad>

$fa = 3;
$fs = 0.5;

clipBottomLengthClearance = 0.25;
clipBottomLength = slide2PosX - slide1PosX + slideWidth - (postWidth - fastenerSlotThroat) * 2 - clipBottomLengthClearance;
clipHeight = fastenerSlotThroat;
//clipDepth = fastenerPegDepth;
clipDepth = postDepth;
ballRadius = clipBallRadius;
//chamfer = clipDepth / 8;
chamfer = 1;

module clip() {
    difference() {
        // Body of clip
        linear_extrude(clipDepth)
            polygon([
                [0, 0],
                [clipBottomLength, 0],
                [clipBottomLength - clipHeight, clipHeight],
                [clipHeight, clipHeight]
            ]);
        // Chamfers
        for (chamferZ = [0, clipDepth]) {
            // bottom and top edge
            for (chamferY = [0, clipHeight])
                translate([clipBottomLength/2, chamferY, chamferZ])
                    rotate([45, 0, 0])
                        cube([clipBottomLength, chamfer, chamfer], center=true);
            // left edge
            translate([0, 0, chamferZ])
                rotate([45, 0, 45])
                    cube([clipBottomLength * 2, chamfer, chamfer], center=true);
            // right edge
            translate([clipBottomLength, 0, chamferZ])
                rotate([45, 0, -45])
                    cube([clipBottomLength * 2, chamfer, chamfer], center=true);
            // front and back edge
            for (chamferX = [0, clipBottomLength])
                translate([chamferX, 0, 0])
                        rotate([0, 0, 45])
                            cube([chamfer, chamfer, clipDepth * 2], center=true);
        }
    };
    // Half sphere in bottom
    for (x = [ clipBottomLength/2-clipBallSpacing, clipBottomLength/2, clipBottomLength/2+clipBallSpacing ])
        translate([x, 0, clipDepth / 2])
            sphere(r=ballRadius);
};

numClips = 3;

for (i = [1 : 3])
    translate([0, (i-1) * (clipHeight + ballRadius + 3)])
        clip();
