include <configuration.scad>;
use <brackets.scad>;
use <effectors.scad>;
use <idler_guide.scad>;

%translate([0,0,-1]) cube([200,200,2], center=true);

translate([-35,40,0]) bracket(motor=true);
translate([25,20,0]) bracket(motor=false);
translate([75,30,0]) rotate([0,0,90]) hotend_clamp();

translate([-36,-50,0]) rail_effector();
translate([25,-105,0]) idler();
translate([20,-75,0]) rotate([0,0,90]) adjustable_wheel();

translate([70,65,0]) idler_guide();

for(i=[0:45:50])
	translate([56,i-45,0]) rod_end();
for(i=[0:45:50])
	translate([76,i-45,0]) rod_end();
