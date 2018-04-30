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
chamfer = 0;

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
        // Chamfer on one side
        translate([clipBottomLength/2, 0, clipDepth])
            rotate([45, 0, 0])
                cube([clipBottomLength, chamfer, chamfer], center=true);
    };
    // Half sphere in bottom
    translate([clipBottomLength / 2, 0, clipDepth / 2])
        sphere(r=ballRadius);
};

numClips = 3;

for (i = [1 : 3])
    translate([0, (i-1) * (clipHeight + ballRadius + 3)])
        clip();
