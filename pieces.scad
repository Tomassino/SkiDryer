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
	sd_woodenPlaneWithHoles([sd_baseWidth, sd_baseDepth, sd_planesThickness], [[sd_skiHolePos, 0, sd_skiHoleWidth, sd_skiHoleDepth]], [[sd_externalVerticalBarPosition, 0, sd_aluminiumBarSectionSize / 2], [sd_internalVerticalBarPosition, 0, sd_aluminiumBarSectionSize / 2]]);
}

/**
 * \brief A leg of the SkiDryer under the lower base
 */
module sd_lowerLeg()
{
	sd_mainAxis("z") {
		sd_woodenLeg(sd_legWidth, sd_heightFromGround);
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
sd_heightFromGround = 100;

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
// 	function sd_makeHoleForHook(h) = [sd_hookRadius, h[0], h[1], true];
// 	function sd_makeHolesForHooks(h, i = 0) = (i == (len(h) - 1) ? sd_makeHoleForHook(h[i]) : concat(sd_makeHoleForHook(h[i]), sd_makeHolesForHooks(h, i + 1)));
// 	holes = sd_makeHolesForHooks(sd_hookPositionsOnExternalVerticalBar);
// 	sd_emptyAluminiumRodWithHoles(sd_verticalBarLength, sd_aluminiumBarSectionSize, sd_aluminiumBarThickness,  sd_aluminiumVerticalBarSection, "z", holes);
	sd_emptyAluminiumRodWithHoles(sd_verticalBarLength, sd_aluminiumBarSectionSize, sd_aluminiumBarThickness,  sd_aluminiumVerticalBarSection, "z", sd_TMP_holes);
}

/**
 * \brief The horizontal bar between the two vertical ones
 */
module sd_horizontalBar()
{
	sd_emptyAluminiumRodWithHoles(sd_horizontalBarLength, sd_aluminiumBarSectionSize, sd_aluminiumBarThickness,  sd_aluminiumHorizontalBarSection, "x");
}

/**
 * \brief The support of the vertical bar on the lower base
 *
 * This is a wooden cube with a hole in the center which is put on the lower
 * base in which the vertical bar is inserted
 */
module sd_verticalBarLowerBaseSupport()
{
	sd_woodenPlaneWithHoles([sd_verticalBarLowerBaseSupportShortSide, sd_verticalBarLowerBaseSupportLongSide, sd_verticalBarLowerBaseSupportThickness], [], [[0, 0, sd_aluminiumBarSectionSize / 2]]);
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
 * \brief The external radius of the vertical bar
 */
sd_aluminiumBarSectionSize = 30;

/**
 * \brief The thickness of the vertical bar
 */
sd_aluminiumBarThickness = 1;

/**
 * \brief The section of the vertical bars
 */
sd_aluminiumVerticalBarSection = "round";

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
 * \brief The thickiness of the support for the vertical bar on the lower base
 */
sd_verticalBarLowerBaseSupportThickness = 100;

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
 * \brief The position of holes in the vertical bar for hooks
 *
 * THIS IS NEEDED BECAUSE WE CANNOT CREATE THIS VECTOR FROM
 * sd_hookPositionsOnExternalVerticalBar, WE WOULD NEED A VECTOR CONCATENATION
 * FUNCTION WHICH HAS BEEN ADDED ONLY RECENTY TO OPENSCAD. WHEN WE MOVE TO THE
 * NEW OPENSCAD, THIS CAN BE REMOVED AND COMPUTED IN THE
 * sd_externalVerticalBar() (THE CODE IS NOW COMMENTED OUT)
 */
sd_TMP_holes = [[sd_hookRadius, 800 - sd_verticalBarLength / 2 - sd_planesThickness, 90 + 90, true], [sd_hookRadius, 950 - sd_verticalBarLength / 2 - sd_planesThickness, -90 + 90, true], [sd_hookRadius, 1200 - sd_verticalBarLength / 2 - sd_planesThickness, 0 + 90, true]];

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
