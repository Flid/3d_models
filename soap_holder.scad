BASE_HEIGHT = 20; // mm
BASE_LENGTH = 100;
BASE_WIDTH = 60;
BASE_WALL = 5;
BASE_CUT_RATIO = 0.7;
BASE_ROUNDING = 5;
HOLE_NUM_LENGTH = 5;
HOLE_NUM_WIDTH = 4;
HOLE_ROUNDING = 3;
WALL = 2;
FN = 30;

$fn = FN;


W = BASE_WIDTH + BASE_WALL*2;
L = BASE_LENGTH + BASE_WALL*2;
    
module hole_cut_2d() {    
    minkowski() {
        width = BASE_WIDTH / HOLE_NUM_WIDTH;
        length = BASE_LENGTH / HOLE_NUM_LENGTH;
        
        circle(HOLE_ROUNDING);
        
        translate([HOLE_ROUNDING+WALL/2, HOLE_ROUNDING+WALL/2])
        square([width-HOLE_ROUNDING*2-WALL, length-HOLE_ROUNDING*2-WALL]);
        
    }
}

module center() {
    linear_extrude(BASE_HEIGHT)
    difference() {
        square([BASE_WIDTH, BASE_LENGTH]);
        
        for(x=[0:HOLE_NUM_WIDTH-1]) {
            for(y=[0:HOLE_NUM_LENGTH-1]) {
                translate([
                    BASE_WIDTH / HOLE_NUM_WIDTH * x,
                    BASE_LENGTH / HOLE_NUM_LENGTH * y,
                ])
                hole_cut_2d();
            }
        }
        
    }
}

module base() {
    
    
    difference() {
        translate([BASE_ROUNDING, BASE_ROUNDING, BASE_ROUNDING])
        minkowski() {
            cube([W-BASE_ROUNDING*2, L-BASE_ROUNDING*2, BASE_HEIGHT-BASE_ROUNDING*2]);
            sphere(BASE_ROUNDING, $fn=FN*2);
        }
        
        translate([BASE_WALL, BASE_WALL, 0])
        cube([BASE_WIDTH, BASE_LENGTH, BASE_HEIGHT]);
    }
    
    translate([BASE_WALL, BASE_WALL, 0])
    center();
}

module center_cut1() {     
    translate([BASE_WIDTH/2+BASE_WALL, BASE_LENGTH/2+BASE_WALL, BASE_HEIGHT+BASE_HEIGHT*BASE_CUT_RATIO])
    scale([1, BASE_LENGTH/BASE_WIDTH, BASE_HEIGHT*BASE_CUT_RATIO/BASE_WIDTH*4])
    sphere(BASE_WIDTH/2, $fn=FN*3);

}

module center_cut() {     
    translate([W/2, L/2, BASE_HEIGHT+BASE_HEIGHT*BASE_CUT_RATIO])
    scale([1, L/W, BASE_HEIGHT*BASE_CUT_RATIO/W*4])
    sphere(W/2, $fn=FN*3);

}

difference() {
    base();
    center_cut();
}


