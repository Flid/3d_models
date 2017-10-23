CELL_R = 10;
CELLS_COUNT = 9;
HEIGHT = 15;
MAIN_R = 29.5;
TOP_WALL = 1;
BOTTOM_WALL = 5;
BOTTOM_HEIGHT = 5;
FN=60;

$fn=FN;

module base() {
    for(i=[0:CELLS_COUNT-1]) {
        rotate([0, 0, 360/CELLS_COUNT*i])
        translate([MAIN_R, 0, 0])
        difference() {
            cylinder(BOTTOM_HEIGHT, CELL_R+BOTTOM_WALL/2, CELL_R+BOTTOM_WALL/2);
            cylinder(BOTTOM_HEIGHT, CELL_R-BOTTOM_WALL/2, CELL_R-BOTTOM_WALL/2);
        }
        
        rotate([0, 0, 360/CELLS_COUNT*i])
        translate([MAIN_R, 0, 0])
        difference() {
            cylinder(HEIGHT, CELL_R+TOP_WALL/2, CELL_R+TOP_WALL/2);
            cylinder(HEIGHT, CELL_R-TOP_WALL/2, CELL_R-TOP_WALL/2);
        }
    }
}

difference() {
    base();
    cylinder(HEIGHT, MAIN_R, MAIN_R, $fn=FN*2);
}