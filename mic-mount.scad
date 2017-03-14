fn = 100;


// MIC PARAMETERS
main_width = 48; // mm
mountable_height = 73; // mm

mount_width = 41.35; // mm
mount_height = 4.4; // mm

bottom_width = 30.27; // mm
taper_height = 10.8; // mm

screw_holder_h = 18;
screw_holder_shaft_d = 26;
screw_holder_d = 35;

cover_thickness = 2; // mm


// SCISSOR MOUNT PARAMETERS
rod_height = 167; // mm
rod_diameter = 5.8; // mm
top_mount_h = 4; // mm
bot_mount_h = 5.5; // mm
no_mount_h = rod_height - top_mount_h - bot_mount_h; // mm

rod_screw_d = 12;
rod_screw_h = 3.1;

rod_cap_d = 7.8;
rod_cap_h = 5.1;

// INTEGRATION PARAMS
rod_distance = 35;


module mount_rod() {
  color([1, 1, 0, 0.5])
  cylinder(d = rod_diameter, h=top_mount_h + bot_mount_h + no_mount_h, $fn=fn);

  color([1, 1, 0, 0.5])
  color("yellow")
  translate([0, 0, rod_height])
  scale([1, 1, rod_cap_h / rod_cap_d])

  hull() {
    sphere(d = rod_cap_d, $fn=fn);
    translate([0, 0, -1 * mountable_height])
    sphere(d = rod_cap_d, $fn=fn);
  }

  removal_slot();
}

module removal_slot() {
  how_far_back = (-1 * rod_diameter / 2) - 1.5;

  color("red")
  hull () {
    translate([0, 0, rod_height - mountable_height - taper_height * 2])
    cylinder(d = rod_diameter + 0.2, h=mountable_height, $fn=fn);

    translate([how_far_back, 0, rod_height - mountable_height - taper_height * 2])
    cylinder(d = rod_diameter + 0.2, h=mountable_height, $fn=fn);
  }

  hull () {
    translate([how_far_back, 0, rod_height - mountable_height - taper_height * 2])
    cylinder(d = rod_diameter + 0.2, h=mountable_height, $fn=fn);

    translate([-1 * rod_diameter, 30, rod_height - mountable_height - taper_height * 2])
    cylinder(d = rod_diameter + 0.2, h=mountable_height, $fn=fn);
  }
}

module mic() {
  color([1, 1, 1, 0.5])

  // main cylinder
  cylinder(d = main_width, h = mountable_height, $fn=fn);

  // mount offset
  translate([0, 0, mount_height * -1])
  cylinder(d = mount_width, h = mount_height, $fn=fn);

  // tapered section
  translate([0, 0, -1 * (mount_height + taper_height)])
  cylinder(d2 = mount_width, d1 = bottom_width, h = taper_height, $fn=fn);

  // mount gap
  translate([0, 0, -1 * (mount_height * 2 + taper_height)])
  cylinder(d = screw_holder_shaft_d, h = mount_height, $fn=fn);

  // screw on part
  translate([0, 0, -1 * (mount_height * 2 + taper_height + screw_holder_h)])
  cylinder(d = screw_holder_d, h = screw_holder_h, $fn=fn);

  translate([rod_distance, 0, -1 * (rod_height - mountable_height + rod_cap_d - 2)])
  mount_rod();
}

module filledMicMount() {

  hull() {
    translate([0, 0, -1 * (taper_height + mount_height)])
    filled_bot_rod_mount();

    difference() {
      sphere(d= main_width + cover_thickness, $fn=fn);
      mic();
    }
  }

  hull () {
    translate([ 0, 0, mountable_height - taper_height - 1 ])
    cylinder(d = main_width + cover_thickness, h = taper_height, $fn=fn);

    translate([rod_distance, 0, -1 * (rod_height - mountable_height)])
    filled_top_rod_mount();
  }

  mount_connector();
}

module mount_connector() {
  color([0, 1, 0, 0.5])
  translate([0, 0, -2])
  cylinder(d = main_width + 2, h = mountable_height, $fn=fn);
}

module filled_top_rod_mount() {
  translate([0, 0, rod_height - top_mount_h - 1])
  scale([1, 1, rod_cap_h / rod_cap_d])
  hull() {
    sphere(d = rod_cap_d + 4, $fn=fn);
    translate([0, 0, -5])
    sphere(d = rod_cap_d + 4, $fn=fn);
  }
}

module filled_bot_rod_mount() {
  translate([rod_distance, 0, 0])
  cylinder(d = rod_diameter + 4, h = taper_height + mount_height, $fn=fn);
}

module micMount() {

  difference() {
    color([1.0, 0.7, 0.7, 0.5])
    filledMicMount();

    color([0.7, 0.7, 0.7, 0.5])
    mic();
  }
}

micMount();

// mic();

// cube([100,100,100]);
