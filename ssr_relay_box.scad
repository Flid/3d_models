// A box for a standard Solid-State relay

module relay1() {
    WALL = 2;
    RELAY_LENGTH = 53;
    RELAY_WIDTH = 18.3;
    RELAY_HEIGHT = 21;
    RELAY_BASE_HEIGHT = 2.5;
    THREAD_R = 1.4;
    THERAD_HEAD_R = 3;
    THERAD_HEAD_H = 2;
    THREAD_OFFSET = 0.6;
    WIRE_CUT_SIZE = 3;
    LIFT = 0.8;
    FN = 30;

    CORNER_COLUMN_SIZE = WALL+THREAD_OFFSET+THREAD_R*2+1;
    TOTAL_LEN = RELAY_LENGTH+WALL*2+LIFT;
    TOTAL_WIDTH = RELAY_WIDTH+WALL*2+LIFT;  


    $fn = FN;

    module thread_cut() {
        cylinder(THERAD_HEAD_H, THERAD_HEAD_R, THREAD_R);
        
        translate([0, 0, THERAD_HEAD_H])
        cylinder(100, THREAD_R, THREAD_R);
    }

    module thread_cuts() {
        distance = WALL+THREAD_OFFSET+THREAD_R+LIFT/2;
        translate([distance, distance, 0])
        thread_cut();

        translate([TOTAL_LEN-distance, distance, 0])
        thread_cut();

        translate([distance, TOTAL_WIDTH-distance, 0])
        thread_cut();

        translate([TOTAL_LEN-distance, TOTAL_WIDTH-distance, 0])
        thread_cut();
    }

    module columns() {
        h = RELAY_HEIGHT-RELAY_BASE_HEIGHT;
        w = 1.5;
        translate([0, 0, RELAY_BASE_HEIGHT])
        cube([CORNER_COLUMN_SIZE, CORNER_COLUMN_SIZE, h]);

        translate([TOTAL_LEN-CORNER_COLUMN_SIZE, 0, RELAY_BASE_HEIGHT])
        cube([CORNER_COLUMN_SIZE, CORNER_COLUMN_SIZE, h]);

        translate([0, TOTAL_WIDTH-CORNER_COLUMN_SIZE, RELAY_BASE_HEIGHT])
        cube([CORNER_COLUMN_SIZE, CORNER_COLUMN_SIZE, h]);

        translate([TOTAL_LEN-CORNER_COLUMN_SIZE, TOTAL_WIDTH-CORNER_COLUMN_SIZE, RELAY_BASE_HEIGHT])
        cube([CORNER_COLUMN_SIZE, CORNER_COLUMN_SIZE, h]);
        
        distance = WALL+THREAD_OFFSET+THREAD_R+LIFT/2;
        translate([distance, distance, RELAY_BASE_HEIGHT])
        cylinder(h, THREAD_R+w, THREAD_R+w);

        translate([TOTAL_LEN-distance, distance, RELAY_BASE_HEIGHT])
        cylinder(h, THREAD_R+w, THREAD_R+w);

        translate([distance, TOTAL_WIDTH-distance, RELAY_BASE_HEIGHT])
        cylinder(h, THREAD_R+w, THREAD_R+w);

        translate([TOTAL_LEN-distance, TOTAL_WIDTH-distance, RELAY_BASE_HEIGHT])
        cylinder(h, THREAD_R+w, THREAD_R+w);
    }

    module bottom() {
        difference() {
            cube([TOTAL_LEN, TOTAL_WIDTH, WALL]);
            thread_cuts();
        }
    }

    module top() {
        difference() {
            columns();
            translate([0, 0, -THERAD_HEAD_H])
            thread_cuts();
        }
        
        difference() {
            cube([TOTAL_LEN, TOTAL_WIDTH, RELAY_HEIGHT+WALL]);
            
            translate([WALL, WALL, 0])
            cube([RELAY_LENGTH+LIFT, RELAY_WIDTH+LIFT, RELAY_HEIGHT]);
            
            translate([0, TOTAL_WIDTH/2-WIRE_CUT_SIZE/2, 0])
            cube([TOTAL_LEN, WIRE_CUT_SIZE, WIRE_CUT_SIZE]);
        }
    }

    bottom();

    translate([0, 0, 30])
    !top();
}

*relay1();






module relay2() {
    WALL = 1.6;
    RELAY_LENGTH = 58.8;
    RELAY_WIDTH = 45.3;
    RELAY_HEIGHT = 27.5;
    THREAD_D = 2.8;
    THREAD_HEAD_D = 6;
    THREAD_HEAD_H = 2;
    COLUMN_D = 9;
    COLUMN_OFFSET = 5;
    BASE_THICKNESS = 6.5;
    WIRE_CUT_HEIGHT = 19;
    WIRE_CUT_WIDTH = 2.5;
    WIRE_CUT_OFFSET_FROM_SIDE = 13;
    $fn=50;
    
    module thread() {
        cylinder(THREAD_HEAD_H, THREAD_HEAD_D/2, THREAD_D/2, $fn=40);
        translate([0, 0, THREAD_HEAD_H])
        cylinder(RELAY_HEIGHT-THREAD_HEAD_H-WALL*2, THREAD_D/2, THREAD_D/2, $fn=30);
    }
    
    module threads() {
        translate([WALL+COLUMN_OFFSET, RELAY_WIDTH/2+WALL, 0])
        thread();
        
        translate([WALL+RELAY_LENGTH - COLUMN_OFFSET, RELAY_WIDTH/2+WALL, 0])
        thread();
    }
    
    module wire_cuts(lift) {
        translate([0, WIRE_CUT_OFFSET_FROM_SIDE-lift/2, 0])
        cube([RELAY_LENGTH+WALL*2, WIRE_CUT_WIDTH+lift, WIRE_CUT_HEIGHT]);
        
        // Wire cut 2
        translate([0, RELAY_WIDTH+WALL*2-WIRE_CUT_OFFSET_FROM_SIDE-WIRE_CUT_WIDTH-lift/2, 0])
        cube([RELAY_LENGTH+WALL*2, WIRE_CUT_WIDTH+lift, WIRE_CUT_HEIGHT]);
    }

    module bottom() {
        // Box
        difference() {
            cube([RELAY_LENGTH + WALL*2, RELAY_WIDTH+WALL*2, RELAY_HEIGHT+WALL]);
            
            translate([WALL, WALL, WALL])
            cube([RELAY_LENGTH, RELAY_WIDTH, RELAY_HEIGHT]);
            
            translate([0, 0, WALL+RELAY_HEIGHT-WIRE_CUT_HEIGHT])
            wire_cuts(lift=0.7);
        }
        
        // Columns
        difference() {
            union() {
                column_h = RELAY_HEIGHT+WALL-BASE_THICKNESS;
                translate([WALL+COLUMN_OFFSET, RELAY_WIDTH/2+WALL, 0])
                cylinder(column_h, COLUMN_D/2, COLUMN_D/2);
                
                translate([WALL+RELAY_LENGTH - COLUMN_OFFSET, RELAY_WIDTH/2+WALL, 0])
                cylinder(column_h, COLUMN_D/2, COLUMN_D/2);
            }
            
            translate([0, 0, RELAY_HEIGHT+WALL*3])
            mirror([0, 0, 1])
            threads();
        }
    }
    
    module top() {
        difference() {
            cube([RELAY_LENGTH+WALL*2, RELAY_WIDTH+WALL*2, WALL*2]);
            threads();
        }

        
        difference() {
            translate([0, 0, WALL*2-WIRE_CUT_WIDTH*2])
            wire_cuts(lift=0);
            
            translate([WALL, WALL, WALL])
            cube([RELAY_LENGTH, RELAY_WIDTH, RELAY_HEIGHT]);
            
            translate([-500, -500, -1000])
            cube([1000, 1000, 1000]);
        }
    }
    
    bottom();
    
    translate([0, RELAY_WIDTH+WALL*2+10])
    top();
    
}

relay2();