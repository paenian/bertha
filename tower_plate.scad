include <configuration.scad>;
use <brackets.scad>;
use <effectors.scad>;
use <idler_guide.scad>;

sb_width = 24;

%translate([0,0,-1]) cube([200,200,2], center=true);

render() translate([-35,40,0]) bracket(motor=true);
render() translate([25,20,0]) bracket(motor=false);
render() translate([75,30,0]) rotate([0,0,90]) hotend_clamp();

render() translate([-36,-50,0]) rail_effector();
render() translate([25,-105,0]) idler();

render() translate([70,65,0]) idler_guide();

render(){
	for(i=[0,45])
		translate([56,i-45,0]) rod_end();
	for(i=[0,45])
		translate([76,i-45,0]) rod_end();
}
