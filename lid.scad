include <sharedparams.scad>

$fa = 3;
$fs = 0.5;

use <Write.scad>

lidWidth = lidSize[0];
lidDepth = lidSize[1];
lidHeight = lidSize[2];

holeRadius = topHoleRadius;

buttonSlotWidth = boxKeywayWidth;
buttonSlotHeight = slidePlateThick + lidButtonSlotClearanceZ * 2;
buttonSlotTopOffset = buttonTopOffset - lidButtonSlotClearanceZ; // from top of lid to top of button slot
echo("buttonSlotTopOffset", buttonSlotTopOffset);

numberFontSize = 2.9;
numLabelHoleOffset = 0.5;
numLabelStart = 0;
numLabelEnd = numPositions - 1;

//slidePlateWidth = lidWidth - 2 * (innerLidPartsOffset + slideWidth / 2);
echo("slidePlateWidth", slidePlateWidth);

//slidePlateVerticalClearance = 1;

//basePlateTopOffset = slideHeight + slidePlateThick + slidePlateVerticalClearance + basePlateTotalThick; // distance from bottom of top of lid, to bottom of base plate
/*
clipThickness = 2;
clipDepth = slideDepth / 8;
clipOverhang = 4;
*/

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
                    union() {
                        // hole
                        cylinder(h=lidTopThick, r=holeRadius);
                        // cone indent
                        rotate_extrude()
                            polygon([[0, 0], [pinBottomConeRadius, 0], [0, pinBottomConeHeight]]);
                    };
            }
        };
        
        // Button slot
        translate([lidWidth / 2 - buttonSlotWidth / 2, 0, lidHeight - buttonSlotTopOffset - buttonSlotHeight])
            cube([buttonSlotWidth, lidSideThick, buttonSlotHeight]);
        
        // Number labels
        numberLabelTextOffsetZ = 0.75;
        for (holeX = [0 : holeGridSizeX - 1], holeY = [0 : holeGridSizeY - 1]) {
            center = [holeX * holeSpacing + holeGridPosX, holeY * holeSpacing + holeGridPosY, lidHeight + 0.5 - numberLabelTextOffsetZ];
            for (num = [numLabelStart : numLabelEnd]) {
                numAng = (360 / (numLabelEnd - numLabelStart + 1)) * (num - numLabelStart);
                numStr = positionNames[num];
                // uncomment to enable number labels
                translate(center) writecircle(numStr, [0, 0, 0], holeRadius + numberFontSize / 2 + numLabelHoleOffset, h=numberFontSize, rotate=numAng);
            }
        }
    };
    // Slides
    translate([slide1PosX, slidePosY, slidePosZ])
        cube([slideWidth, slideDepth, slideHeight]);
    translate([slide2PosX, slidePosY, slidePosZ])
        cube([slideWidth, slideDepth, slideHeight]);
    // Side slides
    translate([slide1PosX, slidePosY, sideSlidePosZ])
        cube([sideSlideWidth, slideDepth, sideSlideHeight]);
    translate([slide2PosX + slideWidth - sideSlideWidth, slidePosY, sideSlidePosZ])
        cube([sideSlideWidth, slideDepth, sideSlideHeight]);
    // Posts
    translate([slide1PosX, slidePosY + postDepth, sideSlidePosZ])
        rotate([180, 0, 0])
            basePlatePost([postWidth, postDepth, postHeight], fastenerPegDepth, basePlateThick, fastenerSlotThroat);
    translate([slide1PosX, slidePosY + postDepth / 2 + slideDepth / 2, sideSlidePosZ])
        rotate([180, 0, 0])
            basePlatePost([postWidth, postDepth, postHeight], fastenerPegDepth, basePlateThick, fastenerSlotThroat);
    translate([slide1PosX, slidePosY + slideDepth, sideSlidePosZ])
        rotate([180, 0, 0])
            basePlatePost([postWidth, postDepth, postHeight], fastenerPegDepth, basePlateThick, fastenerSlotThroat);
    translate([slide2PosX + slideWidth - sideSlideWidth + postWidth, slidePosY, sideSlidePosZ])
        rotate([180, 0, 180])
            basePlatePost([postWidth, postDepth, postHeight], fastenerPegDepth, basePlateThick, fastenerSlotThroat);
    translate([slide2PosX + slideWidth - sideSlideWidth + postWidth, slidePosY + slideDepth / 2 - postDepth / 2, sideSlidePosZ])
        rotate([180, 0, 180])
            basePlatePost([postWidth, postDepth, postHeight], fastenerPegDepth, basePlateThick, fastenerSlotThroat);
    translate([slide2PosX + slideWidth - sideSlideWidth + postWidth, slidePosY + slideDepth - postDepth, sideSlidePosZ])
        rotate([180, 0, 180])
            basePlatePost([postWidth, postDepth, postHeight], fastenerPegDepth, basePlateThick, fastenerSlotThroat);
    // Clips
/*
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
*/
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

// postSize is the size of the post the plate sits on, not including the bit on top that extends through the plate
// cutOutPegDepth is the depth of the cutouts in the base plate.
// plateThick is the thickness of the base plate
// fastenerSlotThroat is the amount the fastener will protrude into the post, must be less than postSize[0]
module basePlatePost(postSize, cutOutPegDepth, plateThick, fastenerSlotThroat) {
    // Post
    cube(postSize);
    // Locating peg
    locatingPegOffsetY = (postSize[1] - cutOutPegDepth) / 2;
    translate([0, locatingPegOffsetY, postSize[2]])
        cube([postSize[0], cutOutPegDepth, plateThick]);
    // Fastener clip
    //reinforcementHeight = fastenerSlotThroat / 3;
    reinforcementHeight = 0.4;
    translate([0, locatingPegOffsetY, postSize[2] + plateThick])
        difference() {
            cube([postSize[0], cutOutPegDepth, fastenerSlotThroat + reinforcementHeight]);
            translate([postSize[0] - fastenerSlotThroat, postSize[1], 0])
                rotate([90, 0, 0])
                    linear_extrude(postSize[1])
                        polygon([[0, 0], [fastenerSlotThroat * 2, 0], [fastenerSlotThroat * 2, fastenerSlotThroat * 2]]);
        };
};

//!basePlatePost([10, 20, 40], 8, 3, 7);

