$fa = 3;
$fs = 0.5;

use <Write.scad>
include <sharedparams.scad>

topHeight = lidTopThick + 10;
bottomHeight = basePlateBaseTopOffset - lidTopThick;
topPlateThick = 5;
slidePlateThick = 5;
slidePlateClearance = 1.5;
topSlideDistance = 2;
topRadius = pinTopRadius;
bottomRadius = pinBottomRadius;
notchWidth = pinNotchWidth;
detentVerticalOffset = topSlideDistance + slidePlateThick + 5;
detentRadius = 1;
bottomCavityDepth = 5;
cavityRadius = bottomRadius * 0.75;
fixedPosKeyWidth = cavityRadius * 0.75;

module pin (num, isFixedPosition) {
    numAngle = (num - 1) * (360 / 9);

    union() {
        difference() {
            union() {
                difference() {
                    // Top/knob portion cylinder.
                    cylinder(h=topHeight+topPlateThick, r=topRadius);
                    // Notch in top.
                    translate([0, -0.5, topHeight + topPlateThick - 1]) cube([topRadius, 1, 1]);
                };
                // Add bottom cylinder
                translate([0, 0, -bottomHeight]) cylinder(h=bottomHeight, r=bottomRadius);
            };
            // Large notch in side
            rotate([0, 0, numAngle])
            translate([bottomRadius - pinNotchDepth, -notchWidth / 2, -(slidePlateThick + slidePlateClearance + topSlideDistance)])
            cube([pinNotchDepth * 1.1, notchWidth, slidePlateThick + slidePlateClearance * 2]);
            /*
            rotate([0, 0, numAngle])
                translate([-bottomRadius * 0.75, -notchWidth / 2, -(slidePlateThick + slidePlateClearance + topSlideDistance)])
                    cube([bottomRadius * 2, notchWidth, slidePlateThick + slidePlateClearance * 2]);
            */
            // Detents
            for(ang = [0 : 360 / 9 : 359]) {
               rotate([0, 0, ang]) translate([bottomRadius, 0, -detentVerticalOffset]) sphere(detentRadius);
            }
            // Bottom cavity
            translate([0, 0, -bottomHeight]) cylinder(h=bottomCavityDepth, r=cavityRadius);
            // Number label
            writecylinder(str(num), [0, 0, -bottomHeight], bottomRadius - 0.5, bottomHeight, east=numAngle);
            // Number marks
            markRadius = (bottomRadius - cavityRadius) / 3;
            for (markNum = [0 : num - 1]) {
                rotate([0, 0, markNum * 360 / 9 / 2]) translate([(bottomRadius + cavityRadius) / 2, 0, -bottomHeight]) sphere(markRadius);
            }
        };
        // Square pin in bottom cavity, only for fixed position
        if (isFixedPosition) {
            rotate([0, 0, numAngle]) translate([-fixedPosKeyWidth / 2, -fixedPosKeyWidth / 2, -bottomHeight]) cube([fixedPosKeyWidth, fixedPosKeyWidth, bottomCavityDepth]);
        }
    };
}

// How many of each pin
duplicateCount = 1;
maxNum = 9;
gridWidth = ceil(sqrt(duplicateCount * 2 * maxNum));
gridSpacing = bottomRadius * 2 + 1;

// Iterate through pin numbers, whether fixed or not, and 1-9 (need 9 of each type)
union() {
    for (setNum = [1 : 1 : duplicateCount]) {
        for(isFixed = [0 : 1 : 1]) {
            for(pinNum = [1 : 1 : maxNum]) {
                gridNum = (setNum - 1) * 2 * maxNum + isFixed * maxNum + pinNum - 1;
                gridX = floor(gridNum / gridWidth);
                gridY = gridNum % gridWidth;
                translate([gridX * gridSpacing, gridY * gridSpacing, 0]) pin(pinNum, isFixed);
            }
        }
    }
};