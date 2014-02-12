/**
 * \file assembly.scad
 *
 * This file contains the assembled SkiDryer
 */

// Including the pieces. We use include because we need to use also the
// constants defined in the file
include <pieces.scad>;

// Placing the lower base with the lower part on the xy plane
translate([0, 0, sd_planesThickness / 2]) {
	sd_lowerBase();
}

// Now placing the supports for the vertical bars on the lower base
translate([0, 0, sd_planesThickness + sd_verticalBarLowerBaseSupportThickness / 2]) {
	translate([sd_externalVerticalBarPosition, 0, 0]) {
		sd_verticalBarLowerBaseSupport();
	}
	translate([sd_internalVerticalBarPosition, 0, 0]) {
		sd_verticalBarLowerBaseSupport();
	}
}

// Also putting the lower ski support on the lower base
translate([sd_skiHolePos + sd_skiHoleWidth / 2 + sd_lowerSkiSupportSide / 2, 0, sd_planesThickness + sd_lowerSkiSupportSide / 2]) {
	sd_lowerSkiSupport();
}

// Now placing the four legs
for (p = [[-1, -1, 0], [-1, 1, 1], [1, 1, 2], [1, -1, 3]]) {
	translate([p[0] * ((sd_baseWidth - sd_legWidth) / 2), p[1] * ((sd_baseDepth  - sd_legWidth) / 2), (sd_totalLength / 2) - sd_heightFromGround]) {
		rotate(a = 90 * p[2], v = [0, 0, -1]) {
			sd_leg();
		}
	}
}

// The next piece is the upper base
translate([0, 0, sd_basesDistance + sd_planesThickness + (sd_planesThickness / 2)]) {
	sd_upperBase();
}

// Now we can place the the external vertical bar...
translate([sd_externalVerticalBarPosition, 0, (sd_verticalBarLength / 2) + sd_planesThickness]) {
	sd_externalVerticalBar();
}

// ... with hooks...
for (hookPosition = sd_hookPositionsOnExternalVerticalBar) {
	translate([sd_externalVerticalBarPosition, 0, hookPosition[0]]) {
		rotate(a = hookPosition[1], v = [0, 0, 1]) {
			sd_hookOnVerticalBar();
		}
	}
}

// ... and then the internal vertical bar...
translate([sd_internalVerticalBarPosition, 0, (sd_verticalBarLength / 2) + sd_planesThickness]) {
	sd_internalVerticalBar();
}

// ... with upper skis supports
for (upperSkiSupportsPosition = sd_upperSkiSupportsPositions) {
	translate([sd_internalVerticalBarPosition + 2 * sd_aluminiumBarRadius + sd_epsilon, 0, upperSkiSupportsPosition]) {
		sd_upperSkiSupport();
	}
}

// Finally we can place the horizontal bar on top of the two vertical bars
translate([(sd_externalVerticalBarPosition + sd_internalVerticalBarPosition) / 2, 0, sd_verticalBarLength + sd_planesThickness + sd_aluminiumBarRadius]) {
	sd_horizontalBar();
}
