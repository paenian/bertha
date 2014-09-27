include <configuration.scad>;

lcd_mount();


module lcd_mount(){
	screwhole = 3.2;
	nuthole = 6.4;
	rad = screwhole/2;
	bump_h = 1;

	nutrad = nuthole/2;
	bolt_sep = 50;
	bolt_offset = 20;

	mount_w = 10;
	mount_l = bolt_sep+wall+bolt_offset;

	//set this to the mounting screw size
	mount_screw = 5.4/2;

	difference(){
		union(){
			//extrusion mount
			cube([ext_x, wall, mount_w]);

			//lcd mount
			rotate([0,0,90]) translate([0,-wall,0]) cube([mount_l, wall, mount_w]);
			
			//screw bumps
			for(i=[bolt_offset,bolt_offset+bolt_sep])
				translate([wall, i, mount_w/2]) rotate([0,90,0]) cylinder(r2=rad*2, r1=rad*2.5, h=bump_h);
			//fillet
			difference(){
				translate([wall,wall,0]) cube([ext_x-wall, ext_x-wall, mount_w]);
				
				translate([ext_x,ext_x,0]) cylinder(r=ext_x-wall, h=50, center=true, $fn=30);
			}
			
		}

		//extrusion screw hole
		translate([ext_x/2,0,wall]) rotate([90,0,0]) cylinder(r=mount_screw, h=wall*3, center=true);
		
		translate([ext_x/2,wall*2,wall]) rotate([90,0,0]) cylinder(r=mount_screw*2, h=wall*2, center=true);
		
		
		//lcd screw holes
		for(i=[bolt_offset,bolt_offset+bolt_sep]) translate([wall, i, mount_w/2]) rotate([0,90,0]){
			cylinder(r=rad, h=rad*10, center=true);
			translate([0,0,-wall-.1]) cylinder(r=nutrad, h=wall/2, $fn=6);
		}
	}
}