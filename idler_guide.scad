include <configuration.scad>;

idler_guide();

synch_rad = (3.81+.2)/2;
bearing_rad = 8.3;

module idler_guide(){
	facets = 64;
	thickness = 1.5;
	difference(){
		union(){
			cylinder(r=12, h=3.5, $fn=facets);
			
			translate([0,0,2]) cylinder(r=bearing_rad+synch_rad+.5, h=6, $fn=facets);
			
		}

		translate([0,0,-.1]) cylinder(r=7, h=2.1);

		translate([0,0,1.9]){
			//bearing fitting
			cylinder(r=bearing_rad/cos(180/facets), h=6.2, $fn=facets);
			
			//synchromesh groove
			render() rotate_extrude($fn=facets) translate([bearing_rad+thickness+synch_rad,3,0]) circle(r=synch_rad/cos(180/facets), $fn=facets);
		}

		//uncomment to see a cutaway view.
		//cube([100,100,100]);
	}
}