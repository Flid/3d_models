LIFT=0.5;
NOZZLE = 0.5;
GLASS_WIDTH=149.5;
GLASS_HEIGHT=212;
GLASS_THICKNESS=3;
GLASS_CUT_ADD=5;  // on every side
FACE_ROUNDING=3;
FRAME_ADD_SMALL=7;
FRAME_ADD_LARGE=30;
FRAME_THICKNESS=60;
FN=30;
WALL=3;
RACK_WALL=2;

TOUCH_SENSOR_WIDTH = 20;
TOUCH_SENSOR_HEIGHT = 16.5;
TOUCH_SENSOR_BORDER = 3;
TOUCH_SENSOR_REDUCE_WINDOW_HEIGHT=1;

USB_POS = "side";  // bottom/side
USB_WIDTH=15;
USB_HEIGHT=5;
USB_BOARD_TIP_SIZE = 2;
USB_BOARD_WIDTH = 18.5;
USB_BOARD_TIP_Z_OFFSET = 4.5;
USB_BOARD_TIP_WIDTH = 8.5;
USB_BOARD_TIP_HEIGHT = 4.5;
USB_BOARD_LEN = FRAME_ADD_LARGE;

LID_CUT_POS = 110;

THREAD_RADIUS=1.5;
THREAD_HEAD_RADIUS=2.6;
THREAD_HEAD_DEPTH=1.5;
THREAD_DEPTH=12 + THREAD_HEAD_DEPTH;

LED_STRIP_WIDTH = 11;
LED_STRIP_DEPTH = 1;

//MOTION_SENSOR_WIDTH = 16.5;
//MOTION_SENSOR_HEIGHT = 18.5;
//MOTION_SENSOR_TIP_HEIGHT = 2.0;
//MOTION_SENSOR_TIP_WIDTH = 4.1;
//MOTION_SENSOR_TIP_Z = 10;
//MOTION_TO_TOUCH_DISTANCE = 2;


module thread_set() {
    translate([FRAME_ADD_SMALL/2+WALL, FRAME_ADD_LARGE/2])
    cylinder(THREAD_DEPTH, THREAD_RADIUS, THREAD_RADIUS, $fn=FN/2);
    
    translate([FRAME_ADD_SMALL/2+WALL, FRAME_ADD_LARGE/2])
    cylinder(THREAD_HEAD_DEPTH, THREAD_HEAD_RADIUS, THREAD_HEAD_RADIUS, $fn=FN/2);
    
    translate([GLASS_WIDTH+FRAME_ADD_SMALL*3/2-WALL, FRAME_ADD_LARGE/2])
    cylinder(THREAD_DEPTH, THREAD_RADIUS, THREAD_RADIUS, $fn=FN/2);
    
    translate([GLASS_WIDTH+FRAME_ADD_SMALL*3/2-WALL, FRAME_ADD_LARGE/2])
    cylinder(THREAD_HEAD_DEPTH, THREAD_HEAD_RADIUS, THREAD_HEAD_RADIUS, $fn=FN/2);
}

module prop(size) {
    intersection() {
        rotate([45, 0, 0])
        cube([size, size, size], center=true);
        
        cube([size*2, size, size]);
    }
}

module separator_base(lift) {
    translate([FRAME_ADD_SMALL-WALL-lift/2, -lift/2, WALL/2-lift/2])
    cube([GLASS_WIDTH+WALL*2+lift, WALL+lift, FRAME_THICKNESS-WALL+lift]);
}

module frame_base() {
    difference() {
        translate([FACE_ROUNDING, FACE_ROUNDING, -FACE_ROUNDING])
        minkowski() {
            sphere(FACE_ROUNDING, $fn=FN);
            cube([
                GLASS_WIDTH+FRAME_ADD_SMALL*2-FACE_ROUNDING*2,
                GLASS_HEIGHT-FACE_ROUNDING*2+FRAME_ADD_LARGE+FRAME_ADD_SMALL,
                FRAME_THICKNESS,
            ]);
        };
        
        translate([-500, -500, -500])
        cube([1000, 1000, 500]);
    }
}

module frame_cut() {
    translate([-500, 0, -500])
    cube([1000, FRAME_ADD_LARGE-WALL, 1000]);
}

HOLDER_WINGTH_LEN = 60;

module holder_wings(lift=0) {
    for(i=[0, 1]) {
        translate([WALL+lift/2+(GLASS_WIDTH+FRAME_ADD_SMALL*2-WALL-lift/2)*i, 0])
        
        rotate([0, -90, 0])
        linear_extrude(WALL+lift/2)
        polygon([
            [0, 0],
            [0, HOLDER_WINGTH_LEN],
            [FRAME_THICKNESS/3, HOLDER_WINGTH_LEN],
            [FRAME_THICKNESS/3*2, 0],
        ]);
    }
}


module lid(lift) {
    difference() {
        intersection() {
            translate([FACE_ROUNDING+WALL, FACE_ROUNDING+WALL, -FACE_ROUNDING])
            minkowski() {
                sphere(FACE_ROUNDING, $fn=FN);
                cube([
                    GLASS_WIDTH+FRAME_ADD_SMALL*2-FACE_ROUNDING*2-WALL*2+lift,
                    GLASS_HEIGHT-FACE_ROUNDING*2+FRAME_ADD_LARGE*2-WALL*2+lift,
                    FRAME_THICKNESS,
                ]);
            };
            
            translate([-500, -500, 0])
            cube([1000, 1000, WALL]);
            
            frame_cut();
        };
        
        thread_set();
    }
    
    // USB tip
    if (USB_POS == "bottom") {
        translate([(GLASS_WIDTH+FRAME_ADD_SMALL*2 - USB_WIDTH)/2+LIFT/2, 0])
        cube([USB_WIDTH-LIFT, USB_HEIGHT, WALL]);
    }
}



module frame_top() {
    difference() {
        frame_base();
        frame_cut();
        
        // Face window
        translate([FRAME_ADD_SMALL+GLASS_CUT_ADD, FRAME_ADD_LARGE-WALL, FRAME_THICKNESS-WALL])
        cube([GLASS_WIDTH-GLASS_CUT_ADD*2, GLASS_HEIGHT-GLASS_CUT_ADD+WALL, WALL]);
        
        // Main dock
        translate([FRAME_ADD_SMALL, FRAME_ADD_LARGE-WALL, WALL])
        cube([GLASS_WIDTH, GLASS_HEIGHT+WALL, FRAME_THICKNESS-WALL*2]);
                    
        // Separator cut
        translate([0, FRAME_ADD_LARGE-WALL+LIFT/2, 0])
        separator_base(LIFT);
        
        // LED strip cut
        translate([FRAME_ADD_SMALL-LED_STRIP_DEPTH, FRAME_ADD_LARGE, FRAME_THICKNESS/2-LED_STRIP_WIDTH/2])
        cube([GLASS_WIDTH+LED_STRIP_DEPTH*2, GLASS_HEIGHT+LED_STRIP_DEPTH, LED_STRIP_WIDTH]);
        
        // Wings holder
        translate([0, FRAME_ADD_LARGE-WALL, 0])
        holder_wings(LIFT);
        
    };  // end difference

    for(pos=[
        [FRAME_ADD_SMALL, FRAME_ADD_LARGE+LIFT, WALL+GLASS_THICKNESS+LIFT/2],
        [FRAME_ADD_SMALL, FRAME_ADD_LARGE+LIFT, FRAME_THICKNESS-WALL-RACK_WALL-GLASS_THICKNESS*2-LIFT/2+0.5],
        [FRAME_ADD_SMALL+GLASS_WIDTH-RACK_WALL, FRAME_ADD_LARGE+LIFT, WALL+GLASS_THICKNESS+LIFT/2],
        [FRAME_ADD_SMALL+GLASS_WIDTH-RACK_WALL, FRAME_ADD_LARGE+LIFT, FRAME_THICKNESS-WALL-RACK_WALL-GLASS_THICKNESS*2-LIFT/2+0.5],
    ]) {
        translate(pos)
        cube([RACK_WALL, GLASS_HEIGHT, RACK_WALL]);
    }
}



module frame_bottom() {
    thicker_wall=5;
    
    difference() {
        intersection() {
            frame_base();
            frame_cut();
        }
         
        // Tool box
        translate([FRAME_ADD_SMALL+thicker_wall, WALL, 0])
        cube([GLASS_WIDTH-thicker_wall*2, FRAME_ADD_LARGE-WALL*2, FRAME_THICKNESS-WALL]);
            
        // Touch holder
        translate([
            (GLASS_WIDTH+FRAME_ADD_SMALL*2 - TOUCH_SENSOR_WIDTH-LIFT)/2, 
            (FRAME_ADD_LARGE-WALL-TOUCH_SENSOR_HEIGHT-LIFT/2)-2, 
            -100+FRAME_THICKNESS-NOZZLE-0.1,
        ])
        cube([TOUCH_SENSOR_WIDTH+LIFT, TOUCH_SENSOR_HEIGHT+LIFT, 100]);
        
        
        // Touch window
        touch_window_width = TOUCH_SENSOR_WIDTH - TOUCH_SENSOR_BORDER * 2;         
        translate([
            (GLASS_WIDTH+FRAME_ADD_SMALL*2)/2, 
            (FRAME_ADD_LARGE-WALL)-2-touch_window_width/2-TOUCH_SENSOR_REDUCE_WINDOW_HEIGHT, 
            0
        ])
        cylinder(100, touch_window_width/2, touch_window_width/2, $fn=50);
        
        // USB cut
        if (USB_POS == "bottom") {
            translate([
                (GLASS_WIDTH+FRAME_ADD_SMALL*2 - USB_WIDTH)/2, 
                0, 
                0,
            ])
            cube([USB_WIDTH, USB_HEIGHT, WALL*3]);
        }
        if (USB_POS == "side") {
            translate([
                GLASS_WIDTH+FRAME_ADD_SMALL*2-USB_BOARD_LEN, 
                WALL, 
                THREAD_DEPTH+1,
            ]) {
                translate([-USB_BOARD_TIP_SIZE, 0, 0])
                cube([USB_BOARD_LEN, USB_BOARD_WIDTH, USB_BOARD_TIP_Z_OFFSET+USB_BOARD_TIP_HEIGHT]);
                
                translate([USB_BOARD_LEN-USB_BOARD_TIP_SIZE, (USB_BOARD_WIDTH-USB_BOARD_TIP_WIDTH)/2, 0])
                cube([USB_BOARD_TIP_SIZE, USB_BOARD_TIP_WIDTH, USB_BOARD_TIP_HEIGHT]);
            }
        }
        
        // LED wires cut
        depth = 2;
        translate([WALL, FRAME_ADD_LARGE-WALL-depth, (FRAME_THICKNESS-LED_STRIP_WIDTH)/2])
        cube([FRAME_ADD_SMALL+thicker_wall-WALL, depth, LED_STRIP_WIDTH]);
        
        translate([GLASS_WIDTH+FRAME_ADD_SMALL-thicker_wall, FRAME_ADD_LARGE-WALL-depth, (FRAME_THICKNESS-LED_STRIP_WIDTH)/2])
        cube([FRAME_ADD_SMALL+thicker_wall-WALL, depth, LED_STRIP_WIDTH]);
        
        lid(LIFT);
        
        thread_set();    
    };  // end difference

    prop_center_dist = 20;
    prop_size=10;
    translate([GLASS_WIDTH/2+FRAME_ADD_SMALL-prop_center_dist-prop_size/2, WALL, WALL])
    prop(prop_size);

    translate([GLASS_WIDTH/2+FRAME_ADD_SMALL+prop_center_dist, WALL, WALL])
    prop(prop_size);

    if (USB_POS == "bottom") {
        translate([GLASS_WIDTH/2+FRAME_ADD_SMALL-prop_size/4, WALL, USB_HEIGHT+prop_size/4+2])
        prop(prop_size);
    }

    // Face holder extension
    translate([FRAME_ADD_SMALL+GLASS_CUT_ADD, FRAME_ADD_LARGE-WALL, FRAME_THICKNESS-WALL/2])
    cube([GLASS_WIDTH-GLASS_CUT_ADD*2, WALL+GLASS_CUT_ADD, WALL/2]);    
    
    translate([0, FRAME_ADD_LARGE-WALL, 0])
    holder_wings();
}


module separator() {
    len_reduce = 3;
    difference() {
        separator_base(0);
        
        translate([FRAME_ADD_SMALL-LED_STRIP_DEPTH, WALL-LED_STRIP_DEPTH, FRAME_THICKNESS/2-LED_STRIP_WIDTH/2])
        cube([GLASS_WIDTH+LED_STRIP_DEPTH*2, GLASS_HEIGHT+LED_STRIP_DEPTH, LED_STRIP_WIDTH]);
        
        translate([FRAME_ADD_SMALL-WALL, 0, FRAME_THICKNESS/2-LED_STRIP_WIDTH/2])
        cube([5, WALL, LED_STRIP_WIDTH]);
        
        // len reduce
        translate([GLASS_WIDTH+WALL+FRAME_ADD_SMALL-len_reduce, 0, 0])
        cube([100, 100, 100]);
        
    }
}

module led_strip_shield(length) {
    LED_SHIELD_THICKNESS = 0.7;
    led_size = 5;
    lift=0.4;  // each side
    led_spacing = 11.6;
    
    difference() {
        cube([LED_STRIP_WIDTH, length, LED_SHIELD_THICKNESS]);
        
        for (i=[0: floor(length/(led_spacing+led_size))+1]) {
            translate([(LED_STRIP_WIDTH-led_size)/2-lift, led_spacing/2 + i*(led_spacing+led_size)-lift, 0])
            cube([led_size+lift*2, led_size+lift*2, LED_SHIELD_THICKNESS]);
        }
    }
}

FN=70;

!led_strip_shield(150);
frame_bottom();

translate([0, 70, 0])
!rotate([90, 0, 0])
separator();

translate([0, 80, 0])
!rotate([-90, 0, 0])
frame_top();

translate([0, 0, -20])
rotate([180, 0, 0])
lid(0);

