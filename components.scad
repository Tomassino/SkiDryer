/**
 * \file components.scad
 *
 * This file contains all the base components for the SkiDryer project. There
 * are demos at the end, so when including this file use the "use" include
 * statement and not the "include" one. All functions and variables of the
 * project have the "sd_" prefix.
 */

/**
 * \brief The color used for wood elements
 */
sd_woodColor = "SaddleBrown";

/**
 * \brief The color used for aluminium elements
 */
sd_aluminiumColor = "Silver";

/**
 * \brief The color used for mounting parts (bolts, nuts, ...)
 */
sd_mountingPartsColor = "SteelBlue";

/**
 * \brief Constructs a wooden plane
 *
 * This is simply a cube with the given dimensions which is centered and
 * brown-colored. The plane lies in the xy plane
 * \param size the size of the plane (a vector of three elements, width, height,
 *             thickness)
 */
module sd_woodenPlane(size)
{
	color(sd_woodColor) {
		cube(size, center = true);
	}
}

/**
 * \brief Creates a wooden plane with holes
 *
 * Creates a wooden plane with holes. Holes can be square or round. The holes
 * are made along the z axis
 * \param size the size of the plane (a vector of three elements, width, height,
 *             thickness)
 * \param squareHoles the list of square holes. Each element of the list is a
 *                    list of four elements: [x, y, w, h] where x and y are the
 *                    coordinates of the center of the hole in the frame of
 *                    reference of the plane (with [0, 0, 0] being the center of
 *                    the plane) and w and h are the width (along the x axis)
 *                    and height (along the y axis)
 * \param roundHoles the list of round holes. Each element is the list is a list
 *                   of three elements: [x, y, r] where x and y are the
 *                   coordinates of the center of the hole in the frame of
 *                   reference of the plane (with [0, 0, 0] being the center of
 *                   the plane) and r is the radius of the hole
 */
module sd_woodenPlaneWithHoles(size, squareHoles = [], roundHoles = [])
{
	difference() {
		sd_woodenPlane(size);
		for (sqhole = squareHoles) {
			translate([sqhole[0], sqhole[1], 0]) {
				cube([sqhole[2], sqhole[3], size[2] * 2], center = true);
			}
		}
		for (rhole = roundHoles) {
			translate([rhole[0], rhole[1], 0]) {
				cylinder(h = size[2] * 2, r = rhole[2], center = true, $fn=20);
			}
		}
	}
}

/**
 * \brief Creates a wooden leg
 *
 * This is simply a cube with a square base and a given height which is centered
 * and brown-colored. The leg height is along the z axis. A leg can have grooves
 * along the z axis on a side of a given depth and width
 * \param section the length of the side of the square section of the leg
 * \param height the height of the leg
 * \param grooves a list of grooves to make along the leg. Each groove is a list
 *                of four elements [w, d, p, s] where w is the width of the
 *                groove, d is the depth, p is the position of the center of the
 *                groove along the leg height and s is the side on which the
 *                groove is made (can be one of "x", "-x", "y" or "-y")
 */
module sd_woodenLeg(section, height, grooves)
{
	color(sd_woodColor) {
		difference() {
			cube([section, section, height], center = true);
			for (groove = grooves) {
				if (groove[3] == "x") {
					translate([section / 2, 0, groove[2]]) {
						cube([groove[1] * 2, section * 2, groove[0]], center = true);
					}
				} else if (groove[3] == "-x") {
					translate([-section / 2, 0, groove[2]]) {
						cube([groove[1] * 2, section * 2, groove[0]], center = true);
					}
				} else if (groove[3] == "y") {
					translate([0, section / 2, groove[2]]) {
						cube([section * 2, groove[1] * 2, groove[0]], center = true);
					}
				} else if (groove[3] == "-y") {
					translate([0, -section / 2, groove[2]]) {
						cube([section * 2, groove[1] * 2, groove[0]], center = true);
					}
				} else {
					echo("Wrong axis for groove");
				}
			}
		}
	}
}

/**
 * \brief Creates a wooden stick along the x or y axis
 *
 * Creates a wooden stick along the x or y axis
 * \param height the height of the stick (along the z axis)
 * \param thickness the thickness of the stick
 * \param length the length of the stick
 * \param xAxis if true the stick is created along the x axis, if false along
 *              the y axis
 */
module sd_woodenStick(height, thickness, length, xAxis = true)
{
	color(sd_woodColor) {
		if (xAxis == true) {
			cube([length, thickness, height], center = true);
		} else {
			cube([thickness, length, height], center = true);
		}
	}
}

/**
 * \brief Creates an aluminium rod
 *
 * Creates an aluminium rod along the given axis. The rod has a circular or
 * square section
 * \param length the length of the rod
 * \param sectionSize the diameter of the rod (if it is circular) or the length
 *                    of the side (if it is square)
 * \param section either "round" or "square", respectively for a circular or
 *                square section
 * \param axis the axis along which the rod is created. This is either "x", "y"
 *             or "z"
 */
module sd_filledAluminiumRod(length, sectionSize, section = "round", axis = "x")
{
	color(sd_aluminiumColor) {
		if (section == "round") {
			if (axis == "x") {
				rotate(a = 90, v = [0, 1, 0]) {
					cylinder(h = length, r = sectionSize / 2, center = true, $fn=20);
				}
			} else if (axis == "y") {
				rotate(a = 90, v = [1, 0, 0]) {
					cylinder(h = length, r = sectionSize / 2, center = true, $fn=20);
				}
			} else if (axis == "z") {
				cylinder(h = length, r = sectionSize / 2, center = true, $fn=20);
			} else {
				echo("Wrong axis specification in sd_filledAluminiumRod");
			}
		} else if (section == "square") {
			if (axis == "x") {
				cube([length, sectionSize, sectionSize], center = true);
			} else if (axis == "y") {
				cube([sectionSize, length, sectionSize], center = true);
			} else if (axis == "z") {
				cube([sectionSize, sectionSize, length], center = true);
			} else {
				echo("Wrong axis specification in sd_filledAluminiumRod");
			}
		} else {
			echo("Wrong section specification in sd_filledAluminiumRod");
		}
	}
}

/**
 * \brief Creates an aluminium rod
 *
 * Creates an aluminium rod along the given axis. The rod has a circular or
 * square section and is empty inside
 * \param length the length of the rod
 * \param sectionSize the diameter of the rod (if it is circular) or the length
 *                    of the side (if it is square)
 * \param thickness the thickness of the material of the rod
 * \param section either "round" or "square", respectively for a circular or
 *                square section
 * \param axis the axis along which the rod is created. This is either "x", "y"
 *             or "z"
 */
module sd_emptyAluminiumRod(length, sectionSize, thickness, section = "round", axis = "x")
{
	color(sd_aluminiumColor) {
		if (section == "round") {
			if (axis == "x") {
				rotate(a = 90, v = [0, 1, 0]) {
					difference() {
						cylinder(h = length, r = sectionSize / 2, center = true, $fn=20);
						cylinder(h = length * 2, r = (sectionSize / 2) - thickness, center = true, $fn=20);
					}
				}
			} else if (axis == "y") {
				rotate(a = 90, v = [1, 0, 0]) {
					difference() {
						cylinder(h = length, r = sectionSize / 2, center = true, $fn=20);
						cylinder(h = length * 2, r = (sectionSize / 2) - thickness, center = true, $fn=20);
					}
				}
			} else if (axis == "z") {
				difference() {
					cylinder(h = length, r = sectionSize / 2, center = true, $fn=20);
					cylinder(h = length * 2, r = (sectionSize / 2) - thickness, center = true, $fn=20);
				}
			} else {
				echo("Wrong axis specification in sd_emptyAluminiumRod");
			}
		} else if (section == "square") {
			if (axis == "x") {
				difference() {
					cube([length, sectionSize, sectionSize], center = true);
					cube([length * 2, sectionSize - (thickness * 2), sectionSize - (thickness * 2)], center = true);
				}
			} else if (axis == "y") {
				difference() {
					cube([sectionSize, length, sectionSize], center = true);
					cube([sectionSize - (thickness * 2), length * 2, sectionSize - (thickness * 2)], center = true);
				}
			} else if (axis == "z") {
				difference() {
					cube([sectionSize, sectionSize, length], center = true);
					cube([sectionSize - (thickness * 2), sectionSize - (thickness * 2), length * 2], center = true);
				}
			} else {
				echo("Wrong axis specification in sd_emptyAluminiumRod");
			}
		} else {
			echo("Wrong section specification in sd_emptyAluminiumRod");
		}
	}
}

/**
 * \brief Creates a filled aluminium rod with holes along the length
 *
 * This creates an aluminium rod with round holes
 * \param length the length of the rod
 * \param sectionSize the diameter of the rod (if it is circular) or the length
 *                    of the side (if it is square)
 * \param section either "round" or "square", respectively for a circular or
 *                square section
 * \param axis the axis along which the rod is created. This is either "x", "y"
 *             or "z"
 * \param holes the list of holes. Each hole is a list of three elements
 *              [r, p, a] where r is the radius of the hole, p is the position
 *              along the rod axis (p = 0 means the center of the rod) and a is
 *              the angle around the rod
 */
module sd_filledAluminiumRodWithHoles(length, sectionSize, section = "round", axis = "x", holes = [])
{
	difference() {
		sd_filledAluminiumRod(length, sectionSize, section, axis);
		for (hole = holes) {
			if (axis == "x") {
				rotate(a = hole[2], v = [1, 0, 0]) {
					translate([hole[1], 0, 0]) {
						cylinder(h = sectionSize * 2, r = hole[0], center = true, $fn=20);
					}
				}
			} else if (axis == "y") {
				rotate(a = 90 + hole[2], v = [0, 1, 0]) {
					translate([0, hole[1], 0]) {
						cylinder(h = sectionSize * 2, r = hole[0], center = true, $fn=20);
					}
				}
			} else if (axis == "z") {
				rotate(a = 90, v = [1, 0, 0]) {
					rotate(a = hole[2], v = [0, 1, 0]) {
						translate([0, hole[1], 0]) {
							cylinder(h = sectionSize * 2, r = hole[0], center = true, $fn=20);
						}
					}
				}
			} else {
				echo("Wrong axis specification");
			}
		}
	}
}

/**
 * \brief Creates an empty aluminium rod with holes along the length
 *
 * This creates an empty aluminium rod with round holes
 * \param length the length of the rod
 * \param sectionSize the diameter of the rod (if it is circular) or the length
 *                    of the side (if it is square)
 * \param thickness the thickness of the material of the rod
 * \param section either "round" or "square", respectively for a circular or
 *                square section
 * \param thickness the thickness of the material of the rod
 * \param axis the axis along which the rod is created. This is either "x", "y"
 *             or "z"
 * \param holes the list of holes. Each hole is a list of four elements
 *              [r, p, a, t] where r is the radius of the hole, p is the
 *              position along the rod axis (p = 0 means the center of the rod),
 *              a is the angle around the rod and t is either true or false: if
 *              true the hole is across the whole rod (i.e. there are two
 *              holes on th eopposite sides of the rod), otherwise only one hole
 *              is done
 */
module sd_emptyAluminiumRodWithHoles(length, sectionSize, thickness, section = "round", axis = "x", holes = [])
{
	difference() {
		sd_emptyAluminiumRod(length, sectionSize, thickness, section, axis);
		for (hole = holes) {
			if (axis == "x") {
				rotate(a = hole[2], v = [1, 0, 0]) {
					translate([hole[1], 0, ((hole[3] == true) ? 0 : sectionSize / 2)]) {
						cylinder(h = ((hole[3] == true) ? sectionSize * 2 : sectionSize), r = hole[0], center = true, $fn=20);
					}
				}
			} else if (axis == "y") {
				rotate(a = 90 + hole[2], v = [0, 1, 0]) {
					translate([0, hole[1], ((hole[3] == true) ? 0 : sectionSize / 2)]) {
						cylinder(h = ((hole[3] == true) ? sectionSize * 2 : sectionSize), r = hole[0], center = true, $fn=20);
					}
				}
			} else if (axis == "z") {
				rotate(a = 90, v = [1, 0, 0]) {
					rotate(a = hole[2], v = [0, 1, 0]) {
						translate([0, hole[1], ((hole[3] == true) ? 0 : sectionSize / 2)]) {
							cylinder(h = ((hole[3] == true) ? sectionSize * 2 : sectionSize), r = hole[0], center = true, $fn=20);
						}
					}
				}
			} else {
				echo("Wrong axis specification");
			}
		}
	}
}

/**
 * \brief Constructs a simple angular support of aluminium
 *
 * The first side is on the xy plane towards the positive y, the other on the
 * xz plane towards the positive z. The origin is
 * in the center of the intersection of the two sides
 * \param l1 the length of the first side of the support
 * \param l2 the length of the second side of the support
 * \param thickness the thickness of the support
 * \param depth the depth of the support
 */
module sd_aluminiumAngularSupport(l1, l2, thickness, depth)
{
	color(sd_aluminiumColor) {
		union() {
			translate([0, (l1 - thickness) / 2, 0]) {
				cube([depth, l1, thickness], center = true);
			}
			translate([0, 0, (l2 - thickness) / 2]) {
				cube([depth, thickness, l2], center = true);
			}
		}
	}
}

/**
 * \brief Constructs an aluminium hook
 *
 * The hook can be though of as a small aluminium rod bent at 90° angle on one
 * side
 * \param length the length of the rod from the non-bent tip to the center of
 *               the bending
 * \param hookLength the length of the bent part of the rod from the center of
 *                   the bending to the tip
 * \param radius the radius of the aluminium rod
 */
module sd_aluminiumHook(length, hookLength, radius)
{
	union() {
		sd_filledAluminiumRod(length, radius * 2, "round", "x");
		// At the bending we put a quarted of a sphere
		translate([length / 2, 0, 0]) {
			color(sd_aluminiumColor) {
				sphere(r = radius, $fn = 20);
			}
		}
		translate([length / 2, 0, hookLength / 2]) {
			sd_filledAluminiumRod(hookLength, radius * 2, "round", "z");
		}
	}
}

/**
 * \brief Creates an aluminium l beam
 *
 * Creates an aluminium l beam along the given axis. The origin of the frame of
 * reference of the l bema if in the center along the external junction of the
 * two sides. Which is side1 and side2 depends on the axis:
 * 	- if axis is "x", side1 is on the xz plane and side2 on the xy plane;
 * 	- if axis is "y", side1 is on the yz plane and side2 on the xy plane;
 * 	- if axis is "z", side1 is on the xz plane and side2 on the yz plane.
 * \param length the length of the l beam
 * \param side1 the external dimension of the first side of the l beam
 * \param side2 the external dimension of the second side of the l beam
 * \param thickness the thickness of the material of the l beam
 * \param axis the axis along which the l beam is created. This is either "x",
 *             "y" or "z"
 */
module sd_aluminiumLBeam(length, side1, side2, thickness, axis = "x")
{
	color(sd_aluminiumColor) {
		if (axis == "x") {
			union() {
				translate([0, thickness / 2, side1 / 2]) {
					cube([length, thickness, side1], center = true);
				}
				translate([0, side2 / 2, thickness / 2]) {
					cube([length, side2, thickness], center = true);
				}
			}
		} else if (axis == "y") {
			union() {
				translate([thickness / 2, 0, side1 / 2]) {
					cube([thickness, length, side1], center = true);
				}
				translate([side2 / 2, 0, thickness / 2]) {
					cube([side2, length, thickness], center = true);
				}
			}
		} else if (axis == "z") {
			union() {
				translate([side1 / 2, thickness / 2, 0]) {
					cube([side1, thickness, length], center = true);
				}
				translate([thickness / 2, side2 / 2, 0]) {
					cube([thickness, side2, length], center = true);
				}
			}
		} else {
			echo("Wrong axis specification in sd_aluminiumLBeam");
		}
	}
}

/**
 * \brief Creates an aluminium l beam with holes and cuts
 *
 * Creates an aluminium l beam along the given axis, as the sd_aluminiumLBeam
 * modules. It is also possible to specify the position of round holes and
 * rectangular cuts along one side
 * \param length the length of the l beam
 * \param side1 the external dimension of the first side of the l beam
 * \param side2 the external dimension of the second side of the l beam
 * \param thickness the thickness of the material of the l beam
 * \param axis the axis along which the l beam is created. This is either "x",
 *             "y" or "z"
 * \param holes the list of holes. Each element in the list is a list of four
 *              elements: [s, x, y, r] where s is either 1 or 2 to indicate that
 *              the hole is on the first or second side, respectively, x and y
 *              are the coordinates of the center of the hole in the frame of
 *              reference of the given side (the x axis is parallel to the l
 *              beam main axis, y is perpendicular to x and lies on the side
 *              external face and the origin is in the center of the side
 *              external face) and r is the radius of the hole
 * \param cuts the list of cuts. Each element in the list is a list of four
 *             elements: [s, p, d, w] where s is either 1 or 2 to indicate that
 *             the cut is on the first or second side, respectively, p is the
 *             position of the center of the cut along the main axis, d is the
 *             depth of the cut and w is the width of the cut
 */
module sd_aluminiumLBeamWithHolesAndCuts(length, side1, side2, thickness, axis = "x", holes = [], cuts = [])
{
	difference() {
		sd_aluminiumLBeam(length, side1, side2, thickness, axis);
		for (hole = holes) {
			if (hole[0] == 1) {
				if (axis == "x") {
					rotate(a = 90, v = [1, 0, 0]) {
						translate([hole[1], hole[2] + side1 / 2, -thickness / 2]) {
							cylinder(h = thickness * 2, r = hole[3], center = true, $fn=20);
						}
					}
				} else if (axis == "y") {
					rotate(a = 90, v = [0, 1, 0]) {
						translate([-hole[2] - side1 / 2, hole[1], thickness / 2]) {
							cylinder(h = thickness * 2, r = hole[3], center = true, $fn=20);
						}
					}
				} else if (axis == "z") {
					rotate(a = 90, v = [1, 0, 0]) {
						translate([hole[2] + side1 / 2, hole[1], -thickness / 2]) {
							cylinder(h = thickness * 2, r = hole[3], center = true, $fn=20);
						}
					}
				} else {
					echo("Wrong axis specification in sd_aluminiumLBeamWithHolesAndCuts");
				}
			} else if (hole[0] == 2) {
				if (axis == "x") {
					translate([hole[1], hole[2] + side2 / 2, thickness / 2]) {
						cylinder(h = thickness * 2, r = hole[3], center = true, $fn=20);
					}
				} else if (axis == "y") {
					translate([hole[2] + side2 / 2, hole[1], thickness / 2]) {
						cylinder(h = thickness * 2, r = hole[3], center = true, $fn=20);
					}
				} else if (axis == "z") {
					rotate(a = 90, v = [0, 1, 0]) {
						translate([-hole[1], hole[2] + side2 / 2, thickness / 2]) {
							cylinder(h = thickness * 2, r = hole[3], center = true, $fn=20);
						}
					}
				} else {
					echo("Wrong axis specification in sd_aluminiumLBeamWithHolesAndCuts");
				}
			} else {
				echo("Wrong hole side specification in sd_aluminiumLBeamWithHolesAndCuts");
			}
		}
		for (cut = cuts) {
			if (cut[0] == 1) {
				if (axis == "x") {
					translate([cut[1], thickness / 2, side1]) {
						cube([cut[3], thickness * 2, cut[2] * 2], center = true);
					}
				} else if (axis == "y") {
					translate([thickness / 2, cut[1], side1]) {
						cube([thickness * 2, cut[3], cut[2] * 2], center = true);
					}
				} else if (axis == "z") {
					translate([side1, thickness / 2, cut[1]]) {
						cube([cut[2] * 2, thickness * 2, cut[3]], center = true);
					}
				} else {
					echo("Wrong axis specification in sd_aluminiumLBeamWithHolesAndCuts");
				}
			} else if (cut[0] == 2) {
				if (axis == "x") {
					translate([cut[1], side2, thickness / 2]) {
						cube([cut[3], cut[2] * 2, thickness * 2], center = true);
					}
				} else if (axis == "y") {
					translate([side2, cut[1], thickness / 2]) {
						cube([cut[2] * 2, cut[3], thickness * 2], center = true);
					}
				} else if (axis == "z") {
					translate([thickness / 2, side2, cut[1]]) {
						cube([thickness * 2, cut[2] * 2, cut[3]], center = true);
					}
				} else {
					echo("Wrong axis specification in sd_aluminiumLBeamWithHolesAndCuts");
				}
			} else {
				echo("Wrong cut side specification in sd_aluminiumLBeamWithHolesAndCuts");
			}
		}
	}
}

/**
 * \brief A bolt with hexagonal head
 *
 * The origin of the bolt is between the head and the remaining part, on the
 * main axis. The main axis is z, with the head on the negative side
 * \param radius the radius of the bolt
 * \param length the length of the bold excluding the head
 * \param headRadius the radius of the head od the bolt (i.e. the distance from
 *                   the center to a vertex of the hexagon)
 * \param headThickness the thickness of the head of the bolt
 */
module sd_bolt(radius, length, headRadius, headThickness)
{
	color(sd_mountingPartsColor) {
		// First creating the head
		translate([0, 0, -headThickness]) {
			cylinder(h = headThickness, r = headRadius, center = false, $fn = 6);
		}
		// Now creating the remaining part
		cylinder(h = length, r = radius, center = false);
	}
}

/**
 * \brief An hexagonal nut
 *
 * The min axis is the z axis, the origin is on one side of the nut, along the
 * main axis. The nut "grows" from the origin towards the positive z axis
 * \param internalRadius the internal radius of the nut
 * \param externalRadius the external radius of the nut (i.e. the distance from
 *                       the center to a vertex of the hexagon)
 * \param thickness the thickness of the nut
 */
module sd_nut(internalRadius, externalRadius, thickness)
{
	color(sd_mountingPartsColor) {
		difference() {
			cylinder(h = thickness, r = externalRadius, center = false, $fn = 6);
			translate([0, 0, thickness / 2]) {
				cylinder(h = thickness * 2, r = internalRadius, center = true);
			}
		}
	}
}

/**
 * \brief An hinge joint
 *
 * The hinge has two rectangular pieces with a common side and a cylinder with
 * the main axis along that side. Where the first rectangle lies depends on the
 * value of the axis parameter (the second rectangle position depends on the
 * angle):
 * 	- if axis is "x", the first rectangle lies on the xy;
 * 	- if axis is "y", the first rectangle lies on the xy;
 * 	- if axis is "z", the first rectangle lies on the xz.
 * Each rectangle has a local frame of reference (used when specifying the hole
 * position) with x being along the main axis (0 is the center, the positive
 * direction is the positive direction of the rotation axis) and y being
 * perpendicular to x on the rectangle face (0 is at the intersection with the
 * local x axis and positive values are towards the rectangle)
 * \param width is the length of the rotation axis
 * \param depth is the depth of the two rectangular pieces
 * \param thickness is the thickness of the two rectangular pieces (this is also
 *                  the radius of the cylinder
 * \param angle the angle of the hinge (0 means closed, i.e. the two rectangular
 *              pieces are one on top of the other). The first rectangle is
 *              always fixed, the second one is moved
 * \param axis is the axis to which the rotation axis of the hinge is parallel
 * \holes1 is the list of holes on the first rectangle. It is a list of lists of
 *         three elements [x, y, r] where x and y are the coordinates of the
 *         hole on the first rectangle frame of reference and r is the radius of
 *         the hole
 * \holes2 is the list of holes on the second rectangle. The format is like the
 *         one of holes1 with positions in the frame of reference of the second
 *         rectangle
 */
module sd_aluminiumHinge(width, depth, thickness, angle = 90, axis = "x", holes1 = [], holes2 = [])
{
	color(sd_aluminiumColor) {
		if (axis == "x") {
			union() {
				difference() {
					translate([0, depth / 2, -thickness/ 2]) {
						cube([width, depth, thickness], center = true);
					}
					for (h = holes1) {
						translate([h[0], h[1], -thickness/ 2]) {
							cylinder(h = thickness * 2, r = h[2], center = true, $fn = 20);
						}
					}
				}
				rotate(a = 90, v = [0, 1, 0]) {
						cylinder(h = width, r = thickness, center = true, $fn = 20);
				}
				rotate(a = angle, v = [1, 0, 0]) {
					difference() {
						translate([0, depth / 2, thickness / 2]) {
							cube([width, depth, thickness], center = true);
						}
						for (h = holes2) {
							translate([h[0], h[1], thickness/ 2]) {
								cylinder(h = thickness * 2, r = h[2], center = true, $fn = 20);
							}
						}
					}
				}
			}
		} else if (axis == "y") {
			union() {
				difference() {
					translate([depth / 2, 0, -thickness/ 2]) {
						cube([depth, width, thickness], center = true);
					}
					for (h = holes1) {
						translate([h[1], h[0], -thickness/ 2]) {
							cylinder(h = thickness * 2, r = h[2], center = true, $fn = 20);
						}
					}
				}
				rotate(a = 90, v = [1, 0, 0]) {
						cylinder(h = width, r = thickness, center = true, $fn = 20);
				}
				rotate(a = angle, v = [0, 1, 0]) {
					difference() {
						translate([depth / 2, 0, thickness / 2]) {
							cube([depth, width, thickness], center = true);
						}
						for (h = holes2) {
							translate([h[1], h[0], thickness/ 2]) {
								cylinder(h = thickness * 2, r = h[2], center = true, $fn = 20);
							}
						}
					}
				}
			}
		} else if (axis == "z") {
			cube([side1, thickness, length], center = true);
		} else {
			echo("Wrong axis specification in sd_aluminiumHinge");
		}
	}
}

// The following lines are left here as an example

translate([0, 0, 0]) {
	sd_woodenPlane([100, 100, 10]);
}

translate([0, 0, 100]) {
	sd_woodenPlaneWithHoles([100, 100, 10], [[25, 25, 30, 30]], [[-20, -20, 10], [20, -20, 20]]);
}

translate([0, 100, 0]) {
	sd_woodenLeg(20, 100, [[7, 5, 30, "y"], [10, 2, -10, "-x"]]);
}

translate([100, 0, 0]) {
	sd_woodenStick(10, 5, 90, true);
}

translate([-100, 0, 0]) {
	sd_filledAluminiumRod(90, 10, "round", "z");
}

translate([-100, 0, 100]) {
	sd_filledAluminiumRod(90, 10, "square", "z");
}

translate([-100, -100, 0]) {
	sd_emptyAluminiumRod(100, 10, 0.1, "round", "x");
}

translate([-100, -100, 100]) {
	sd_emptyAluminiumRod(100, 10, 0.1, "square", "x");
}

translate([-100, 100, 0]) {
	sd_filledAluminiumRodWithHoles(90, 10, "round", "y", [[2, 30, 45]]);
}

translate([-100, 100, 100]) {
	sd_filledAluminiumRodWithHoles(90, 10, "square", "y", [[2, 30, 45]]);
}

translate([0, -100, 0]) {
	sd_emptyAluminiumRodWithHoles(90, 10, 0.1, "round", "z", [[2, 30, 45, false]]);
}

translate([0, -100, 100]) {
	sd_emptyAluminiumRodWithHoles(90, 10, 0.1, "square", "z", [[2, 30, 45, false]]);
}

translate([100, -100, 0]) {
	sd_aluminiumAngularSupport(50, 40, 1, 10);
}

translate([100, 100, 0]) {
	sd_aluminiumHook(30, 10, 3);
}

translate([0, 100, 100]) {
	sd_aluminiumLBeam(100, 10, 20, 1, "x");
}

translate([100, 0, 100]) {
	sd_aluminiumLBeamWithHolesAndCuts(100, 10, 20, 1, "y", [[1, -40, -2.0, 1.5], [2, 30, -2, 3]], [[1, 30, 2.5, 7.5], [2, -40, 5, 15]]);
}

translate([100, 100, 100]) {
	sd_bolt(5, 30, 10, 4);
}

translate([100, -100, 100]) {
	sd_nut(5, 10, 4);
}

translate([0, 0, -100]) {
	!sd_aluminiumHinge(10, 5, 0.1, 67, "y", [[-3, 2.5, 1], [3, 2.5, 1]], [[-3, 2.5, 1], [3, 2.5, 1]]);
}
