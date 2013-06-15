include <configuration.scad>;

foot(taper = true);

foot_rad = 15;

module foot(taper = false){
	difference(){
		union(){
			cylinder(r1=foot_rad, r2=foot_rad-wall, h=15, $fn=36);
			translate([0,0,15]) scale([1,1,.5]) sphere(r=foot_rad-wall, $fn=36);
		}
		
		translate([0,0,-.1]) cylinder(r=bolt_rad, h=25);
		translate([0,0,15]) cylinder(r1=(taper)?bolt_rad:bolt_cap_rad, r2=bolt_cap_rad+1, h=4);
		translate([0,0,18]) cylinder(r=bolt_cap_rad+1, h=4);

		//scallop the edges, to put cables through the etrusion
		for(i=[0:1]) mirror([i,0,0]) translate([foot_rad,0,-.1]) sphere(r=foot_rad-wall);
	}
}