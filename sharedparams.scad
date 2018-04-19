// Total outside dimensions of box plus lid; width, depth, height
boxSize = [150, 150, 80];

// Thickness of the top surface of the lid.
lidTopThick = 3;

// Thickness of the wall of the top section of the box.
boxTopThick = 3;

// Thickness of the wall of the sides of the lid
lidSideThick = 2;

// Height of the upper section of the box.
boxTopSectionHeight = 30;

// Total outside dimensions of the lid
lidSize = [boxSize[0], boxSize[1], boxTopSectionHeight + lidTopThick];

// Distance from bottom of lid to bottom of slot for button
boxKeywayOffsetZ = 18;

// Clearance to leave between inner sides of lid and outer sides of the top of the box, on each side
lidSideBoxClearance = 1.5;

// Thickness of the sliding plate
slidePlateThick = 3;

// amount of clearance to leave between inside workings and box
// clearance to sides in built into lidSideThick
boxInsideClearance = 1;

// This is the offset from the origin (either X or Y) to where the inner workings of
// the lid can start.  It includes necessary clearances to fit the lid on the box.
innerLidPartsOffset = lidSideThick + lidSideBoxClearance + boxTopThick + boxInsideClearance;

// Radius of the top section of the pins
pinTopRadius = 2.5;

// Radius of the top section of the pins
pinBottomRadius = 4;

// Radius of the holes in the lid
topHoleRadius = pinTopRadius + 0.5;

// Distance between centers of holes
holeSpacing = 12;

// How many holes
holeGridSizeX = 9;
holeGridSizeY = 9;

// The offset from the XY origin of the lid to the center of the nearest hole
holeGridPosX = (lidSize[0] - (holeGridSizeX - 1) * holeSpacing) / 2;
holeGridPosY = (lidSize[1] - (holeGridSizeY - 1) * holeSpacing) / 2;

// Distance (radius) of clearance from rotating pin to parts
pinRotateClearance = 1;

// Amount added to pin bottom diameter to get the diameter of slide plate holes
slidePlatePinClearance = 0.8;

// Width of border around edges of holes in sliding plate
slidePlateBorderSize = 5;

// Width of the sliding plate
slidePlateWidth = (holeGridSizeX - 1) * holeSpacing + 2 * (pinBottomRadius + slidePlatePinClearance + slidePlateBorderSize);

clipEdgeOffset = 2;
