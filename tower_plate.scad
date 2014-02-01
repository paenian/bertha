include <configuration.scad>;
use <brackets.scad>;
use <effectors.scad>;
use <idler_guide.scad>;
//use <bearing_arms.scad>;


sb_width = 24;

%translate([0,0,-1]) cube([200,200,2], center=true);

render() translate([-37,38,0]) bracket(motor=true);
render() translate([25,24,0]) bracket(motor=false, push=true);
//render() translate([75,30,0]) rotate([0,0,90]) hotend_clamp();

render() translate([-36,-50,0]) rail_effector();
render() translate([20,-98,0]) idler(push=true);

render() translate([20,-71,0]) idler_guide();

render(){
	for(i=[50])
		translate([52,i-50,0]) rod_end();
	for(i=[0, 50, 100])
		translate([72,i-25,0]) rod_end();
}
