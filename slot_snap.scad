slot_snap();

module slot_snap(){
	slot_w = 6.4;
	slot_h = 2;
	slot_b = 1;

	width = slot_w+4;
	length = 20;
	height = slot_h*3+1;

	%cube([2,2,40], center=true);

	rad = (width-slot_w)/2;

	//translate([0,0,height]) mirror([0,0,1]) //pins up
	translate([0,0,length/2]) rotate([90,0,0]) //vertical
	difference(){
		translate([0,0,height/2]) cube([width, length, height],center=true);
		for(i=[0:1]) mirror([i,0,0]){
			translate([width/2, 0, slot_b+rad]) rotate([90,0,0]) rotate([0,0,180/6]) cylinder(r=rad/cos(30), h=length+1, center=true, $fn=6);

			translate([width/2+.66, 0, slot_b]) rotate([90,0,0]) rotate([0,0,180/6]) cylinder(r=rad/cos(30)+.25, h=length+1, center=true, $fn=6);
	
			translate([width/2-slot_b, 0, -rad/2/cos(30)]) rotate([90,0,0]) rotate([0,0,180/6]) cylinder(r=rad/cos(30), h=length+1, center=true, $fn=6);
		}

		translate([0,0,(height-slot_h)/2-.01]) cube([slot_w/2, length+1, height-slot_h],center=true);
	}
}