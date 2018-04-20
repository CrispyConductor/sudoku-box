// Total outside dimensions of box plus lid; width, depth, height
boxSize = [150, 150, 80];

// Radius of the top section of the pins
pinBottomRadius = boxSize[0] / 50;

// Radius of the top section of the pins
pinTopRadius = pinBottomRadius * 0.625;

// Distance between centers of holes
holeSpacing = pinBottomRadius * 4;

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

// Radius of the holes in the lid
topHoleRadius = pinTopRadius + 0.5;

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

// Offset from the top of lid to near side of sliding plate
slidePlateTopOffset = lidSize[2] - boxKeywayOffsetZ;

// Thickness of just base plate base sheet
basePlateThick = 3;

// thickness of base plate including needed mechanisms
basePlateTotalThick = 10; // todo: calculate this

// Distance from top of base plate mechanisms to bottom of slide plate
slidePlateToBaseClearance  = 3;

// Distance from the top of the lid to the top of the base plate base (ie, the top of the plate, not including mechanisms)
basePlateBaseTopOffset = slidePlateTopOffset + slidePlateThick + slidePlateToBaseClearance + basePlateTotalThick - basePlateThick;

// Amount the notch protrudes into the pin from the farthest point on the circumference
pinNotchDepth = pinBottomRadius * 2 * 0.75;

// Depth of the sliding plate
slidePlateDepth = lidSize[1] - 2 * (lidSideThick + lidSideBoxClearance + boxTopThick + boxInsideClearance) - pinNotchDepth * 1.25;

// Width of the notch in pins
pinNotchWidth = pinBottomRadius / 2;

// Amount of clearance between the prongs and pin notches on each side of the notch
pinNotchClearance = 0.4;

// Amount of space to leave between pins and prongs in locked state
prongLengthClearance = 1;

slideWidth = holeGridPosX - pinBottomRadius - pinRotateClearance - innerLidPartsOffset;
slideHeight = slidePlateTopOffset - lidTopThick;
slideDepth = lidSize[1] - 2 * innerLidPartsOffset;

slidePosY = innerLidPartsOffset;
slidePosZ = lidSize[2] - slideHeight - lidTopThick;
slide1PosX = innerLidPartsOffset;
slide2PosX = lidSize[0] - innerLidPartsOffset - slideWidth;

sideSlideClearance = 1;

sideSlideWidth = (lidSize[0] - slidePlateWidth) / 2 - slide1PosX - sideSlideClearance;
sideSlideHeight = slidePlateThick;
sideSlidePosZ = slidePosZ - sideSlideHeight;

postWidth = sideSlideWidth;
postDepth = slideDepth / 10;
postHeight = basePlateBaseTopOffset - (lidSize[2] - sideSlidePosZ);

fastenerPegDepth = postDepth / 2;
fastenerSlotThroat = postWidth * 0.65;

