BASE_DIAM = 200;
BASE_HEIGHT = 300;
BOTTOM_HEIGHT = 20;
BOTTOM_WALL = 5;
WALL = 2;
FN=50;
LIFT = 1;

PLATE_HEIGHT = 15;

CASE_SHIFT = 0;
CASE_DEPTH = 20;
CASE_WIDTH = 25;
CASE_HEIGHT = 100;
CASE_OVERLAP = 10;
BASE_WINDOW_HEIGHT = 55;

LED_CUT_HEIGHT = 35;
LED_CUT_BORDER_HEIGHT = 14;
LED_CUT_DEPTH = 10;
LED_CUT_Z_POS = CASE_HEIGHT + CASE_WIDTH/sqrt(2) - LED_CUT_DEPTH * sqrt(2);


BASE_HOLES_COUNT = 10;
BASE_HOLE_DIAM = 5;
BASE_HOLE_CIRCLE_DIAM = 80;


module base_external() {
    side = LED_CUT_DEPTH * sqrt(2);
    
    // Upper solid
    translate([0, 0, LED_CUT_Z_POS+LED_CUT_HEIGHT])
    cylinder(BASE_HEIGHT-LED_CUT_Z_POS, BASE_DIAM/2, BASE_DIAM/2, $fn=FN);
    
    // upper cut 45 deg ring
    translate([0, 0, LED_CUT_Z_POS + LED_CUT_HEIGHT - LED_CUT_DEPTH])
    cylinder(LED_CUT_DEPTH, BASE_DIAM/2-side, BASE_DIAM/2, $fn=FN);
    
    // middle cut ring
    translate([0, 0, LED_CUT_Z_POS + LED_CUT_DEPTH])
    cylinder(LED_CUT_HEIGHT-LED_CUT_DEPTH*2, BASE_DIAM/2-side, BASE_DIAM/2-side, $fn=FN);
    
    // bottom cut 45 deg ring
    translate([0, 0, LED_CUT_Z_POS])
    cylinder(LED_CUT_DEPTH, BASE_DIAM/2, BASE_DIAM/2-side, $fn=FN);
    
    // Bottom solid
    translate([0, 0, BOTTOM_HEIGHT])
    cylinder(LED_CUT_Z_POS-BOTTOM_HEIGHT, BASE_DIAM/2, BASE_DIAM/2, $fn=FN);
    
    
    // upper base 45 deg ring
    translate([0, 0, BOTTOM_HEIGHT-BOTTOM_WALL])
    cylinder(BOTTOM_WALL, BASE_DIAM/2-BOTTOM_WALL, BASE_DIAM/2, $fn=FN);

    // middle base ring
    cylinder(BOTTOM_HEIGHT-BOTTOM_WALL, BASE_DIAM/2-BOTTOM_WALL, BASE_DIAM/2-BOTTOM_WALL, $fn=FN);
}


module base_internal() {
    side = LED_CUT_DEPTH * sqrt(2);
    w = WALL * sqrt(2);
    
    // Upper solid
    translate([0, 0, LED_CUT_Z_POS+LED_CUT_HEIGHT])
    cylinder(BASE_HEIGHT-LED_CUT_Z_POS, BASE_DIAM/2-WALL, BASE_DIAM/2-WALL, $fn=FN);
    
    // upper cut 45 deg ring
    translate([0, 0, LED_CUT_Z_POS + LED_CUT_HEIGHT - LED_CUT_DEPTH])
    cylinder(LED_CUT_DEPTH, BASE_DIAM/2-side-w, BASE_DIAM/2-w, $fn=FN);
    
    // middle cut ring
    translate([0, 0, LED_CUT_Z_POS + LED_CUT_DEPTH])
    cylinder(LED_CUT_HEIGHT-LED_CUT_DEPTH*2, BASE_DIAM/2-side-WALL, BASE_DIAM/2-side-WALL, $fn=FN);
    
    // bottom cut 45 deg ring
    translate([0, 0, LED_CUT_Z_POS])
    cylinder(LED_CUT_DEPTH, BASE_DIAM/2-w, BASE_DIAM/2-side-w, $fn=FN);
    
    // Bottom solid
    translate([0, 0, BOTTOM_HEIGHT])
    cylinder(LED_CUT_Z_POS-BOTTOM_HEIGHT, BASE_DIAM/2-WALL, BASE_DIAM/2-WALL, $fn=FN);
    
    
    // upper base 45 deg ring
    translate([0, 0, BOTTOM_HEIGHT-BOTTOM_WALL])
    cylinder(BOTTOM_WALL, BASE_DIAM/2-BOTTOM_WALL-w, BASE_DIAM/2-w, $fn=FN);

    // middle base ring
    translate([0, 0, WALL])
    cylinder(BOTTOM_HEIGHT-BOTTOM_WALL-WALL, BASE_DIAM/2-BOTTOM_WALL-WALL, BASE_DIAM/2-BOTTOM_WALL-WALL, $fn=FN);
    
    for (i=[0:BASE_HOLES_COUNT-1]) {
        rotate([0, 0, (360/BASE_HOLES_COUNT) * i])
        translate([BASE_HOLE_CIRCLE_DIAM/2, 0, 0])
        cylinder(WALL, BASE_HOLE_DIAM/2, BASE_HOLE_DIAM/2, $fn=FN/2);
    }
    
    // case window
    color("red")
    translate([-BASE_DIAM/2, -CASE_WIDTH/2+WALL, BOTTOM_HEIGHT])
    cube([CASE_DEPTH-WALL, CASE_WIDTH-WALL*2, BASE_WINDOW_HEIGHT]);
}


*base_internal();


module base() {
    difference() {
        base_external();
        base_internal();
    }
}


module case_base() {
    difference() {
        cube([CASE_DEPTH+CASE_OVERLAP, CASE_WIDTH, CASE_HEIGHT]);
        
        translate([0, WALL, 0])
        cube([CASE_DEPTH-WALL+CASE_OVERLAP, CASE_WIDTH-WALL*2, CASE_HEIGHT]);
        
        translate([CASE_DEPTH-WALL+CASE_OVERLAP, CASE_WIDTH/2, BOTTOM_HEIGHT])
        rotate([45, 0, 0])
        cube([WALL*2, WALL*2, WALL*2], center=true);
    }
    
    // head
    translate([(CASE_DEPTH+CASE_OVERLAP)/2, CASE_WIDTH/2, CASE_HEIGHT])
    difference() {
        rotate([45, 0, 0])
        cube([CASE_DEPTH+CASE_OVERLAP, CASE_WIDTH / sqrt(2), CASE_WIDTH / sqrt(2)], center=true);
        
        translate([-WALL, 0, -WALL * sqrt(2)])
        rotate([45, 0, 0])
        cube([CASE_DEPTH+CASE_OVERLAP, CASE_WIDTH / sqrt(2), CASE_WIDTH / sqrt(2)], center=true);
    }
}


module case() {
    intersection() {
        base_external();
        
        translate([-BASE_DIAM/2-CASE_SHIFT-CASE_OVERLAP, -CASE_WIDTH/2, 0])
        case_base();
    }
}

module plate() {
    difference() {
        // base
        cylinder(BOTTOM_HEIGHT+PLATE_HEIGHT+WALL, BASE_DIAM/2, BASE_DIAM/2, $fn=FN);
        
        // 45 deg cut
        translate([0, 0, BOTTOM_HEIGHT+PLATE_HEIGHT+WALL-BOTTOM_WALL])
        cylinder(BOTTOM_WALL, BASE_DIAM/2-BOTTOM_WALL, BASE_DIAM/2, $fn=FN);
        
        // internal cut
        translate([0, 0, WALL])
        cylinder(BOTTOM_HEIGHT+PLATE_HEIGHT, BASE_DIAM/2-BOTTOM_WALL+LIFT/2, BASE_DIAM/2-BOTTOM_WALL+LIFT/2, $fn=FN);
    }
}




base();
// LED border
translate([0, 0, LED_CUT_Z_POS])
difference() {
    cylinder(LED_CUT_BORDER_HEIGHT, BASE_DIAM/2, BASE_DIAM/2, $fn=FN);
    cylinder(LED_CUT_BORDER_HEIGHT, BASE_DIAM/2-WALL*sqrt(2), BASE_DIAM/2-WALL*sqrt(2), $fn=FN);
}
case();



*translate([0, 0, -80])
plate();