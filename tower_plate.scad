include <configuration.scad>;
use <brackets.scad>;
use <effectors.scad>;

%translate([0,0,-1]) cube([200,200,2], center=true);

translate([-30,40,0]) bracket(motor=true);
translate([30,20,0]) bracket(motor=false);
translate([30,40,0]) idler();

translate([-35,-45,0]) rail_effector();
translate([25,-40,0]) hotend_clamp();
translate([20,-65,0]) rotate([0,0,90]) adjustable_wheel();

for(i=[0:20:78])
	translate([55,i-66,0]) rod_end();
