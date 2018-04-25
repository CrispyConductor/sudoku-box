include <sharedparams.scad>

$fa = 3;
$fs = 0.5;

basePlateWidth = slide2PosX - slide1PosX + slideWidth;
basePlateDepth = slideDepth;

basePlatePosX = slide1PosX;
basePlatePosY = slidePosY;

cutOutClearance = 0.25;

difference() {
    union() {
        // Main block, translated to XY reference frame of lid
        translate([basePlatePosX, basePlatePosY, 0])
            cube([basePlateWidth, basePlateDepth, basePlateThick]);
        // Pin bottom supports
        for (holeX = [0 : holeGridSizeX - 1], holeY = [0 : holeGridSizeY - 1]) {
            translate([holeX * holeSpacing + holeGridPosX, holeY * holeSpacing + holeGridPosY, basePlateThick])
                cylinder(h=pinBottomCavityHeight, r=pinBottomCavityRadius - pinBottomCavityClearance);
        }
    };
    // Cut-outs
    cutOutWidth = postWidth + cutOutClearance;
    cutOutDepth = fastenerPegDepth + 2 * cutOutClearance;
    translate([basePlatePosX, slidePosY + (postDepth - fastenerPegDepth) / 2 - cutOutClearance, 0])
        cube([cutOutWidth, cutOutDepth, basePlateThick]);
    translate([basePlatePosX, slidePosY + (postDepth - fastenerPegDepth) / 2 - cutOutClearance + slideDepth / 2 - postDepth / 2, 0])
        cube([cutOutWidth, cutOutDepth, basePlateThick]);
    translate([basePlatePosX, slidePosY + (postDepth - fastenerPegDepth) / 2 - cutOutClearance + slideDepth - postDepth, 0])
        cube([cutOutWidth, cutOutDepth, basePlateThick]);
    translate([basePlatePosX + basePlateWidth - cutOutWidth, slidePosY + (postDepth - fastenerPegDepth) / 2 - cutOutClearance, 0])
        cube([cutOutWidth, cutOutDepth, basePlateThick]);
    translate([basePlatePosX + basePlateWidth - cutOutWidth, slidePosY + (postDepth - fastenerPegDepth) / 2 - cutOutClearance + slideDepth / 2 - postDepth / 2, 0])
        cube([cutOutWidth, cutOutDepth, basePlateThick]);
    translate([basePlatePosX + basePlateWidth - cutOutWidth, slidePosY + (postDepth - fastenerPegDepth) / 2 - cutOutClearance + slideDepth - postDepth, 0])
        cube([cutOutWidth, cutOutDepth, basePlateThick]);
}

// Bottom slides
bottomSlideHeight = slidePosZ - (sideSlidePosZ - postHeight) - slidePlateThick - slidePlateVerticalClearance;
translate([slide1PosX + sideSlideWidth, slidePosY, basePlateThick])
    cube([slideWidth - sideSlideWidth, slideDepth, bottomSlideHeight]);
translate([slide2PosX, slidePosY, basePlateThick])
    cube([slideWidth - sideSlideWidth, slideDepth, bottomSlideHeight]);

// Detent mechanisms
