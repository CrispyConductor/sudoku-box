include <sharedparams.scad>

$fa = 3;
$fs = 0.5;

notchAngle = 360 / numPositions;

knobOuterRadius = pinTopRadius + 1;
knobInnerRadius = pinTopRadius - 0.1;
knobSkirtRadius = holeSpacing/2 - 1;
knobSkirtHeight = 1;
knobHeight = pinTopHeight - lidTopThick;

knurlStartZ = knobHeight / 2;

module knob(isFixed=false) {
    difference() {
        union() {
            difference() {
                union() {
                    // Core cylinder
                    cylinder(h=knobHeight, r=knobOuterRadius);
                    // Skirt
                    cylinder(h=knobSkirtHeight, r=knobSkirtRadius);
                };
                // Inner cutout
                cylinder(h=knobHeight, r=knobInnerRadius);
                // Side notch
                rotate([0, 0, -notchAngle/2])
                rotate_extrude(angle=notchAngle)
                    square([knobSkirtRadius + 1, knobHeight + 1]);
                // "knurling"
                if (!isFixed) {
                    knurlDepth = 0.5;
                    knurlWidth = 0.8;
                    numKnurls = 20;
                    for(ang = [0 : 360 / 30 : 359]) {
                        rotate([0, 0, ang])
                            translate([0, 0, knurlStartZ])
                                linear_extrude(knobHeight - knurlStartZ)
                                    polygon([
                                        [knobOuterRadius, -(knurlWidth/2)],
                                        [knobOuterRadius, knurlWidth/2],
                                        [knobOuterRadius - knurlDepth, 0]]
                                    );
                    }
                }
            };
            // Inner keys
            intersection() {
                translate([0, -(pinTopRadius/2 + (pinTopRadius - pinKnobKeySize)), pinTopHeight/2])
                    cube([pinTopRadius*2, pinTopRadius, pinTopHeight], center=true);
                cylinder(h=knobHeight, r=knobInnerRadius);
            };
            intersection() {
                translate([0, (pinTopRadius/2 + (pinTopRadius - pinKnobKeySize)), pinTopHeight/2])
                    cube([pinTopRadius*2, pinTopRadius, pinTopHeight], center=true);
                cylinder(h=knobHeight, r=knobInnerRadius);
            };
        };
        // Chamfer on bottom
        chamferSize = 0.65;
        rotate_extrude()
            polygon([
                [0, 0],
                [knobInnerRadius + chamferSize, 0],
                [0, knobInnerRadius + chamferSize]
            ]);
    };
};

howManyKnobs = 9;

gridWidth = ceil(sqrt(howManyKnobs));
gridSpacing = knobSkirtRadius * 2 + 2;
isFixed = false;

for(num = [0 : 1 : howManyKnobs-1]) {
    gridX = floor(num / gridWidth);
    gridY = num % gridWidth;
    translate([gridX * gridSpacing, gridY * gridSpacing, 0]) knob(isFixed);
}

