RING_OUTER_DIAM = 157.5;
RING_INNER_DIAM = 145.8;

BORDER_THICKNESS = 2;
BORDER_THICKNESS_EXT = 1.2;
LIFT = 0.5;


BASE_HEIGHT = 150;
PLATE_HEIGHT = 30;

FN = 50;

SPIKES_COUNT = 34;
SPIKE_WIDTH = 15;
SPIKE_HEIGHT = 10;
EXTRUDE_TWIST_PER_MM = 1.5;
EXTRUDE_SLICES_PER_MM = 2;


module vase_base(radius, spike_height, spike_width) {
    difference() {
        circle(radius+BORDER_THICKNESS_EXT, $fn=FN);
        circle(radius, $fn=FN);
    }

    for(i=[0:SPIKES_COUNT]) {
        rotate([0, 0, 360 / SPIKES_COUNT * i])
        polygon([
            [radius+BORDER_THICKNESS_EXT-1, -spike_width/2],
            [radius+BORDER_THICKNESS_EXT-1+spike_height, 0],
            [radius+BORDER_THICKNESS_EXT-1, spike_width/2],
        ]);
    }
}


module vase(height, radius, direction) {
    function get_scale(z) = z*sin(z*180)*0.1;
    function get_current_height(z) = SPIKE_HEIGHT * pow(sin(z*180), 0.6);
    function get_current_width(z) = SPIKE_WIDTH;
    function get_angle(z) = direction*EXTRUDE_TWIST_PER_MM*height * sin(z*180-90)*0.15;
    
    SLICES_COUNT = height*EXTRUDE_SLICES_PER_MM;

    for (i=[0:SLICES_COUNT]) {
        z = i / SLICES_COUNT;
        z_next = (i+1) / SLICES_COUNT;
        s = get_scale(z);
        s_next = get_scale(z_next);
        h = get_current_height(z);
        w = get_current_width(z);
        angle = get_angle(z);
        angle_next = get_angle(z_next);
        
        rotate([0, 0, angle])
        translate([0, 0, 1/EXTRUDE_SLICES_PER_MM*i])
        linear_extrude(1/EXTRUDE_SLICES_PER_MM+0.05, twist=(angle-angle_next), scale=(1+s_next)/(1+s), slices=5)
        vase_base(radius * (1+s), h, w);
    }
    
    translate([0, 0, height-BORDER_THICKNESS_EXT/2])
    cylinder(BORDER_THICKNESS_EXT, radius+BORDER_THICKNESS_EXT, radius+BORDER_THICKNESS, $fn=FN);
}




module base() {
    difference() {
        cylinder(BASE_HEIGHT, RING_INNER_DIAM/2-LIFT, RING_INNER_DIAM/2-LIFT, $fn=FN);
        
        translate([0, 0, BORDER_THICKNESS])
        cylinder(BASE_HEIGHT, RING_INNER_DIAM/2-BORDER_THICKNESS-LIFT, RING_INNER_DIAM/2-BORDER_THICKNESS-LIFT, $fn=FN);
    }
    
    for (i=[0:7]) {
        rotate([0, 0, 45*i])
        translate([0, RING_INNER_DIAM/2-BORDER_THICKNESS, BASE_HEIGHT-15])
        
        hull() {
            translate([0, BORDER_THICKNESS-LIFT*2, 0])
            cube([1, 0.1, 0.1]);
            
            translate([0, BORDER_THICKNESS-LIFT*2, 5])
            cube([1, 5, 0.1]);
        }
    }
}

*vase_base(RING_OUTER_DIAM/2, SPIKE_WIDTH, SPIKE_WIDTH);

base();

translate([0, 0, BASE_HEIGHT+0.5])
mirror([0, 0, 1])
vase(BASE_HEIGHT, RING_OUTER_DIAM/2+LIFT*2, 1);