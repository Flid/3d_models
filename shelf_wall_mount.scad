// Smalluseful thing to attach... something to something.

LEN_1 = 40;
LEN_2 = 25;
LEN_MID = 5;
THICKNESS = 3;
HEIGHT = 15;
THREAD_R = 3.40/2;

difference() {
    cube([THICKNESS, LEN_1, HEIGHT]);
    
    translate([0, HEIGHT/2, HEIGHT/2])
    rotate([0, 90, 0])
    cylinder(THICKNESS+1, THREAD_R, THREAD_R, $fn=30);
   
}



hull() {
    translate([0, LEN_1, 0])
    cube([THICKNESS, 0.1, HEIGHT]);

    translate([-HEIGHT/2+THICKNESS/2, LEN_1+LEN_MID, 0])
    cube([HEIGHT, 0.1, THICKNESS]);
}

difference() {
    translate([-HEIGHT/2+THICKNESS/2, LEN_1+LEN_MID, 0])
    cube([HEIGHT, LEN_2, THICKNESS]);
    
    translate([THICKNESS/2, LEN_1+LEN_MID+LEN_2-HEIGHT/2, 0])
    cylinder(THICKNESS+1, THREAD_R, THREAD_R, $fn=30);
}


