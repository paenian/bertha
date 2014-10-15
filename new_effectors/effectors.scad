include <configuration.scad>

//623_bearing();
$fn=90;

arm_mount_sep = 64;
//arm_sep = arm_mount_sep-(623_rad*2+1)*2;
arm_sep = 40;
rodend_jaw_sep = 623_width*2+spacer_len+slop;

rod_offset_z = 2;
rod_inset_r = 30;

pulley_rad = 12/2;
idler_rad = 17.50/2;

wheel_sep = 31.5;	//this is calculated from rail width+wheel size
wheel_z_sep = 60;

belt_width=6;


//hotend effector vars
arm_rad = 27;

extruder_rad = 13.5;
//hotend_attachment_rad = 23;
hotend_rad = 8.15;
//mount_height=12.5;


echo(arm_sep);



//This is a rail effector assembled.
translate([0,0,rod_inset_r]) rotate([90,0,0]) translate([0,0,-wall])
bearing_bar();

rotate([0,0,180])
rail_effector();

translate([arm_sep/2,0,rod_inset_r+.1]) rotate([0,0,-38]) rotate([30,0,0]) rotate([0,90,0])
rod_end();

translate([0,0,0]){
!	hotend_effector();
	
	translate([0, -arm_rad+1, 17]) bearing_bar();
}

//bearing bar + rod ends for printing
union(){
	bearing_bar();
	
	for(i=[-1,1]) translate([i*arm_sep/2,0,0]) rotate([0,0,-90*i]) rod_end();
}



%cube([arm_mount_sep,wall,wall], center=true);
%cube([arm_sep,wall+2,wall+2], center=true);

echo("rod end jaws", rodend_jaw_sep);

module extruder_mount(solid = 1, m_height = 15, fillet = 8, tap_height=0){
	gap = 2.25;

	if(solid){		
		//clamp material
		cylinder(r=hotend_rad/cos(30)+wall, h=m_height, $fn=6);
		translate([hotend_rad+m3_rad+1, -hotend_rad-wall, m_height/2]) rotate([-90,0,0]) cylinder(r=m3_cap_rad+wall/2, h=hotend_rad+wall+gap+wall);
	}else{
		union(){
			//hotend hole
			translate([0,0,-.05]) cylinder(r=hotend_rad/cos(180/18)+.1, h=m_height+.1, $fn=36);
			translate([0,0,m_height-1]) cylinder(r1=hotend_rad/cos(180/18)+.1, r2=hotend_rad/cos(180/18)+1, h=1.1, $fn=36);

			//bolt slots
			if(m_height > m3_nut_rad*2){
				translate([hotend_rad+m3_rad+1,0,m_height/2]) rotate([90,0,0]) cap_cylinder(r=m3_rad, h=wall*3+gap, center=true);
				translate([hotend_rad+m3_rad+1,-wall-m3_nut_height-1,m_height/2]) hull(){
					rotate([-90,0,0]) rotate([0,0,30]) cylinder(r1=m3_nut_rad+.1, r2=m3_nut_rad, h=m3_nut_height+.75, $fn=6);
					translate([0,0,-m_height/2]) rotate([-90,0,0]) rotate([0,0,30]) cylinder(r1=m3_nut_rad+.25, r2=m3_nut_rad, h=m3_nut_height+.75, $fn=6);
				}

				//mount tightener
				translate([hotend_rad+m3_rad+1,wall+gap,m_height/2]) rotate([-90,0,0]) cylinder(r=m3_cap_rad, h=10);
				translate([hotend_rad+m3_rad+1,wall+gap,m_height/2]) rotate([-90,0,0]) cylinder(r=m3_rad, h=10);

				//gap
				//translate([0,gap/2,-.05]) cube([wall*3.5, gap, m_height+.1]);
				translate([hotend_rad+m3_rad, gap/2, m_height/2]) rotate([-90,0,0]) cylinder(r=m_height/2/cos(30)+.1, h=gap, $fn=6);
			}
		}
	}
}

module hotend_tripleclamp(tap_height = 0, height = 10, solid=1){
	//extruder mounts
	for(i=[0:120:359]) rotate([0,0,i]) mirror([0,0,1]) translate([0,0,-height]) 
		translate([0,extruder_rad,0]) extruder_mount(solid,height,0,tap_height);
}

module arm_mounts(solid=1, height=5, inset=25){
	for(i=[0:120:359]) rotate([0,0,i]) translate([0,-arm_rad, 0]) arm_bearings(solid=solid, height=height, inset=inset, offset=0, base_height=0);

	//translate([0, -arm_rad, -623_rad]) bearing_bar();
}

module hotend_effector_body(solid=1, height=15){
	if(solid==1){
		cylinder(r=45, h=height);
	}else{
		for(i=[0:120:359]) rotate([0,0,i]) translate([0,- arm_rad, -.5]) hull(){
			translate([0,0,0]) scale([1,.45,1]) cylinder(r=arm_mount_sep/2,h=height+1);
			translate([0,-arm_mount_sep,0]) cylinder(r=arm_mount_sep/2,h=height+1);
		}
	}
}

module hotend_effector(){
	h = 15;
	inset = 23;
	difference(){
		union(){
			difference(){
				union(){
					arm_mounts(solid=1, height=h, inset=inset);
					hotend_effector_body(solid=1, height=h);
				}
				arm_mounts(solid=0, height=h, inset=inset);
				hotend_effector_body(solid=0, height=h);
			}

			rotate([0,0,60])
			hotend_tripleclamp(height=h, solid=1);
		}
		
		rotate([0,0,60])
		hotend_tripleclamp(height=h, solid=0);
	}
}

module rod_end_helper(solid=1){
	for(i=[0,1]) mirror([i,0,0]) translate([rodend_jaw_sep/2+slop/2,0,0]) rotate([0,90,0]) rotate([0,0,180]) 623_bearing_cone(rad = 623_rad-1, height=1, solid=solid);
}

module rod_end(){
	jaw_depth = 18;
	rod_width = 8.5+slop;
	rod_len = 24;
	clamp_extra=2;
	translate([0,0,rod_width/sqrt(2)+wall/4-.75]) 
	difference(){
		union(){
			rod_end_helper(solid=1);
			
			//clamp
			translate([0,jaw_depth+rod_len/2,rod_width*sqrt(2)/2+m3_rad-clamp_extra]) rotate([0,90,0]) cylinder(r=m3_cap_rad/cos(30)+clamp_extra, h=wall*2, center=true, $fn=6);

			//jaws
			difference(){
				hull(){
					//bolt holder
					for(i=[0,1]) mirror([i,0,0]) translate([rodend_jaw_sep/2+.95,0,0]) intersection() {
						rotate([0,90,0]) cylinder(r=rod_width/sqrt(2)+1, h=wall);
						scale([1,1,1.4]) sphere(r=rod_width/sqrt(2));
					}
					
					//rod
					translate([0,jaw_depth,0]) rotate([-90,0,0]) cylinder(r=rod_width/sqrt(2)+wall/2, h=rod_len, $fn=8);
				}
		
				//cut off top and bottom
				for(i=[0:1]) mirror([0,0,i]) translate([0,0,.75-5-rod_width/sqrt(2)-wall/4]) cube([100,100,10], center=true);

				//bolt cutouts
				rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=m3_rad, h=50, center=true);
				translate([rodend_jaw_sep/2+.95+wall-2,0,0]) rotate([0,90,0]) rotate([0,0,-90]) cap_cylinder(r=m3_cap_rad+.25, h=wall);
				mirror([1,0,0]) translate([rodend_jaw_sep/2+.95+wall-2,0,0]) rotate([0,90,0]) rotate([0,0,-90]) cylinder(r=m3_nut_rad+.1, h=wall, $fn=6);

				//jaw cutout
				%cube([5, jaw_depth*2, 5],center=true);
				cube([(rodend_jaw_sep/2+.95)*2, jaw_depth*2, (rodend_jaw_sep/2+3)*3],center=true);
			}
		}
		rod_end_helper(solid=0);

		//rod cutout
		echo("Rod Length+=",jaw_depth+wall/2);
		translate([0,jaw_depth+wall/2,0]) rotate([-90,0,0]) cylinder(r=rod_width/sqrt(2), h=rod_len+.2, $fn=4);
		translate([0,jaw_depth+wall/2,0]) rotate([-90,0,0]) cylinder(r=rod_width/sqrt(2)/2, h=rod_len+.2, center=true);

		//slit
		translate([0,0,7]) cube([2,100,14], center=true);

		//clamp
		translate([0,jaw_depth+rod_len/2,rod_width*sqrt(2)/2+m3_rad]) rotate([0,90,0]) {
			rotate([0,0,-90]) cap_cylinder(r=m3_rad, h=wall*2+1, center=true);
			translate([0,0,wall]) rotate([0,0,-90]) cap_cylinder(r=m3_cap_rad, h=wall*2);
			translate([0,0,-wall*3]) cylinder(r=m3_nut_rad, h=wall*2, $fn=6);
		}
	}
}

module wheel_mount(solid=1, rad=6, height=5, eccentric=0){
	if(solid){
		cylinder(r=rad, h=height);
	}else{
		if(eccentric == 1){
			translate([0,0,-.1]) cylinder(r=eccentric_rad, h=height+.2);
			translate([0,0,height-m5_nut_height]) cylinder(r=eccentric_washer_rad, h=height+.2);
		}else{
			translate([0,0,-.1]) cylinder(r=m5_rad, h=height+.2);
			translate([0,0,height-m5_nut_rad]) cylinder(r1=m5_nut_rad, r2=m5_nut_rad+.25, h=m5_nut_height+.1, $fn=6);
		}
	}
}

module arm_bearings(solid=1, height=5, inset=10, offset=0, base_height=0){
	h = 623_width+2;
	m_rad = 2;

	if(solid){
		minkowski(){
			sphere(r=m_rad, $fn=6);

			difference(){
				intersection(){
					rotate([0,-90,0])
					linear_extrude(height=arm_mount_sep+slop/2+h*2+3-m_rad*2, center=true) barbell([0,623_rad-2],[inset,1],623_rad*2-m_rad,623_rad+3-m_rad,18,200);

					translate([arm_mount_sep/2+h+slop/2+1.5,(-623_rad-2)*2,0]) rotate([0,-90,0]) cube([inset+623_rad+2,offset+623_rad*6,arm_mount_sep+slop/2+h*2+3]);	
				}
				hull() for(i=[0:1]) mirror([i,0,0]) {
					translate([arm_mount_sep/2-h*2+m_rad,623_rad*3+6-inset/cos(30),base_height+h*2-m_rad]) rotate([90,0,0]) cylinder(r=h*2, h=50, center=true);

					translate([arm_mount_sep/2+h-h*2+1+m_rad,623_rad*3+6-inset/cos(30),base_height+h*5]) rotate([90,0,0]) cylinder(r=h, h=50, center=true);
				}
			}
		}
	}else{
		for(i=[0:1]) mirror([i,0,0]){
			translate([arm_mount_sep/2+h+slop/2,1,inset]) rotate([0,-90,0]) rotate([0,0,90]) 623_bearing_mount(rad=623_rad+1, height=h, solid=solid);
		}

		//clean the bottom
		translate([0,0,-50]) cube([200,200,100], center=true);
	}
}

module rail_effector_helper(solid=1, rod_inset = 0, rod_offset = 2, height=10){
	h = 623_width+2;
	m_rad = 2;

	translate([0,rod_offset,0]) arm_bearings(solid=solid, height=h, inset=rod_inset, offset = rod_offset, base_height=height);


	//wheel mounts
	translate([0,wheel_z_sep/2, 0])
	for(i=[-1,1]) for(j=[-1,1]) translate([wheel_sep/2*i,wheel_z_sep/2*j,0]) wheel_mount(solid=solid, rad=6, height=height, eccentric=i);
}

module rail_effector(){

	height = 12;
	
	//translate([0,0,wall])
	difference(){
		union(){
			//hard points
			rail_effector_helper(solid=1, rod_inset=rod_inset_r, rod_offset=rod_offset_z, height=height);

			//screws to attach belts to
			translate([pulley_rad,wall*2+rod_offset_z,0]) wheel_mount(solid=1, rad=7, height=height, eccentric=0);

			translate([idler_rad,wheel_z_sep-wall*2,0]) wheel_mount(solid=1, rad=7, height=height, eccentric=0);
			
			//extra bump for the endstop
			intersection(){
				translate([0,0,height+1]) cube([20,(623_rad+2)*2,6], center=true);
				translate([0,-623_rad-2,height]) sphere(r=623_rad);
			}

			//body
			difference(){
				hull(){
					for(i=[-1,1]) translate([arm_mount_sep/2*i,0,0]) wheel_mount(solid=1, rad=623_rad+2, height=height, eccentric=0);
					for(i=[-1,1]) translate([wheel_sep/2*i,wheel_z_sep,0]) wheel_mount(solid=1, rad=623_rad+2, height=height, eccentric=0);
				}
				translate([0,0,-.05]) hull(){
					for(i=[-1,1]) translate([(arm_mount_sep/2-(623_rad+2)*2)*i,(623_rad+2)*2,0]) wheel_mount(solid=1, rad=623_rad+2, height=height+.1, eccentric=0);
					for(i=[-1,1]) translate([(wheel_sep/2-(623_rad+2))*i,wheel_z_sep-(623_rad+2)*2,0]) wheel_mount(solid=1, rad=623_rad+2, height=height+.1, eccentric=0);
				}
			}
		}

		//holes in the hard points
		rail_effector_helper(solid=0, rod_inset=rod_inset_r, rod_offset=rod_offset_z, height=height);

		//screws to attach belts to
		translate([pulley_rad,wall*2+rod_offset_z,0]) wheel_mount(solid=0, rad=7, height=height, eccentric=0);
		translate([idler_rad,wheel_z_sep-wall*2,0]) wheel_mount(solid=0, rad=7, height=height, eccentric=0);

		//lop off the bottom
		translate([0,0, -wall*2]) cube([arm_mount_sep*2, arm_mount_sep*2, wall*2], center=true);
	}
}

module bearing_bar_helper(solid=1){
	for(i=[0:1]) mirror([i,0,0]){
		//bearing cones for end bearings
		if(solid==1){
			translate([arm_mount_sep/2,0,1]) rotate([0,-90,0]) 623_bearing_cone(rad = wall+wall/2, height = wall+.25, solid=solid);
		}else{
			translate([arm_mount_sep/2,0,1]) rotate([0,-90,0]) 623_bearing_cone(rad = wall+wall/2, height = wall+.25, solid=solid, nut_trap=1);
		}
			
		//bearing mounts for middle bearings
		for(j=[0,1]) mirror([0,j,0]) translate([arm_sep/2,0,1]) rotate([-90,0,0]) 623_bearing_mount(rad=623_rad+2, height=623_width+spacer_len/2, solid=solid);
	}
}

module bearing_bar(){
	translate([0,0,wall])
	difference(){
		union(){
			bearing_bar_helper(solid=1);
			//connect 'em up
			rotate([0,90,0]) cylinder(r=wall+wall/2+1, h=arm_mount_sep-623_rad*2, center=true);
		}

		//cut off the front, back and bottom
		for(i=[90:90:270]) rotate([i,0,0]) translate([0,0, wall*2]) {
			cube([arm_mount_sep, wall*4, wall*2], center=true);
		}

		//clear out the hollows
		bearing_bar_helper(solid=0);

		//make some speed holes
		for(i=[0,1]) mirror([i,0,0]) translate([623_rad+2,0,0]) rotate([90,0,0]) rotate([0,0,30]) cylinder(r=623_rad-2, h=40, center=true, $fn=6);
		rotate([90,0,0]) rotate([0,0,30]) cylinder(r=623_rad-2, h=40, center=true, $fn=6);
	}
}