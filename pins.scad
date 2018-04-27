$fa = 3;
$fs = 0.5;

use <Write.scad>
include <sharedparams.scad>

topHeight = lidTopThick + 10;
bottomHeight = basePlateBaseTopOffset - lidTopThick;
slidePlateClearance = 1.5;
topRadius = pinTopRadius;
bottomRadius = pinBottomRadius;
notchWidth = pinNotchWidth;
//detentRadius = 1;


module pin (num, isFixedPosition) {
    numAngle = (num - 1) * (360 / 9);

    union() {
        difference() {
            union() {
                difference() {
                    // Top/knob portion cylinder.
                    cylinder(h=topHeight, r=topRadius);
                    // Notch in top.
                    translate([0, -0.5, topHeight - 1])
                        cube([topRadius, 1, 1]);
                };
                // Add bottom cylinder
                translate([0, 0, -bottomHeight])
                    cylinder(h=bottomHeight, r=bottomRadius);
            };
            // Large notch in side
            notchHeight = slidePlateThick + slidePlateClearance * 2;
            notchOffsetZ = -(slidePlateTopOffset - lidTopThick) - notchHeight + slidePlateClearance;
            rotate([0, 0, numAngle - 180])
                translate([bottomRadius - pinNotchDepth, -notchWidth / 2, notchOffsetZ])
                    cube([pinNotchDepth, notchWidth, notchHeight]);
            /*
            rotate([0, 0, numAngle])
                translate([-bottomRadius * 0.75, -notchWidth / 2, -(slidePlateThick + slidePlateClearance + topSlideDistance)])
                    cube([bottomRadius * 2, notchWidth, slidePlateThick + slidePlateClearance * 2]);
            */
            // Detents
            detentWidth = 1;
            detentDepth = 0.5;
            detentHeight = basePlateDetentProngOffsetZ + detentProngHeight / 2 + 1.5;
            for(ang = [0 : 360 / 9 : 359]) {
               rotate([0, 0, ang])
                translate([0, 0, -bottomHeight])
                    linear_extrude(detentHeight)
                        polygon([[bottomRadius, -(detentWidth/2)], [bottomRadius, detentWidth/2], [bottomRadius - detentDepth, 0]]);
            }
            /*for(ang = [0 : 360 / 9 : 359]) {
               rotate([0, 0, ang]) translate([bottomRadius, 0, -detentVerticalOffset]) sphere(detentRadius);
            }*/
            // Bottom cavity
            translate([0, 0, -bottomHeight]) cylinder(h=pinBottomCavityHeight, r=pinBottomCavityRadius);
            // Number label
            translate([0, 0, notchOffsetZ + notchHeight/2 + bottomHeight/2])
                writecylinder(str(num), [0, 0, -bottomHeight], bottomRadius - 0.5, bottomHeight, east=numAngle);
            // Number marks
            /*markRadius = (bottomRadius - cavityRadius) / 3;
            for (markNum = [0 : num - 1]) {
                rotate([0, 0, markNum * 360 / 9 / 2]) translate([(bottomRadius + cavityRadius) / 2, 0, -bottomHeight]) sphere(markRadius);
            }*/
        };
        // Key in bottom cavity, only for fixed position
        if (isFixedPosition) {
            /*rotate([0, 0, numAngle])
                translate([-fixedPosKeyWidth / 2, -fixedPosKeyWidth / 2, -bottomHeight])
                    cube([fixedPosKeyWidth, fixedPosKeyWidth, pinBottomCavityHeight]);*/
            rotate([0, 0, numAngle])
                translate([0, 0, -bottomHeight + pinBottomCavityHeight/2])
                    cube([pinBottomCavityRadius * 2, fixedPosKeyWidth, pinBottomCavityHeight], center=true);
        }
    };
}

// How many of each pin
duplicateCount = 1;
// How many numbers
maxNum = 1;

includeFixedPins = true;
includeMovingPins = true;
numPinTypes = (includeFixedPins ? 1 : 0) + (includeMovingPins ? 1 : 0);

gridWidth = ceil(sqrt(duplicateCount * numPinTypes * maxNum));
gridSpacing = bottomRadius * 2 + 0.25;

// Iterate through pin numbers, whether fixed or not, and 1-9 (need 9 of each type)
union() {
    for (setNum = [1 : 1 : duplicateCount]) {
        for(typeNum = [0 : 1 : numPinTypes - 1]) {
            for(pinNum = [1 : 1 : maxNum]) {
                gridNum = (setNum - 1) * 2 * maxNum + typeNum * maxNum + pinNum - 1;
                gridX = floor(gridNum / gridWidth);
                gridY = gridNum % gridWidth;
                isFixed = includeMovingPins ? typeNum : 1;
                translate([gridX * gridSpacing, gridY * gridSpacing, 0]) pin(pinNum, isFixed);
            }
        }
    }
};