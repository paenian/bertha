include <configuration.scad>;

bed_thickness=4;
bed_radius=14*25.4/2;
bolt_cap_thickness = bolt_cap_rad/2;

arc = 20;



//bed_clip();

//translate([-30,30,0])
bed_mount_side();

module bed_clip(){
	clip_thickness = wall*2;
	clip_width = wall*3;
	translate([-bed_radius+clip_width/2,-arc,0])
	difference(){
		//makes a pie slice
		intersection(){
			cylinder(r=bed_radius+clip_width, h=clip_thickness, $fn=36*20);
			cube([bed_radius+clip_width,bed_radius+clip_width,clip_thickness]);
    			rotate(arc-90) cube([bed_radius+clip_width,bed_radius+clip_width,clip_thickness]);
		}

		translate([0,0,-.1]) cylinder(r=bed_radius-clip_width, h=clip_thickness+.2, $fn=36*20);
		
		translate([0,0,clip_thickness-bed_thickness]) cylinder(r=bed_radius, h=bed_thickness+.1, $fn=36*20);
	
		rotate([0,0,arc/4]) translate([bed_radius+clip_width/2,0,-.1]){
			cylinder(r=bolt_rad, h=5+.2);
			translate([0,0,wall+.1]) cylinder(r1=bolt_rad, r2=bolt_cap_rad, h=bolt_cap_thickness+.1);
			translate([0,0,wall+bolt_cap_thickness+.1]) cylinder(r=bolt_cap_rad, h=bolt_cap_thickness+.1);
		}
	}
}

module bed_mount_side(){
	boltsize=4.5/2;
	bolthead=7.5/2;
	boltthick = 5;

	//make the screws 3mm
	screw_rad = 3.2/2;
	//screw_rad = bolt_rad;

	thickness=wall*3;

	difference(){
		union(){
			cube([ext_y+wall, ext_x+wall, thickness*2]);
	
			//backpack
			translate([0,ext_x-.1,0]) cube([ext_y+wall*2, wall*3, thickness]);

			//wing for attachment, with fillet
			translate([0,ext_x-.1,thickness-.1]) cube([ext_y+wall, wall, thickness+.1]);
			difference(){
				translate([0,ext_x+wall-.1,thickness-.1]) cube([ext_y+wall,wall,wall]);
				translate([-.1,ext_x+wall*2-.1,wall+thickness-.1]) rotate([0,90,0]) cylinder(r=wall, h=ext_y+wall+.2);
			}
		}

		//extrusion slot
		translate([wall, -.1, -.1]) cube([ext_y+.1, ext_x, thickness*2+.2]);

		//extrusion screws
		translate([-10,ext_x/2,thickness]) rotate([0,90,0]) cylinder(r=screw_rad, h=100);
		for(i=[10+wall,wall+50]) translate([ i, ext_x, thickness*1.5]) rotate ([-90,0,0]) {
			translate([0,0,-wall]) cylinder(h = wall*4, r=screw_rad);
			translate([0,0,wall]) cylinder(h = thickness, r=bolt_cap_rad);
		}
			
		//bolt slot
		translate([-1, ext_x+wall*1.5,thickness/2]) rotate([0,90,0]) cylinder(r=bolt_rad+.15, h=ext_y+wall*3);

		//nut slot
		for(i=[0:3:20]) translate([ext_y-nut_height+wall, ext_x+wall*1.5+i,thickness/2]) rotate([0,90,0]) rotate([0,0,30]) cylinder(r=nut_rad+.1, h=nut_height+.2, $fn=6);
	}
}