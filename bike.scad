FN = 100;
LIFT = 0.6;

BASE_FRAME_DIAM = 35;
BASE_LEN = 20;
BASE_HEIGHT = 48;
BASE_BORDER_WIDTH = 12;
BASE_WIDTH = BASE_FRAME_DIAM + 2*BASE_BORDER_WIDTH;
BASE_BOLT_DIAM = 6+LIFT;
BASE_BOLT_HEAD_DIAM = 12;
BASE_BOLT_HEAD_HEIGHT = 5;
BASE_BOLT_HEAD_SIZE_SQ = 11;
BASE_LOCK_WIDTH = BASE_FRAME_DIAM * 0.4;
BASE_LOCK_HEIGHT = 3.5;
BASE_LOCK_THICKNESS = 1.6;
BASE_WIRE_CUT_DIAM = 3.5;

ROUNDING = 3;

module base_single(head_type) {
    difference() {
        
        minkowski () {
            translate([ROUNDING, ROUNDING, 0])
            cube([BASE_WIDTH-ROUNDING*2, BASE_LEN-ROUNDING*2, BASE_HEIGHT/2-ROUNDING]);
            sphere(ROUNDING, $fn=FN);
        }
        
        translate([-500, -500, -500])
        cube([1000, 1000, 500]);
        
        translate([BASE_WIDTH/2, -10, -1])
        rotate([-90, 0, 0]) 
        cylinder(100, BASE_FRAME_DIAM/2+LIFT/2, BASE_FRAME_DIAM/2+LIFT/2, $fn=FN*2);
        
        // bolt body
        translate([BASE_BORDER_WIDTH/2, BASE_LEN/2, -10])
        cylinder(100, BASE_BOLT_DIAM/2, BASE_BOLT_DIAM/2, $fn=FN);
        
        translate([BASE_WIDTH-BASE_BORDER_WIDTH/2, BASE_LEN/2, -10])
        cylinder(100, BASE_BOLT_DIAM/2, BASE_BOLT_DIAM/2, $fn=FN);
        
        // bolt head
        if (head_type == "round") {
            translate([BASE_BORDER_WIDTH/2, BASE_LEN/2, BASE_HEIGHT/2-BASE_BOLT_HEAD_HEIGHT])
            cylinder(BASE_BOLT_HEAD_HEIGHT, BASE_BOLT_HEAD_DIAM/2, BASE_BOLT_HEAD_DIAM/2, $fn=FN);
            
            translate([BASE_WIDTH-BASE_BORDER_WIDTH/2, BASE_LEN/2, BASE_HEIGHT/2-BASE_BOLT_HEAD_HEIGHT])
            cylinder(BASE_BOLT_HEAD_HEIGHT, BASE_BOLT_HEAD_DIAM/2, BASE_BOLT_HEAD_DIAM/2, $fn=FN);
        }
        else {
            translate([BASE_BORDER_WIDTH/2, BASE_LEN/2, BASE_HEIGHT/2-BASE_BOLT_HEAD_HEIGHT/2])
            cube([BASE_BOLT_HEAD_SIZE_SQ+LIFT, BASE_BOLT_HEAD_SIZE_SQ+LIFT, BASE_BOLT_HEAD_HEIGHT], center=true);
            translate([BASE_WIDTH-BASE_BORDER_WIDTH/2, BASE_LEN/2, BASE_HEIGHT/2-BASE_BOLT_HEAD_HEIGHT/2])
            cube([BASE_BOLT_HEAD_SIZE_SQ+LIFT, BASE_BOLT_HEAD_SIZE_SQ+LIFT, BASE_BOLT_HEAD_HEIGHT], center=true);
        }
        
        // side wire cut
        translate([BASE_WIDTH-BASE_BORDER_WIDTH/2-BASE_WIRE_CUT_DIAM/2, 0, 0])
        cube([BASE_WIRE_CUT_DIAM, BASE_WIRE_CUT_DIAM, BASE_HEIGHT]);
        
    }
}

module base_lock(head_type) {
    difference() {
        translate([0, 0, -ROUNDING])
        cube([BASE_LOCK_WIDTH, BASE_LEN, BASE_LOCK_HEIGHT+ROUNDING]);
        
        translate([BASE_LOCK_THICKNESS, 0, 0])
        cube([
            BASE_LOCK_WIDTH-BASE_LOCK_THICKNESS*2, 
            BASE_LEN-BASE_LOCK_THICKNESS, 
            BASE_LOCK_HEIGHT-BASE_LOCK_THICKNESS
        ]);
        
        translate([BASE_LOCK_THICKNESS*2, 0, 0])
        cube([
            BASE_LOCK_WIDTH-BASE_LOCK_THICKNESS*4, 
            BASE_LEN-BASE_LOCK_THICKNESS*2, 
            BASE_LOCK_HEIGHT
        ]);
    }
}


module base_top() {
    base_single("round");
}

module base_bottom() {
    base_single("square");

    translate([(BASE_WIDTH-BASE_LOCK_WIDTH)/2, 0, BASE_HEIGHT/2])
    base_lock();
}

module lock() {
    cube([
        BASE_LOCK_WIDTH-BASE_LOCK_THICKNESS*2-LIFT, 
        BASE_LEN-BASE_LOCK_THICKNESS-LIFT, 
        BASE_LOCK_HEIGHT-BASE_LOCK_THICKNESS-LIFT,
    ]);
    
    translate([BASE_LOCK_THICKNESS, BASE_LOCK_THICKNESS, 0])
    cube([
        BASE_LOCK_WIDTH-BASE_LOCK_THICKNESS*4-LIFT, 
        BASE_LEN-BASE_LOCK_THICKNESS*2-LIFT, 
        BASE_LOCK_HEIGHT+LIFT,
    ]);
}



LCD_WALL_THCKNESS = 1.2;
LCD_SCREEN_WIDTH = 24;
LCD_SCREEN_HEIGHT = 14;
LCD_ANGLE = 60;
ROTATE = true;

LCD_BOX_WIDTH = 27+LIFT+LCD_WALL_THCKNESS*2;
LCD_BOX_LEN = 4+LIFT+LCD_WALL_THCKNESS*2;
LCD_BOX_HEIGHT = 26 + LIFT+LCD_WALL_THCKNESS;

module lcd_holder_base() {
    difference() {
        cube([LCD_BOX_WIDTH, LCD_BOX_LEN, LCD_BOX_HEIGHT+100]);
        
        translate([LCD_WALL_THCKNESS, LCD_WALL_THCKNESS])
        cube([27+LIFT, 4+LIFT, 26 + LIFT+100]);
        
        translate([(LCD_BOX_WIDTH-LCD_SCREEN_WIDTH)/2, -100+LCD_WALL_THCKNESS, 100+LCD_BOX_HEIGHT-7.5-LCD_SCREEN_HEIGHT])
        cube([LCD_SCREEN_WIDTH, 100, LCD_SCREEN_HEIGHT]);
        
    }
}


module lcd_holder() {
    difference() {
        translate([0, 0, ROTATE?(4+LIFT+LCD_WALL_THCKNESS*2)*sin(60):0])
        rotate([ROTATE?-LCD_ANGLE:0, 0, 0])
        translate([0, 0, -100])
        lcd_holder_base();

        translate([-500, -500, -500])
                cube([1000, 1000, 500]);
    }
    
    difference() {
        translate([-1, -3])
        cylinder(1.2, 5, 5, $fn=FN);
        
        translate([0, -500, -500])
        cube([1000, 1000, 1000]);
    }
    
    translate([LCD_BOX_WIDTH, 0, 0])
    mirror([1, 0, 0])
    difference() {
        translate([-1, -3])
        cylinder(1.2, 5, 5, $fn=FN);
        
        translate([0, -500, -500])
        cube([1000, 1000, 1000]);
    }
}

CUT_LEN = -4.05;


module lcd_holder_top() {
    difference() {
        translate([0, 0, CUT_LEN])
        rotate([-90+LCD_ANGLE, 0, 0])
        lcd_holder();
        
        translate([-500, -500, -1000])
        cube([1000, 1000, 1000]);
    }
}


 module lcd_holder_bottom() {
    translate([0, 0, -10])
    difference() {
        translate([0, 0, CUT_LEN])
        rotate([-90+LCD_ANGLE, 0, 0])
        lcd_holder();
        
        translate([-500, -500, 0])
        cube([1000, 1000, 1000]);
    }
}


BOX_WIDTH = 55;
BOX_LEN = 55;
BOX_HEIGHT = 55;
BOX_THICKNESS = 2;
BOX_CUT1_LEN = 5;

module box() {
    
    difference() {
        minkowski() {
            translate([ROUNDING, ROUNDING, ROUNDING])
            cube([BOX_WIDTH-ROUNDING*2, BOX_LEN-ROUNDING*2, BOX_HEIGHT-ROUNDING*2]);
            sphere(ROUNDING, $fn=FN);
        }
        
        minkowski() {
            translate([ROUNDING+BOX_THICKNESS, ROUNDING+BOX_THICKNESS, ROUNDING+BOX_THICKNESS])
            cube([
                BOX_WIDTH-ROUNDING*2-BOX_THICKNESS*2, 
                BOX_LEN-ROUNDING*2-BOX_THICKNESS*2, 
                BOX_HEIGHT-ROUNDING*2-BOX_THICKNESS*2
            ]);
            sphere(ROUNDING, $fn=FN);
        }
    }
    
    translate([
        (BOX_WIDTH-(BASE_LOCK_WIDTH-BASE_LOCK_THICKNESS*2))/2, 
        BOX_LEN-BOX_CUT1_LEN,
        BOX_HEIGHT+BASE_LOCK_HEIGHT+LIFT
    ])
    mirror([0, 1, 0])
    mirror([0, 0, 1])
    lock();
    
    translate([BOX_THICKNESS, BOX_THICKNESS, BOX_THICKNESS])
    intersection() {
        cube([10, 10, 10]);
        
        rotate([-90, 0, 0])
        cylinder(10, 10, 0, $fn=FN);
    }
    
    translate([BOX_THICKNESS, BOX_THICKNESS, BOX_HEIGHT-BOX_THICKNESS])
    rotate([0, 90, 0])
    intersection() {
        cube([10, 10, 10]);
        rotate([-90, 0, 0])
        cylinder(10, 10, 0, $fn=FN);
    }
    
    translate([BOX_WIDTH-BOX_THICKNESS, BOX_THICKNESS, BOX_HEIGHT-BOX_THICKNESS])
    rotate([0, 180, 0])
    intersection() {
        cube([10, 10, 10]);
        rotate([-90, 0, 0])
        cylinder(10, 10, 0, $fn=FN);
    }
    
    translate([BOX_WIDTH-BOX_THICKNESS, BOX_THICKNESS, BOX_THICKNESS])
    rotate([0, 270, 0])
    intersection() {
        cube([10, 10, 10]);
        rotate([-90, 0, 0])
        cylinder(10, 10, 0, $fn=FN);
    }
}

module box1() {
    difference() {
        box();
        
        translate([-500, -1000-BOX_CUT1_LEN+BOX_LEN, -500])
        cube([1000, 1000, 1000]);
    }
}

module box2() {
    difference() {
        box();
        
        translate([-500, -1000+ROUNDING, -500])
        cube([1000, 1000, 1000]);
        
        translate([-500, -BOX_CUT1_LEN+BOX_LEN, -500])
        cube([1000, 1000, 1000]);
    }
}

module box3() {
    difference() {
        box();
        
        translate([-500, 0+ROUNDING, -500])
        cube([1000, 1000, 1000]);
    }
}

box1();
//box2();
//box3();
//lcd_holder_top();
//lcd_holder_bottom();
//base_top();
//base_bottom();

