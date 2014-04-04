/**
 * \file closingMechanism.scad
 *
 * This file contains the demonstration of the closing mechanism of the skiDryer
 */

// Including the pieces. We use include because we need to use also the
// constants defined in the file
include <pieces.scad>;

/**
 * \brief The vertical distance between the axes of the two hinges for each
 *        upper leg when the skiDryer is open
 */
sd_upperLegHingesAxesVerticalDistance = sd_basesDistance - 2 * sd_hingeThickness;

/**
 * \brief The horizontal distance between the axes of the two hinges for each
 *        upper leg when the skiDryer is closed
 */
sd_upperLegHingesAxesHorizontalDistance = sd_legWidth + 2 * sd_hingeThickness;

/**
 * \brief The distance between the axes of the two hinges for each upper leg
 */
sd_upperLegHingesAxesDistance = sqrt(pow(sd_upperLegHingesAxesHorizontalDistance, 2) + pow(sd_upperLegHingesAxesVerticalDistance, 2));

/**
 * \brief The angle of the line connecting the axes of the two hinges with the
 *        base
 */
sd_upperLegHingesAxesAngle = asin(sd_upperLegHingesAxesVerticalDistance / sd_upperLegHingesAxesDistance);

/**
 * \brief Computes the vertical distance of the two bases at the given angle
 *
 * \param angle the angle of the closing mechanism (0 means open and the
 *              distance is equal to sd_basesDistance, 90 means closed)
 */
function sd_basesVerticalDistanceAtAngle(angle) = (2 * sd_hingeThickness) + (sd_upperLegHingesAxesDistance * sin(angle + sd_upperLegHingesAxesAngle));

/**
 * \brief Computes the horizontal displacement of the two bases at the given
 *        angle
 *
 * \param angle the angle of the closing mechanism (0 means open and the
 *              displacement is 0, 90 means closed)
 */
function sd_basesHorizontalDisplacementAtAngle(angle) = sd_upperLegHingesAxesHorizontalDistance - (sd_upperLegHingesAxesDistance * cos(angle + sd_upperLegHingesAxesAngle));

/**
 * \brief Computes the position of the center of the upper base given the angle
 *
 * This function returna a vector of three elements being the position of the
 * lower part of the upper base depending on the closing mechanism angle and the
 * position of center of the upper part of the lower base.
 * \param angle the angle of the closing mechanism
 * \param lowerBasePos the position of the center of the upper part of the lower
 *                     base
 * \param rotateAroundX if true the closing mechanism for the legs rotates
 *                      around the x axis, if false around the y axis
 */
function sd_upperBasePosition(angle, lowerBasePos, rotateAroundX) = lowerBasePos + [
	(rotateAroundX == true) ? 0 : sd_basesHorizontalDisplacementAtAngle(angle),
	(rotateAroundX == true) ? -sd_basesHorizontalDisplacementAtAngle(angle) : 0,
	sd_basesVerticalDistanceAtAngle(angle)];

/**
 * \brief Returns the position of the leg along the rotation axis of the closing
 *        mechanism
 *
 * The leg is identified by a parameter p which can be either 1 or -1. If other
 * values are used the placement will be incorrect
 * \param p the parameter identifying the leg
 * \param rotateAroundX if true the closing mechanism for the legs rotates
 *                      around the x axis, if false around the y axis
 */
function sd_legPositionAlongRotationAxis(p, rotateAroundX) = p * ((((rotateAroundX == true) ? sd_baseWidth : sd_baseDepth) - sd_legWidth) / 2 - sd_legsDistanceFromBorderAlongRotationAxis);

/**
 * \brief Returns the position of the leg along the axis perpendicular to the
 *        rotation axis of the closing mechanism
 *
 * The leg is identified by a parameter p which can be either 1 or -1. If other
 * values are used the placement will be incorrect
 * \param p the parameter identifying the leg
 * \param rotateAroundX if true the closing mechanism for the legs rotates
 *                      around the x axis, if false around the y axis
 */
function sd_legPositionAlongNonRotationAxis(p, rotateAroundX) = p * ((((rotateAroundX == true) ? sd_baseDepth : sd_baseWidth) - sd_legWidth) / 2 - sd_legsDistanceFromBorderAlongNonRotationAxis);

/**
 * \brief Returns the position of the center of a leg when the skiDryer is open
 *
 * This function returns the position of the center of a leg when the skiDryer
 * is open (this is also the position of the lower legs). A leg is identified by
 * a couple [p0, p1] with both p0 and p1 being either -1 or 1 (other values will
 * lead to an incorrect placement). This function only actually computes the x
 * and y position. The z position is passed as a parameter and is retuned as is.
 * \param p the couple of values identifying the leg (see function description)
 * \param rotateAroundX if true the closing mechanism for the legs rotates
 *                      around the x axis, if false around the y axis
 * \param z the position along z
 */
function sd_legPosition(p, rotateAroundX, z) = [
	(rotateAroundX == true) ? sd_legPositionAlongRotationAxis(p[0], rotateAroundX) : sd_legPositionAlongNonRotationAxis(p[0], rotateAroundX),
	(rotateAroundX == true) ? sd_legPositionAlongNonRotationAxis(p[1], rotateAroundX) : sd_legPositionAlongRotationAxis(p[1], rotateAroundX),
	z];

/**
 * \brief Returns the position of the center of an upper leg
 *
 * This function is like the one above but also takes into account the angle of
 * the closing mechanism
 * \param p the couple of values identifying the leg (see sd_legPosition
 *          function description)
 * \param rotateAroundX if true the closing mechanism for the legs rotates
 *                      around the x axis, if false around the y axis
 */
function sd_upperLegPosition(p, rotateAroundX) = sd_legPosition(p, rotateAroundX, sd_planesThickness + sd_upperLegsDisplacement[2] / 2) + (
	(rotateAroundX == true) ?
	[0, sd_upperLegsDisplacement[1] / 2, 0] :
	[sd_upperLegsDisplacement[0] / 2, 0, 0]);

/**
 * \brief Returns the position of an hinge on the lower base
 *
 * This function returns the position of an hinge on the lower base. The hinge
 * is identified by a couple [p0, p1] with both p0 and p1 being either -1 or 1
 * (other values will lead to an incorrect placement)
 * \param p the couple of values identifying the hinge (see function
 *          description)
 * \param rotateAroundX if true the closing mechanism for the legs rotates
 *                      around the x axis, if false around the y axis
 */
function sd_upperLegLowerBaseHingePosition(p, rotateAroundX) = [
	(rotateAroundX == true) ?
		p[0] * (sd_baseWidth / 2 - sd_legWidth / 2 - sd_legsDistanceFromBorderAlongRotationAxis) :
		p[0] * (sd_baseWidth / 2 - sd_legsDistanceFromBorderAlongNonRotationAxis) + sd_hingeThickness + ((1 - p[0]) / 2) * sd_legWidth,
	(rotateAroundX == true) ?
		p[1] * (sd_baseDepth / 2 - sd_legsDistanceFromBorderAlongNonRotationAxis) - sd_hingeThickness - ((p[1] + 1) / 2) * sd_legWidth :
		p[1] * (sd_baseDepth / 2 - sd_legWidth / 2 - sd_legsDistanceFromBorderAlongRotationAxis),
	sd_planesThickness + sd_hingeThickness];

/**
 * \brief Returns the position of an hinge on the upper base
 *
 * This function returns the position of an hinge on the upper base. The hinge
 * is identified by a couple [p0, p1] with both p0 and p1 being either -1 or 1
 * (other values will lead to an incorrect placement)
 * \param p the couple of values identifying the hinge (see function
 *          description)
 * \param rotateAroundX if true the closing mechanism for the legs rotates
 *                      around the x axis, if false around the y axis
 */
function sd_upperLegUpperBaseHingePosition(p, rotateAroundX) = [
	(rotateAroundX == true) ?
		p[0] * (sd_baseWidth / 2 - sd_legWidth / 2 - sd_legsDistanceFromBorderAlongRotationAxis) :
		p[0] * (sd_baseWidth / 2 - sd_legsDistanceFromBorderAlongNonRotationAxis) - sd_hingeThickness - ((p[0] + 1) / 2) * sd_legWidth + sd_upperLegsDisplacement[0],
	(rotateAroundX == true) ?
		p[1] * (sd_baseDepth / 2 - sd_legsDistanceFromBorderAlongNonRotationAxis) + sd_hingeThickness + ((1 - p[1]) / 2) * sd_legWidth + sd_upperLegsDisplacement[1] :
		p[1] * (sd_baseDepth / 2 - sd_legWidth / 2 - sd_legsDistanceFromBorderAlongRotationAxis),
	sd_planesThickness + sd_upperLegsDisplacement[2] - sd_hingeThickness];

/**
 * \brief Returns the position of the upper bolt of the closing mechanism,
 *        depending on whether the closing mechanism rotates aroud x or y
 *
 * \param rotateAroundX if true the closing mechanism for the legs rotates
 *                      around the x axis, if false around the y axis
 */
function upperBoltPosition(rotateAroundX) =
	(rotateAroundX == true) ?
		sd_upperBaseLowerFacePos + [-sd_baseWidth / 2 - sd_steelRopeBoltLength / 2, -sd_baseDepth / 2 + sd_steelRopeAttachDistanceFromExtremity, sd_planesThickness / 2] :
		sd_upperBaseLowerFacePos + [sd_baseWidth / 2 - sd_steelRopeAttachDistanceFromExtremity, -sd_baseDepth / 2 - sd_steelRopeBoltLength / 2, sd_planesThickness / 2];

/**
 * \brief Returns the position of the lower bolt of the closing mechanism,
 *        depending on whether the closing mechanism rotates aroud x or y
 *
 * \param rotateAroundX if true the closing mechanism for the legs rotates
 *                      around the x axis, if false around the y axis
 */
function lowerBoltPosition(rotateAroundX) =
	(rotateAroundX == true) ?
		sd_lowerBaseLowerFacePos + [-sd_baseWidth / 2 - sd_steelRopeBoltLength / 2, sd_baseDepth / 2 - sd_steelRopeAttachDistanceFromExtremity, sd_planesThickness / 2] :
		sd_lowerBaseLowerFacePos + [-sd_baseWidth / 2 + sd_steelRopeAttachDistanceFromExtremity, -sd_baseDepth / 2 - sd_steelRopeBoltLength / 2, sd_planesThickness / 2];

/**
 * \brief Returns the position of the steel rope of the closing mechanism
 *
 * \param rotateAroundX if true the closing mechanism for the legs rotates
 *                      around the x axis, if false around the y axis
 */
function closingMechanismRopePosition(rotateAroundX) =
	(rotateAroundX == true) ?
		upperBoltPosition(rotateAroundX) + [sd_steelRopeBoltLength / 4, 0, 0]:
		upperBoltPosition(rotateAroundX) + [0, sd_steelRopeBoltLength / 4, 0];

/**
 * \brief Returns the angle of the steel rope of the closing mechanism when the
 *        skiDryer is open
 *
 * \param rotateAroundX if true the closing mechanism for the legs rotates
 *                      around the x axis, if false around the y axis
 */
function closingMechanismRopeAngleWhenOpen(rotateAroundX) =
	(rotateAroundX == true) ?
		atan((upperBoltPosition(rotateAroundX)[2] - lowerBoltPosition(rotateAroundX)[2]) / (upperBoltPosition(rotateAroundX)[1] - lowerBoltPosition(rotateAroundX)[1])) :
		-atan((upperBoltPosition(rotateAroundX)[2] - lowerBoltPosition(rotateAroundX)[2]) / (upperBoltPosition(rotateAroundX)[0] - lowerBoltPosition(rotateAroundX)[0]));

/**
 * \brief Creates the lower part, the one interested by the closing mechanism
 *
 * This construction lacks the aluminium bars to hang stuffs.
 * \param angle the angle of the hinges. 0 means open, 90 means closed (this is
 *              the angle of the leg with the perpendicular to the lower base).
 *              When the angle is 0, the mechanism to keep the skiDryer open is
 *              in place
 * \param rotateAroundX if true the leg rotate around the x axis, otherwise
 *                      around the y axis
 */
module sd_closingMechanism(angle = 0, rotateAroundX = true) {
	// Checking the angle is valid
	if ((angle < 0) || (angle > 90)) {
		echo("Wrong angle for che closing mechanism");
	} else {
		// Placing the lower base with the lower part on the xy plane
		translate(sd_lowerBaseLowerFacePos + [0, 0, sd_planesThickness / 2]) {
			sd_lowerBase();
		}

		// Placing the lower legs
// QUI TOGLIERE LOWER LEG FATTE COSÌ E METTERE PIEDINI
		for (p = [[-1, -1], [-1, 1], [1, 1], [1, -1]]) {
			translate(sd_legPosition(p, rotateAroundX, -sd_heightFromGround / 2)) {
				sd_lowerLeg();
			}
		}

		// Placing the legs between the lower and upper base and the hinges
		for (p = [[-1, -1], [-1, 1], [1, 1], [1, -1]]) {
			// Placing leg
			translate(sd_upperLegPosition(p, rotateAroundX)) {
				sd_upperLeg(angle, rotateAroundX);
			}

			// Placing the hinge on the lower base
			translate(sd_upperLegLowerBaseHingePosition(p, rotateAroundX)) {
				sd_upperLegLowerBaseHinge(90 - angle, rotateAroundX);
			}

			// Placing the hinge on the upper base
			translate(sd_upperLegUpperBaseHingePosition(p, rotateAroundX)) {
				sd_upperLegUpperBaseHinge(90 - angle, rotateAroundX);
			}
		}

		// Placing the upper base
		translate(sd_upperBaseLowerFacePos + [0, 0, sd_planesThickness / 2]) {
			sd_upperBase();
		}

		// Now putting the lower ski support on the lower base
		translate([sd_skiHolePos + sd_skiHoleWidth / 2 + sd_lowerSkiSupportSide / 2, 0, sd_planesThickness + sd_lowerSkiSupportSide / 2]) {
			sd_mainAxis("y") {
				sd_lowerSkiSupport();
			}
		}

		// Also placing the supports for the vertical bars on the lower base
		translate([0, 0, sd_planesThickness + sd_verticalBarLowerBaseSupportThickness / 2]) {
			translate([sd_externalVerticalBarPosition, 0, 0]) {
				sd_verticalBarLowerBaseSupport();
			}
			translate([sd_internalVerticalBarPosition, 0, 0]) {
				sd_verticalBarLowerBaseSupport();
			}
		}

		// Putting the mechanism to keep the skiDryer open
		if (rotateAroundX == true) {
			// Putting two bolts where the rope to keep the skiDryer open is attached. This is not the final
			// mechanism
			translate(upperBoltPosition(rotateAroundX)) {
				sd_mainAxis("x") {
					sd_bolt(sd_steelRopeRingsDiameter / 2, sd_steelRopeBoltLength, sd_steelRopeBoltHeadRadius, sd_steelRopeBoltHeadThickness);
				}
			}
			translate(lowerBoltPosition(rotateAroundX)) {
				sd_mainAxis("x") {
					sd_bolt(sd_steelRopeRingsDiameter / 2, sd_steelRopeBoltLength, sd_steelRopeBoltHeadRadius, sd_steelRopeBoltHeadThickness);
				}
			}

			// Putting the rope of the skiDryer closing mechanism
			if (angle == 0) {
				// The rope is simply parallel to the upper base
				translate(closingMechanismRopePosition(rotateAroundX)) {
					rotate(a = closingMechanismRopeAngleWhenOpen(rotateAroundX), v = [1, 0, 0]) {
						rotate(a = -90, v = [0, 0, 1]) {
							rotate(a = 90, v = [1, 0, 0]) {
								sd_keepSkiDryerOpenRope(rotateAroundX);
							}
						}
					}
				}
			} else {
				// The rope is simply parallel to the upper base
				translate(closingMechanismRopePosition(rotateAroundX)) {
					rotate(a = -90, v = [0, 0, 1]) {
						rotate(a = 90, v = [1, 0, 0]) {
							sd_keepSkiDryerOpenRope(rotateAroundX);
						}
					}
				}
			}
		} else {
			// Putting two bolts where the rope to keep the skiDryer open is attached. This is not the final
			// mechanism
			translate(upperBoltPosition(rotateAroundX)) {
				sd_mainAxis("y") {
					sd_bolt(sd_steelRopeRingsDiameter / 2, sd_steelRopeBoltLength, sd_steelRopeBoltHeadRadius, sd_steelRopeBoltHeadThickness);
				}
			}
			translate(lowerBoltPosition(rotateAroundX)) {
				sd_mainAxis("y") {
					sd_bolt(sd_steelRopeRingsDiameter / 2, sd_steelRopeBoltLength, sd_steelRopeBoltHeadRadius, sd_steelRopeBoltHeadThickness);
				}
			}

			// Putting the rope of the skiDryer closing mechanism
			if (angle == 0) {
				// The rope is in place to keep the skiDryer open
				translate(closingMechanismRopePosition(rotateAroundX)) {
					rotate(a = closingMechanismRopeAngleWhenOpen(rotateAroundX), v = [0, 1, 0]) {
						rotate(a = 90, v = [1, 0, 0]) {
							sd_keepSkiDryerOpenRope(rotateAroundX);
						}
					}
				}
			} else {
				// The rope is simply parallel to the upper base
				translate(closingMechanismRopePosition(rotateAroundX)) {
					rotate(a = 90, v = [1, 0, 0]) {
						sd_keepSkiDryerOpenRope(rotateAroundX);
					}
				}
			}
		}
	}
}

/**
 * \brief Whether the rotation mechanism rotates around the x or y axis
 */
sd_rotateAroundX = false;

/**
 * \brief The angle of the closing mechanism
 */
sd_closingMechanismAngle = 90 * (($t < 0.1) ? 0 : ($t > 0.9) ? 1 : ($t - 0.1) / 0.8);

/**
 * \brief The position of the lower part of the lower base
 */
sd_lowerBaseLowerFacePos = [0, 0, 0];

/**
 * \brief The position of the lower part of the upper base
 */
sd_upperBaseLowerFacePos = sd_upperBasePosition(sd_closingMechanismAngle, sd_lowerBaseLowerFacePos + [0, 0, sd_planesThickness], sd_rotateAroundX);

/**
 * \brief The displacement of the center of upper legs due to the position of
 *        the closing mechanism
 */
sd_upperLegsDisplacement = sd_upperBaseLowerFacePos - (sd_lowerBaseLowerFacePos + [0, 0, sd_planesThickness]);

// Creating the assembly
sd_closingMechanism(sd_closingMechanismAngle, sd_rotateAroundX);
