// A replacement part for Anet Prusa i3 belt holder

POINT_SIZE = 0.88;
HOLE_RADIUS = 1.9;
HEIGHT = 16;

module first() {
    linear_extrude(HEIGHT){   
        difference() {
            square([17, 13.5]);
            translate([3.1, 3.1]) circle(HOLE_RADIUS, $fn=50);
            translate([14.5, 3.1]) circle(HOLE_RADIUS, $fn=50);
            translate([7.5, 3]) square([3.6, 11]);
            translate([6.4, 7.8]) square([5.8, 3.0]);
            translate([0.3+POINT_SIZE, 13.5]) circle(POINT_SIZE, $fn=50);
            translate([0.3*2+POINT_SIZE*3, 13.5]) circle(POINT_SIZE, $fn=50);
            translate([0.3*3+POINT_SIZE*5, 13.5]) circle(POINT_SIZE, $fn=50);
            translate([0.3*4+POINT_SIZE*7, 13.5]) circle(POINT_SIZE, $fn=50);
        }
    }
}

translate([0, 0, HEIGHT]) rotate([180, 0, 0]) {
    
    difference() {
        first();
        translate([3.1, 3.1, -1]) cylinder(5, 3, 3, $fn=50);
        translate([14.5, 3.1, -1]) cylinder(5, 3, 3, $fn=50);
    }
}