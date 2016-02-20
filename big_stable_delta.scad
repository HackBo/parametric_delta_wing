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

// Vertical stabilizer area at 3% of wing area (for each stabilizer).
vert_stab_area = wing_area * 0.04;
// Separation of the vertical stabilizers from the evelons and from the middle of the chord.
vert_stab_separation_from_elevon = 40;
vert_stab_separation_from_half_chord = 20;
vert_stab_length = skid_len / 2 - elevon_length * 1.1 - vert_stab_separation_from_elevon - vert_stab_separation_from_half_chord;
// Computed to get the area given by the shape of the vert stab.
vert_stab_height = (8 * vert_stab_area) / (7 * vert_stab_length);

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
//lasercutout(thickness=thickness, points=wing_polygon);

//Skid


/*
                                                                p3______ p4
                                                                /       |
                                                               /        |
                                                              /         |
           _____       _____                                p2          |
   _______|     |_____|     |________________________________|          |______
   \                                                         p1        p5       \
    \                                                                            \p6
     \                                                                           |p7
      \                                                                         /p8
       \_______________________________________________________________________/p9

*/


// Back of the skid.
_skid_hole_start = skid_len / 2 + vert_stab_separation_from_half_chord;
skidb_p1 = [_skid_hole_start, skid_height];
skidb_p2 = [_skid_hole_start, skid_height + thickness + vert_stab_height / 2];
skidb_p3 = [_skid_hole_start + vert_stab_length / 2, skid_height + thickness + vert_stab_height];
skidb_p4 = [_skid_hole_start + vert_stab_length, skid_height + thickness + vert_stab_height];
skidb_p5 = [_skid_hole_start + vert_stab_length, skid_height];
vert_stab_polygon = [skidb_p1, skidb_p2, skidb_p3, skidb_p4, skidb_p5, skidb_p1];
//translate([100,100]) rotate([90,0,0])
lasercutout(thickness=thickness, points=vert_stab_polygon);
