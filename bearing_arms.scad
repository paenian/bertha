include <configuration.scad>;
use <effectors.scad>;

arm_sep = 70;

//Requires 8 625 2RS ball bearings per arm!
bearing_rad = 16/2+.15;
bearing_width = 5+.3;
bearing_bore = 5/2;
bearing_core = 8/2;
bearing_rim = 12/2;
lock_lip = .25;

rod_end_length = 30;
rod_end_thickness = 8.75;
rod_end_gap = 20;

rim = -.05;

//this holds 4 bearings - two on the outsides of the rail effector, and two at right angles to them.
//vertical_bearing();

//%arm_mounts();
//bearing_arm(35,3);
$fn=64;

//bearing_arm_hex(25);

//stacked_bearing(.01);

//right_angle(wall=4);

//%cylinder(r=13, h=10, center=true); 

in = 2;
//miniujoint(sep = .4, sphere=12, inset = in);
//ujointarm(sep = .4, sphere=12, inset = in, slop = .5);

//rotate([0,-45,0]) 
triplebearing();
triplebearingarm(sep = 2, sphere=9.5, inset = in, slop = .5);

module triplebearing(){
	bearing_rad = 5.2;
	bearing_thick = 4;
	wall = 3;

	offset = 0;

	bearing_sep = bearing_rad*2+wall+2.1-1.5;
	echo("Dist between bearings:",bearing_sep);

	translate([-offset,0,0]) 
	difference(){
		union(){
			//bar
			difference(){
				translate([offset,0,0]) rotate([90,0,0]){
					cylinder(r=bolt_rad-.25, h=bearing_sep+bearing_thick*2-1, center=true);
					cylinder(r=bearing_rad-1.75, h=bearing_sep, center=true);
				}
				rotate([0,90,0]) cylinder(r=bolt_cap_rad+.25, h=10);
			}

			//bearings
			rotate([0,90,0]) cylinder(r=bearing_sep/2, h=bearing_thick*2-1, center=true);
			//center bearing
			*rotate([0,90,0]) tiny_bearing(1,0,wall,1);
		}
		
		//center bearing cutout
		union(){
//			for(i=[0,1]) mirror([i,0,0])
				//translate([bearing_thick/2+wall/4,0,0]) 
				rotate([0,90,0]) tiny_bearing(0,0,wall,2,0);
		}

		//flatten
		translate([0,0,-bearing_sep-bolt_rad/2-.75]) cube([bearing_sep*2, bearing_sep*2, bearing_sep*2],center=true);
	}
}

module triplebearingarm(sep = 0, sphere = 10, slop=.25){
	bearing_rad = 5.2;
	bearing_thick = 4;
	wall = 3;

	offset = 0;

	height = bearing_rad*2+wall*2;

	bearing_sep = bearing_rad*2+wall+2.1-1.5;
	echo("Dist between bearings:",bearing_sep);//15.5 now

	width = bearing_rad*2+bearing_thick*2+sep*2;
	
	facets = 8;
	
	translate([0,0,height/2-flat])
	difference(){
		union(){
			//the bearings themselves
			hull(){
				for(i=[0,1]) mirror([0,i,0]){
					translate([0,bearing_sep/2+bearing_thick/2,0]) rotate([90,90,0]) tiny_bearing(1,1,wall-1,0);
					translate([-height*3/4,(bearing_sep+bearing_thick*2-height/2)/2,-height/4]) sphere(r=height/4, $fn=facets);
				}
	
				rotate([-90,0,0]) cylinder(r=height/2, h=bearing_sep+wall+bearing_thick*2, center=true);
	
				//translate([-height*3/4,0,-height/4]) rotate([90,0,0]) cylinder(r=height/4, h=bearing_sep+wall+bearing_thick*2, center=true);
			}

			//the arm grabber
			hull(){
				//sphere(r=sphere+slop);
				//translate([-bearing_sep/2,0,0]) sphere(r=sphere-2);
				//#translate([-height*3/4,0,-height/4]) rotate([90,0,0]) cylinder(r=height/4, h=bearing_sep+wall+bearing_thick*2, center=true);

				for(i=[0,1]) mirror([0,i,0])
					translate([-height*3/4,(bearing_sep+bearing_thick*2-height/2)/2,-height/4]) sphere(r=height/4, $fn=facets);
		
				//([wall,width+wall+.6,height/2], center=true);
			
				rotate([45,0,0]) translate([-rod_end_length/2-rod_end_gap,0,0]) cube([rod_end_length,rod_end_thickness+wall*2,rod_end_thickness+wall*2], center=true);
			}
		}

		for(i=[0,1]) mirror([0,i,0]){
			translate([0,bearing_sep/2+bearing_thick/2,0]) rotate([90,90,0]) tiny_bearing(0,1,wall,2);

			//make a zip tie slot
			*translate([0,bearing_sep/2+wall-.5,0]) rotate([90,0,0]) rotate_extrude(convexity = 10){
				translate([bearing_rad+1.5+.7, .5, 0]) scale([1,1]) rotate(a=30) circle(r=1, center=true, $fn=6);
				translate([bearing_rad+1.5+.7, -.5, 0]) scale([1,1]) rotate(a=30) circle(r=1, center=true, $fn=6);
			}
		}

		//hole for the arm
		rotate([45,0,0]) translate([-(rod_end_length+1)/2-rod_end_gap,0,0]) cube([rod_end_length+1,rod_end_thickness,rod_end_thickness], center=true);

		//hollow out the joint itself
		hull(){
			//translate([-bearing_sep/2,0,0]) 
			intersection(){
				sphere(r=sphere+slop);
				cube([width*2, sphere*2-4.5, width*2], center=true);
			}
			
			translate([-offset,0,0]) intersection(){
				sphere(r=sphere+slop);
				cube([width*2, sphere*2-4.5, width*2], center=true);
			}
			//translate([-bearing_sep/2,0,0]) sphere(r=sphere-2);
		}

		//cut off the back
		translate([width,0,0]) cube([width*2,width*2,width*2], center=true);

		//nut trap
		rotate([45,0,0]) translate([-rod_end_length+bolt_rad*2, 0, -rod_end_thickness/2-nut_height]){
			rotate([0,0,30]) cylinder(r=nut_rad, h=nut_height+.1, $fn=6);
			translate([0,nut_rad,0]) rotate([0,0,30]) cylinder(r=nut_rad, h=nut_height+.1, $fn=6);
			cylinder(r=bolt_rad, h=nut_height*3, center=true);
		}
	}

	//flatten the top and bottom
	for(i=[0,1]) mirror([0,0,i])
		translate([0,0,-height+1]) cube([200,200,height], center=true);

		//flatten the top and bottom
		for(i=[0,1]) mirror([0,0,i])
			translate([0,0,-height+flat]) cube([200,200,height], center=true);
	}
}

module ujointarm(sep = 0, sphere = 10, slop=.25){
	bearing_rad = 5.2;
	bearing_thick = 4;

	width = bearing_rad*2+bearing_thick*2+sep*2;

	difference(){
		union(){
			translate([-width/2-wall+1,0,0]) cube([width+wall*2, width+wall*2-inset*2, wall*2], center=true);
			translate([1,0,0]) rotate([90,0,0]) cylinder(r=wall, h=width+wall*2-inset*2, center=true);
		}

		//bolt hole
		rotate([90,0,0]) cylinder(r=bolt_rad, h=width*2, center=true);

		//nut trap
		for(i=[0,1]) mirror([0,i,0]) rotate([90,0,0]) rotate([0,0,0]) translate([0,0,width/2+slop/2-.01-inset]) cylinder(r=nut_rad, h=nut_height+.1, $fn=6);

		//hollow out the middle
		intersection(){
			sphere(r=sphere+slop);
			cube([width*2, width+slop-inset*2, width*2], center=true);
		}
	}
}

module miniujoint(sep=0, sphere=10, inset = 0){
	bearing_rad = 5.2;
	bearing_thick = 4;
	
	width = bearing_rad*2+bearing_thick*2+sep*2;
	height = bearing_rad*2-2-.2;

	rounding = 2;

	//%cube([width, width-4, wall*2], center=true);

	difference(){
		union(){
			intersection(){
				sphere(r=sphere);
				minkowski(){
					cube([width-rounding*2, width-rounding*2-inset*2, height], center=true);
					cylinder(r=rounding, h=.1, center=true);
				}
				echo("Square Size:",width);
			}
		}
	
		for(i=[0:90:359]){
			echo(inset*(i%180/90));
			rotate([0,0,i]) rotate([90,0,0]){
				translate([0,0,width/2-bearing_thick+.01+inset*(i%180/90-1)]) cylinder(r=bearing_rad, h=bearing_thick);
				translate([0,0,width/2-bearing_thick+.01+inset*(i%180/90-1)-1]) cylinder(r=bearing_rad-1, h=bearing_thick);
				translate([0,0,width/2-bearing_thick+.01+inset*(i%180/90-1)-1]) rotate([0,0,45]) cube([bearing_rad-1, bearing_rad-1, bearing_thick]);
				
				if(sep >= 3) translate([0,0,bearing_rad-nut_height+sep]) cylinder(r=nut_rad, h=nut_height+.1, $fn=6);
				cylinder(r=bolt_rad, h=bearing_rad+.1+sep);
			}
		}
	}
}

module right_angle(){
	offset = bearing_rad+bearing_width/2;
	difference(){
		union(){
			for(i=[0,90]){
				rotate([0,90,i]) translate([0,0,offset]){
					hex_bearing(1,0,wall);
					translate([+bearing_rad/2+wall/4,0,0]) cube([bearing_rad+wall/2,bearing_rad*2+wall,bearing_width+wall], center=true);
					rotate([0,0,90-i*2]) translate([+bearing_rad/2+wall/4,0,0]) cube([bearing_rad+wall/2,bearing_rad*2+wall,bearing_width+wall], center=true);
				}
			}
			//join the middle
			translate([offset,offset,-bearing_rad-wall/2]) rotate([0,0,180/36]) cylinder(r=(bearing_width/2+wall/2)/cos(180/36), h=bearing_rad*2+wall,$fn=36);
		}
		for(i=[0,90])
			rotate([0,90,i]) translate([0,0,offset])
					hex_bearing(0,0,wall);
	}
}

module stacked_bearing(clearance=10){
	difference(){
		union(){
			//hull(){
				//base bearing
				difference(){
					hex_bearing(1,1);
					translate([bearing_width/2+wall/2+10,0,0]) cube([20,bearing_rad*2+wall+1, 50],center=true);
				}
				translate([0,0,(bearing_rad+wall/2)*1.5+clearance]) rotate([0,90,0]) hex_bearing(1,0,wall);

				intersection(){
					translate([0,0,(bearing_width/2-wall/2+clearance+bearing_rad+wall/2)/2]) cube([bearing_width+wall, bearing_rad*2+wall*2, bearing_width+wall+clearance+bearing_rad+wall/2+.2],center=true);
					translate([0,0,-bearing_width/2-wall/2]) cylinder(r1=bearing_rad+wall+1, r2=bearing_rad+wall/2, h=50);
				}
			//}
		}

		//base bearing
		hex_bearing(0,1);
	
		translate([0,0,(bearing_rad+wall/2)*1.5+clearance]) rotate([0,90,0]) hex_bearing(0,0,wall);
		
		//vertical bearing insert path
		translate([0,0,(bearing_width/2-wall/2+clearance+bearing_rad+wall/2)/2-.1]) cube([bearing_width+.1, bearing_rad*2+.1, bearing_width+wall+clearance+bearing_rad+wall/2+.05],center=true);
	
		//bolt room for horizontal bearing
		hull(){
			translate([-10,0,bearing_width/2+wall/2]) cylinder(r1=bearing_rad/cos(30), r2=5, h=clearance, $fn=6);
			translate([10,0,bearing_width/2+wall/2]) cylinder(r1=bearing_rad/cos(30), r2=5, h=clearance, $fn=6);
		}
	}
}

module bearing_arm_hex(length=20){
	difference(){
		union(){
			for(i=[0, 1]){
				mirror([i,0,0]){
					hull(){
						translate([arm_sep/2+bearing_width/2,0,0]) rotate([0,90,0]) hex_bearing(1,0,wall); //vertical bearings
						translate([arm_sep/2+bearing_width/2,0,-wall/2]) cube([bearing_width+wall, bearing_rad*2+wall*1.75, wall], center=true); //add a little extra support for the lower arm
						difference(){
							translate([arm_sep/2-bearing_rad,length,0]) rotate([0,0,90]) hex_bearing(1,false); //horizontal bearings
							translate([arm_sep/2-wall-30,0,-25]) cube([30,50,50]);
						}
					}
					translate([arm_sep/2-bearing_rad,length,0]) rotate([0,0,90]) hex_bearing(1,false); //horizontal bearings
				}
			}
	
			//join the bearings
			front_joint(length);

		}
		for(i=[0, 1]){
			mirror([i,0,0]){
				translate([arm_sep/2+bearing_width/2,0,0]) rotate([0,90,0]) hex_bearing(0,0); //vertical bearings
				translate([arm_sep/2-bearing_rad,length,0]) rotate([0,0,90]) hex_bearing(0,1); //horizontal bearings
			}
		}

		//clearance for the cones
		difference(){
			scale([1.05,1.2,1.2]) arm_mounts();
			for(i=[0,1]) mirror([i,0,0]) translate([arm_sep/2+bearing_width/2,0,-wall/2]) cube([bearing_width+wall, bearing_rad*2+wall*1.75, wall], center=true);
		}

		//flatten the base
		translate([0,0,-arm_sep/2-wall/2-bearing_width/2]) cube([arm_sep*2, arm_sep, arm_sep], center=true);
	}
}

module front_joint(length){
	hex_rad = 3.4;
	difference(){
		translate([0,length,0]) scale([arm_sep/(bearing_rad+wall/2)/2,.9,1]) cylinder(r=bearing_rad+wall/2, h=bearing_width+wall, center=true);

		translate([0,length,0]) scale([arm_sep/(bearing_rad+wall/2)/2-2,.7,1.1]) cylinder(r=bearing_rad+wall/2, h=bearing_width+wall, center=true);

	}
}

module bearing_arm(distance = 30, angle = 10){
	min_thick = (bearing_width+wall/2+wall/4+lock_lip)/2-1;
	//this places it for printing.
	translate([0,0,tan(angle)*30+min_thick])
	rotate([-angle,0,0])
	
	difference(){
		intersection(){
			//bearing mounts
			union(){
				for(i=[0,1]) mirror([i,0,0]) {
					translate([arm_sep/2,0,0]) vertical_bearing(1,1);
					translate([arm_sep/2-bearing_width,distance-bearing_rad-wall/2,-bearing_width/2]) bearing(1, 0);
					echo("Distance Between Centers", (distance-bearing_rad-wall/2));
					hull(){
						render() intersection(){
							union(){
								translate([arm_sep/2-wall/2,0,0]) rotate([0,90,0]) cylinder(r=bearing_rad+wall/2,h=bearing_width+wall/2-.25);
								translate([arm_sep/2-bearing_width,distance-bearing_rad-wall/2,-bearing_width/2-wall/2]) difference(){
									cylinder(r=bearing_rad+wall/2,h=bearing_width+wall/2);
									translate([0,0,-.5]) cylinder(r=bearing_rad,h=bearing_width+wall/2+1);
								}
							}
							translate([arm_sep/2+bearing_width/2+wall/4-wall/2,distance/2-bearing_rad-wall/2,0]) cube([bearing_width+wall/2, distance+3, distance], center=true);
						}
					}
				}
				
				//connect the two sides together
				difference(){
					translate([0,(distance-bearing_rad-wall/2)/2,-min_thick-wall/4]) cube([arm_sep, distance, 14.5], center=true);
					rotate([0,90,0]) cylinder(r=bearing_rad+wall/2, h=arm_sep+1, center=true);
				}
			}

			//slice
			rotate([0,90,0]) intersection(){
				//translate([-min_thick,distance,0]) rotate([0,0,45-angle]) translate([0,-distance,0]) cylinder(r=distance, h=arm_sep*2, center=true, $fn=4);
				translate([min_thick,distance,0]) rotate([0,0,-45+angle]) translate([0,-distance,0]) cylinder(r=distance, h=arm_sep*2, center=true, $fn=4);
			}
		}
	
		for(i=[0,1]) mirror([i,0,0]) {
			//cut out the bearings
			translate([arm_sep/2,0,0]) vertical_bearing(0);
			translate([arm_sep/2-bearing_width,distance-bearing_rad-wall/2,-bearing_width/2]) bearing(0);

			//cinch gaps for the front bearings
			translate([0,(distance-bearing_rad-wall/2+distance)/2,-min_thick-wall/4+14.5/4]) scale([arm_sep-bearing_width*2,14.5/2,arm_sep/2]) sphere(r=.5);
		}
	}
}

module vertical_bearing(solid=1, rim=1){	
	rotate([0,90,0])
	bearing(solid, rim);
}

module bearing(solid=1, rim=1){
	translate([0,0,-wall/2])
	if(solid){
		union(){
			cylinder(r=bearing_rad+wall/2, h=bearing_width+wall/2);
			if(rim){
				translate([0,0,bearing_width+wall/2]) rotate_extrude(convexity = 10){
				
					translate([bearing_rad+wall/4-lock_lip, 0, 0])	circle(r = wall/4+lock_lip);
				}
			}
		}
	}else{
		//hollow out the center
		cylinder(r=bearing_rim, h=30, center=true);
		translate([0,0,wall/2]) cylinder(r=bearing_rad/(cos(180/$fn)), h=bearing_width+.01);
		//make a zip tie slot
		translate([0,0,bearing_width/2+wall/2-lock_lip]) rotate_extrude(convexity = 10){
			translate([bearing_rad+wall/2+.5, .5, 0]) scale([1,1]) rotate(a=30) circle(r=1, center=true, $fn=6);
			translate([bearing_rad+wall/2+.5, -.5, 0]) scale([1,1]) rotate(a=30) circle(r=1, center=true, $fn=6);
		}
	}
}

//trying to make a bearing mount that works with half of a bearing
module hex_bearing(solid=1, vertical=1, wall = 5){
	if(solid){
		union(){
			//bearing surround, with room for supports
			cylinder(r=(bearing_rad+wall/2), h=bearing_width+wall, center=true);
		}
	}else{
		//hollow out the center
		hull(){
			cylinder(r=bearing_rad/(cos(180/$fn)), h=bearing_width+.02, center=true);
			translate([bearing_rad*2,0,0]) cylinder(r=bearing_rad/(cos(180/$fn)), h=bearing_width+.02, center=true);
		}

		if(vertical){
			rotate([0,0,30]) cylinder(r=bearing_rad+rim, h=bearing_width+wall+.01, center=true, $fn=6);
			translate([0,0,(bearing_width+wall+.01)/4]) hull(){
				rotate([0,0,30]) cylinder(r=bearing_rad+rim, h=(bearing_width+wall+.01)/2, center=true, $fn=6);
				translate([bearing_rad,0,0]) rotate([0,0,30]) cylinder(r=bearing_rad+rim, h=(bearing_width+wall+.01)/2, center=true, $fn=6);
			}
		}else{
			translate([0,0,-(bearing_width+.02)/2]) rotate([0,0,90+45]) cube([bearing_rad, bearing_rad,bearing_width+.02]);
			difference(){
				rotate([0,0,30]) cylinder(r=bearing_rad+rim, h=bearing_width+wall+.01, center=true, $fn=6);
				//translate([bearing_width,0,0]) cube([wall/2,bearing_rad*2,bearing_rad*2], center=true);
			}
		}

		//make a zip tie slot
		rotate_extrude(convexity = 10){
			translate([bearing_rad+wall/2+.8, .6, 0]) scale([1,1]) rotate(a=30) circle(r=1.2, center=true, $fn=6);
			translate([bearing_rad+wall/2+.8, -.6, 0]) scale([1,1]) rotate(a=30) circle(r=1.2, center=true, $fn=6);
		}
	}
}




module tiny_bearing(solid=1, vertical=1, wall = 5, zip=1, insert=1){
	bearing_rad = 5.2;
	bearing_width = 4;

	if(solid){
		union(){
			//bearing surround, with room for supports
			cylinder(r=(bearing_rad+wall/2), h=bearing_width+wall, center=true);
		}
	}else{
		//hollow out the center
		hull(){
			cylinder(r=bearing_rad/(cos(180/$fn)), h=bearing_width+.02, center=true);
			if(insert) if(!vertical) translate([bearing_rad*2,0,0]) cylinder(r=bearing_rad/(cos(180/$fn)), h=bearing_width+.02, center=true);
		}

		if(vertical){
			rotate([0,0,0]) cylinder(r=bearing_rad+rim, h=bearing_width+wall+.1, center=true, $fn=4);
		
			intersection(){
				translate([0,0,-(bearing_width+.02)/2]) rotate([0,0,90+45]) cube([bearing_rad, bearing_rad,bearing_width+.02]);
				translate([-.5,-bearing_rad,-(bearing_width+.02)/2]) rotate([0,0,90]) cube([bearing_rad*2, bearing_rad,bearing_width+.02]);
			}

			*translate([0,0,(bearing_width+wall+.01)/4]) hull(){
				rotate([0,0,0]) cylinder(r=bearing_rad+rim, h=(bearing_width+wall+.01)/2, center=true, $fn=4);
				translate([bearing_rad,0,0]) rotate([0,0,0]) cylinder(r=bearing_rad+rim, h=(bearing_width+wall+.01)/2, center=true, $fn=4);
			}
		}else{
			intersection(){
				translate([0,0,-(bearing_width+.02)/2]) rotate([0,0,90+45]) cube([bearing_rad, bearing_rad,bearing_width+.02]);
				translate([-.5,-bearing_rad,-(bearing_width+.02)/2]) rotate([0,0,90]) cube([bearing_rad*2, bearing_rad,bearing_width+.02]);
			}
			difference(){
				rotate([0,0,0]) cylinder(r=bearing_rad+rim, h=bearing_width+wall+.01, center=true, $fn=4);
				//translate([bearing_width,0,0]) cube([wall/2,bearing_rad*2,bearing_rad*2], center=true);
			}
			//flay the edges a bit
			for(i=[0,1]) mirror([0,0,i])
				rotate([0,0,90]) translate([0,0,bearing_width/2-.5]) cylinder(r1=bolt_rad, r2=bolt_cap_rad, h=bolt_cap_rad/2);
		}

		//make a zip tie slot
		if(zip==1){
			rotate_extrude(convexity = 10){
				translate([bearing_rad+1.5+.4, .5, 0]) scale([1,1]) rotate(a=30) circle(r=1, center=true, $fn=6);
				translate([bearing_rad+1.5+.4, -.5, 0]) scale([1,1]) rotate(a=30) circle(r=1, center=true, $fn=6);
			}
		}

		if(zip==2){
			for(i=[0,1]){
				mirror([0,i,0]) translate([0, bearing_rad+wall/2, 0]) cube([20,1.5,3], center=true);
			}
		}
	}
}
