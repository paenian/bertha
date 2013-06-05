include <configuration.scad>;

idler_guide();

synch_rad = (3.81+.2)/2;
bearing_rad = 8.2;

module idler_guide(){
	facets = 64;
	difference(){
		union(){
			cylinder(r=11, h=1.1, $fn=facets);
			translate([0,0,1]) cylinder(r=10.5, h=6, $fn=facets);
		}

		translate([0,0,-.1]) cylinder(r=7, h=1.1);

		translate([0,0,.9]){
			//bearing fitting
			cylinder(r=bearing_rad/cos(180/facets), h=6.2, $fn=facets);
			
			//synchromesh groove
			render() rotate_extrude($fn=facets) translate([9.5+synch_rad,3,0]) circle(r=synch_rad/cos(180/facets), $fn=facets);
		}

		//uncomment to see a cutaway view.
		//cube([100,100,100]);
	}
}