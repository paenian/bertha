include <configuration.scad>;

rail_width=25.4649;
v_rad = 9.77;
arm_sep = 70;

hotend_rad = 8;
hotend_groove_rad=6;

rod_end_thickness = 8;

//translate([0,0,65]) cube([40,40,10],center=true);
//translate([0,36,20]) cube([40,10,40],center=true);

$fn=36;
height = 40;
radius = 40;
extruder_rad = 25;
center_rad = 15;
igus_rad = 6/2;
shroud_height = 40;	//height of fan shroud.  Adjust based on extruder.

//%translate([0,0,0]) cylinder(r=extruder_rad, h=1);
%rotate([0,0,30]) cylinder(r=center_rad/cos(60), h=1, $fn=3);


//rail_effector();
//adjustable_wheel();
//hotend_effector();
//translate([0,33,0])
//hotend_clamp();
//translate([0,-33,0]) rod_end();

module hotend_effector(){
	difference(){
		union(){
			//body
			//hexamid();

			//arms
			for(i=[0:120:359]) rotate([0,0,i])
				translate([0,radius,height]) arm_mounts_outer(1);

			//arm supports
			for(i=[0:120:359]) rotate([0,0,i])
				//translate([0,-radius,0]) rotate([30,0,0]) ybar(6.9, height+9);
				translate([0,-radius,0]) rotate([30,0,0]) translate([0,0,-.5]) ybar(13, height+6);


			//extruder mounts
			for(i=[0:120:359]) rotate([0,0,i])
				translate([0,extruder_rad,0]) extruder_mount(1);

			//fan diverter
			fan_shroud();

			//anchor
			#for(i=[0:120:359]) rotate([0,0,i])
				translate([-wall/4,0,0]) cube([wall/2,extruder_rad/2,wall/2]);
		}

		//arms
		for(i=[0:120:359]) rotate([0,0,i])
			translate([0,radius,height]) arm_mounts_outer(0);

		//extruder mounts
		for(i=[0:120:359]) rotate([0,0,i])
			translate([0,extruder_rad,0]) extruder_mount(0);

		//clean up the bottom
		translate([0,0,-50]) cube([100,100,100],center=true);
	}
}

body_rad = 60;

module hexamid(){
	difference(){
		union(){
			rotate([0,0,30]) cylinder(r1=body_rad/cos(180/6), r2=center_rad/cos(180/6), h=height-wall, $fn=6);
		}

		for(i=[90:120:359]){
			rotate([0,0,i]) translate([body_rad/cos(180/6)+wall*1.5,0,-.1]) rotate([0,0,180/12]) cylinder(r=body_rad/cos(180/12), h=height+2, $fn=12);
		}

		//translate([0,0,-wall]) rotate([0,0,-30]) cylinder(r1=body_rad/cos(180/3), r2=0, height, $fn=3);
		#translate([0,0,0]) sphere(r=36, $fn=36);

		rotate([0,0,30]) cylinder(r=center_rad/2+wall, h=100, $fn=3);
	}
}

mount_height = 15;
mount_width = 75;

module extruder_mount(solid = 1){
	if(solid){
		translate([-mount_width/2,-wall*2,0]) cube([mount_width,wall*2,mount_height]);
		cylinder(r=hotend_rad+wall, h=mount_height, $fn=18);
	}else{
		union(){
			//shore up the front
			translate([-mount_width/4,.01,-.1]) cube([mount_width/2,wall*3,mount_height+1]);

			//hotend hole
			translate([0,0,-.1]) cylinder(r=hotend_rad/cos(180/18), h=mount_height+1, $fn=36);
			%translate([0,0,0]) cylinder(r=2, h=50);

			//bolt slots
			render() for(i=[0,1]) mirror([i,0,0]){
				translate([hotend_rad+bolt_dia,0,mount_height/2]) rotate([-90,0,0]) cylinder(r=bolt_rad, h=wall*3, center=true);
				translate([hotend_rad+bolt_dia,-wall*2-.1,mount_height/2]) rotate([-90,0,0]) cylinder(r=nut_rad, h=nut_height+.2, $fn=6);

				//translate([hotend_rad+bolt_dia,0,mount_height]) rotate([-90,0,0]) cylinder(r=bolt_rad, h=wall*2, center=true);
				//translate([hotend_rad+bolt_rad,-wall*2/2,mount_height/2]) cube([bolt_dia,wall*2+.02,mount_height/2]);

				//translate([hotend_rad+bolt_dia,0,mount_height]) cube([nut_dia,nut_height+.2,mount_height+nut_dia], center=true);
			}
		}
	}
}

module ybar(size = wall*2, height = height){
	difference(){
		rotate([0,0,30]) cylinder(r=size, h=height, $fn=6);
		for(i=[60:120:359]) rotate([0,0,i]) translate([0,size+wall,-.1]) rotate([0,0,30]) cylinder(r=size, h=height+.2, $fn=6);
		for(i=[0:120:359]) rotate([0,0,i]) translate([0,size+wall,height/3]) scale([1,1,2.25]) sphere(r=size);
	}
//	rotate([0,0,-30]) difference(){
//		cylinder(r=size/cos(60), h = height, $fn=3);
//		for(i=[-30:120:359]) rotate([0,0,i]) translate([0,size,-.1]) rotate([0,0,30]) cylinder(r=size/2, h=height+.2,$fn=36);
//	}
}

module fan_shroud(){
	difference(){
		union(){
			for(i=[0:120:359]){
				rotate([0,0,i]) translate([0,center_rad+1,0]) scale([1.3,1,shroud_height/center_rad]) sphere(r=center_rad+1);
			}
		}
		
		for(i=[0:120:359]) rotate([0,0,i]) translate([0,center_rad+1,-.1]) {
			scale([1.3,1,shroud_height/center_rad]) sphere(r=center_rad);
			translate([-30,0,0]) cube([60,30,60]);
		}

		//cut off the bottom
		translate([0,0,-50]) cube([100,100,100], center=true);
	}
}

bracket_height = 15;
bracket_thick = wall*2;
bracket_width = 40;

pushfit_dia = 10;
pushfit_rad = pushfit_dia/2;
pushfit_thread_dia = 6;
pushfit_thread_rad = pushfit_thread_dia/2;

groove_height = 4.4; //dec
groove_rad = 6;
groove_top = 5.1; //dec

//holds the extruder on
module hotend_clamp(){

	difference(){
		union(){
			//hotend block
			translate([0,0,bracket_thick/2]) cube([bracket_width, bracket_height, bracket_thick], center=true);
			//pushfit connector   //dec
			difference () {
				translate([0,bracket_height/2,0]) {
					translate([0,pushfit_rad/2,(bracket_thick+pushfit_rad+wall)/2+.5]) cube([bracket_width, pushfit_rad, bracket_thick+pushfit_rad+1+wall], center=true);
					translate([0,pushfit_rad/2,bracket_thick+1]) rotate([90,0,0]) cylinder(r=pushfit_rad+wall*2/2, h=pushfit_rad, center=true);
				}
				rotate ([90,0,0]) translate ([0,16,-15]) obloid_thingy();
			}
		}

		//pushfit hole
		translate([0,bracket_height/2,bracket_thick+1]) rotate([90,0,0]) cylinder(r=pushfit_rad, h=15, center=true, $fn=72);

		//hotend hole
		difference(){
			translate([0,0,bracket_thick+1]) rotate([90,0,0]) cylinder(r=hotend_rad, h=bracket_height, center=true, $fn=72);
			//groove slot
			translate([0,bracket_height/2-groove_top-groove_height/2,bracket_thick+1]) rotate([90,0,0]) difference() {
				cylinder(r=hotend_rad, h=groove_height, center=true, $fn=72);
				cylinder(r=groove_rad, h=groove_height+.2, center=true, $fn=72);
			}
		}
		translate([0,bracket_height/2,bracket_thick+1]) rotate([90,0,0]) cylinder(r=hotend_rad+1, h=.5);
		

		//bolt slots
		render() for(i=[0,1]) mirror([i,0,0]){
			translate([hotend_rad+bolt_dia,bracket_height/4,bracket_thick/2]) cylinder(r=bolt_rad, h=bracket_thick+1, center=true);
			translate([hotend_rad+bolt_dia,-bracket_height/4,bracket_thick/2]) cylinder(r=bolt_rad, h=bracket_thick+1, center=true);
			translate([hotend_rad+bolt_rad,-bracket_height/4,-.5]) cube([bolt_dia,bracket_height/2,bracket_thick+1]); 
		}
	}
}
module obloid_thingy (){ //dec
	union() {
		difference () {
			translate ([-pushfit_rad*6,0,0]) cube ([pushfit_rad*12,pushfit_rad*4,10]);	
			translate ([0,-pushfit_rad,0]) cylinder (r=pushfit_rad+wall*2/2, h=10);			
			//translate ([pushfit_rad*2,0,0]) cylinder (r1=pushfit_rad,r2=pushfit_rad,h=10);		
			//translate ([-pushfit_rad*3,0,0]) cylinder (r1=pushfit_rad,r2=pushfit_rad,h=10);	
		}
		union () {

			hull () {
				translate ([3*pushfit_rad-1.2,0,0]) cylinder (r1=pushfit_rad,r2=pushfit_rad,h=10);
				translate ([6*pushfit_rad,0,0]) cylinder (r1=pushfit_rad,r2=pushfit_rad,h=10);
			}	
			hull () {
				translate ([-3*pushfit_rad+1.3,0,0]) cylinder (r1=pushfit_rad,r2=pushfit_rad,h=10);
				translate ([-6*pushfit_rad,0,0]) cylinder (r1=pushfit_rad,r2=pushfit_rad,h=10);
			}
		}
	}
}

bio_rad = 96;
module biohazard(){
	difference(){
		for(i=[0:120:359]) rotate([0,0,i]){
			intersection(){
				translate([0,bio_rad,0]) cylinder(r=bio_rad, h=wall*2, $fn=64);
				cylinder(r=62, h=wall*2, $fn=64);
			}
		}
		for(i=[0:120:359]) rotate([0,0,i]){
			translate([0,bio_rad+wall*3,-.1]) cylinder(r=bio_rad-wall, h=wall*2+.2, $fn=64);
		}
	}
}

module rail_effector(){
	difference(){
		union(){
			//v wheels
			%translate([-rail_width/2-v_rad,0,0]) adjustable_wheel();
			adjustable_wheel_mount(1);

			for(i=[0,1]) mirror([0,i,0]) translate([rail_width/2+v_rad,(rail_width+v_rad*2)/sqrt(3),0]) wheel_mount(1);

			//arms
			translate([0,radius-.5,0]) arm_mounts(1);

			//belt mount
			for(i=[0,1]) mirror([0,i,0]) translate([8,(rail_width/2+v_rad+8)/sqrt(3),0]) belt_mount(1);

			//connect everything up
			rail_body();
		}

		//holes for everything
		//v wheels
		//translate([-rail_width/2-v_rad,0,0]) wheel_mount(0);
		adjustable_wheel_mount(0);
		for(i=[0,1]) mirror([0,i,0]) translate([rail_width/2+v_rad,(rail_width+v_rad*2)/sqrt(3),0]) wheel_mount(0);

		//arms
		translate([0,radius-.5,0]) arm_mounts(0);

		//belt mount
		for(i=[0,1]) mirror([0,i,0]) translate([8,(rail_width/2+v_rad+8)/sqrt(3),0]) belt_mount(0);
	}
}

slider_offset=6.5;

module adjustable_wheel(){
	difference(){
		union(){
			wheel_mount(1);
			intersection(){
				translate([0,0,wall]) rotate([0,90,0]) cylinder(r=v_rad/cos(45)-.5, h=16, center=true, $fn=4);
				translate([0,0,wall]) cube([20,30,wall*2],center=true);
				translate([9,0,0]) cylinder(r=18, h=30, $fn=6);
			}
		}
		wheel_mount(0);
		for(i=[0,1]) mirror([0,i,0]) {
			translate([-9,slider_offset,wall]) rotate([0,90,0]) cylinder(r=bolt_rad, h=20);
			translate([-13,slider_offset,wall]) rotate([0,90,0]) cylinder(r=bolt_cap_rad+.5, h=8);
		}
	}
}

gap = 2;
module adjustable_wheel_mount(solid = 1){
	if(solid){
		//beef up the slot
		intersection(){
			translate([-radius/2-rail_width/2+gap+wall*2,0,wall]) rotate([0,90,0]) cylinder(r=v_rad/cos(45)+wall/cos(45), h=radius, center=true, $fn=4);
			translate([-radius/2-rail_width/2+gap+wall*2,0,wall]) cube([radius, radius, wall*2],center=true);
			cylinder(r=radius-rounding/cos(30), h=wall*2, $fn=6);
		}
		translate([-rail_width/2+gap-.02+wall+nut_height/2,0,wall+1-.1]) cube([nut_height,30,2],center=true);
	}else{
		//slot
		translate([-radius/2-rail_width/2+gap,0,wall]) rotate([0,90,0]) cylinder(r=v_rad/cos(45), h=radius, center=true, $fn=4);

		//bolt holes
		for(i=[0,1]) mirror([0,i,0]) {
			translate([-rail_width/2+gap/2-.01,slider_offset,wall]) rotate([0,90,0]) cylinder(r=bolt_rad, h=wall*2);
			translate([-rail_width/2+gap/2-.02+wall+nut_height,slider_offset,wall]) rotate([0,90,0]) cylinder(r=nut_rad, h=wall-1, $fn=6);
			translate([-rail_width/2+gap/2-.02+wall+nut_height,slider_offset,wall+nut_rad]) rotate([0,90,0]) cylinder(r=nut_rad, h=wall, $fn=6);
		}
	}
}

rounding = wall/2;

module rail_body(){
	//backbone
	minkowski(){
		union(){
			difference(){
				cylinder(r=radius-rounding/cos(30), h=wall-rounding, $fn=6);
				cylinder(r=radius-rounding/cos(30)-wall/cos(30), h=wall-rounding+.1, $fn=6);
			}
			translate([0,0,wall-rounding]) difference(){
				cylinder(r=radius-(rounding+2.45)/cos(30), h=wall-rounding, $fn=6);
				cylinder(r=radius-(rounding+2.55)/cos(30), h=wall-rounding+.1, $fn=6);
			}
		}
		intersection(){
			sphere(r=rounding, $fn=12);
			translate([0,0,wall]) cube([wall*2, wall*2, wall*2], center=true);
		}
	}
}

module belt_mount(solid = 1){
	if(solid){
		cylinder(r=v_rad, h=wall);
		translate([0,0,wall]) cylinder(r1=v_rad, r2=bolt_cap_rad, h=nut_height+1);
	}else{
		translate([0,0,-.01]) cylinder(r=nut_rad, h=nut_height, $fn=6);
		translate([0,0,nut_height+.3]) cylinder(r=bolt_rad, h=wall+1);
	}
}

module wheel_mount(solid = 1){
	if(solid){
		cylinder(r=v_rad-2, h=wall);
		translate([0,0,wall]) cylinder(r1=v_rad-2, r2=8/2, h=10);
	}else{
		translate([0,0,-.01]) cylinder(r=nut_rad, h=nut_height*2, $fn=6);
		translate([0,0,nut_height*2+.3]) cylinder(r=bolt_rad, h=20);
	}
}

arm_rad = wall*1.75;
//45 degrees: (arm_rad-igus_rad)
//60 degrees: (arm_rad-igus_rad)/sqrt(3);
cone_height = (arm_rad-igus_rad);
echo(cone_height);

module arm_mounts(solid = 1){
	translate([0,0,wall]) rotate([0,90,0])
	if(solid){
		cylinder(r=arm_rad, h=arm_sep-cone_height*2, center=true, $fn=12);
		for(i=[0,1]) mirror([0,0,i]) translate([0,0,arm_sep/2-cone_height]) cylinder(r1=arm_rad, r2=igus_rad, h=cone_height, $fn=12);
	}else{
		//nut slot
		translate([0,0,-.01]) cylinder(r=nut_rad, h=arm_sep-cone_height*2, center=true, $fn=6);
		translate([nut_rad,0,-.01]) cylinder(r=nut_rad, h=arm_sep-cone_height*2, center=true, $fn=6);
		cylinder(r=bolt_rad, h=arm_sep+wall, center=true);

		//flatten the bottom
		translate([wall+10,0,0]) cube([20,25,arm_sep],center=true);

		//make sure the rod can't hit anything
		#render() for(i=[0,1]) mirror([0,0,i]) translate([0,0,arm_sep/2+rod_end_thickness/2]) rod_end_sweep();
	}
}

module rod_end_sweep(){
	#difference(){
		sphere(r=9.5, $fn=36);
		for(i=[0,1]) mirror([0,0,i]) translate([0,0,rod_end_thickness/2-.1]) cylinder(r1=igus_rad, r2=36, h=((36-igus_rad)/2)/sqrt(3),$fn=12);
	}
}

module arm_mounts_outer(solid = 1){
	translate([0,0,0]) rotate([0,90,0])
	if(solid){
		for(i=[0,1]) mirror([0,0,i]) translate([0,0,arm_sep/2+rod_end_thickness]){
			cylinder(r2=arm_rad, r1=igus_rad, h=cone_height, $fn=18);
			translate([0,0,cone_height]) cylinder(r=arm_rad, h=cone_height, $fn=18);
			translate([0,0,cone_height*2]) sphere(r=arm_rad, $fn=18);
		}
	}else{
		for(i=[0,1]) mirror([0,0,i]) translate([0,0,arm_sep/2+rod_end_thickness]){
			render() translate([0,0,-rod_end_thickness/2]) rod_end_sweep();
			translate([0,0,-.1]) cylinder(r=bolt_rad, h=wall*3);
			translate([0,0,wall+arm_rad]) cylinder(r=nut_rad, h=wall*3, $fn=6);
		}

		//flatten the bottom
		//translate([wall+10,0,0]) cube([20,25,arm_sep*2],center=true);
	}
}

rod_size = 8.4;
taper = 4;
module rod_end(){
	translate([0,0,rod_size*cos(30)-1]) rotate([90+taper,0,0])
	difference(){
		cylinder(r=rod_size, h=40, $fn=6);

		//taper
		for(i=[0:1]) mirror([0,i,0]) translate([-10,rod_size*cos(30)-1,0]) rotate([taper,0,0]) translate([0,0,-1]) cube([20,10,50]);

		//carbon fiber hole
		translate([0,0,-.01]) rotate([0,0,45]) cylinder(r=rod_size/2/cos(180/4), h=20, $fn=4);

		//nut hole
		translate([0,0,22.5]){
			cylinder(r=bolt_rad, h=20);
			cylinder(r1=nut_rad+1, r2=nut_rad, h=15, $fn=6);
			translate([0,0,7.5]) cube([nut_rad+1,20,15],center=true);
		}
	}
}
