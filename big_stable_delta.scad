// Press F6 if the rendering looks weird.
// F5 is a preview.
// F6 is a full render.

include <lasercut/lasercut.scad>;

INCHES_TO_MM = 25.4;

thickness = 5;  // Model plane foam.
wingspan = 1020;
length = (83 / 102) * wingspan;

slot_start_back = (21 / 83) * length;
prop_dm_inches = 8;
prop_dm_mm = prop_dm_inches * INCHES_TO_MM;

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
wing_p4 = [0, length / 5];
wing_p5 = [0, 0];

wing_polygon = [wing_p1, wing_p2, wing_p3, wing_p4, wing_p5];

difference() {
  lasercutout(thickness=thickness, points=wing_polygon);
  lasercutout(thickness=thickness, points=slot_polygon);
}
