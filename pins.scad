$fa = 3;
$fs = 0.5;

use <Write.scad>
include <sharedparams.scad>

topHeight = pinTopHeight;
bottomHeightClearance = 0.15;
bottomHeight = basePlateBaseTopOffset - lidTopThick - bottomHeightClearance;
slidePlateClearance = 1.5; // Vertical clearance in notch for slide plate prong
topRadius = pinTopRadius;
bottomRadius = pinBottomRadius;
notchWidth = pinNotchWidth;
//detentRadius = 1;
// distance fin extends from pins
fixedPinFinExtension = 1.8;
pinTopConeHeight = topRadius / 2;


module pin (num, isFixedPosition) {
    numAngle = (num - 1) * (360 / numPositions);

    union() {
        difference() {
            union() {
                difference() {
                    union() {
                        // Top/knob portion cylinder.
                        cylinder(h=topHeight, r=topRadius);
                        // Top cone
                        translate([0, 0, topHeight])
                            rotate_extrude()
                                polygon([[0, 0], [topRadius, 0], [0, pinTopConeHeight]]);
                    };
                    // Notch in top.
                    translate([0, -0.5, topHeight - 1])
                        cube([topRadius, 1, 10]);
                    // Notch in side
                    translate([topRadius - 1, -0.5, lidTopThick])
                        cube([1, 1, topHeight - lidTopThick]);
                    // Cap off top cone halfway so it's not pointy
                    translate([0, 0, topHeight + pinTopConeHeight/2])
                        cylinder(h=pinTopConeHeight, r=topRadius);
                    // Key for knob
                    knobKeyExtraZOffset = 1;
                    translate([0, -(topRadius/2 + (topRadius - pinKnobKeySize)), topHeight/2 + lidTopThick + knobKeyExtraZOffset])
                        cube([topRadius*2, topRadius, topHeight], center=true);
                    translate([0, (topRadius/2 + (topRadius - pinKnobKeySize)), topHeight/2 + lidTopThick + knobKeyExtraZOffset])
                        cube([topRadius*2, topRadius, topHeight], center=true);
                };
                // Add bottom cylinder
                translate([0, 0, -bottomHeight])
                    cylinder(h=bottomHeight, r=bottomRadius);
                // Add bottom cone
                intersection() {
                    rotate_extrude()
                        polygon([[0, 0], [pinBottomConeRadius, 0], [0, pinBottomConeHeight]]);
                    cylinder(h=pinBottomConeHeight, r=bottomRadius);
                };
            };
            // Large notch in side
            notchHeight = slidePlateThick + slidePlateClearance * 2 + slidePlateVerticalClearance;
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
            //detentHeight = basePlateDetentProngOffsetZ + detentProngHeight / 2 + 1.5;
            detentExtraClearanceZ = 1;
            detentHeight = detentProngHeight + 2 * detentExtraClearanceZ;
            for(ang = [0 : 360 / numPositions : 359]) {
                rotate([0, 0, ang])
                    translate([0, 0, -bottomHeight + basePlateDetentProngOffsetZ - detentHeight / 2])
                        linear_extrude(detentHeight)
                            polygon([[bottomRadius, -(detentWidth/2)], [bottomRadius, detentWidth/2], [bottomRadius - detentDepth, 0]]);
            }
            // Long detent (for easier pin insertion)
            rotate([0, 0, numAngle])
                translate([0, 0, -bottomHeight])
                    linear_extrude(basePlateDetentProngOffsetZ)
                        polygon([[bottomRadius, -(detentWidth/2)], [bottomRadius, detentWidth/2], [bottomRadius - detentDepth, 0]]);
            /*for(ang = [0 : 360 / 9 : 359]) {
               rotate([0, 0, ang]) translate([bottomRadius, 0, -detentVerticalOffset]) sphere(detentRadius);
            }*/
            // Bottom cavity
            translate([0, 0, -bottomHeight])
                cylinder(h=pinBottomCavityHeight, r=pinBottomCavityRadius);
            // Number label
            translate([0, 0, notchOffsetZ + notchHeight/2 + bottomHeight/2])
                writecylinder(str(num), [0, 0, -bottomHeight], bottomRadius - 0.5, bottomHeight, east=numAngle);
            // Number marks
            /*markRadius = (bottomRadius - cavityRadius) / 3;
            for (markNum = [0 : num - 1]) {
                rotate([0, 0, markNum * 360 / 9 / 2]) translate([(bottomRadius + cavityRadius) / 2, 0, -bottomHeight]) sphere(markRadius);
            }*/
        };
        
        if (isFixedPosition) {
            // Side fins
            difference() {
                for (i = [-45:90:45])
                    rotate([0, 0, numAngle + i])
                        translate([-fixedPinFinWidth/2, -bottomRadius - fixedPinFinExtension, -bottomHeight])
                            cube([fixedPinFinWidth, bottomRadius * 2 + fixedPinFinExtension * 2, fixedPinFinHeight]);
                translate([0, 0, -bottomHeight])
                    cylinder(h=pinBottomCavityHeight, r=pinBottomCavityRadius);
            };
            
            /*rotate([0, 0, numAngle])
                translate([-fixedPosKeyWidth / 2, -fixedPosKeyWidth / 2, -bottomHeight])
                    cube([fixedPosKeyWidth, fixedPosKeyWidth, pinBottomCavityHeight]);*/
            /*rotate([0, 0, numAngle])
                translate([0, 0, -bottomHeight + pinBottomCavityHeight/2])
                    cube([pinBottomCavityRadius * 2, fixedPosKeyWidth, pinBottomCavityHeight], center=true);*/
        }
    };
}

// How many of each pin
duplicateCount = 1;
// How many numbers
maxNum = 2;

includeFixedPins = true;
includeMovingPins = false;
numPinTypes = (includeFixedPins ? 1 : 0) + (includeMovingPins ? 1 : 0);

gridWidth = ceil(sqrt(duplicateCount * numPinTypes * maxNum));
movingPinSpacing = bottomRadius * 2 + 0.5;
fixedPinSpacing = bottomRadius * 2 + fixedPinFinExtension * 2 + fixedPinFinWidth;
gridSpacing = includeFixedPins ? fixedPinSpacing : movingPinSpacing;

// Iterate through pin numbers, whether fixed or not, and 1-9 (need 9 of each type)
union() {
    for (setNum = [1 : 1 : duplicateCount]) {
        for(typeNum = [0 : 1 : numPinTypes - 1]) {
            for(pinNum = [1 : 1 : maxNum]) {
                gridNum = (setNum - 1) * numPinTypes * maxNum + typeNum * numPinTypes + pinNum - 1;
                gridX = floor(gridNum / gridWidth);
                gridY = gridNum % gridWidth;
                isFixed = includeMovingPins ? typeNum : 1;
                translate([gridX * gridSpacing, gridY * gridSpacing, 0]) pin(pinNum, isFixed);
            }
        }
    }
};