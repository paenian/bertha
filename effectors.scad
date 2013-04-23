include <configuration.scad>;

rail_width=25.4649;
v_rad = 9.77;
arm_sep = 60;

hotend_rad = 8;
hotend_groove_rad=6;

rod_end_thickness = 8;

%translate([0,0,65]) cube([40,40,10],center=true);
%translate([0,36,20]) cube([40,10,40],center=true);

radius = 36;
extruder_rad = 18;
center_rad = 42;

//%translate([0,22.5,0]) cylinder(r=hotend_rad, h=50);


//rail_effector();
//adjustable_wheel();
hotend_effector();
//translate([0,33,25])
//extruder_bracket();

module hotend_effector(){
	difference(){
		union(){
			//body
			hexamid();

			//arms
			for(i=[0:120:359]) rotate([0,0,i])
				translate([0,radius,0]) arm_mounts_outer(1);

			//extruder mounts
			for(i=[0:120:359]) rotate([0,0,i])
				translate([0,extruder_rad,30]) extruder_mount(1);
		}

		//arms
		for(i=[0:120:359]) rotate([0,0,i])
			translate([0,radius,0]) arm_mounts_outer(0);

		//extruder mounts
		for(i=[0:120:359]) rotate([0,0,i])
			translate([0,extruder_rad,30]) extruder_mount(0);
	}
}

body_rad = 60;
height = 50;
module hexamid(){
	difference(){
		union(){
			rotate([0,0,30]) cylinder(r1=body_rad/cos(180/6), r2=center_rad/cos(180/6), h=height-wall, $fn=6);
		}

		for(i=[90:120:359]){
			rotate([0,0,i]) translate([body_rad/cos(180/6)+wall*1.5,0,-.1]) rotate([0,0,180/12]) cylinder(r=body_rad/cos(180/12), h=height+2, $fn=12);
		}

		translate([0,0,-wall]) rotate([0,0,-30]) cylinder(r1=body_rad/cos(180/3), r2=0, height, $fn=3);

		rotate([0,0,30]) cylinder(r=center_rad/2+wall, h=100, $fn=3);
	}
}

mount_height = 15;
mount_width = 60;

module extruder_mount(solid = 1){
	if(solid){
		translate([-mount_width/2,-wall,0]) cube([mount_width,wall*2,mount_height]);
	}else{
		union(){
			//hotend hole
			translate([0,wall,.3]) cylinder(r=hotend_rad, h=mount_height);
			%translate([0,wall,.3]) cylinder(r=2, h=height);

			//bolt slots
			render() for(i=[0,1]) mirror([i,0,0]){
				translate([hotend_rad+bolt_dia,0,mount_height/2]) rotate([-90,0,0]) cylinder(r=bolt_rad, h=wall*3, center=true);
				translate([hotend_rad+bolt_dia,-wall,mount_height/2]) rotate([-90,0,0]) cylinder(r=nut_rad, h=nut_height*2, center=true, $fn=6);

				//translate([hotend_rad+bolt_dia,0,mount_height]) rotate([-90,0,0]) cylinder(r=bolt_rad, h=wall*2, center=true);
				//translate([hotend_rad+bolt_rad,-wall*2/2,mount_height/2]) cube([bolt_dia,wall*2+.02,mount_height/2]);

				//translate([hotend_rad+bolt_dia,0,mount_height]) cube([nut_dia,nut_height+.2,mount_height+nut_dia], center=true);
			}
		}
	}
}

bracket_height = 20;
bracket_thick = wall*2;
bracket_width = 40;

pushfit_dia = 10;
pushfit_rad = pushfit_dia/2;
pushfit_thread_dia = 6;
pushfit_thread_rad = pushfit_thread_dia/2;

groove_height = 2.5;
groove_rad = 6;
groove_top = 5;

//holds the extruder on
module extruder_bracket(){
	difference(){
		union(){
			//hotend block
			translate([0,0,bracket_thick/2]) cube([bracket_width, bracket_height, bracket_thick], center=true);
			//pushfit connector
			translate([0,bracket_height/2,0]) {
				translate([0,pushfit_rad/2,bracket_thick/2+.5]) cube([bracket_width, pushfit_rad, bracket_thick+1], center=true);
				translate([0,pushfit_rad/2,bracket_thick+1]) rotate([90,0,0]) cylinder(r=pushfit_rad+wall/2, h=pushfit_rad, center=true);
			}
		}

		//pushfit hole
		translate([0,bracket_height/2,bracket_thick+1]) rotate([90,0,0]) cylinder(r=pushfit_rad, h=15, center=true);

		//hotend hole
		difference(){
			translate([0,0,bracket_thick+1]) rotate([90,0,0]) cylinder(r=hotend_rad, h=bracket_height, center=true);
			//groove slot
			translate([0,bracket_height/2-groove_top-groove_height/2,bracket_thick+1]) rotate([90,0,0]) difference() {
				cylinder(r=hotend_rad, h=groove_height, center=true);
				cylinder(r=groove_rad, h=groove_height+.2, center=true);
			}
		}
		translate([0,bracket_height/2,bracket_thick+1]) rotate([90,0,0]) cylinder(r=hotend_rad+1, h=.5);
		

		//bolt slots
		render() for(i=[0,1]) mirror([i,0,0]){
			translate([hotend_rad+bolt_dia,bracket_height/4,bracket_thick/2]) cylinder(r=bolt_rad, h=bracket_thick+1, center=true);
			translate([hotend_rad+bolt_dia,-bracket_height/4,bracket_thick/2]) cylinder(r=bolt_rad, h=bracket_thick+1, center=true);
			translate([hotend_rad+bolt_rad,-wall*2/2,-.5]) cube([bolt_dia,bracket_height/2,bracket_thick+1]); 
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
		translate([0,0,-.01]) cylinder(r=nut_rad, h=nut_height, $fn=6);
		translate([0,0,nut_height+.3]) cylinder(r=bolt_rad, h=20);
	}
}

arm_rad = wall*1.75;

module arm_mounts(solid = 1){
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
	}
}

module arm_mounts_outer(solid = 1){
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
