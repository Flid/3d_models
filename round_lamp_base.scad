FN=100;
RADIUS = 48.8;
LIFT = 1;
COLUMN_WIDTH = 10;
SEGMENTS_COUNT = 6;
LAYER_THICKNESS = 5;
LAYER_COLUMNS_WIDTH = 5;


module base() {
    difference() {
        cylinder(20, RADIUS-LIFT/2, RADIUS-LIFT/2, $fn=FN);
        translate([0, 0, 2])
        cylinder(20, RADIUS-2-LIFT/2, RADIUS-2-LIFT/2, $fn=FN);
    }
    
    cylinder(2, RADIUS-LIFT/2+3, RADIUS-LIFT/2+3, $fn=FN);

}

module segment(height) {
    cylinder(height, COLUMN_WIDTH/2, COLUMN_WIDTH/2, $fn=FN);
}

module layer(radius) {
    linear_extrude(LAYER_THICKNESS)
    for(i=[0:SEGMENTS_COUNT]) {
        rotate([0, 0, i*(360/SEGMENTS_COUNT)])
        translate([0, -LAYER_COLUMNS_WIDTH/2])
        square([radius, LAYER_COLUMNS_WIDTH]);
    };  
} 

ECHO_SIZE = 15.5;
ECHO_DIST = 41.5 - ECHO_SIZE;
BUTTON_SIZE = 6.5;


module top() {
    *cylinder(10, 5, 5);
    difference() {
        union() {
            cylinder(10, RADIUS-LIFT/2+1, RADIUS-LIFT/2+1, $fn=FN);
            cylinder(2, RADIUS-LIFT/2+2, RADIUS-LIFT/2+2, $fn=FN);
            
            
        }
        translate([0, 0, 2])
        cylinder(10, RADIUS-LIFT/2-1, RADIUS-LIFT/2-1, $fn=FN);
        
        translate([-ECHO_DIST/2, 18, -5])
        cylinder(100, ECHO_SIZE/2+LIFT/2, ECHO_SIZE/2+LIFT/2);
        
        translate([ECHO_DIST/2, 18, -5])
        cylinder(100, ECHO_SIZE/2+LIFT/2, ECHO_SIZE/2+LIFT/2);
        
        translate([-ECHO_DIST/2*1.2, -20, -5])
        cylinder(100, BUTTON_SIZE/2+LIFT/2, BUTTON_SIZE/2+LIFT/2);
        
        translate([ECHO_DIST/2*1.2, -20, -5])
        cylinder(100, BUTTON_SIZE/2+LIFT/2, BUTTON_SIZE/2+LIFT/2);
        
        translate([-3.9/2-LIFT/4, -30, -1])
        cube([3.9+LIFT/2, 7.7+LIFT/2, 10]);
        
    }
    
    
}

*base();

segment(24);

layer(15);

!top();

