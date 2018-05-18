$fa = 3;
$fs = 0.5;

use <Write.scad>
include <sharedparams.scad>

topHeight = pinTopHeight;
slidePlateClearance = 1.5; // Vertical clearance in notch for slide plate prong
topRadius = pinTopRadius;
bottomRadius = pinBottomRadius;
notchWidth = pinNotchWidth;
//detentRadius = 1;
// distance fin extends from pins
fixedPinFinExtension = 1.8;
pinTopConeHeight = topRadius / 2;


detentExtraClearanceZ = 1;
detentHeight = detentProngHeight + 2 * detentExtraClearanceZ;
bottomHeight = basePlateBaseTopOffset - lidTopThick;

notchHeight = slidePlateThick + slidePlateClearance * 2 + slidePlateVerticalClearance;
notchOffsetZ = -(slidePlateTopOffset - lidTopThick) - notchHeight + slidePlateClearance;

module pin (num, isFixedPosition, includeSupport=false) {
    bottomHeightClearanceFixed = 0.1;
    bottomHeightClearanceMoving = 0.4;
    bottomHeightClearance = isFixedPosition ? bottomHeightClearanceFixed : bottomHeightClearanceMoving;
    realBottomHeight = bottomHeight - bottomHeightClearance;
    
    
    numAngle = num * (360 / numPositions);

    translate([0, 0, -bottomHeightClearance])
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
                    topLabelNotchWidth = 0.5;
                    translate([0, -topLabelNotchWidth/2, topHeight - 1])
                        cube([topRadius, topLabelNotchWidth, 10]);
                    // Notch in side
                    sideLabelNotchWidth = 0.5;
                    translate([topRadius - 1, -sideLabelNotchWidth/2, lidTopThick])
                        cube([1, sideLabelNotchWidth, topHeight - lidTopThick]);
                    // Cap off top cone halfway so it's not pointy
                    translate([0, 0, topHeight + pinTopConeHeight/2])
                        cylinder(h=pinTopConeHeight, r=topRadius);
                    // Key for knob
                    knobKeyExtraZOffset = 0;
                    translate([0, -(topRadius/2 + (topRadius - pinKnobKeySize)), topHeight/2 + lidTopThick + knobKeyExtraZOffset])
                        cube([topRadius*2, topRadius, topHeight], center=true);
                    translate([0, (topRadius/2 + (topRadius - pinKnobKeySize)), topHeight/2 + lidTopThick + knobKeyExtraZOffset])
                        cube([topRadius*2, topRadius, topHeight], center=true);
                };
                // Add bottom cylinder
                translate([0, 0, -realBottomHeight])
                    cylinder(h=realBottomHeight, r=bottomRadius);
                // Add bottom cone
                intersection() {
                    rotate_extrude()
                        polygon([[0, 0], [pinBottomConeRadius, 0], [0, pinBottomConeHeight]]);
                    cylinder(h=pinBottomConeHeight, r=bottomRadius);
                };
            };
            // Large notch in side
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
                cylinder(h=pinBottomCavityHeight+bottomHeightClearance, r=pinBottomCavityRadius);
            // Number label
            translate([0, 0, notchOffsetZ + notchHeight/2 + bottomHeight/2])
                writecylinder(positionNames[num], [0, 0, -bottomHeight], bottomRadius - 0.5, bottomHeight, east=numAngle);
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
                        translate([-fixedPinFinWidth/2, -bottomRadius - fixedPinFinExtension, -realBottomHeight])
                            cube([fixedPinFinWidth, bottomRadius * 2 + fixedPinFinExtension * 2, fixedPinFinHeight - (bottomHeight - realBottomHeight)]);
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
        
        if (includeSupport  && !isFixedPosition) {
            // Support is a wider cylinder around part of the bottom, linked loosely to the pin
            supportCylinderDistanceToPin = 1.0;
            supportCylinderThick = 1;
            supportHeight = basePlateDetentProngOffsetZ - detentHeight / 2 - 1;
            supportCylinderInnerRadius = bottomRadius + supportCylinderDistanceToPin;
            supportCylinderOuterRadius = supportCylinderInnerRadius + supportCylinderThick;
            supportAttachHeight = 0.15;
            supportAttachDistance = 0;
            attachmentGapWidth = supportCylinderInnerRadius * 0.7;
            supportBaseSize = supportCylinderOuterRadius * 2 + 2;
            supportBaseThick = 0.75;
            supportPointDistance = 0.25;
            supportPointHeight = 0.3;
            numSupportPoints = 8;
            translate([0, 0, -realBottomHeight])
                union() {
                    difference() {
                        // Support cylinder
                        cylinder(h=supportHeight, r=supportCylinderOuterRadius);
                        // Inner cavity
                        cylinder(h=supportHeight, r=supportCylinderInnerRadius);
                    };
                    // Attachments
                    for (z = [supportHeight - supportAttachHeight - 1/*, supportHeight / 2*/])
                        translate([0, 0, z])
                            difference() {
                                cylinder(h=supportAttachHeight, r=supportCylinderOuterRadius);
                                cylinder(h=supportAttachHeight, r=bottomRadius + supportAttachDistance);
                                for(ang = [numAngle, numAngle-90])
                                    rotate([0, 0, ang])
                                        translate([0, 0, supportAttachHeight/2])
                                            cube([attachmentGapWidth, supportCylinderOuterRadius*2, supportAttachHeight], center=true);
                            };
                    // Support points
                    pointSize = supportCylinderInnerRadius - bottomRadius - supportPointDistance;
                    for(ang = [0 : 360/numSupportPoints : 359])
                        rotate([0, 0, ang])
                            translate([supportCylinderInnerRadius, 0, supportHeight - supportPointHeight])
                                linear_extrude(supportPointHeight)
                                    polygon([
                                        [0, pointSize/2],
                                        [0, -pointSize/2],
                                        [-pointSize, 0]
                                    ]);
                    // Base
                    difference() {
                        translate([0, 0, supportBaseThick/2])
                            cube([supportBaseSize, supportBaseSize, supportBaseThick], center=true);
                        cylinder(h=supportBaseThick, r=supportCylinderInnerRadius);
                    };
                };
        }
    };
}

// How many of each pin
duplicateCount = 3;
// How many numbers
startNum = 1;
endNum = 9;
numNums = endNum - startNum + 1;

includeFixedPins = false;
includeMovingPins = !includeFixedPins;
numPinTypes = (includeFixedPins ? 1 : 0) + (includeMovingPins ? 1 : 0);

includeSupport = true;

gridWidth = ceil(sqrt(duplicateCount * numPinTypes * numNums));
movingPinSpacing = bottomRadius * 2 + 5;
fixedPinSpacing = bottomRadius * 2 + fixedPinFinExtension * 2 + fixedPinFinWidth;
gridSpacing = includeFixedPins ? fixedPinSpacing : movingPinSpacing;

useUpperStabilizingPlate = false;
upperStabilizingPlateThick = 0.15;

// Iterate through pin numbers, whether fixed or not, and 1-9 (need 9 of each type)
union() {
    for (setNum = [1 : 1 : duplicateCount]) {
        for(typeNum = [0 : 1 : numPinTypes - 1]) {
            for(pinNum = [startNum : 1 : endNum]) {
                gridNum = (setNum - 1) * numPinTypes * numNums + typeNum * numPinTypes + pinNum - startNum;
                gridX = floor(gridNum / gridWidth);
                gridY = gridNum % gridWidth;
                isFixed = includeMovingPins ? typeNum : 1;
                translate([gridX * gridSpacing, gridY * gridSpacing, 0]) pin(pinNum, isFixed, includeSupport);
            }
        }
    }
    if (useUpperStabilizingPlate) {
        stabilizingPlateZ = notchOffsetZ - upperStabilizingPlateThick - 0.75;
        translate([0, 0, stabilizingPlateZ])
            cube([(gridWidth - 1) * gridSpacing, (gridWidth - 1) * gridSpacing, upperStabilizingPlateThick]);
    }
};