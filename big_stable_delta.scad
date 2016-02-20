// Press F6 if the rendering looks weird.
// F5 is a preview.
// F6 is a full render.

include <lasercut/lasercut.scad>;

// Wing parameters.

INCHES_TO_MM = 25.4;

thickness = 5;  // Model plane foam.
wingspan = 1020;
length = (83 / 102) * wingspan;

elevon_length = (8 / 83) * length;

slot_start_back = (21 / 83) * length;
prop_dm_inches = 8;
prop_dm_mm = prop_dm_inches * INCHES_TO_MM;

// Distance of the prop tip from the bottom of the delta wing.
prop_raised_above_bottom_mm = 25;
tip_chord_length = length / 5;

// Area in mm^2. Used to compute the size of the vertical stabilizers.
wing_area = wingspan * tip_chord_length + wingspan * (length - tip_chord_length) / 2;

// Compute the skid length.
angle = atan((length - length / 5.0) / (wingspan / 2.0)) ;
angle_rad = angle * (PI / 180);
skid_dist_from_center = prop_dm_mm * 1.25 / 2.0;
skid_len = (wingspan / 2.0 - skid_dist_from_center) * tan(angle) + length / 5.0;
skid_height = prop_dm_mm / 2 + prop_dm_mm * 0.1 - prop_raised_above_bottom_mm;




// Vertical stabilizer area as a percentage of the wing area (for each stabilizer).
vert_stab_area = wing_area * 0.045;
// Separation of the vertical stabilizers from the evelons and from the middle of the chord.
vert_stab_separation_from_elevon = 30;
vert_stab_separation_from_half_chord = 10;
vert_stab_length = skid_len / 2 - elevon_length * 1.1 - vert_stab_separation_from_elevon - vert_stab_separation_from_half_chord;
// Computed to get the area given by the shape of the vert stab.
vert_stab_height = (8 * vert_stab_area) / (7 * vert_stab_length);
//vert_stab_height = vert_stab_area/  (vert_stab_length + vert_stab_length / 8);

// Approximation for noise reduction slot. See: http://www.rcgroups.com/forums/showthread.php?t=1608266

/*
     slot_p4___________slot_p5
           /           \
          /             \
  slot_p3/        slot_p6\______________slot_p7
         |
         |
         |
         |______________________________
      slot_p2                       slot_p1
*/

_prop_slot_height = 0.22 * prop_dm_mm + 0.15 * prop_dm_mm;
_prop_slot_width = prop_dm_mm * 1.1 / 2;
_slot_edge = (wingspan / 2) - _prop_slot_width;

slot_p1 = [wingspan / 2, slot_start_back];
slot_p2 = [_slot_edge, slot_start_back];
slot_p3 = [_slot_edge, slot_start_back + prop_dm_mm * 0.15];
slot_p4 = [_slot_edge + prop_dm_mm * 0.05, slot_start_back + _prop_slot_height];
slot_p5 = [wingspan / 2 - prop_dm_mm * 0.25, slot_start_back + _prop_slot_height];
slot_p6 = [wingspan / 2 - prop_dm_mm * 0.125, slot_start_back + _prop_slot_height - prop_dm_mm * 0.10];
slot_p7 = [wingspan / 2, slot_start_back + _prop_slot_height - prop_dm_mm * 0.10];

slot_polygon = [slot_p1, slot_p2, slot_p3, slot_p4, slot_p5, slot_p6, slot_p7];

wing_p1 = [0, 0];
wing_p2 = [wingspan / 2, 0];
wing_p3 = [wingspan / 2, length];
wing_p4 = [0, tip_chord_length];
wing_p5 = [0, 0];

wing_polygon = concat(concat([wing_p1, wing_p2], slot_polygon), [wing_p3, wing_p4, wing_p5]);
lasercutout(thickness=thickness, points=wing_polygon);
translate([wingspan, 0, +thickness]) rotate([0, 180, 0]) lasercutout(thickness=thickness, points=wing_polygon);


//Skid

/*
                                                                p3______ p4
                                                                /       |
                                                               /        |
                                                              /         |
           _____       _____                                p2          |
   _______|     |_____|     |________________________________|          |______p6
   \                                                         p1        p5       \
    \                                                                            \p7
    \                                                                            |
      \                                                                         /p8, p9
       \_______________________________________________________________________/p10

*/

// front of the skid.

// Tabs.
tab_width = (5 / 83) * skid_len;
skid_tabs = [[tab_width * 0, skid_height + 0 * thickness],  [tab_width * 1, skid_height + 0 * thickness],  [tab_width * 1, skid_height + 1.0 * thickness],  [tab_width * 2, skid_height + 1.0 * thickness],  [tab_width * 2, skid_height + 0 * thickness],  [tab_width * 3, skid_height + 0 * thickness],  [tab_width * 3, skid_height + 1.0 * thickness],  [tab_width * 4, skid_height + 1.0 * thickness],  [tab_width * 4, skid_height + 0 * thickness]];

scale_x = (14 / 61) * skid_len;
scale_y = skid_height;
first_x_below_skid = (30 / 61) * skid_len;
skid_leading_curve = [[1.000 * scale_x + first_x_below_skid, 0.000 * scale_y],[0.933 * scale_x, 0.076 * scale_y],[0.867 * scale_x, 0.105 * scale_y],[0.800 * scale_x, 0.135 * scale_y],[0.733 * scale_x, 0.166 * scale_y],[0.667 * scale_x, 0.199 * scale_y],[0.600 * scale_x, 0.236 * scale_y],[0.533 * scale_x, 0.276 * scale_y],[0.467 * scale_x, 0.320 * scale_y],[0.400 * scale_x, 0.370 * scale_y],[0.333 * scale_x, 0.427 * scale_y],[0.267 * scale_x, 0.490 * scale_y],[0.200 * scale_x, 0.561 * scale_y],[0.133 * scale_x, 0.640 * scale_y],[0.067 * scale_x, 0.729 * scale_y], [0 * scale_x, 0.828 * scale_y],,  [0, skid_height]];

// Back of the skid.
_skid_hole_start = skid_len / 2 + vert_stab_separation_from_half_chord;
skidb_p1 = [_skid_hole_start, skid_height];
skidb_p2 = [_skid_hole_start, skid_height + thickness + vert_stab_height / 2];
skidb_p3 = [_skid_hole_start + vert_stab_length / 2, skid_height + thickness + vert_stab_height];
skidb_p4 = [_skid_hole_start + vert_stab_length, skid_height + thickness + vert_stab_height];
skidb_p5 = [_skid_hole_start + vert_stab_length, skid_height];
skidb_p6 = [skid_len - elevon_length * 1.1, skid_height];
skidb_p7 = [skid_len, skid_height / 2];
skidb_p8 = [skid_len, skid_height / 3];
skidb_p9 = [skid_len - elevon_length /2, skid_height / 10];
skidb_p10 = [skid_len - elevon_length /1.5, skid_height / 20];
skidb_p12 = [skid_len - elevon_length * 1.1, 0];

vert_stab_polygon = concat(skid_leading_curve, concat(skid_tabs, [skidb_p1, skidb_p2, skidb_p3, skidb_p4, skidb_p5, skidb_p6, skidb_p7, skidb_p8, skidb_p9,skidb_p10, skidb_p12]));
translate([(wingspan / 2 - skid_dist_from_center), skid_len, -skid_height]) rotate([90, 0, 0]) rotate([0,270, 0]) lasercutout(thickness=thickness, points=vert_stab_polygon);
translate([(wingspan / 2 + skid_dist_from_center), skid_len, -skid_height]) rotate([90, 0, 0]) rotate([0,270, 0]) lasercutout(thickness=thickness, points=vert_stab_polygon);


