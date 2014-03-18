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
 * position of center of the upper part of the lower base. Use this function if
 * the legs rotate around the x axis when closing.
 * \param angle the angle of the closing mechanism
 * \param lowerBasePos the position of the center of the upper part of the lower
 *                     base
 */
function sd_upperBasePositionRotX(angle, lowerBasePos) = lowerBasePos + [
	0,
	-sd_basesHorizontalDisplacementAtAngle(angle),
	sd_basesVerticalDistanceAtAngle(angle)];

/**
 * \brief Computes the position of the center of the upper base given the angle
 *
 * This function returna a vector of three elements being the position of the
 * lower part of the upper base depending on the closing mechanism angle and the
 * position of center of the upper part of the lower base. Use this function if
 * the legs rotate around the y axis when closing
 * \param angle the angle of the closing mechanism
 * \param lowerBasePos the position of the center of the upper part of the lower
 *                     base
 */
function sd_upperBasePositionRotY(angle, lowerBasePos) = lowerBasePos + [
	-sd_basesHorizontalDisplacementAtAngle(angle),
	0,
	sd_basesVerticalDistanceAtAngle(angle)];

/**
 * \brief Creates the lower part, the one interested by the closing mechanism
 *
 * This construction lacks the aluminium bars to hang stuffs.
 * \param angle the angle of the hinges. 0 means open, 90 means closed (this is
 *              the angle of the leg with the perpendicular to the lower base)
 * \param rotateAroundX if true the leg rotate around the x axis, otherwise
 *                      around the y axis
 */
module sd_closingMechanism(angle = 90, rotateAroundX) {
	// Checking the angle is valid
	if ((angle < 0) || (angle > 90)) {
		echo("Wrong angle for che closing mechanism");
	} else {
		// Placing the lower base with the lower part on the xy plane
		translate(sd_lowerBaseLowerFacePos + [0, 0, sd_planesThickness / 2]) {
			sd_lowerBase();
		}

		// Placing the lower legs
		for (p = [[-1, -1], [-1, 1], [1, 1], [1, -1]]) {
			translate([p[0] * ((sd_baseWidth - sd_legWidth) / 2 - sd_legsDistanceFromBorderShortSide), p[1] * ((sd_baseDepth - sd_legWidth) / 2 - sd_legsDistanceFromBorderLongSide), -sd_heightFromGround / 2]) {
				sd_lowerLeg();
			}
		}

SCRIVERE CODICE PER ROTAZIONE GAMBE INTORNO A Y (CERCARE DI USARE FUNZIONI PER EVITARE DI DUPLICARE IL CODICE) E POI AGGIUNGERE ALTRI PEZZI SULLA BASE INFERIORE

		// Placing the legs between the lower and upper base and the hinges
		for (p = [[-1, -1], [-1, 1], [1, 1], [1, -1]]) {
			if (rotateAroundX == true) {
				// Placing leg
				translate([p[0] * (sd_baseWidth / 2 - sd_legWidth / 2 - sd_legsDistanceFromBorderShortSide), p[1] * (sd_baseDepth / 2 - sd_legWidth / 2 - sd_legsDistanceFromBorderLongSide) + sd_upperLegsDisplacement[1] / 2, sd_planesThickness + sd_upperLegsDisplacement[2] / 2]) {
					sd_upperLeg(angle, true);
				}
				// Placing the hinge on the lower base
				if (p[1] == -1) {
					translate([p[0] * (sd_baseWidth / 2 - sd_legWidth / 2 - sd_legsDistanceFromBorderShortSide), -(sd_baseDepth / 2 - sd_legsDistanceFromBorderLongSide + sd_hingeThickness), sd_planesThickness + sd_hingeThickness]) {
						sd_upperLegLowerBaseHinge(90 - angle);
					}
					// Placing the hinge on the upper base
					translate([p[0] * (sd_baseWidth / 2 - sd_legWidth / 2 - sd_legsDistanceFromBorderShortSide), -(sd_baseDepth / 2 - sd_legsDistanceFromBorderLongSide -sd_legWidth - sd_hingeThickness) + sd_upperLegsDisplacement[1], sd_planesThickness + sd_upperLegsDisplacement[2] - sd_hingeThickness]) {
						sd_upperLegUpperBaseHinge(90 - angle);
					}
				} else {
					translate([p[0] * (sd_baseWidth / 2 - sd_legWidth / 2 - sd_legsDistanceFromBorderShortSide), sd_baseDepth / 2 - sd_legsDistanceFromBorderLongSide - sd_hingeThickness - sd_legWidth, sd_planesThickness + sd_hingeThickness]) {
						sd_upperLegLowerBaseHinge(90 - angle);
					}
					// Placing the hinge on the upper base
					translate([p[0] * (sd_baseWidth / 2 - sd_legWidth / 2 - sd_legsDistanceFromBorderShortSide), sd_baseDepth / 2 - sd_legsDistanceFromBorderLongSide + sd_hingeThickness + sd_upperLegsDisplacement[1], sd_planesThickness + sd_upperLegsDisplacement[2] - sd_hingeThickness]) {
						sd_upperLegUpperBaseHinge(90 - angle);
					}
				}
			} else {
				translate([p[0] * (sd_baseWidth / 2 - sd_legWidth / 2 - sd_legsDistanceFromBorderShortSide) + sd_upperLegsDisplacement[0] / 2, p[1] * (sd_baseDepth / 2 - sd_legWidth / 2 - sd_legsDistanceFromBorderLongSide), sd_planesThickness + sd_upperLegsDisplacement[2] / 2]) {
					sd_upperLeg(angle, false);
				}
			}
		}

		// Placing the upper base
		translate(sd_upperBaseLowerFacePos + [0, 0, sd_planesThickness / 2]) {
			sd_upperBase();
		}
	}
}

/**
 * \brief The angle of the closing mechanism
 */
sd_closingMechanismAngle = 90 * $t;

/**
 * \brief The position of the lower part of the lower base
 */
sd_lowerBaseLowerFacePos = [0, 0, 0];

/**
 * \brief The position of the lower part of the upper base
 */
sd_upperBaseLowerFacePos = sd_upperBasePositionRotX(sd_closingMechanismAngle, sd_lowerBaseLowerFacePos + [0, 0, sd_planesThickness]);

/**
 * \brief The displacement of the center of upper legs due to the position of
 *        the closing mechanism
 */
sd_upperLegsDisplacement = sd_upperBaseLowerFacePos - (sd_lowerBaseLowerFacePos + [0, 0, sd_planesThickness]);

// Creating the assembly
sd_closingMechanism(sd_closingMechanismAngle, true);
