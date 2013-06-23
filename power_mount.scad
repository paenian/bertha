include <configuration.scad>;

//power_mount_side();
switch_mount();

module switch_mount(){
	power_x = 38;
	power_y = 28;
	power_z = 48;
	power_hole_sep = 39.5;

	
	
	slot_z = 10;
	
	mount_x =  power_x+wall*2;
	mount_y = power_y+wall*2;
	mount_z = power_z+wall*2;
	
	mount_bolt_rad = 3.3/2;

	min_rad = 2;
	min_res = 36;

	%translate([mount_x, 0, slot_z+wall]) cube([ext_x, mount_y, ext_y]);

	difference(){
		union(){
			//body
			cube([mount_x, mount_y, mount_z]);

			//cable pass-through
			cube([mount_x+ext_x, mount_y, slot_z+wall]);
			
			//extrusion mount wings
			hull(){
				for(i=[-wall, mount_y+wall]) translate([mount_x-wall, i, slot_z+wall+ext_x/2]) rotate([0,90,0]) cylinder(r=ext_x/2, h=wall);
				translate([mount_x-wall, mount_y/2, slot_z+wall+ext_y-ext_x/2]) rotate([0,90,0]) cylinder(r=ext_x/2, h=wall);
				//this is just to make the hull work out for printing
				translate([mount_x-wall, mount_y/2, wall]) rotate([0,90,0]) cylinder(r=wall, h=wall);
			}

			//power mount wings
			hull(){
				for(y=[(mount_y+power_hole_sep)/2, (mount_y+power_hole_sep)/2-power_hole_sep]) translate([0, y, mount_z/2]) rotate([0,90,0]) cylinder(r=ext_x/2, h=wall*2);
				for(z=[wall, mount_z-wall]) translate([0, mount_y/2, z]) rotate([0,90,0]) cylinder(r=wall, h=wall/2);
			}
		}

		//power insertion hole
		translate([-.1,wall+min_rad,wall+min_rad])
		minkowski($fn=min_res){
			cube([power_x-min_rad*2, power_y-min_rad*2, power_z-min_rad*2]);
			sphere(r=min_rad);
		}

		//cable pass-through hole
		translate([power_x-min_rad*2, wall+min_rad,wall+min_rad])
		minkowski($fn=min_res){
			//cube([power_x-min_rad*2, power_y-min_rad*2, power_z-min_rad*2]);
			cube([ext_x*3, power_y-min_rad*2, slot_z-min_rad*2+.5]);
			sphere(r=min_rad);
		}


		//power mount holes
		for(y=[(mount_y+power_hole_sep)/2, (mount_y+power_hole_sep)/2-power_hole_sep]) translate([-.1, y, mount_z/2]) rotate([0,90,0]) cylinder(r=bolt_rad, h=wall*2);
		for(y=[(mount_y+power_hole_sep)/2, (mount_y+power_hole_sep)/2-power_hole_sep]) translate([wall, y, mount_z/2]) rotate([0,90,0]) cylinder(r=nut_rad, h=wall*2, $fn=6);

		//extrusion mount holes
		for(i=[-wall, mount_y+wall]) translate([mount_x, i, slot_z+wall+ext_x/2]) rotate([0,90,0]) cylinder(r=mount_bolt_rad, h=20, center=true);
		translate([mount_x, mount_y/2, slot_z+wall+ext_y-ext_x/2]) rotate([0,90,0]) cylinder(r=mount_bolt_rad, h=20, center=true);
	}
}


module power_mount_side(){
	boltsize=4.5/2;
	bolthead=7.5/2;
	boltthick = 5;

	//make the screws 3mm
	bolt_rad = 3.2/2;

	difference(){
		cube([ext_y+wall*2, ext_x+wall+2, wall*3]);

		//extrusion slot
		translate([wall, -.1, -.1]) cube([ext_y, ext_x+.2, wall*3+.2]);
	
		//supply screws
		for(i=[wall+11.5, wall+11.5+25]) translate([ i, ext_x-1, wall*3/2]) rotate ([-90,0,0]) {
			cylinder(h = wall+4, r=boltsize);
			cylinder(h = boltthick, r1=bolthead, r2=bolthead);
		}

		//extrusion screws
		translate([-10,ext_x/2,wall*3/2]) rotate([0,90,0]) cylinder(r=bolt_rad, h=100);
	}
}