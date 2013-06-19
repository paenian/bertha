include <configuration.scad>;

//rumba_mount(left = true);
//rumba_mount(left = false);
fan_mount();

rumba_x = 76;
rumba_y = 135;
mount_w = 8;


module rumba_mount(left = true){
	screwhole = 3.2;
	nuthole = 6.4;
	rad = screwhole/2;
	bump_h = 2.25;
	nutrad = nuthole/2;
	far_bolt = 71.5;
	close_bolt = 4;
	mid_bolt = 36;

	//set this to the mounting screw size
	mount_screw = 3.2/2;

	mirror([(left)?0:1,0,0])
	difference(){
		union(){
			//extrusion mount
			cube([ext_y-5, wall, wall*2+mount_w]);

			//rumba mount
			rotate([0,0,90]) translate([0,-wall,0]) cube([rumba_x+wall+wall, wall, wall*2+mount_w]);
			//rumba screw bumps
			translate([wall, wall+wall+far_bolt, wall*2+mount_w/2]) rotate([0,90,0]) cylinder(r2=rad*2, r1=rad*2.5, h=bump_h);
			if(left){
				translate([wall, wall+wall+close_bolt, wall*2+mount_w/2]) rotate([0,90,0]) cylinder(r2=rad*2, r1=rad*2.5, h=bump_h);
			}else{
				translate([wall, wall+wall+mid_bolt, wall*2+mount_w/2]) rotate([0,90,0]) cylinder(r2=rad*2, r1=rad*2.5, h=bump_h);
			}
			

			//brace
			translate([.1,(ext_y-22.5)*sqrt(3),0]) rotate([0,0,-60]) cube([(ext_y-22.5)*2, wall, wall*2]);
		}

		//extrusion screw holes
		for(i=[ext_x*.5,ext_x*2.5]) translate([i,0,wall]) rotate([90,0,0]) cylinder(r=mount_screw, h=wall*3, center=true);
		
		//rumba screw holes
		translate([wall, wall+wall+far_bolt, wall*2+mount_w/2]) rotate([0,90,0]) cylinder(r=rad, h=rad*10, center=true);
		translate([-.1, wall+wall+far_bolt, wall*2+mount_w/2]) rotate([0,90,0]) cylinder(r=nutrad, h=wall/2, $fn=6);
		
			if(left){
				translate([wall, wall+wall+close_bolt, wall*2+mount_w/2]) rotate([0,90,0]) cylinder(r=rad, h=rad*10, center=true);
				translate([-.1, wall+wall+close_bolt, wall*2+mount_w/2]) rotate([0,90,0]) cylinder(r=nutrad, h=wall/2, $fn=6);
			}else{
				translate([wall, wall+wall+mid_bolt, wall*2+mount_w/2]) rotate([0,90,0]) cylinder(r=rad, h=rad*10, center=true);
				translate([-.1, wall+wall+mid_bolt, wall*2+mount_w/2]) rotate([0,90,0]) cylinder(r=nutrad, h=wall/2, $fn=6);
			}
	}
}

//%cube([40,40,40], center=true);
module fan_mount(){
	//these settings are for 40mm fan
	//hole = 38/2;
	//screws = 45/2;
	//bracket = 50;
	//screw_rad = 3/2;

	//this'll do a 60mm fan
	hole = 58/2;
	screws = 70/2;
	bracket = 70;
	screw_rad = 4.6/2;
	

	difference(){
		union(){
			//extrusion mount
			translate([0,bracket/2+wall/2,wall/4+wall]) cube([bracket, wall, wall*2], center=true);
			
			//fan mount
			translate([-wall/2,-wall/4,wall/4]) minkowski(){
				cube([bracket-wall, bracket+wall-wall/2, wall/2], center=true);
				intersection(){
					cube([wall,wall,wall]);
					translate([wall/2,wall,0]) cylinder(r=wall/2, h=.01);
				}
			}

			//fillet
			translate([0,bracket/2-wall/2+.1,wall-.1]) difference(){
				cube([bracket,wall,wall], center=true);
				translate([0,-wall/2,wall/2]) rotate([0,90,0]) cylinder(r=wall, h=bracket+1, center=true);
			}

			//side rails
			for(i=[1,-1]) translate([i*(-bracket/2+wall/4), +wall/2, wall*3/4]) cube([wall/2, bracket, wall/2], center=true);
		}

		//fan hole
		cylinder(r=hole, h=wall*2, center=true);

		//fan screw holes
		for(i=[0:90:359]) rotate([0,0,i]) translate([screws/sqrt(2),screws/sqrt(2),0]) cylinder(r=screw_rad, h=wall*2, center=true);

		//translate([0,bracket/2+wall/2,wall/4+wall])
		//extrusion screw holes
		for(i=[wall*1.5-bracket/2,bracket/2-wall*1.5]) {
			translate([i,bracket/2+wall/2,wall*1.4]) rotate([90,0,0]) cylinder(r=3.3/2, h=wall*3, center=true);
			translate([i,bracket/2-wall/2,wall*1.4]) rotate([90,0,0]) cylinder(r=bolt_cap_rad, h=wall, center=true);
		}
	}
}