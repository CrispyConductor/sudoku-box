include <mainparams.scad>

// Radius of the top section of the pins
pinTopRadius = knobDiameter / 2;

// Radius of the top section of the pins
pinBottomRadius = pinTopRadius + 1.125;

// Distance between centers of holes
minHoleSpacing = pinBottomRadius * 4;
holeSpacing = max(minHoleSpacing, knobSpacing);

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

// Offset from top of the lid to top of the button
buttonTopOffset = 15;

// Amount of clearance between the sliding button and button hole in the lid, on each side in vertical direction
lidButtonSlotClearanceZ = 0.5;

// Width of the button in the front
buttonWidth = 4;

// Amount of space to leave between the button arm and keyway slot, on each side
keywayClearanceX = 0.5;

// Width of the box keyway slot (narrow part)
boxKeywayWidth = buttonWidth + 2 * keywayClearanceX;

// Width of box key slot (thick part)
boxKeyholeWidth = boxKeywayWidth * 2;

// Amount of space to leave between button and keyhole, on each side
keyholeClearanceZ = 0.5;

// Clearance to leave between inner sides of lid and outer sides of the top of the box, on each side
lidSideBoxClearance = 0.85;

// Thickness of the sliding plate
slidePlateThick = 3;

// amount of clearance to leave between inside workings and box
// clearance to sides in built into lidSideThick
boxInsideClearance = 2;

// This is the offset from the origin (either X or Y) to where the inner workings of
// the lid can start.  It includes necessary clearances to fit the lid on the box.
innerLidPartsOffset = lidSideThick + lidSideBoxClearance + boxTopThick + boxInsideClearance;

// Radius of the holes in the lid
topHoleRadius = pinTopRadius + 0.5;

// How many holes
holeGridSizeX = knobGridSizeXY[0];
holeGridSizeY = knobGridSizeXY[1];

// The offset from the XY origin of the lid to the center of the nearest hole
holeGridPosX = (lidSize[0] - (holeGridSizeX - 1) * holeSpacing) / 2;
holeGridPosY = (lidSize[1] - (holeGridSizeY - 1) * holeSpacing) / 2;

// Distance (radius) of clearance from rotating pin to parts
pinRotateClearance = 3;

// Amount added to pin bottom diameter to get the diameter of slide plate holes
slidePlatePinClearance = 0.8;

// Width of border around edges of holes in sliding plate
slidePlateBorderSize = 8;

// Width of the sliding plate
slidePlateWidth = (holeGridSizeX - 1) * holeSpacing + 2 * (pinBottomRadius + slidePlatePinClearance + slidePlateBorderSize);

// Offset from the top of lid to near side of sliding plate
slidePlateTopOffset = buttonTopOffset;

// Thickness of just base plate base sheet
basePlateThick = 3;

// Height of the detent prongs
detentProngHeight = 2;

// Offset from the top of the base plate to the Z center of the detent prong
basePlateDetentProngOffsetZ = 10;

// thickness of base plate including needed mechanisms
basePlateTotalThick = basePlateThick + basePlateDetentProngOffsetZ + detentProngHeight + 3;

// Distance from top of base plate mechanisms to bottom of slide plate
slidePlateToBaseClearance  = 3;

// Distance from the top of the lid to the top of the base plate base (ie, the top of the plate, not including mechanisms)
basePlateBaseTopOffset = slidePlateTopOffset + slidePlateThick + slidePlateToBaseClearance + basePlateTotalThick - basePlateThick;

// Amount the notch protrudes into the pin from the farthest point on the circumference
pinNotchDepth = pinBottomRadius * 2 * 0.65;

// Depth of the sliding plate
slidePlateDepth = lidSize[1] - 2 * (lidSideThick + lidSideBoxClearance + boxTopThick + boxInsideClearance) - pinNotchDepth * 1.25;

// Width of the notch in pins
pinNotchWidth = pinBottomRadius * 0.8;

// Amount of clearance between the prongs and pin notches on each side of the notch
pinNotchClearance = 0.4;

// Amount of space to leave between pins and prongs in locked state
prongLengthClearance = 1;

// Amount of clearance to leave for pressing the button to unlock the box.
// ie, the distance the button travels past the point where it unlocks the box.
buttonPressClearance = 0.5;

// The minimum amount the buttons extends in the unlocked (pushed) position
buttonMinExtension = 5;

// Vertical clearance between slides for sliding plate
slidePlateVerticalClearance = 1.5;

// Radius of the pivot hole in the bottom of the pin
pinBottomCavityRadius = pinBottomRadius - 1;

// Height of pin bottom cavity
pinBottomCavityHeight = 3;

// Length of the bottom cavity key notch
fixedPosKeyWidth = (pinBottomRadius - pinBottomCavityRadius) * 0.8;

 // Width of the support post for the detent prongs
detentPostWidth = pinBottomRadius * 2;

// Depth/thickness of the support post for the detent prongs
detentPostDepth = 2.5;

// Distance from the detent post to the outside of the pin cylinder (not counting the bit that protrudes inside the cylinder
detentProngLength = 3.5;

fixedPinFinWidth = 1.4;
fixedPinFinSlotClearance = 0.5;
fixedPinSlotWidth = fixedPinFinWidth + fixedPinFinSlotClearance;

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

pinBottomCavityClearance = 0.5;

clipBallRadius = 0.75;
