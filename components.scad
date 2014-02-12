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
 * Creates an aluminium rod along the given axis. The rod has a cylindrical
 * shape
 * \param length the length of the rod
 * \param radius the radius of the rod
 * \param axis the axis along which the rod is created. This is either "x", "y"
 *             or "z"
 */
module sd_filledAluminiumRod(length, radius, axis = "x")
{
	color(sd_aluminiumColor) {
		if (axis == "x") {
			rotate(a = 90, v = [0, 1, 0]) {
				cylinder(h = length, r = radius, center = true, $fn=20);
			}
		} else if (axis == "y") {
			rotate(a = 90, v = [1, 0, 0]) {
				cylinder(h = length, r = radius, center = true, $fn=20);
			}
		} else if (axis == "z") {
			cylinder(h = length, r = radius, center = true, $fn=20);
		} else {
			echo("Wrong axis specification");
		}
	}
}

/**
 * \brief Creates an aluminium rod
 *
 * Creates an aluminium rod along the given axis. The rod has a cylindrical
 * shape and is empty inside
 * \param length the length of the rod
 * \param radius the external radius of the rod
 * \param thickness the thickness of the material of the rod
 * \param axis the axis along which the rod is created. This is either "x", "y"
 *             or "z"
 */
module sd_emptyAluminiumRod(length, radius, thickness, axis = "x")
{
	color(sd_aluminiumColor) {
		if (axis == "x") {
			rotate(a = 90, v = [0, 1, 0]) {
				difference() {
					cylinder(h = length, r = radius, center = true, $fn=20);
					cylinder(h = length * 2, r = radius - thickness, center = true, $fn=20);
				}
			}
		} else if (axis == "y") {
			rotate(a = 90, v = [1, 0, 0]) {
				difference() {
					cylinder(h = length, r = radius, center = true, $fn=20);
					cylinder(h = length * 2, r = radius - thickness, center = true, $fn=20);
				}
			}
		} else if (axis == "z") {
			difference() {
				cylinder(h = length, r = radius, center = true, $fn=20);
				cylinder(h = length * 2, r = radius - thickness, center = true, $fn=20);
			}
		} else {
			echo("Wrong axis specification");
		}
	}
}

/**
 * \brief Creates a filled aluminium rod with holes along the length
 *
 * This creates an aluminium rod with round holes
 * \param length the length of the rod
 * \param radius the external radius of the rod
 * \param axis the axis along which the rod is created. This is either "x", "y"
 *             or "z"
 * \param holes the list of holes. Each hole is a list of three elements
 *              [r, p, a] where r is the radius of the hole, p is the position
 *              along the rod axis (p = 0 means the center of the rod) and a is
 *              the angle around the rod
 */
module sd_filledAluminiumRodWithHoles(length, radius, axis = "x", holes = [])
{
	difference() {
		sd_filledAluminiumRod(length, radius, axis);
		for (hole = holes) {
			if (axis == "x") {
				rotate(a = hole[2], v = [1, 0, 0]) {
					translate([hole[1], 0, 0]) {
						cylinder(h = radius * 4, r = hole[0], center = true, $fn=20);
					}
				}
			} else if (axis == "y") {
				rotate(a = 90 + hole[2], v = [0, 1, 0]) {
					translate([0, hole[1], 0]) {
						cylinder(h = radius * 4, r = hole[0], center = true, $fn=20);
					}
				}
			} else if (axis == "z") {
				rotate(a = 90, v = [1, 0, 0]) {
					rotate(a = hole[2], v = [0, 1, 0]) {
						translate([0, hole[1], 0]) {
							cylinder(h = radius * 4, r = hole[0], center = true, $fn=20);
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
 * \param radius the radius of the rod
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
module sd_emptyAluminiumRodWithHoles(length, radius, thickness, axis = "x", holes = [])
{
	difference() {
		sd_emptyAluminiumRod(length, radius, thickness, axis);
		for (hole = holes) {
			if (axis == "x") {
				rotate(a = hole[2], v = [1, 0, 0]) {
					translate([hole[1], 0, ((hole[3] == true) ? 0 : radius)]) {
						cylinder(h = ((hole[3] == true) ? radius * 4 : radius * 2), r = hole[0], center = true, $fn=20);
					}
				}
			} else if (axis == "y") {
				rotate(a = 90 + hole[2], v = [0, 1, 0]) {
					translate([0, hole[1], ((hole[3] == true) ? 0 : radius)]) {
						cylinder(h = ((hole[3] == true) ? radius * 4 : radius * 2), r = hole[0], center = true, $fn=20);
					}
				}
			} else if (axis == "z") {
				rotate(a = 90, v = [1, 0, 0]) {
					rotate(a = hole[2], v = [0, 1, 0]) {
						translate([0, hole[1], ((hole[3] == true) ? 0 : radius)]) {
							cylinder(h = ((hole[3] == true) ? radius * 4 : radius * 2), r = hole[0], center = true, $fn=20);
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
 * \param hookLength the length of the bent part of the rod rom the center of
 *                   the bending to the tip
 * \param radius the radius of the aluminium rod
 */
module sd_aluminiumHook(length, hookLength, radius)
{
	union() {
		sd_filledAluminiumRod(length, radius, "x");
		// At the bending we put a quarted of a sphere
		translate([length / 2, 0, 0]) {
			color(sd_aluminiumColor) {
				sphere(r = radius, $fn = 20);
			}
		}
		translate([length / 2, 0, hookLength / 2]) {
			sd_filledAluminiumRod(hookLength, radius, "z");
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
	sd_filledAluminiumRod(100, 5, "z");
}

translate([-100, -100, 0]) {
	sd_emptyAluminiumRod(100, 5, 0.1, "x");
}

translate([-100, 100, 0]) {
	sd_filledAluminiumRodWithHoles(90, 5, "y", [[2, 30, 45]]);
}

translate([0, -100, 0]) {
	sd_emptyAluminiumRodWithHoles(90, 5, 0.1, "z", [[2, 30, 45, false]]);
}

translate([100, -100, 0]) {
	sd_aluminiumAngularSupport(50, 40, 1, 10);
}

translate([100, 100, 0]) {
	sd_aluminiumHook(30, 10, 3);
}
