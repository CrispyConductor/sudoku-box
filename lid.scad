$fa = 3;
$fs = 0.5;

use <Write.scad>

lidTopThick = 3;
lidSideThick = 2;

lidWidth = 150; // corresponds to bottomWidth on box
lidDepth = 150; // corresponds to bottomDepth on box
lidHeight = 30 + lidTopThick; // corresponds to topHeight on box, plus lidTopThick

holeGridSizeX = 9;
holeGridSizeY = 9;
holeRadius = 3;
holeSpacing = 12;

slidePlateThick = 3;

buttonSlotWidth = 5;
buttonSlotHeight = slidePlateThick + 1;
keywayOffsetZ = 18; // from bottom of lid to bottom of button slot, from box
buttonSlotTopOffset = lidHeight - keywayOffsetZ - buttonSlotHeight + 0.5;

boxTopThick = 3; // corresponds to topThick on box
// amount of clearance to leave between inside workings and box
// clearance to sides in built into lidSideThick
boxInsideClearance = 1;

lidSideBoxClearance = 1; // From box

// This is the offset from the origin (either X or Y) to where the inner workings of
// the lid can start.  It includes necessary clearances to fit the lid on the box.
innerLidPartsOffset = lidSideThick + lidSideBoxClearance + boxTopThick + boxInsideClearance;

holeGridPosX = (lidWidth - (holeGridSizeX - 1) * holeSpacing) / 2;
holeGridPosY = (lidDepth - (holeGridSizeY - 1) * holeSpacing) / 2;

slideWidth = (holeGridPosX - holeRadius - innerLidPartsOffset) / 2;
slideHeight = buttonSlotTopOffset - lidTopThick;
slideDepth = lidDepth - 2 * innerLidPartsOffset;
slideDepth = lidDepth - 2 * (lidSideThick + boxTopThick + boxInsideClearance);

numberFontSize = 2.5;
numLabelStart = 1;
numLabelEnd = 9;

slidePlateWidth = lidWidth - 2 * (innerLidPartsOffset + slideWidth / 2);
sideSlideClearance = 1;

slidePlateVerticalClearance = 1;
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
    translate([slide1PosX, clipDepth + slidePosY, slidePosZ - sideSlideHeight])
        rotate([180, 0, 0])
            clipMale([clipThickness, clipDepth, basePlateTopOffset - slideHeight - sideSlideHeight], clipOverhang);
    translate([slide1PosX, slidePosY + slideDepth, slidePosZ - sideSlideHeight])
        rotate([180, 0, 0])
            clipMale([clipThickness, clipDepth, basePlateTopOffset - slideHeight - sideSlideHeight], clipOverhang);
    translate([slide2PosX + slideWidth, slidePosY, slidePosZ - sideSlideHeight])
        rotate([180, 0, 180])
            clipMale([clipThickness, clipDepth, basePlateTopOffset - slideHeight - sideSlideHeight], clipOverhang);
    translate([slide2PosX + slideWidth, slidePosY + slideDepth - clipDepth, slidePosZ - sideSlideHeight])
        rotate([180, 0, 180])
            clipMale([clipThickness, clipDepth, basePlateTopOffset - slideHeight - sideSlideHeight], clipOverhang);
};

// clipArmSize is a vector [ thickness, depth, height ]; height is to bottom of clip wedge, does not include wedge height
// wedgeOverhang is the amount that the wedge overhangs the thing it's clipping
module clipMale(clipArmSize, wedgeOverhang) {
    wedgeHeight = wedgeOverhang + clipArmSize[0];
    cube([clipArmSize[0], clipArmSize[1], clipArmSize[2]]);
    translate([0, clipArmSize[1], clipArmSize[2]])
        rotate([90, 0, 0])
            linear_extrude(clipArmSize[1])
                polygon([[0, 0], [0, wedgeHeight], [wedgeOverhang + clipArmSize[0], 0]]);
};

//clipMale([2, 10, 20], 2);

