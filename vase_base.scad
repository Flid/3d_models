FN = 70;
BORDER_THICKNESS = 0.8;
SPIKES_COUNT = 30;
SPIKE_WIDTH = 3;
SPIKE_HEIGHT = 5;
EXTRUDE_TWIST_PER_MM = 0.5;
EXTRUDE_SLICES_PER_MM = 1;


FN = 10;
EXTRUDE_SLICES_PER_MM = 0.05;

module vase_base(radius, spike_height, spike_width) {
    difference() {
        circle(radius+BORDER_THICKNESS, $fn=FN);
        circle(radius, $fn=FN);
    }

    for(i=[0:SPIKES_COUNT]) {
        rotate([0, 0, 360 / SPIKES_COUNT * i])
        translate([radius+BORDER_THICKNESS+spike_height/2, 0])
        square([spike_height+1, spike_width], center=true);   
    }
}


module vase(height, radius, direction) {
    function get_scale(z) = z*sin(z*180)*0.5;
    function get_current_height(z) = SPIKE_HEIGHT * pow(sin(z*180), 0.6);
    function get_current_width(z) = 2 + SPIKE_WIDTH - SPIKE_WIDTH * sin(z*180);
    function get_angle(z) = direction*EXTRUDE_TWIST_PER_MM*height * sin(z*180-90)*0.5;
    
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
    
    difference() {
        translate([0, 0, height-20])
        cylinder(20, radius+BORDER_THICKNESS, radius+BORDER_THICKNESS, $fn=FN);
        translate([0, 0, height-21])
        cylinder(22, radius+BORDER_THICKNESS-2, radius+BORDER_THICKNESS-2, $fn=FN);
    }
}


translate([0, 0, 170])
mirror([0, 0, 1])
vase(170, 50, 1);
