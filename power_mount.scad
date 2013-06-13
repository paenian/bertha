include <configuration.scad>;




power_mount_side();

module body () {
  cube([x+thick+thick,y+ythick,z]);
}

module cut () {
 
 translate ([0,4.5,0]) translate([ 0, -2*thick, 0 ]) cube([2*thick,2*thick,z]);  //z wheel clearance
 translate ([x+thick,4.5,0]) translate([ 0, -2*thick, 0 ]) cube([2*thick,2*thick,z]);  //z wheel clearance
 translate([ 0, y/2, z/2 ]) rotate ([0,90,0]) cylinder(h = x+2*thick, r=boltsize/2, $fn=10);  //makerslide bolt holes
 translate([ thick+11.5, y-1, z/2 ]) rotate ([-90,0,0]) cylinder(h = thick+2, r=screwsize/2, $fn=10);  //power supply screw hole
 //translate([ thick+11.5, y-0.01, z/2 ]) rotate ([-90,0,0]) cylinder(h = 1.5, r1=screwsize/2+1, r2=screwsize/2, $fn=10);  //power supply screw hole countersink
 translate([ thick+11.5, y-0.01, z/2 ]) rotate ([-90,0,0]) cylinder(h = 2.5, r1=screwhead/2, r2=screwhead/2, $fn=10);  //power supply screw hole countersink
 translate([ thick+11.5+25, y-1, z/2 ]) rotate ([-90,0,0]) cylinder(h =thick+2, r=screwsize/2, $fn=10);  //power supply screw holes
 //translate([ thick+11.5+25, y-0.01, z/2 ]) rotate ([-90,0,0]) cylinder(h = 1.5, r1=screwsize/2+1, r2=screwsize/2, $fn=10);  //power supply screw hole countersink
 translate([ thick+11.5+25, y-0.01, z/2 ]) rotate ([-90,0,0]) cylinder(h = 2.5, r1=screwhead/2, r2=screwhead/2, $fn=10);  //power supply screw hole countersink
 translate([ thick+11.5+25, y-6, z/2 ]) rotate ([-90,0,0]) cylinder(h = 6, r=screwsize/2+1.5, $fn=20);  //power supply screw clearance 
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