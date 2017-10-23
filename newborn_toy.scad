// Everything needed to build a toy for newborns

HOLDER_HEIGHT = 60;
HOLDER_WIDTH = 23;
WALL = 10;
LIFT = 1;
ROUNDING = 4;
FN = 50;
BOLT_DIAM = 6.5;
BOLT_HEAD = 12.5;
PLUG_SIZE = 10;

STRIPE_SIZE = 7;
STRIPE_ROUNDING = 2;
STRIPE_LENGTH = 100;

module holder() {
    
    difference() {
        translate([ROUNDING, ROUNDING, ROUNDING])
        minkowski() {
            cube([
                HOLDER_WIDTH + WALL*2 + LIFT - ROUNDING*2, 
                HOLDER_WIDTH - ROUNDING*2, 
                HOLDER_HEIGHT + WALL + LIFT/2 - ROUNDING*2
            ]);
            sphere(ROUNDING, $fn=FN);
        }
        translate([WALL, 0, 0])
        cube([HOLDER_WIDTH + LIFT, HOLDER_WIDTH, HOLDER_HEIGHT]);
        
        translate([-500, HOLDER_WIDTH/2, 8])
        rotate([0, 90, 0])
        cylinder(1000, BOLT_DIAM/2, BOLT_DIAM/2, $fn=FN);
            
        
        translate([0, HOLDER_WIDTH/2, 8])
        rotate([0, 90, 0])
        cylinder(3, BOLT_HEAD/2, BOLT_HEAD/2, $fn=FN);

        translate([HOLDER_WIDTH/2 + WALL, HOLDER_WIDTH/2, HOLDER_HEIGHT + WALL - 8])
        cylinder(9, PLUG_SIZE/2+LIFT/2, PLUG_SIZE/2+LIFT/2, $fn=FN);
    }
    
}


*holder();

*intersection(){
    difference() {
        cylinder(PLUG_SIZE, 200, 200, $fn=FN*2);
        
        translate([0, 0, -1])
        cylinder(PLUG_SIZE+2, 200-PLUG_SIZE, 200-PLUG_SIZE, $fn=FN*2);
        
        translate([200, 7, 0])
        cylinder(20, 3, 3, $fn=FN);
    }
    
    translate([0, 0, -10])
    cube([1000, 1000, 30]);
}


*translate([-250, 200, PLUG_SIZE])
rotate([0, 90, 0])
cube([PLUG_SIZE, PLUG_SIZE, 200]);

module connector() {
    difference() {
        cube([PLUG_SIZE*2, PLUG_SIZE+2, PLUG_SIZE+2]);
        
        translate([0, 2, 2])
        cube([PLUG_SIZE*2, PLUG_SIZE, PLUG_SIZE]);
    }
}

*connector();

*translate([0, 20, 0])
connector();


module center_top() {
    translate([0, 0, STRIPE_SIZE])
    cylinder(20, 20, 1, $fn=FN);
    
    translate([0, 1.5, 28.5])
    rotate([90, 0, 0])
    difference() {
        cylinder(3, 5, 5, $fn=FN);
        cylinder(3, 3, 3, $fn=FN);
    }
}



module center_bottom() {
    difference() {
        cylinder(STRIPE_SIZE, 20, 20, $fn=FN*2);
        
        for (i=[0:4]) {
            rotate([360/5 * i, -90, 0])
            translate([0, -STRIPE_SIZE/2-LIFT/2, PLUG_SIZE])
            cube([STRIPE_SIZE+LIFT, STRIPE_SIZE+LIFT, 100]);
        }
    }
    translate([0, 0, -2])
    cylinder(2, 20, 20, $fn=FN);
}

*center_top();
*center_bottom();

module white_stripes() {
    color("white")
    
    for (i=[0:4]) {
        rotate([90, 0, 0])
        translate([i*10, -5-LIFT/2, PLUG_SIZE])
        
        difference() {
            translate([STRIPE_ROUNDING*2, STRIPE_ROUNDING, STRIPE_ROUNDING])
            minkowski() {
                cube([STRIPE_SIZE+LIFT-STRIPE_ROUNDING*2, STRIPE_SIZE+LIFT-STRIPE_ROUNDING*2, STRIPE_LENGTH]);
                sphere(STRIPE_ROUNDING/2, $fn=FN);
            }
            
            rotate([-90, 0, 0])
            translate([0, -STRIPE_LENGTH+2, -5])
            cylinder(20, 3, 3, $fn=FN);
            
            rotate([-90, 0, 0])
            translate([STRIPE_SIZE+STRIPE_ROUNDING*2, -STRIPE_LENGTH+2, -5])
            cylinder(20, 3, 3, $fn=FN);
        }
    }
}

white_stripes();