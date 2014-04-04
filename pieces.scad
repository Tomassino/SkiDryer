/**
 * \file pieces.scad
 *
 * This file contains all the actual pieces to build the SkiDryer. This uses
 * base components from "components.scad". There are demos at the end, so when
 * including this file use the "use" include statement and not the "include"
 * one. All functions and variables of the project have the "sd_" prefix. All
 * measures are intended to be in mm
 */

// Including base components
use <components.scad>;

/**
 * \brief The lower base of the SkiDryer
 *
 * This is the lower base of SkiDryer, the one nearer to the floor
 */
module sd_lowerBase()
{
	sd_woodenPlaneWithHoles([sd_baseWidth, sd_baseDepth, sd_planesThickness]);
}

/**
 * \brief The upper base of the SkiDryer
 *
 * This is the upper base of SkiDryer
 */
module sd_upperBase()
{
	if (sd_aluminiumVerticalBarSection == "round") {
		sd_woodenPlaneWithHoles([sd_baseWidth, sd_baseDepth, sd_planesThickness], [[sd_skiHolePos, 0, sd_skiHoleWidth, sd_skiHoleDepth]], [[sd_externalVerticalBarPosition, 0, sd_aluminiumBarSectionSize / 2], [sd_internalVerticalBarPosition, 0, sd_aluminiumBarSectionSize / 2]]);
	} else if (sd_aluminiumVerticalBarSection == "square") {
		sd_woodenPlaneWithHoles([sd_baseWidth, sd_baseDepth, sd_planesThickness], [[sd_skiHolePos, 0, sd_skiHoleWidth, sd_skiHoleDepth], [sd_externalVerticalBarPosition, 0, sd_aluminiumBarSectionSize, sd_aluminiumBarSectionSize], [sd_internalVerticalBarPosition, 0, sd_aluminiumBarSectionSize, sd_aluminiumBarSectionSize]], []);
	} else {
		echo("Wrong section specification in sd_upperBase");
	}
}

/**
 * \brief A leg of the SkiDryer under the lower base
 *
 * This are feets under the lower base
 */
module sd_lowerLeg()
{
	sd_mainAxis("z") {
		translate([sd_heightFromGround / 2, 0, 0]) {
			sd_footSupport(sd_footThreadedPartRadius, sd_footSupportThreadedPartThickness, sd_footThreadedPartLength, sd_footSupportRadius, sd_footSupportThickness);
		}
		translate([sd_heightFromGround / 2 -sd_footSupportThickness, 0, 0]) {
			sd_foot(sd_footThreadedPartRadius, sd_footThreadedPartLength, sd_footRadius, sd_footThickness);
		}
	}
}

/**
 * \brief A leg of the SkiDryer between the lower and upper base
 *
 * \param angle the angle of the leg
 * \param rotateAroundX if true the leg rotate around the global x axis,
 *                      otherwise around the global y axis
 */
module sd_upperLeg(angle, rotateAroundX)
{
	if (rotateAroundX == true) {
		rotate(a = angle, v = [1, 0, 0]) {
			sd_mainAxis("z") {
				sd_woodenLeg(sd_legWidth, sd_basesDistance);
			}
		}
	} else {
		rotate(a = angle, v = [0, 1, 0]) {
			sd_mainAxis("z") {
				sd_woodenLeg(sd_legWidth, sd_basesDistance);
			}
		}
	}
}

/**
 * \brief The hinge between the upper leg and the lower base
 *
 * \param angle the angle of the hinge
 * \param rotateAroundX if true the hinge axis is parallel to the global x axis,
 *                      otherwise to the global y axis
 */
module sd_upperLegLowerBaseHinge(angle, rotateAroundX)
{
	if (rotateAroundX == true) {
		rotate(a = 180, v = [0, 0, 1]) {
			sd_aluminiumHinge(sd_legWidth, sd_hingeDepth, sd_hingeThickness, angle);
		}
	} else {
		rotate(a = 270, v = [0, 0, 1]) {
			sd_aluminiumHinge(sd_legWidth, sd_hingeDepth, sd_hingeThickness, angle);
		}
	}
}

/**
 * \brief The hinge between the upper leg and the lower base
 *
 * \param angle the angle of the hinge
 * \param rotateAroundX if true the hinge axis is parallel to the global x axis,
 *                      otherwise to the global y axis
 */
module sd_upperLegUpperBaseHinge(angle, rotateAroundX)
{
	if (rotateAroundX == true) {
		rotate(a = 180, v = [0, 1, 0]) {
			sd_aluminiumHinge(sd_legWidth, sd_hingeDepth, sd_hingeThickness, angle);
		}
	} else {
		rotate(a = 90, v = [0, 0, 1]) {
			rotate(a = 180, v = [0, 1, 0]) {
				sd_aluminiumHinge(sd_legWidth, sd_hingeDepth, sd_hingeThickness, angle);
			}
		}
	}
}

/**
 * \brief The lower support for skis
 *
 * This is a simple wooden stick on the lower base
 */
module sd_lowerSkiSupport()
{
	sd_woodenStick(sd_lowerSkiSupportSide, sd_lowerSkiSupportSide, sd_skiHoleDepth);
}

/**
 * \brief The support of the vertical bar on the lower base
 *
 * This is a wooden cube with a hole in the center which is put on the lower
 * base in which the vertical bar is inserted
 */
module sd_verticalBarLowerBaseSupport()
{
	if (sd_aluminiumVerticalBarSection == "round") {
		sd_woodenPlaneWithHoles([sd_verticalBarLowerBaseSupportShortSide, sd_verticalBarLowerBaseSupportLongSide, sd_verticalBarLowerBaseSupportThickness], [], [[0, 0, sd_aluminiumBarSectionSize / 2]]);
	} else if (sd_aluminiumVerticalBarSection == "square") {
		sd_woodenPlaneWithHoles([sd_verticalBarLowerBaseSupportShortSide, sd_verticalBarLowerBaseSupportLongSide, sd_verticalBarLowerBaseSupportThickness], [[0, 0, sd_aluminiumBarSectionSize, sd_aluminiumBarSectionSize]], []);
	} else {
		echo("Wrong section specification in sd_verticalBarLowerBaseSupport");
	}
}

/**
 * \brief A rope to keep the skiDryer open
 *
 * This is a rope with two rings at the two extremities. The origin is in the
 * center of one ring
 * \param rotateAroundX if true the closing mechanism of the skiDryer rotates
 *                      around the global x axis, if false around the global y
 *                      axis
 */
module sd_keepSkiDryerOpenRope(rotateAroundX)
{
	// The helper function computing the distance between the centers of the two rings at
	// the extremities of the rope
	function ropeLength(rX) = sqrt(((rX == true) ? pow(sd_baseDepth - 2 * sd_steelRopeAttachDistanceFromExtremity, 2) : pow(sd_baseWidth - 2 * sd_steelRopeAttachDistanceFromExtremity, 2)) + pow(sd_basesDistance + sd_planesThickness, 2));

	// First placing the straight part
	translate([-ropeLength(rotateAroundX) / 2, 0, 0]) {
		sd_straightSteelRope(ropeLength(rotateAroundX) - sd_steelRopeRingsDiameter - sd_steelRopeSection, sd_steelRopeSection);
	}

	// Now plaing the ring at one end...
	sd_steelRopeRing(sd_steelRopeRingsDiameter, sd_steelRopeSection);

	// ... finally the ring at the other one end
	translate([-ropeLength(rotateAroundX), 0, 0]) {
		sd_steelRopeRing(sd_steelRopeRingsDiameter, sd_steelRopeSection);
	}
}

/**
 * \brief A small value used when it is needed to make the shape simple
 */
sd_epsilon = 0.01;

/**
 * \brief The width of the base
 */
sd_baseWidth = 1000;

/**
 * \brief The depth of the base
 */
sd_baseDepth = 500;

/**
 * \brief The thickness of wooden planes
 */
sd_planesThickness = 30;

/**
 * \brief The position along the width of the center of the hole for the skis
 *        in the upper base as a fraction of base width
 */
sd_skiHoleRelPos = 0.3;

/**
 * \brief The (absolute) position along the width of the center of the hole for
 *        the skis in the upper base as a fraction of base width
 */
sd_skiHolePos = sd_skiHoleRelPos * sd_baseWidth;

/**
 * \brief The width of the ski hole
 */
sd_skiHoleWidth = 100;

/**
 * \brief The depth of the ski hole as a proportion of the upper base depth
 */
sd_skiHoleRelDepth = 0.6;

/**
 * \brief The (absolute) depth of the ski hole
 */
sd_skiHoleDepth = sd_skiHoleRelDepth * sd_baseDepth;

/**
 * \brief The distance beween the upper and the lower base
 *
 * This is the distance between the upper part of the lower base and the lower
 * part of the upper base
 */
sd_basesDistance = 300;

/**
 * \brief The distance of the lower base from the ground
 *
 * This is the distance from the lower part of the lower base to the ground
 */
sd_heightFromGround = 40;

/**
 * \brief The radius of the threaded part of the foot (and of the support)
 */
sd_footThreadedPartRadius = 5;

/**
 * \brief The radius of the foot
 */
sd_footRadius = 15;

/**
 * \brief The thickness of the foot
 */
sd_footThickness = 10;

/**
 * \brief The thickness of the threaded part of the foot support
 */
sd_footSupportThreadedPartThickness = 2;

/**
 * \brief The radius of the foot support
 */
sd_footSupportRadius = sd_footRadius;

/**
 * \brief The thickness of the foot support
 */
sd_footSupportThickness = 2;

/**
 * \brief The length of the threaded part of both the foot and its support
 */
sd_footThreadedPartLength = sd_heightFromGround - sd_footThickness - sd_footSupportThickness;

/**
 * \brief The dimension of the side of each leg
 */
sd_legWidth = 60;

/**
 * \brief The depth of hinges
 */
sd_hingeDepth = sd_legWidth;

/**
 * \brief The thickness of hinges
 */
sd_hingeThickness = 2;

/**
 * \brief The distance of the legs from the border of the long side of the bases
 */
sd_legsDistanceFromBorderAlongNonRotationAxis = 65;

/**
 * \brief The distance of the legs from the border of the short side of the
 *        bases
 */
sd_legsDistanceFromBorderAlongRotationAxis = 0;

/**
 * \brief The side of the lower ski support
 *
 * The lower ski support has a square section
 */
sd_lowerSkiSupportSide = sd_legWidth;

/**
 * \brief The thickness of the support for the vertical bar on the lower base
 */
sd_verticalBarLowerBaseSupportThickness = sd_legWidth;

/**
 * \brief The short dimension of the support for the vertical bar on the lower
 *        base
 *
 * This is the lengh of the short side, the one parallel to the base long side
 */
sd_verticalBarLowerBaseSupportShortSide = 100;

/**
 * \brief The long dimension of the support for the vertical bar on the lower
 *        base
 *
 * This is the lengh of the long side, the one perpendicular to the base long
 * side
 */
sd_verticalBarLowerBaseSupportLongSide = 150;

/**
 * \brief The size of the aluminium bar section
 *
 * This is the external diameter of the vertical bar if it has a round section,
 * the length of one side if it is square. See sd_aluminiumVerticalBarSection
 * for the section kind
 */
sd_aluminiumBarSectionSize = 30;

/**
 * \brief The section of the vertical bars
 */
sd_aluminiumVerticalBarSection = "square";

/**
 * \brief The section of the steel rope to keep the skiDryer open
 */
sd_steelRopeSection = 2;

/**
 * \brief The internal diameter of the rings at the end of the rope to keep the
 *        skiDryer open
 */
sd_steelRopeRingsDiameter = 10;

/**
 * \brief The distance from the extremities of the plane at which the rope to
 *        keep the skiDryer open is attached
 */
sd_steelRopeAttachDistanceFromExtremity = 50;

/**
 * \brief The length of the bolts to which the steel rope to keep the skiDryer
 *        open is attached
 */
sd_steelRopeBoltLength = 50;

/**
 * \brief The radius of the head of the bolt to which the steel rope to keep
 *        the skiDryer open is attached
 */
sd_steelRopeBoltHeadRadius = sd_steelRopeRingsDiameter;

/**
 * \brief The thickness of the head of the bolt to which the steel rope to keep
 *        the skiDryer open is attached
 */
sd_steelRopeBoltHeadThickness = 10;























/**
 * \brief The internal vertical bar to hang stuffs
 */
module sd_internalVerticalBar()
{
	sd_emptyAluminiumRodWithHoles(sd_verticalBarLength, sd_aluminiumBarSectionSize, sd_aluminiumBarThickness, sd_aluminiumVerticalBarSection, "z");
}

/**
 * \brief The external vertical bar to hang stuffs
 */
module sd_externalVerticalBar()
{
	function sd_makeHoleForHook(h) = [sd_hookRadius, h[0], h[1], true];
	function sd_makeHolesForHooks(h, i = 0) = (i == (len(h) - 1) ? sd_makeHoleForHook(h[i]) : concat(sd_makeHoleForHook(h[i]), sd_makeHolesForHooks(h, i + 1)));
	holes = sd_makeHolesForHooks(sd_hookPositionsOnExternalVerticalBar);
	sd_emptyAluminiumRodWithHoles(sd_verticalBarLength, sd_aluminiumBarSectionSize, sd_aluminiumBarThickness,  sd_aluminiumVerticalBarSection, "z", holes);
}

/**
 * \brief The horizontal bar between the two vertical ones
 */
module sd_horizontalBar()
{
	sd_emptyAluminiumRodWithHoles(sd_horizontalBarLength, sd_aluminiumBarSectionSize, sd_aluminiumBarThickness,  sd_aluminiumHorizontalBarSection, "x");
}

/**
 * \brief The upper support for skis
 *
 * This is a simple aluminium rod attached to the internal vertical bar
 */
module sd_upperSkiSupport()
{
	sd_emptyAluminiumRodWithHoles(sd_skiHoleDepth, sd_aluminiumBarSectionSize, sd_aluminiumBarThickness,  sd_aluminiumVerticalBarSection, "y");
}

/**
 * \brief The hook on the vertical bar
 *
 * The hook is translated so that the distance from the center to the non-bent
 * tip is sd_hookDistanceFromCenterToNonBentTip and the distance from the center
 * to the bending is sd_hookDistanceFromCenterToBending
 */
module sd_hookOnVerticalBar()
{
	rotate(a = 180, v = [0, 0, 1]) {
		translate([(sd_hookDistanceFromCenterToBending - sd_hookDistanceFromCenterToNonBentTip) / 2, 0, 0]) {
			sd_aluminiumHook(sd_hookTotalLength, sd_hookLength, sd_hookRadius);
		}
	}
}

/**
 * \brief The total length of the legs
 */
sd_totalLength = sd_basesDistance + sd_planesThickness + sd_heightFromGround;

/**
 * \brief The dimension of the groove of each leg for mounting on the lower base
 */
sd_legGrooveDepth = 10;

/**
 * \brief The thickness of the vertical bar
 */
sd_aluminiumBarThickness = 1;

/**
 * \brief The section of the horizontal bar
 */
sd_aluminiumHorizontalBarSection = "round";

/**
 * \brief The length of the vertical bar
 */
sd_verticalBarLength = 1300;

/**
 * \brief The length of the horizontal bar
 */
sd_horizontalBarLength = 650;

/**
 * \brief The distance of one of the vertical bar from the border of the base
 *
 * This is the distance of the external part of the vertical bar from the border
 * of the base
 */
sd_verticalBarDistanceFromBorder = 70;

/**
 * \brief The position of the center of the most external vertical bar on the
 *        base
 */
sd_externalVerticalBarPosition = -((sd_baseWidth / 2) - sd_verticalBarDistanceFromBorder - (sd_aluminiumBarSectionSize / 2));

/**
 * \brief The position of the center of the most internal vertical bar on the
 *        base
 */
sd_internalVerticalBarPosition = sd_externalVerticalBarPosition + sd_horizontalBarLength - sd_aluminiumBarSectionSize;

/**
 * \brief The side of the lower ski support
 *
 * The lower ski support has a square section
 */
sd_lowerSkiSupportSide = 60;

/**
 * \brief The distance from the center of the hook to the non-bent tip
 */
sd_hookDistanceFromCenterToNonBentTip = sd_aluminiumBarSectionSize;

/**
 * \brief The distance from the center of the hook to the bending
 */
sd_hookDistanceFromCenterToBending = sd_aluminiumBarSectionSize + 30;

/**
 * \brief The total length of the non-bent part of the hook
 */
sd_hookTotalLength = sd_hookDistanceFromCenterToNonBentTip + sd_hookDistanceFromCenterToBending;

/**
 * \brief The length of the bend part of the hook
 */
sd_hookLength = 20;

/**
 * \brief The radius of the hook
 */
sd_hookRadius = 3;

/**
 * \brief The positions of the hooks on the external vertical bar
 *
 * Each position is a couple [p, a] there p is the distance from the upper face
 * of the lower base and a is the angle around the vertical bar
 */
sd_hookPositionsOnExternalVerticalBar = [[800, 90], [950, -90], [1200, 0]];

/**
 * \brief The vector with positions of the upper ski support
 *
 * Each element is an height from the upper face of the lower base position
 */
sd_upperSkiSupportsPositions = [500, 850, 1200];

// The following lines are left here as an example

// sd_lowerBase();
//
// translate([0, 0, sd_basesDistance]) {
// 	sd_upperBase();
// }
//
// translate([0, sd_baseWidth, 0]) {
// 	sd_lowerLeg();
// }
//
// translate([0, -sd_baseWidth, 0]) {
// 	sd_upperLeg(45, true);
// }
//
// translate([sd_baseWidth, -sd_baseWidth, 0]) {
// 	sd_upperLegLowerBaseHinge(45);
// }
//
// translate([-sd_baseWidth, -sd_baseWidth, 0]) {
// 	sd_upperLegUpperBaseHinge(45);
// }







// translate([sd_baseWidth + sd_aluminiumBarSectionSize * 10, 0, 0]) {
// 	sd_internalVerticalBar();
// }
//
// translate([-sd_baseWidth - sd_aluminiumBarSectionSize * 10, -sd_baseWidth, 0]) {
// 	sd_externalVerticalBar();
// }
//
// translate([0, -sd_baseWidth, 0]) {
// 	sd_horizontalBar();
// }
//
// translate([-sd_baseWidth - sd_verticalBarLowerBaseSupportLongSide * 2, 0, 0]) {
// 	sd_verticalBarLowerBaseSupport();
// }
//
// translate([sd_baseWidth + sd_aluminiumBarSectionSize * 10, -sd_baseWidth, 0]) {
// 	sd_lowerSkiSupport();
// }
//
// translate([sd_baseWidth + sd_aluminiumBarSectionSize * 10, sd_baseWidth, 0]) {
// 	sd_upperSkiSupport();
// }
//
// translate([-sd_baseWidth - sd_aluminiumBarSectionSize * 10, sd_baseWidth, 0]) {
// 	sd_hookOnVerticalBar();
// }
