// Lots of details to build a perfect Rostock MAX V3 enclosure.
MAIN_RADIUS = 240;
MAIN_HEIGHT = 6;

FN=30;
FN=120;
CORNER_RADIUS = 160.5;

BORDER_WALL = 2;
BORDER_HEIGHT = 3;
BORDER_MIDDLE_HEIGHT = 0.5;
BORDER_CUT_THICKNESS = 1.5;

ANGLE_OUT_SHIFT = 0;
ANGLE_WALL = 1.5;
ANGLE_SIDE = 10;
ANGLE_THICKNES = 2;
ANGLE_HEIGHT = 30;
ANGLE_LIFT = 0.7;
ANGLE_HOLDER_SIZE = ANGLE_WALL*2 + ANGLE_SIDE + ANGLE_LIFT;

THREAD_RADIUS = 1.8;

module pie_slice(r=3.0,a=30, h=10) {
  intersection() {
    cylinder(h, r, r);
    cube([r, r, r]);
    rotate([0, 0, a-90]) cube([r, r, r]);
  }
}

module angle_holder() {
    out_shift = MAIN_RADIUS-ANGLE_HOLDER_SIZE+ANGLE_WALL-BORDER_WALL+ANGLE_THICKNES+ANGLE_LIFT/2;
    translate([-ANGLE_HOLDER_SIZE, out_shift, 0])
    difference() {
        cube([ANGLE_HOLDER_SIZE*2, ANGLE_HOLDER_SIZE, ANGLE_HEIGHT]);
        
        
        translate([ANGLE_WALL+ANGLE_HOLDER_SIZE, ANGLE_WALL+ANGLE_SIDE-ANGLE_THICKNES-BORDER_CUT_THICKNESS, 0])
        cube([1000, ANGLE_THICKNES+ANGLE_LIFT+BORDER_CUT_THICKNESS, ANGLE_HEIGHT]);
        
        translate([ANGLE_WALL+ANGLE_HOLDER_SIZE, ANGLE_WALL, 0])
        cube([ANGLE_THICKNES+ANGLE_LIFT, ANGLE_SIDE+ANGLE_LIFT, ANGLE_HEIGHT]);
        
        translate([-ANGLE_WALL+ANGLE_HOLDER_SIZE-1000, ANGLE_WALL+ANGLE_SIDE-ANGLE_THICKNES-BORDER_CUT_THICKNESS, 0])
        cube([1000, ANGLE_THICKNES+ANGLE_LIFT+BORDER_CUT_THICKNESS, ANGLE_HEIGHT]);
        
        translate([ANGLE_HOLDER_SIZE-ANGLE_WALL-ANGLE_THICKNES-ANGLE_LIFT, ANGLE_WALL, 0])
        cube([ANGLE_THICKNES+ANGLE_LIFT, ANGLE_SIDE+ANGLE_LIFT, ANGLE_HEIGHT]);
    }
    
    translate([-ANGLE_HOLDER_SIZE, out_shift, 0])
    cube([ANGLE_HOLDER_SIZE*2, ANGLE_HOLDER_SIZE, MAIN_HEIGHT]);
}


module angle_holders() {
    for(i=[0:2]) {
        rotate([0, 0, 120*i])
        angle_holder();
    }
}


module angle_holder_cuts(lift=0) {
    for(i=[0:2]) {
        rotate([0, 0, 120*i])
        translate([-ANGLE_HOLDER_SIZE-lift/2, MAIN_RADIUS-ANGLE_HOLDER_SIZE-lift/2, 0])
        cube([ANGLE_HOLDER_SIZE*2+lift, ANGLE_HOLDER_SIZE+lift, 100]);
    }
}

module thread_cuts() {
    for(i=[0:2]) {
        // Near angle 1
        rotate([0, 0, 120*i])
        translate([-25, MAIN_RADIUS-16, 0])
        cylinder(100, THREAD_RADIUS, THREAD_RADIUS, $fn=20);
        
        // Near angle 2
        rotate([0, 0, 120*i])
        translate([25, MAIN_RADIUS-16, 0])
        cylinder(100, THREAD_RADIUS, THREAD_RADIUS, $fn=20);
        
        
        // Center 1
        rotate([0, 0, 120*i + 60])
        translate([-10, MAIN_RADIUS-45, 0])
        cylinder(100, THREAD_RADIUS, THREAD_RADIUS, $fn=20);
        
        // Center 2
        rotate([0, 0, 120*i + 60])
        translate([10, MAIN_RADIUS-45, 0])
        cylinder(100, THREAD_RADIUS, THREAD_RADIUS, $fn=20);
        
        // Center 1-2
        rotate([0, 0, 120*i + 60])
        translate([-10, MAIN_RADIUS-25, 0])
        cylinder(100, THREAD_RADIUS, THREAD_RADIUS, $fn=20);
        
        // Center 2-2
        rotate([0, 0, 120*i + 60])
        translate([10, MAIN_RADIUS-25, 0])
        cylinder(100, THREAD_RADIUS, THREAD_RADIUS, $fn=20);
    }
}

module base() {
    R=60.5;

    intersection() {
        union() {
            translate([-R*cos(30), -R*sin(30)])
            cylinder(MAIN_HEIGHT, CORNER_RADIUS, CORNER_RADIUS, $fn=FN);

            translate([R*cos(30), -R*sin(30)])
            cylinder(MAIN_HEIGHT, CORNER_RADIUS, CORNER_RADIUS, $fn=FN);
            
            translate([0, R])
            cylinder(MAIN_HEIGHT, CORNER_RADIUS, CORNER_RADIUS, $fn=FN);
        }    
        rotate([0, 0, 90])
        cylinder(100, 184*2, 184*2, $fn=3);       
    }

    intersection() {
        rotate([0, 0, 90])
        cylinder(MAIN_HEIGHT, 184*2, 184*2, $fn=3);   
        
        cylinder(MAIN_HEIGHT, 207, 207);
    }
}


module full_base() {
    difference() {
        cylinder(MAIN_HEIGHT, MAIN_RADIUS, MAIN_RADIUS, $fn=FN*2);
        base();
        thread_cuts();
    }

    // external wall
    translate([0, 0, MAIN_HEIGHT])
    difference() {
        cylinder(BORDER_HEIGHT, MAIN_RADIUS, MAIN_RADIUS, $fn=FN*2);
        cylinder(BORDER_HEIGHT, MAIN_RADIUS-BORDER_WALL, MAIN_RADIUS-BORDER_WALL, $fn=FN*2);
        
        angle_holder_cuts();
    }
    
    // Middle fill
    translate([0, 0, MAIN_HEIGHT])
    difference() {
        r = MAIN_RADIUS-BORDER_WALL;
        cylinder(BORDER_MIDDLE_HEIGHT, r, r, $fn=FN*2);
        cylinder(BORDER_MIDDLE_HEIGHT, r-BORDER_CUT_THICKNESS, r-BORDER_CUT_THICKNESS, $fn=FN*2);
        
        angle_holder_cuts();
    }

    // internal wall
    translate([0, 0, MAIN_HEIGHT])
    difference() {
        r = MAIN_RADIUS-BORDER_WALL-BORDER_CUT_THICKNESS;
        cylinder(BORDER_HEIGHT, r, r, $fn=FN*2);
        cylinder(BORDER_HEIGHT, r-BORDER_WALL, r-BORDER_WALL, $fn=FN*2);
        
        angle_holder_cuts();
    }
    
    angle_holders();
}

module center_holder(rounding=5, length=50, width=35, thickness=4) {
    linear_extrude(thickness) {
        difference() {
            translate([rounding, rounding])
            minkowski() {
                circle(rounding, $fn=FN);
                square([width-rounding*2, length-rounding*2]);
            }
            
            shift = 10;
            translate([width/2-10, 11+shift])
            circle(THREAD_RADIUS, $fn=20);
            
            translate([width/2+10, 11+shift])
            circle(THREAD_RADIUS, $fn=20);
            
            translate([width/2-10, 31+shift])
            circle(THREAD_RADIUS, $fn=20);
            
            translate([width/2+10, 31+shift])
            circle(THREAD_RADIUS, $fn=20);
            
            translate([width/2, 5])
            circle(THREAD_RADIUS, $fn=20);
        }
    }
}


*full_base();

*color("blue")
translate([0, 0, 5])
base();


*translate([0, 0, 0])
intersection() {
    full_base();
    
    rotate([0, 0, -60])
    pie_slice(r=MAIN_RADIUS+10, h=100, a=90+30);
}


*center_holder();


module side_holder(thickness=4) {
    ext_radius = MAIN_RADIUS-BORDER_WALL*2-BORDER_CUT_THICKNESS - 1;
    int_radius = ext_radius-16;
    hole_y_pos = 25;
    holder_len = hole_y_pos*2+30;
    
    translate([0, 0, 10])
    intersection() {
        difference() {
            cylinder(thickness, ext_radius, ext_radius, $fn=FN*2);
            cylinder(thickness, int_radius, int_radius, $fn=FN*2);
            angle_holder_cuts(lift=1.5);
            thread_cuts();
        }
        
        rotate([0, 0, -30])
        union() {
            translate([MAIN_RADIUS-100, -hole_y_pos-15, -50])
            cube([100, holder_len, 100]);
        }
    }
    
    // arm 1
    rotate([0, 0, -30])
    translate([int_radius-16, hole_y_pos-5, 10])
    difference() {    
        cube([20, 20, thickness]);
        
        translate([6, 10, 0])
        cylinder(thickness, THREAD_RADIUS, THREAD_RADIUS, $fn=20);
    }
    
    // arm 2
    rotate([0, 0, -30])
    translate([int_radius-16, -holder_len+hole_y_pos+15, 10])
    difference() {
        cube([20, 20, thickness]);
        translate([6, 10, 0])
        cylinder(thickness, THREAD_RADIUS, THREAD_RADIUS, $fn=20);
    }
}

*color("red")
side_holder();

///////////////////////////////////////////////////////////////

module camera_holder() {
    height = 40;
    platform_size = 15;
    
    cylinder(height, 2, 2, $fn=50);
    
    translate([0, 0, height])
    cylinder(4, 2, 5, $fn=50);
    
    translate([0, 0, height+4])
    difference() {
        cylinder(4, 5, 5, $fn=50);
        cylinder(4, 2.5, 2.5, $fn=30);
    }
    
    translate([0, 0, 3/2])
    cube([3, platform_size*2, 3], center=true);
    
    translate([0, 0, 3/2])
    cube([platform_size*2, 3, 3], center=true);
}

*camera_holder();


///////////////////////////////////////////////////////////////


module holder_pad_1(thickness) {
    difference() {
        cube([12, 50, thickness]);
        
        translate([6, 4.5, 0])
        cylinder(10, 3, 3, $fn=20);
        
        translate([6, 45, 0])
        cylinder(10, 3, 3, $fn=20);
    }
}

module holder_pad_2(thickness) {
    difference() {
        cube([12, 50, thickness]);
        
        translate([6, 15.5, 0])
        cylinder(10, 3, 3, $fn=20);
        
        translate([6, 34, 0])
        cylinder(10, 3, 3, $fn=20);
    }
}

*holder_pad_1(3);

*translate([15, 0])
holder_pad_1(2);

*translate([30, 0])
holder_pad_2(3);

*translate([45, 0])
holder_pad_2(2);


module magnet_holder(holder_size=20) {
    size = 12.5;
    wall = 2;
    thread = 1.6;
    
    difference() {
        cube([size + wall*2, 12, wall]);
        
        translate([4, 9.5], $fn=20)
        cylinder(wall, thread, thread);
        
        translate([size + wall*2 - 4, 9.5], $fn=20)
        cylinder(wall, thread, thread);
    }
    

    
    difference() {
        color("blue")
        translate([wall, -size-holder_size, wall])
        minkowski() {
            cube([size, size+holder_size, size]);
            sphere(wall, $fn=40);
        }
        
        translate([wall, wall-size-wall, wall])
        cube([size, size, size+wall*10]);
    }
    
    
    !difference() {
        cube([size + wall*2, 12, wall]);
        
        translate([4, 9.5], $fn=20)
        cylinder(wall, thread, thread);
        
        translate([size + wall*2 - 4, 9.5], $fn=20)
        cylinder(wall, thread, thread);
    }
}

magnet_holder(20);