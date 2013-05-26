include <configuration.scad>;

idler_guide();

synch_rad = (3.81+.2)/2;


module idler_guide(){
	facets = 64;
	difference(){
		union(){
			cylinder(r=10, h=1.1, $fn=facets);
			translate([0,0,1]) cylinder(r=9.5, h=6, $fn=facets);
		}

		translate([0,0,-.1]) cylinder(r=7, h=1.1);
		translate([0,0,.9]){
			cylinder(r=8.1/cos(180/facets), h=6.2, $fn=facets);
			
			render() rotate_extrude($fn=facets) translate([8.5+synch_rad,2.5,0]) circle(r=synch_rad/cos(180/facets), $fn=facets);
		}
	}
}