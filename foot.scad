include <configuration.scad>;

!foot(taper = true);

cable_tie();

foot_rad = 15;

module foot(taper = false){
	difference(){
		union(){
			cylinder(r1=foot_rad, r2=foot_rad-wall, h=15, $fn=36);
			translate([0,0,14.6]) scale([1,1,.5]) sphere(r=foot_rad-wall, $fn=36);
		}
		
		translate([0,0,-.1]) cylinder(r=bolt_rad, h=25);
		translate([0,0,13]) cylinder(r1=(taper)?bolt_rad:bolt_cap_rad, r2=bolt_cap_rad+1, h=4);
		translate([0,0,16]) cylinder(r=bolt_cap_rad+1, h=4);

		//scallop the edges, to put cables through the etrusion
		for(i=[0:1]) mirror([i,0,0]) translate([foot_rad,0,-.1]) scale([1,1,1.5]) sphere(r=foot_rad-wall);
	}
}

//uses an M5 screw to tie into the base, then has a slot for a cable tie to go into.
module cable_tie(){
	$fn=32;
	tie_x = 3;
	tie_y = 14;
	tie_z = 14;

	echo(bolt_cap_rad);

	difference(){
		union(){
			cube([tie_x+wall, tie_y+wall, tie_z]);
		}

		translate([-.1,tie_y/2+wall/2,tie_z/2]) rotate([0,90,0]) cylinder(r=bolt_rad, h=wall*5);
		
		translate([wall,tie_y/2+wall/2,tie_z/2]) rotate([0,90,0]) cylinder(r=bolt_cap_rad, h=wall*5);


		translate([wall/2,wall/2,-.1]) cube([tie_x, tie_y, tie_z+1]);
	}
}