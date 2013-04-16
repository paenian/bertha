include <configuration.scad>;

rail_width=25.4649;
v_rad = 9.77;
arm_sep = 60;

hotend_rad = 12;


rod_end_thickness = 8;

//%cube([rail_width,100,wall],center=true);

radius=36;
%cylinder(r=30, h=40);

//rail_effector();
//adjustable_wheel();

hotend_effector();

module hotend_effector(){
	difference(){
		union(){
			//body
			//biohazard(1);

			hexamid();

			//arms
			for(i=[0:120:359]) rotate([0,0,i]){
				translate([0,radius,0]) arm_mounts_outer(1);
			}

			//extruder mounts
			for(i=[0:120:359]) rotate([0,0,i]){
				//translate([0,16.666,25]) extruder_mount(1);
			}
		}

		//arms
		for(i=[0:120:359]) rotate([0,0,i]){
			translate([0,radius,0]) arm_mounts_outer(0);
		}

		//extruder mounts
		for(i=[0:120:359]) rotate([0,0,i]){
			translate([0,16.666,25]) extruder_mount(0);
		}
	}
}

body_rad = 60;
center_rad = 36;
height = 50;
module hexamid(){
	difference(){
		union(){
			rotate([0,0,30]) cylinder(r1=body_rad/cos(180/6), r2=center_rad/cos(180/6), h=height, $fn=6);
		}

		for(i=[90:120:359]){
			rotate([0,0,i]) translate([body_rad/cos(180/6)+wall*1.5,0,-.1]) rotate([0,0,180/12]) cylinder(r=body_rad/cos(180/12), h=height+2, $fn=12);
		}

		translate([0,0,-wall]) rotate([0,0,-30]) cylinder(r1=body_rad/cos(180/3), r2=0, height, $fn=3);
	}
}

module extruder_mount(solid = 1){
	if(solid){
		translate([-65/2,-wall,0]) cube([65,wall*2,30]);
	}else{
		translate([0,wall,.3]) cylinder(r=hotend_rad, h=90, center=true);
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
			//-rail_width/2-v_rad-8;
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
		//-rail_width/2-v_rad-8;
		for(i=[0,1]) mirror([0,i,0]) translate([8,(rail_width/2+v_rad+8)/sqrt(3),0]) belt_mount(0);
	}
}

slider_offset=6.5;

module adjustable_wheel(){
	difference(){
		union(){
			wheel_mount(1);
			intersection(){
				translate([0,0,wall]) rotate([0,90,0]) cylinder(r=v_rad/cos(45)-.5, h=20, center=true, $fn=4);
				translate([0,0,wall]) cube([20,30,wall*2],center=true);
				translate([9,0,0]) cylinder(r=18, h=30, $fn=6);
			}
		}
		wheel_mount(0);
		for(i=[0,1]) mirror([0,i,0]) {
			translate([-9,slider_offset,wall]) rotate([0,90,0]) cylinder(r=bolt_rad, h=20);
			translate([-11,slider_offset,wall]) rotate([0,90,0]) cylinder(r=bolt_cap_rad, h=8);
		}
	}
}
gap = 2;
module adjustable_wheel_mount(solid = 1){
	if(solid){
		//beef up the slot
		//translate([wall,0,0])
		intersection(){
			translate([-radius/2-rail_width/2+gap+wall*2,0,wall]) rotate([0,90,0]) cylinder(r=v_rad/cos(45)+wall/cos(45), h=radius, center=true, $fn=4);
			translate([-radius/2-rail_width/2+gap+wall*2,0,wall]) cube([radius, radius, wall*2],center=true);
			cylinder(r=radius-rounding/cos(30), h=wall*2, $fn=6);
		}
		translate([-rail_width/2+gap-.02+wall+nut_height/2,0,wall+1-.1]) cube([nut_height,30,2],center=true);

	}else{
		//slot
		translate([-radius/2-rail_width/2+gap/2,0,wall]) rotate([0,90,0]) cylinder(r=v_rad/cos(45), h=radius, center=true, $fn=4);
	
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
	//difference(){
	//	cylinder(r=body_rad/cos(60), h=wall, $fn=6);
	//	for(i=[0:60:359]) rotate([0,0,i]) translate([0,(body_rad-wall)/cos(60)-2*wall,-.1]) rotate([0,0,30]) cylinder(r=wall/cos(60), h=wall+.2, $fn=3);
	//}

	//translate([7.3,0,0]) cylinder(r=rail_width/cos(30), h=wall*3, $fn=6);

	//backbone
	//translate([0,0,wall/2]) cube([rail_width,arm_sep,wall],center=true);
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
		translate([0,0,-.01]) cylinder(r=nut_rad, h=nut_height, $fn=6);
		translate([0,0,nut_height+.3]) cylinder(r=bolt_rad, h=20);
	}
}

arm_rad = wall*1.75;

module arm_mounts(solid = 1){
//	%cube([arm_sep,1,30], center=true);
	translate([0,0,wall]) rotate([0,90,0])
	if(solid){
		cylinder(r=arm_rad, h=arm_sep-wall*4, center=true);
		for(i=[0,1]) mirror([0,0,i]) translate([0,0,arm_sep/2-wall*2]) cylinder(r1=arm_rad, r2=bolt_cap_rad, h=wall*2);
	}else{
		//nut slot
		translate([0,0,-.01]) cylinder(r=nut_rad, h=arm_sep-wall*4, center=true, $fn=6);
		translate([nut_rad,0,-.01]) cylinder(r=nut_rad, h=arm_sep-wall*4, center=true, $fn=6);
		cylinder(r=bolt_rad, h=arm_sep+wall, center=true);

		//flatten the bottom
		translate([wall+10,0,0]) cube([20,25,arm_sep],center=true);

		//cut out for the rail itself
		//translate([-arm_rad,0,0]) rotate([90,0,0]) scale([wall/rail_width,1,1]) cylinder(r=rail_width, h=arm_rad*2-2, center=true);
	}
}

module arm_mounts_outer(solid = 1){
//	%cube([arm_sep,1,30], center=true);
	translate([0,0,wall]) rotate([0,90,0])
	if(solid){
		for(i=[0,1]) mirror([0,0,i]) translate([0,0,arm_sep/2+rod_end_thickness]){
			cylinder(r2=arm_rad, r1=bolt_cap_rad, h=wall*2);
			translate([0,0,wall*2]) sphere(r=arm_rad);
		}

	}else{
		for(i=[0,1]) mirror([0,0,i]) translate([0,0,arm_sep/2+rod_end_thickness]){
			translate([0,0,-.1]) cylinder(r=bolt_rad, h=wall*3);
			translate([0,0,wall+arm_rad]) cylinder(r=nut_rad, h=wall*3, $fn=6);
		}

		//flatten the bottom
		translate([wall+10,0,0]) cube([20,25,arm_sep*2],center=true);
	}
}
