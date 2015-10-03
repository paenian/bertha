include <configuration.scad>;

vertical_guide();

module spool_hook(){
	$fn=72;
	outer_rad = 30/2;
	bearing_bore = 8/2-.25;
	bearing_rest = 11/2;
	bearing_rest_width = 1;
	bearing_width = 6/2;
	
	difference(){
		union(){
			cylinder(r=outer_rad, h=wall);
			translate([0,0,wall-.1]) cylinder(r=bearing_rest, h=bearing_rest_width+.1);
			translate([0,0,wall+bearing_rest_width-.1]) cylinder(r=bearing_bore, h=bearing_width);
		}

		translate([0,0,-.1]) cylinder(r=bolt_rad, h=50);
	}
}

module vertical_guide(){
	$fn=72;
	outer_rad = 30/2;
	bearing_bore = 8/2-.25;
	bearing_rest = 11/2;
	bearing_rest_width = 1;
	bearing_width = 10;
	
difference(){
	translate([0,0,3])
	rotate([0,90,0])
	rotate([0,0,-18.8])
	difference(){
		intersection(){
			union(){
				cylinder(r=outer_rad+wall*2, h=wall);
				translate([0,0,wall-.1]) cylinder(r=bearing_rest, h=bearing_rest_width+.1);
				translate([0,0,wall+bearing_rest_width-.1]) cylinder(r=bearing_bore, h=bearing_width);
				translate([-10,-outer_rad-wall, 0]) cube([20,wall,24]);
			}

			hull(){
				translate([-10,-outer_rad-wall, 0]) cube([20,.01,24]);
				translate([0,4,0]) cylinder(r=bearing_bore-2, h=20);
			}
		}

		translate([0,-11,18]) rotate([90,0,0]) cylinder(r=bolt_rad, h=10);
	}
	
	translate([0,0,-10]) cube([50,50,20],center=true);
}
}