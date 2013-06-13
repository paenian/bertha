include <configuration.scad>;

foot(taper = true);

module foot(taper = false){
	difference(){
		union(){
			cylinder(r1=15, r2=10, h=15, $fn=36);
			translate([0,0,15]) scale([1,1,.5]) sphere(r=10, $fn=36);
		}
		
		translate([0,0,-.1]) cylinder(r=bolt_rad, h=25);
		translate([0,0,15]) cylinder(r1=(taper)?bolt_rad:bolt_cap_rad, r2=bolt_cap_rad+1, h=6);
	}
}