// A nozzle for XVX NANO E-Cigarette. The default metal one is terrible.

LIFT = -0.1;
WALL = 1;
MAIN_D = 7;
INT_D = 5;
$fn=120;

color("red")
difference() {
    cylinder(10, MAIN_D/2-LIFT, MAIN_D/2-LIFT);
    cylinder(10, MAIN_D/2-WALL-LIFT, MAIN_D/2-WALL-LIFT);
}


color("green")
translate([0, 0, 10])
difference() {
    cylinder(5.1, MAIN_D/2-LIFT, INT_D/2-LIFT);
    cylinder(5.1, MAIN_D/2-WALL-LIFT, INT_D/2-WALL-LIFT);
}

color("blue")
translate([0, 0, 15])
difference() {
    cylinder(0.9, INT_D/2-LIFT, INT_D/2-LIFT);
    cylinder(0.9, INT_D/2-WALL-LIFT, INT_D/2-WALL-LIFT);
}


color("red")
translate([0, 0, 15.9])
difference() {
    cylinder(0.2, INT_D/2-LIFT, INT_D/2-0.2-LIFT);
    cylinder(0.2, INT_D/2-WALL-LIFT, INT_D/2-WALL-LIFT);
}

color("green")
translate([0, 0, 16.1])
difference() {
    cylinder(1, INT_D/2-0.2-LIFT, INT_D/2-0.2-LIFT);
    cylinder(1, INT_D/2-WALL-LIFT, INT_D/2-WALL-LIFT);
}

color("blue")
translate([0, 0, 17.1])
difference() {
    cylinder(0.2, INT_D/2-0.2-LIFT, INT_D/2-LIFT);
    cylinder(0.2, INT_D/2-WALL-LIFT, INT_D/2-WALL-LIFT);
}

color("red")
translate([0, 0, 17.3])
difference() {
    cylinder(2.7, INT_D/2-LIFT, INT_D/2-LIFT);
    cylinder(2.7, INT_D/2-WALL-LIFT, INT_D/2-WALL-LIFT);
}

