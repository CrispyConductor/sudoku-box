include <sharedparams.scad>

$fa = 3;
$fs = 0.5;

use <Write.scad>

lidWidth = lidSize[0];
lidDepth = lidSize[1];
lidHeight = lidSize[2];

holeRadius = topHoleRadius;

buttonSlotWidth = 5;
buttonSlotHeight = slidePlateThick + 1;
keywayOffsetZ = boxKeywayOffsetZ; // from bottom of lid to bottom of button slot
buttonSlotTopOffset = lidHeight - keywayOffsetZ - buttonSlotHeight + 0.5;

slideWidth = holeGridPosX - pinBottomRadius - pinRotateClearance - innerLidPartsOffset;
slideHeight = buttonSlotTopOffset - lidTopThick;
slideDepth = lidDepth - 2 * innerLidPartsOffset;

numberFontSize = 2.5;
numLabelStart = 1;
numLabelEnd = 9;

//slidePlateWidth = lidWidth - 2 * (innerLidPartsOffset + slideWidth / 2);
echo("slidePlateWidth", slidePlateWidth);
sideSlideClearance = 1;

slidePlateVerticalClearance = 1;
basePlateThick = 3; // Thickness of just base plate base sheet
basePlateTotalThick = 10; // thickness of base plate including needed mechanisms; determines clearance to sliding plate
basePlateTopOffset = slideHeight + slidePlateThick + slidePlateVerticalClearance + basePlateTotalThick; // distance from bottom of top of lid, to bottom of base plate

clipThickness = 2;
clipDepth = slideDepth / 8;
clipOverhang = 4;

rotate([0, 180, 0]) // rotate to 3d printable orientation
union() {
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
        
        // Button slot
        translate([lidWidth / 2 - buttonSlotWidth / 2, 0, lidHeight - buttonSlotTopOffset - buttonSlotHeight])
            cube([buttonSlotWidth, lidSideThick, buttonSlotHeight]);
        
        // Number labels
        for (holeX = [0 : holeGridSizeX - 1], holeY = [0 : holeGridSizeY - 1]) {
            center = [holeX * holeSpacing + holeGridPosX, holeY * holeSpacing + holeGridPosY, lidHeight - 0.5];
            for (num = [numLabelStart : numLabelEnd]) {
                numAng = (360 / (numLabelEnd - numLabelStart + 1)) * (num - numLabelStart);
                // uncomment to enable number labels
                //translate(center) writecircle(str(num), [0, 0, 0], holeRadius + numberFontSize / 2 + holeRadius * 0.1, h=numberFontSize, rotate=numAng);
            }
        }
    };
    // Slides
    slidePosY = innerLidPartsOffset;
    slidePosZ = lidHeight - slideHeight - lidTopThick;
    slide1PosX = innerLidPartsOffset;
    slide2PosX = lidWidth - innerLidPartsOffset - slideWidth;
    translate([slide1PosX, slidePosY, slidePosZ])
        cube([slideWidth, slideDepth, slideHeight]);
    translate([slide2PosX, slidePosY, slidePosZ])
        cube([slideWidth, slideDepth, slideHeight]);
    // Side slides
    sideSlideWidth = (lidWidth - slidePlateWidth) / 2 - slide1PosX - sideSlideClearance;
    sideSlideHeight = slidePlateThick;
    translate([slide1PosX, slidePosY, slidePosZ - sideSlideHeight])
        cube([sideSlideWidth, slideDepth, sideSlideHeight]);
    translate([slide2PosX + slideWidth - sideSlideWidth, slidePosY, slidePosZ - sideSlideHeight])
        cube([sideSlideWidth, slideDepth, sideSlideHeight]);
    // Clips
    clipHeight = basePlateTopOffset - slideHeight - sideSlideHeight;
    filletSize = min(clipHeight / 4, sideSlideWidth - clipThickness);
    translate([slide1PosX, clipDepth + slidePosY + clipEdgeOffset, slidePosZ - sideSlideHeight])
        rotate([180, 0, 0])
            clipMale([clipThickness, clipDepth, clipHeight], clipOverhang, filletSize);
    translate([slide1PosX, slidePosY + slideDepth - clipEdgeOffset, slidePosZ - sideSlideHeight])
        rotate([180, 0, 0])
            clipMale([clipThickness, clipDepth, clipHeight], clipOverhang, filletSize);
    translate([slide2PosX + slideWidth, slidePosY + clipEdgeOffset, slidePosZ - sideSlideHeight])
        rotate([180, 0, 180])
            clipMale([clipThickness, clipDepth, clipHeight], clipOverhang, filletSize);
    translate([slide2PosX + slideWidth, slidePosY + slideDepth - clipDepth - clipEdgeOffset, slidePosZ - sideSlideHeight])
        rotate([180, 0, 180])
            clipMale([clipThickness, clipDepth, clipHeight], clipOverhang, filletSize);
    // Central clips.  These aren't actually used as clips.  They extend lower than the others and are
    // intended to fit into recesses in the base plate to prevent front-to-back movement.
    centralClipPosY = slideDepth / 2 + slidePosY - clipDepth / 2;
    translate([slide1PosX, clipDepth + centralClipPosY, slidePosZ - sideSlideHeight])
        rotate([180, 0, 0])
            clipMale([clipThickness, clipDepth, clipHeight], clipOverhang, filletSize, squareVerticalExtension = basePlateThick);
    translate([slide2PosX + slideWidth, centralClipPosY, slidePosZ - sideSlideHeight])
        rotate([180, 0, 180])
            clipMale([clipThickness, clipDepth, clipHeight], clipOverhang, filletSize, squareVerticalExtension = basePlateThick);
};

// clipArmSize is a vector [ thickness, depth, height ]; height is to bottom of clip wedge, does not include wedge height
// wedgeOverhang is the amount that the wedge overhangs the thing it's clipping
// filletSize is the amount the fillet extends from the base
module clipMale(clipArmSize, wedgeOverhang, filletSize = 0, squareVerticalExtension = 0, taper = true) {
    wedgeHeight = wedgeOverhang + clipArmSize[0];
    taperTop = clipArmSize[0] / 2; // Thickness at top of the taper
    // Stalk
    if (taper)
        translate([0, clipArmSize[1], 0])
            rotate([90, 0, 0])
                linear_extrude(clipArmSize[1])
                    polygon([[0, 0], [clipArmSize[0], 0], [taperTop, clipArmSize[2]], [0, clipArmSize[2]]]);
    else
        cube([clipArmSize[0], clipArmSize[1], clipArmSize[2]]);
    // Overhang
    translate([0, clipArmSize[1], clipArmSize[2]])
        rotate([90, 0, 0])
            linear_extrude(clipArmSize[1])
                polygon([[0, 0], [0, wedgeHeight], [wedgeOverhang + clipArmSize[0], 0]]);
    // Fillet
    translate([0, clipArmSize[1], 0])
        rotate([90, 0, 0])
            linear_extrude(clipArmSize[1])
                polygon([[0, 0], [0, filletSize + clipArmSize[0]], [filletSize + clipArmSize[0], 0]]);
    // Square vertical extension
    if(squareVerticalExtension > 0)
        translate([0, 0, clipArmSize[2] - squareVerticalExtension])
            cube([wedgeOverhang + clipArmSize[0], clipArmSize[1], squareVerticalExtension]);
};

//!clipMale([2, 10, 20], 2, 2, 3);

