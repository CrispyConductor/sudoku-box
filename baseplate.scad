include <sharedparams.scad>

$fa = 3;
$fs = 0.5;

basePlateWidth = slide2PosX - slide1PosX + slideWidth;
basePlateDepth = slideDepth;

basePlatePosX = slide1PosX;
basePlatePosY = slidePosY;

// Clearance on each side of the side cutouts
cutOutClearance = 0.25;

// Clearance on each side of the slide in the pin pivots
fixedPosKeyClearance = 0.2;

difference() {
    union() {
        // Main block, translated to XY reference frame of lid
        translate([basePlatePosX, basePlatePosY, 0])
            cube([basePlateWidth, basePlateDepth, basePlateThick]);
        // Pin bases
        for (holeX = [0 : holeGridSizeX - 1], holeY = [0 : holeGridSizeY - 1]) {
            translate([holeX * holeSpacing + holeGridPosX, holeY * holeSpacing + holeGridPosY, basePlateThick])
                pinBaseModule();
        }
        // Bottom slides
        bottomSlideHeight = slidePosZ - (sideSlidePosZ - postHeight) - slidePlateThick - slidePlateVerticalClearance;
        translate([slide1PosX + sideSlideWidth + cutOutClearance, slidePosY, basePlateThick])
            cube([slideWidth - sideSlideWidth - cutOutClearance, slideDepth, bottomSlideHeight]);
        translate([slide2PosX, slidePosY, basePlateThick])
            cube([slideWidth - sideSlideWidth - cutOutClearance, slideDepth, bottomSlideHeight]);
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

module pinBaseModule() {
    difference() {
        // Pivot peg
        cylinder(h=pinBottomCavityHeight, r=pinBottomCavityRadius - pinBottomCavityClearance);
        // Fixed position slot
        translate([0, 0, pinBottomCavityHeight/2])
            cube([fixedPosKeyWidth + 2 * fixedPosKeyClearance, pinBottomCavityRadius * 2, pinBottomCavityHeight], center=true);
    };
    // Detent prong post
    detentPostHeight = basePlateDetentProngOffsetZ + detentProngHeight / 2;
    translate([0, pinBottomRadius + detentProngLength, detentPostHeight / 2])
        cube([detentPostWidth, detentPostDepth, detentPostHeight], center = true);
    // Detent prong
    prongBottomOffset = 1; // distance from base plate to base of prong arm
    prongPointDepth = 0.4; // length of point of prong that protrudes into pin detent
    prongThick = 0.4; // thickness of prong
    translate([prongThick / 2, pinBottomRadius + detentProngLength, prongBottomOffset])
        rotate([90, 0, -90])
            linear_extrude(prongThick)
                polygon([
                    [0, 0],
                    [0, detentPostHeight - prongBottomOffset],
                    [detentProngLength + prongPointDepth, detentPostHeight - prongBottomOffset],
                    [detentProngLength + prongPointDepth, detentPostHeight - prongBottomOffset - detentProngHeight]
                ]);
};
