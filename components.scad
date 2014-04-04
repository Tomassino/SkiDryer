/**
 * \file components.scad
 *
 * This file contains all the base components for the SkiDryer project. There
 * are demos at the end, so when including this file use the "use" include
 * statement and not the "include" one. All modules have the main axis along x.
 * All functions and variables of the project have the "sd_" prefix.
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
 * \brief The color used for steel ropes
 */
sd_steelRopeColor = "Red";

/**
 * \brief The color used for brass elements
 */
sd_brassColor = "Yellow";

/**
 * \brief Makes the given axis the main axis of the module
 *
 * This function makes the assumption that the main axis of the module to be
 * rotated is x, so sd_mainAxis("x") does nothing.
 * \param axis the new main axis, either "x", "y" or "z"
 */
module sd_mainAxis(axis)
{
	if (axis == "x") {
		children();
	} else if (axis == "y") {
		rotate(a = 90, v = [0, 0, 1]) {
			children();
		}
	} else if (axis == "z") {
		rotate(a = -90, v = [0, 1, 0]) {
			children();
		}
	} else {
		echo("Wrong axis specification in sd_mainAxis");
	}
}

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
 * and brown-colored. The leg height is along the x axis. A leg can have grooves
 * along the x axis on a side of a given depth and width
 * \param section the length of the side of the square section of the leg
 * \param height the height of the leg
 * \param grooves a list of grooves to make along the leg. Each groove is a list
 *                of four elements [w, d, p, s] where w is the width of the
 *                groove, d is the depth, p is the position of the center of the
 *                groove along the leg height and s is the side on which the
 *                groove is made (can be one of "y", "-y", "z" or "-z")
 */
module sd_woodenLeg(section, height, grooves)
{
	color(sd_woodColor) {
		difference() {
			cube([height, section, section], center = true);
			for (groove = grooves) {
				if (groove[3] == "y") {
					translate([groove[2], section / 2, 0]) {
						cube([groove[0], groove[1] * 2, section * 2], center = true);
					}
				} else if (groove[3] == "-y") {
					translate([groove[2], -section / 2, 0]) {
						cube([groove[0], groove[1] * 2, section * 2], center = true);
					}
				} else if (groove[3] == "z") {
					translate([groove[2], 0, section / 2]) {
						cube([groove[0], section * 2, groove[1] * 2], center = true);
					}
				} else if (groove[3] == "-z") {
					translate([groove[2], 0, -section / 2]) {
						cube([groove[0], section * 2, groove[1] * 2], center = true);
					}
				} else {
					echo("Wrong axis for groove");
				}
			}
		}
	}
}

/**
 * \brief Creates a wooden stick along the x axis
 *
 * Creates a wooden stick along the x axis
 * \param height the height of the stick (along the z axis)
 * \param thickness the thickness of the stick
 * \param length the length of the stick
 */
module sd_woodenStick(height, thickness, length)
{
	color(sd_woodColor) {
		cube([length, thickness, height], center = true);
	}
}

/**
 * \brief Creates an aluminium rod
 *
 * Creates an aluminium rod along the x axis. The rod has a circular or square
 * section
 * \param length the length of the rod
 * \param sectionSize the diameter of the rod (if it is circular) or the length
 *                    of the side (if it is square)
 * \param section either "round" or "square", respectively for a circular or
 *                square section
 */
module sd_filledAluminiumRod(length, sectionSize, section = "round")
{
	color(sd_aluminiumColor) {
		if (section == "round") {
			rotate(a = 90, v = [0, 1, 0]) {
				cylinder(h = length, r = sectionSize / 2, center = true, $fn=20);
			}
		} else if (section == "square") {
			cube([length, sectionSize, sectionSize], center = true);
		} else {
			echo("Wrong section specification in sd_filledAluminiumRod");
		}
	}
}

/**
 * \brief Creates an aluminium rod
 *
 * Creates an aluminium rod along the x axis. The rod has a circular or square
 * section and is empty inside
 * \param length the length of the rod
 * \param sectionSize the diameter of the rod (if it is circular) or the length
 *                    of the side (if it is square)
 * \param thickness the thickness of the material of the rod
 * \param section either "round" or "square", respectively for a circular or
 *                square section
 */
module sd_emptyAluminiumRod(length, sectionSize, thickness, section = "round")
{
	color(sd_aluminiumColor) {
		if (section == "round") {
			rotate(a = 90, v = [0, 1, 0]) {
				difference() {
					cylinder(h = length, r = sectionSize / 2, center = true, $fn=20);
					cylinder(h = length * 2, r = (sectionSize / 2) - thickness, center = true, $fn=20);
				}
			}
		} else if (section == "square") {
			difference() {
				cube([length, sectionSize, sectionSize], center = true);
				cube([length * 2, sectionSize - (thickness * 2), sectionSize - (thickness * 2)], center = true);
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
 * \param holes the list of holes. Each hole is a list of three elements
 *              [r, p, a] where r is the radius of the hole, p is the position
 *              along the rod axis (p = 0 means the center of the rod) and a is
 *              the angle around the rod
 */
module sd_filledAluminiumRodWithHoles(length, sectionSize, section = "round", holes = [])
{
	difference() {
		sd_filledAluminiumRod(length, sectionSize, section);
		for (hole = holes) {
			rotate(a = hole[2], v = [1, 0, 0]) {
				translate([hole[1], 0, 0]) {
					cylinder(h = sectionSize * 2, r = hole[0], center = true, $fn=20);
				}
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
 * \param holes the list of holes. Each hole is a list of four elements
 *              [r, p, a, t] where r is the radius of the hole, p is the
 *              position along the rod axis (p = 0 means the center of the rod),
 *              a is the angle around the rod and t is either true or false: if
 *              true the hole is across the whole rod (i.e. there are two
 *              holes on th eopposite sides of the rod), otherwise only one hole
 *              is done
 */
module sd_emptyAluminiumRodWithHoles(length, sectionSize, thickness, section = "round", holes = [])
{
	difference() {
		sd_emptyAluminiumRod(length, sectionSize, thickness, section);
		for (hole = holes) {
			rotate(a = hole[2], v = [1, 0, 0]) {
				translate([hole[1], 0, ((hole[3] == true) ? 0 : sectionSize / 2)]) {
					cylinder(h = ((hole[3] == true) ? sectionSize * 2 : sectionSize), r = hole[0], center = true, $fn=20);
				}
			}
		}
	}
}

/**
 * \brief Constructs a simple angular support of aluminium
 *
 * The first side is on the xy plane towards the positive y, the other on the
 * xz plane towards the positive z. The origin is in the center of the
 * intersection of the two sides
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
		sd_filledAluminiumRod(length, radius * 2, "round");
		// At the bending we put a quarted of a sphere
		translate([length / 2, 0, 0]) {
			color(sd_aluminiumColor) {
				sphere(r = radius, $fn = 20);
			}
		}
		translate([length / 2, 0, hookLength / 2]) {
			rotate(a = 90, v = [0, 1, 0]) {
				sd_filledAluminiumRod(hookLength, radius * 2, "round");
			}
		}
	}
}

/**
 * \brief Creates an aluminium l beam
 *
 * Creates an aluminium l beam along the x axis. The origin of the frame of
 * reference of the l beam if in the center along the external junction of the
 * two sides. Side1 is on the xz plane and side2 on the xy plane.
 * \param length the length of the l beam
 * \param side1 the external dimension of the first side of the l beam
 * \param side2 the external dimension of the second side of the l beam
 * \param thickness the thickness of the material of the l beam
 */
module sd_aluminiumLBeam(length, side1, side2, thickness)
{
	color(sd_aluminiumColor) {
		union() {
			translate([0, thickness / 2, side1 / 2]) {
				cube([length, thickness, side1], center = true);
			}
			translate([0, side2 / 2, thickness / 2]) {
				cube([length, side2, thickness], center = true);
			}
		}
	}
}

/**
 * \brief Creates an aluminium l beam with holes and cuts
 *
 * Creates an aluminium l beam along the x axis, as the sd_aluminiumLBeam
 * modules. It is also possible to specify the position of round holes and
 * rectangular cuts along one side
 * \param length the length of the l beam
 * \param side1 the external dimension of the first side of the l beam
 * \param side2 the external dimension of the second side of the l beam
 * \param thickness the thickness of the material of the l beam
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
module sd_aluminiumLBeamWithHolesAndCuts(length, side1, side2, thickness, holes = [], cuts = [])
{
	difference() {
		sd_aluminiumLBeam(length, side1, side2, thickness);
		for (hole = holes) {
			if (hole[0] == 1) {
				rotate(a = 90, v = [1, 0, 0]) {
					translate([hole[1], hole[2] + side1 / 2, -thickness / 2]) {
						cylinder(h = thickness * 2, r = hole[3], center = true, $fn=20);
					}
				}
			} else if (hole[0] == 2) {
				translate([hole[1], hole[2] + side2 / 2, thickness / 2]) {
					cylinder(h = thickness * 2, r = hole[3], center = true, $fn=20);
				}
			} else {
				echo("Wrong hole side specification in sd_aluminiumLBeamWithHolesAndCuts");
			}
		}
		for (cut = cuts) {
			if (cut[0] == 1) {
				translate([cut[1], thickness / 2, side1]) {
					cube([cut[3], thickness * 2, cut[2] * 2], center = true);
				}
			} else if (cut[0] == 2) {
				translate([cut[1], side2, thickness / 2]) {
					cube([cut[3], cut[2] * 2, thickness * 2], center = true);
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
 * main axis. The main axis is x, with the head on the negative side
 * \param radius the radius of the bolt
 * \param length the length of the bold excluding the head
 * \param headRadius the radius of the head od the bolt (i.e. the distance from
 *                   the center to a vertex of the hexagon)
 * \param headThickness the thickness of the head of the bolt
 */
module sd_bolt(radius, length, headRadius, headThickness)
{
	color(sd_mountingPartsColor) {
		rotate(a = 90, v = [0, 1, 0]) {
			// First creating the head
			translate([0, 0, -headThickness]) {
				cylinder(h = headThickness, r = headRadius, center = false, $fn = 6);
			}
			// Now creating the remaining part
			cylinder(h = length, r = radius, center = false);
		}
	}
}

/**
 * \brief An hexagonal nut
 *
 * The min axis is the x axis, the origin is on one side of the nut, along the
 * main axis. The nut "grows" from the origin towards the positive x axis
 * \param internalRadius the internal radius of the nut
 * \param externalRadius the external radius of the nut (i.e. the distance from
 *                       the center to a vertex of the hexagon)
 * \param thickness the thickness of the nut
 */
module sd_nut(internalRadius, externalRadius, thickness)
{
	color(sd_mountingPartsColor) {
		rotate(a = 90, v = [0, 1, 0]) {
			difference() {
				cylinder(h = thickness, r = externalRadius, center = false, $fn = 6);
				translate([0, 0, thickness / 2]) {
					cylinder(h = thickness * 2, r = internalRadius, center = true);
				}
			}
		}
	}
}

/**
 * \brief An hinge joint
 *
 * The hinge has two rectangular pieces with a common side and a cylinder with
 * the main axis along that side. The main axis is the x axis, the first
 * rectangle lies on the xy plane, while the position of the second rectangle
 * depends on the angle. Each rectangle has a local frame of reference (used
 * when specifying the hole position) with x being along the main axis (0 is the
 * center, the positive direction is the positive direction of the rotation
 * axis) and y being perpendicular to x on the rectangle face (0 is at the
 * intersection with the local x axis and positive values are towards the
 * rectangle)
 * \param width is the length of the rotation axis
 * \param depth is the depth of the two rectangular pieces
 * \param thickness is the thickness of the two rectangular pieces (this is also
 *                  the radius of the cylinder
 * \param angle the angle of the hinge (0 means closed, i.e. the two rectangular
 *              pieces are one on top of the other). The first rectangle is
 *              always fixed, the second one is moved
 * \holes1 is the list of holes on the first rectangle. It is a list of lists of
 *         three elements [x, y, r] where x and y are the coordinates of the
 *         hole on the first rectangle frame of reference and r is the radius of
 *         the hole
 * \holes2 is the list of holes on the second rectangle. The format is like the
 *         one of holes1 with positions in the frame of reference of the second
 *         rectangle
 */
module sd_aluminiumHinge(width, depth, thickness, angle = 90, holes1 = [], holes2 = [])
{
	color(sd_aluminiumColor) {
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
	}
}

/**
 * \brief A straight steel rope
 *
 * The rope is created along the x axis
 * \param length the length of the rope
 * \param section the diameter of the section of the rope
 */
module sd_straightSteelRope(length, section)
{
	color(sd_steelRopeColor) {
		rotate(a = 90, v = [0, 1, 0]) {
			cylinder(h = length, r = section / 2, center = true, $fn=20);
		}
	}
}

/**
 * \brief A ring made up of steel rope
 *
 * The ring is created in the xy plane
 * \param diameter the internal diameter of the ring
 * \param section the diameter of the section of the rope
 */
module sd_steelRopeRing(diameter, section)
{
	color(sd_steelRopeColor) {
		rotate_extrude($fn = 50) {
			translate([diameter / 2 + section, 0, 0]) {
				circle(d = section);
			}
		}
	}
}

/**
 * \brief A brass foot (without the support)
 *
 * The origin of the foot is in the center of the top of the bolt. The main axis
 * is x, with the foot on the negative side
 * \param radius the radius of the bolt
 * \param length the length of the bold excluding the foot
 * \param footRadius the radius of the foot
 * \param footThickness the thickness of the foot
 */
module sd_foot(radius, length, footRadius, footThickness)
{
	color(sd_brassColor) {
		rotate(a = 90, v = [0, 1, 0]) {
			// First creating the foot
			translate([0, 0, -footThickness - length]) {
				cylinder(h = footThickness, r = footRadius, center = false, $fn = 20);
			}
			// Now creating the remaining part
			translate([0, 0, -length]) {
				cylinder(h = length, r = radius, center = false);
			}
		}
	}
}

/**
 * \brief A brass foot support
 *
 * The origin of the foot support is in the center of the top of the support.
 * The main axis is x, with the piece on the negative side
 * \param innerRadius the inner radius of the "nut"
 * \param thickness the thickness of the "nut"
 * \param length the length of the bold excluding the foot
 * \param supportRadius the radius of the support
 * \param supportThickness the thickness of the support
 */
module sd_footSupport(innerRadius, thickness, length, supportRadius, supportThickness)
{
	// The function to compute the distance from the center of the holes for mounting screws
	function mountingHolesDistanceFromCenter() = innerRadius + thickness + (supportRadius - innerRadius + thickness) / 2;
	// The function to compute the radius of the holes for mounting screws
	function mountingHolesRadius() = (supportRadius - innerRadius - thickness) / 6;

	color(sd_brassColor) {
		rotate(a = 90, v = [0, 1, 0]) {
			// First creating the support
			translate([0, 0, -supportThickness]) {
				difference() {
					cylinder(h = supportThickness, r = supportRadius, center = false, $fn = 20);
					// Making three holes for mounting screws
					translate([mountingHolesDistanceFromCenter(), 0, -supportThickness / 2]) {
						cylinder(h = 2 * supportThickness, r = mountingHolesRadius(), center = false, $fn = 20);
					}
					translate([-mountingHolesDistanceFromCenter() * sin(30), mountingHolesDistanceFromCenter() * cos(30), -supportThickness / 2]) {
						cylinder(h = 2 * supportThickness, r = mountingHolesRadius(), center = false, $fn = 20);
					}
					translate([-mountingHolesDistanceFromCenter() * sin(30), -mountingHolesDistanceFromCenter() * cos(30), -supportThickness / 2]) {
						cylinder(h = 2 * supportThickness, r = mountingHolesRadius(), center = false, $fn = 20);
					}
				}
			}
			// Now creating the remaining part
			translate([0, 0, -supportThickness - length]) {
				difference() {
					cylinder(h = length, r = innerRadius + thickness, center = false);
					translate([0, 0, -length / 2]) {
						cylinder(h = 2 * length, r = innerRadius, center = false);
					}
				}
			}
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
	sd_woodenLeg(20, 100, [[7, 5, 30, "y"], [10, 2, -10, "-z"]]);
}

translate([100, 0, 0]) {
	sd_woodenStick(10, 5, 90, true);
}

translate([-100, 0, 0]) {
	sd_filledAluminiumRod(90, 10, "round");
}

translate([-100, 0, 100]) {
	sd_filledAluminiumRod(90, 10, "square");
}

translate([-100, -100, 0]) {
	sd_emptyAluminiumRod(100, 10, 0.1, "round");
}

translate([-100, -100, 100]) {
	sd_emptyAluminiumRod(100, 10, 0.1, "square");
}


translate([-100, 100, 0]) {
	sd_filledAluminiumRodWithHoles(90, 10, "round", [[2, 30, 45]]);
}

translate([-100, 100, 100]) {
	sd_filledAluminiumRodWithHoles(90, 10, "square", [[2, 30, 45]]);
}

translate([0, -100, 0]) {
	sd_emptyAluminiumRodWithHoles(90, 10, 0.1, "round", [[2, 30, 45, false]]);
}

translate([0, -100, 100]) {
	sd_emptyAluminiumRodWithHoles(90, 10, 0.1, "square", [[2, 30, 45, false]]);
}

translate([100, -100, 0]) {
	sd_aluminiumAngularSupport(50, 40, 1, 10);
}

translate([100, 100, 0]) {
	sd_aluminiumHook(30, 10, 3);
}

translate([0, 100, 100]) {
	sd_aluminiumLBeam(100, 10, 20, 1);
}

translate([100, 0, 100]) {
	sd_aluminiumLBeamWithHolesAndCuts(100, 10, 20, 1, [[1, -40, -2.0, 1.5], [2, 30, -2, 3]], [[1, 30, 2.5, 7.5], [2, -40, 5, 15]]);
}

translate([100, 100, 100]) {
	sd_mainAxis("y") {
		sd_bolt(5, 30, 10, 4);
	}
}

translate([100, -100, 100]) {
	sd_nut(5, 10, 4);
}

translate([0, 0, -100]) {
	sd_aluminiumHinge(50, 25, 0.5, 67, [[-15, 12.5, 5], [15, 12.5, 5]], [[-15, 12.5, 5], [15, 12.5, 5]]);
}

translate([100, 0, -100]) {
	sd_straightSteelRope(80, 2);
}

translate([100, 100, -100]) {
	sd_steelRopeRing(40, 2);
}

translate([-100, 0, -100]) {
	sd_foot(5, 20, 20, 5);
}

translate([-100, 100, -100]) {
	sd_footSupport(5, 1, 20, 20, 5);
}
