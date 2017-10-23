HEIGHT = 170;
DEPTH = 100;
WIDTH = 11;
LIFT = 1;
RULER_WIDTH = 3;
RULER_HEIGHT = 30;
WALL = 2;


module holder() {
    difference() {
        translate([0, +WALL+RULER_WIDTH/2+LIFT/2])
        rotate([90, 270, 0])
        linear_extrude(WALL*2 + RULER_WIDTH+LIFT)
        polygon([
            [0, 0],
            [HEIGHT, 0],
            [HEIGHT, DEPTH],
            [HEIGHT - WALL*2 - RULER_HEIGHT, DEPTH],
            [HEIGHT - WALL*2 - RULER_HEIGHT-20, 15],
            [0, 0],
            
        ]);
        
        translate([-1000-WALL-LIFT/2, -RULER_WIDTH/2-LIFT/2, HEIGHT - RULER_HEIGHT-WALL-LIFT/2])
        cube([1000, RULER_WIDTH+LIFT, RULER_HEIGHT+LIFT]);
    }
    
    translate([-WALL, -WIDTH, -WIDTH])
    cube([WALL, WIDTH*2, HEIGHT+WIDTH*3]);
}

holder();