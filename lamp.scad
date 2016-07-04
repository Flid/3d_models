SIDE = 105.5;

difference(){
    union(){
        import_stl("crinklelamp.STL");

        translate([SIDE/4-3, SIDE/4-3]) cube([SIDE/2+6, SIDE/2+6, 15]);
    }
    translate([SIDE/4, SIDE/4]) cube([SIDE/2, SIDE/2, 50]);
}