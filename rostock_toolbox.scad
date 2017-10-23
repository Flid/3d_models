BASE_RADIUS = 160.5;
BASE_ANGLE = 82;
BASE_THICKNESS = 2;
BASE_HEIGHT = 150;

$fn=150;

module pie_slice(r=3.0,a=30, h=10) {
  intersection() {
    cylinder(h, r, r);
    cube([r, r, r]);
    rotate([0, 0, a-90]) cube([r, r, r]);
  }
}

difference() {
    pie_slice(r=BASE_RADIUS, a=BASE_ANGLE, h=BASE_HEIGHT);
    pie_slice(r=BASE_RADIUS-BASE_THICKNESS, a=BASE_ANGLE+1, h=BASE_HEIGHT);
}