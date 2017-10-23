WIDTH = 90;
HEIGHT = 150;
SCALE=2.2;

module plate() {
    difference() {
        scale([SCALE, 1, 1]) cylinder(10, WIDTH/2, WIDTH/2, $fn=150);
        translate([0, 0, 3]) scale([0.95, 0.95, 1]) scale([SCALE, 1, 1]) cylinder(10, WIDTH/2, WIDTH/2, $fn=100);
    }
}


plate();

module base(){
    difference() {
        scale([2.2, 1, 1]) cylinder(HEIGHT, WIDTH/2, WIDTH/2, $fn=150);
        translate([0, 0, 3]) scale([0.95, 0.95, 1]) scale([2.2, 1, 1]) cylinder(HEIGHT, WIDTH/2, WIDTH/2, $fn=100);
        translate([-WIDTH*SCALE*0.9/2, -WIDTH]) cube([WIDTH*SCALE*0.9, WIDTH*2, HEIGHT]);
        translate([-500, -WIDTH*0.1]) cube([1000, WIDTH*0.2, HEIGHT]);
        
    }
}

base();

!difference() {
    translate([0, 0, HEIGHT-10]) plate();
    base();
}