include <configuration.scad>;

rail_width=25.4649-.25;	//this must be adjusted for new rails.
v_rad = 9.77;


//these are the major changes.  Change them back to work with the old stuff - everything should be compatible.
arm_sep = 54;		//70 - should make the machine more stable with the narrow rails
height = 40;			//40 - note that the hotends are 10mm higher than they used to be.  Change this to 30 if you're using short hotends.
radius = 30;			//40 - adds 20mm build area in XY
extruder_rad = 15;	//25	 - this give 20mm more build area in XY

//this is the mounts for the hotend clamper to the hotend mover.
hotend_attachment_rad = 23;


rod_end_thickness = 8;

//translate([0,0,65]) cube([40,40,10],center=true);
//translate([0,36,20]) cube([40,10,40],center=true);

$fn=90;


center_rad = 15;
igus_rad = 6.5/2;
shroud_height = 40;	//height of fan shroud.  Adjust based on extruder.
rail_offset = 10;

hotend_rad = 8.05;

//%translate([0,20,0]) cube([30,10,30], center=true);
//%translate([0,-18,-height/2]) cube([30,10,30], center=true);

//%translate([0,0,0]) cylinder(r=extruder_rad, h=1);
//%rotate([0,0,30]) cylinder(r=center_rad/cos(60), h=1, $fn=3);



////////SHIFTED VARIABLES
mount_height = 15;
//mount_width = 50;
m_thickness = wall*2+1+1;

arm_rad = wall*1.75;
//60 degrees: (arm_rad-igus_rad)/sqrt(3);	//60 degree sweep
cone_height = (arm_rad-igus_rad);	//45 degree sweep
nut_mount = wall+nut_height/2;	//thickness behind cone

rod_size = 8.6;
taper = 4.5;
bolt_length = 20+4;
rod_inset = 15;




//translate([0,80,15]) mirror([0,1,0])
//rail_effector();
//translate([0,33,0])
//hotend_clamp(pushfit = false);
//translate([arm_sep/2+6,-10,16.5]) mirror([0,1,0])
//rod_end();
//fan_mount();
hotend_effector();
//mirror([0,0,1]) translate([0,0,-12.5]) hotend_tripleclamp(tap_height=0, h=12.5);

module hotend_tripleclamp(tap_height = 0, h = 10){
	difference(){
		union(){
			//corner joints
			for(i=[0:120:359]) rotate([0,0,i])
				hull(){
					translate([0,-hotend_attachment_rad,0]) cylinder(r=nut_rad+1, h=h);
					translate([0,-hotend_attachment_rad+wall,0]) cylinder(r=nut_rad, h=h);
				}
			
			//center fill
			cylinder(r=wall*2, h=h);

			//extruder mounts
			for(i=[0:120:359]) rotate([0,0,i])
				translate([0,extruder_rad,0]) extruder_mount(1,h,0,tap_height);
		}

		//extruder mounts
		for(i=[0:120:359]) rotate([0,0,i])
			translate([0,extruder_rad,0]) extruder_mount(0,h,0,tap_height);

		//bolt holes
		for(i=[0:120:359]) rotate([0,0,i])
			translate([0,-hotend_attachment_rad,-.05]) cylinder(r=bolt_rad+.125, h=h+.1);
		//translate([0,0,wall]) cylinder(r=m3bolt_cap_rad, h=h+.1);
		translate([0,0,-.05]) cylinder(r=m3bolt_rad, h=h+.1);
		translate([0,0,-.05]) cylinder(r=m3nut_rad, h=nut_height*2, $fn=6);
		translate([0,0,-.05]) rotate([0,0,180/12]) cylinder(r=5/cos(180/12), h=nut_height, $fn=12);
	}
}

module extruder_clamp(solid = 1, h = 10, fillet = 0){
	if(solid==1){
		union(){
			cylinder(r=16, h=h, $fn=6);
		}
	}else{
		translate([]) cylinder(r=bolt_rad, h=20);
	}
}

module hotend_effector(){
	fillet = 3;
	difference(){
		union(){
			//arms
			render() for(i=[0:120:359]) rotate([0,0,i])
				translate([0,radius,height]) arm_mounts(1);

			render() for(i=[0:120:359]) rotate([0,0,i]) translate([0,radius,height]){
				difference(){
					intersection(){
						rotate([0,90,0]) cylinder(r=arm_rad, h=arm_sep-cone_height*4, center=true, $fn=36);
						translate([0,arm_rad+bolt_rad, 0]) cube([arm_sep-cone_height*4, arm_rad*2, arm_rad*2],center=true);
					}
					translate([0,0,-arm_rad]) rotate([90,0,0]) scale([1,(arm_rad)/(arm_sep/2-nut_mount-cone_height),1]) cylinder(r=arm_sep/2-nut_mount-cone_height, h=20, center=true, $fn=6);
				}
			}

			//arm supports
			render() arm_supports(fillet);

			//extruder mounts
			for(i=[0:120:359]) rotate([0,0,i])
				translate([0,extruder_rad,0]) extruder_mount(1,5,0);
			cylinder(r=10, h=wall);
	
			//hotend attachment holes
			for(i=[0:120:359]) rotate([0,0,i]) {
				translate([0,-hotend_attachment_rad,0]) cylinder(r=nut_rad+wall/2, h=height/2, $fn=6);

				//little fillet
				translate([0,-hotend_attachment_rad+(nut_rad+wall/2)*cos(30)-.05,wall]) difference() {
						
					hull(){
						translate([-nut_rad/2-wall/4,0,0]) cube([nut_rad+wall/2, .05, fillet]);
						translate([-nut_rad/4-wall/8,0,0]) cube([nut_rad/2+wall/4, fillet, fillet]);
					}

					translate([0,fillet,fillet]) rotate([0,90,0]) cylinder(r=fillet, h=nut_rad+wall/2+.1, center=true);
					}
	
			}
		}

		//arms
		render() for(i=[0:120:359]) rotate([0,0,i])
			translate([0,radius,height]) arm_mounts(0);

		//extruder mounts
		for(i=[0:120:359]) rotate([0,0,i]){
			translate([0,extruder_rad,0]) extruder_mount(0,5,0);
			//make the hotend hole bigger
			translate([0,extruder_rad,-.1]) cylinder(r=(hotend_rad+.5)/cos(180/18), h=5+1, $fn=36);
		}

		//reprap logo - also exhaust path for the fans
		render() for(i=[0:120:359]) rotate([0,0,i])
			translate([0,0,height/2+wall/2]) rotate([90,0,0]) teardrop(10,radius*2);
	
		//hotend attachment holes
		for(i=[0:120:359]) rotate([0,0,i]){
			translate([0,-hotend_attachment_rad,-.05]) cylinder(r=bolt_rad, h=15.1);
			translate([0,-hotend_attachment_rad,10]) cylinder(r=nut_rad, h=10, $fn=6);

			//fan slot
			translate([0,radius-6+bolt_rad,height-34/2]) cube([31,12,31], center=true);
		}

		//endstop recess
		translate([0,0,sz/2-.1]) cube([sx,sy,sz], center=true);	
		for(i=[0,1]) mirror([i,0,0]) translate([sx/2+1,sy/2-1,0]) cube([2,2,20], center=true);

		//fix some overhangs
		translate([0,0,height]) cylinder(r=radius-wall, h=height, center=true, $fn=6);
	}
}
		sx = 7;
		sy = 7;
		sz = 4;

module teardrop(r, h) {
  facets = 4;
  rotate([0,0,90]) 
  union () {
 //   cube([r,r,h]);
	intersection(){
		translate([r*cos(180/facets),0,0]) cylinder(r=r*cos(180/facets), h=h, $fn=facets);
		rotate([0,0,45]) cylinder(r=r/cos(180/facets), h=h, $fn=facets);
	}
    cylinder(r=r, h=h);
  }
}

module arm_supports(fillet = 5){
	ring_rad = radius*sqrt(3)-arm_sep/2+cone_height;
	intersection(){
		rotate([0,0,30]) cylinder(r1=extruder_rad/cos(60), r2=(radius+wall+bolt_rad)/cos(60), h=height,$fn=3);
		union() for(i=[0:120:359]) rotate([0,0,i])
			translate([0,-radius*2,height/2]) difference(){
				rotate([0,0,30]) cylinder(r2=(ring_rad+nut_mount)/cos(30),r1=(ring_rad+nut_mount)/cos(30),h=height+wall*2, center=true, $fn=6);
				cylinder(r2=ring_rad,r1=ring_rad+2,h=height+wall*2+1, center=true);
			}
	}
}

module extruder_mount(solid = 1, m_height = mount_height, fillet = 8, tap_height=0){
	gap = 2;
	tap_dia = 9.1;
	tap_rad = tap_dia/2;

	if(solid){
		translate([-(arm_sep-cone_height*2-nut_mount)/2,-m_thickness,0]) cube([arm_sep-cone_height*2-nut_mount,m_thickness,m_height]);
		//cylinder(r=(hotend_rad+wall/2)/cos(30), h=m_height, $fn=6);
		
		//fillet square
		for(i=[0,1]) mirror([i,0,0]) translate([arm_sep/2-cone_height-nut_mount-fillet+.05-1,0,m_height-.05]) rotate([90,0,0]) cube([fillet, fillet, m_thickness]);
		
		//clamp material
		if(m_height > nut_rad*2){
			cylinder(r=hotend_rad/cos(30)+wall, h=m_height, $fn=6);
			translate([hotend_rad+bolt_rad+1,gap,m_height/2]) rotate([-90,0,0]) cylinder(r=m_height/2/cos(30), h=wall+1, $fn=6);
		}
	}else{
		union(){
			//fillet round
			for(i=[0,1]) mirror([i,0,0]) translate([arm_sep/2-cone_height-nut_mount-fillet-.05-1,.05,m_height+fillet-.01]) rotate([90,0,0]) cylinder(r=fillet,h=m_thickness+.1);

			//hotend hole
			translate([0,0,-.05]) cylinder(r=hotend_rad/cos(180/18)+.1, h=m_height+.1-tap_height, $fn=36);
			//tap hole
			translate([0,0,-.05]) cylinder(r=tap_rad/cos(180/18), h=m_height+.1, $fn=36);

			//bolt slots
			if(m_height > nut_rad*2){
				translate([hotend_rad+bolt_rad+1,-m_thickness-.05,m_height/2]) rotate([-90,0,0]) cylinder(r=bolt_rad, h=m_thickness+20);
				translate([hotend_rad+bolt_rad+1,-m_thickness/2-nut_height,m_height/2]) hull(){
					rotate([-90,0,0]) rotate([0,0,30]) cylinder(r=nut_rad, h=nut_height+.25, $fn=6);
					translate([0,0,-m_height/2]) rotate([-90,0,0]) rotate([0,0,30]) cylinder(r=nut_rad, h=nut_height+.25, $fn=6);
				}

				//mount tightener
				translate([hotend_rad+bolt_rad+1,wall+gap+1,m_height/2]) rotate([-90,0,0]) cylinder(r=bolt_cap_rad, h=10);
				translate([0,0,-.05]) cube([wall*3, gap, m_height+.1]);

				render() translate([0,-extruder_rad-hotend_attachment_rad,-.05]) rotate([0,0,60]) 
				difference(){
					translate([0,-gap,0]) cylinder(r=nut_rad+1, h=m_height+.1);
					cylinder(r=nut_rad+1, h=m_height+.1);
					translate([0,-wall,-.05]) cube([wall*5, wall, m_height+.1]);
				}
			}
		}
	}
}

//holds the extruder on
module hotend_clamp(pushfit = true){
	bracket_height = 15;
	bracket_thick = wall*2;
	bracket_width = 40;

	pushfit_dia = 9.2;
	pushfit_rad = pushfit_dia/2;
	pushfit_thread_dia = 6;
	pushfit_thread_rad = pushfit_thread_dia/2;

	groove_height = 4;
	groove_rad = 6.05;
	groove_top = 5.5;

	difference(){
		union(){
			//hotend block
			translate([0,0,bracket_thick/2]) cube([bracket_width, bracket_height, bracket_thick], center=true);
			//pushfit connector
			if(pushfit){
				difference () {
					translate([0,bracket_height/2,0]) {
						translate([0,wall/2,(bracket_thick+pushfit_rad+wall/2)/2+.5]) cube([bracket_width, wall, bracket_thick+pushfit_rad+1+wall/2], center=true);
						translate([0,wall/2,bracket_thick+1]) rotate([90,0,0]) cylinder(r=pushfit_rad+wall, h=wall, center=true);
					}
				}
			}
		}

		for(i=[0,1]) mirror([i,0,0]) translate([-bracket_width/2,bracket_height/2+wall/2,bracket_thick+1+pushfit_rad+wall]) scale([1.44,1,1]) rotate([-90,0,0]) cylinder(r=pushfit_rad+wall,h=wall+1, center=true);

		//pushfit hole
		translate([0,bracket_height/2,bracket_thick+1]) rotate([90,0,0]) cylinder(r=pushfit_rad, h=15, center=true, $fn=72);

		//hotend hole
		difference(){
			translate([0,-.1,bracket_thick+1]) rotate([90,0,0]) cylinder(r=hotend_rad, h=bracket_height+.2, center=true, $fn=72);
			//groove slot
			translate([0,bracket_height/2-groove_top-groove_height/2,bracket_thick+1]) rotate([90,0,0]) difference() {
				cylinder(r=hotend_rad, h=groove_height, center=true, $fn=72);
				cylinder(r=groove_rad, h=groove_height+.15, center=true, $fn=72);
			}
		}
		translate([0,bracket_height/2+.01,bracket_thick+1]) rotate([90,0,0]) cylinder(r=hotend_rad+1, h=.5);
		

		//bolt slots
		render() for(i=[0,1]) mirror([i,0,0]){
			translate([hotend_rad+bolt_dia,bracket_height/4,bracket_thick/2]) cylinder(r=bolt_rad, h=bracket_thick+1, center=true);
			translate([hotend_rad+bolt_dia,-bracket_height/4,bracket_thick/2]) cylinder(r=bolt_rad, h=bracket_thick+1, center=true);
			translate([hotend_rad+bolt_rad,-bracket_height/4,-.5]) cube([bolt_dia,bracket_height/2,bracket_thick+1]);
		}
	}
}

module rail_effector(){
	thickness = 15;
	pulley_rad = 8;
	outer_rad = rail_width/2+v_rad*2-3;
	inner_rad = rail_width/2+v_rad-5;
	facets = 6;
	difference(){
		union(){
			//body
			rotate([0,0,180/facets]) difference(){
				cylinder(r=outer_rad/cos(180/facets), h=thickness, $fn=facets);
				translate([0,0,-.1]) cylinder(r=inner_rad/cos(180/facets), h=thickness+1, $fn=facets);
			}

			//v wheel mounts
			translate([-rail_width/2-v_rad,0,0]) wheel_mount(1, thickness-2);
			hull(){
				for(i=[0,1]) mirror([0,i,0]) translate([rail_width/2+v_rad,(rail_width+v_rad*2)/sqrt(3),0]) wheel_mount(1, thickness-2);
				//belt mount
				translate([pulley_rad,0,0]) belt_mount(1, thickness-4);
			}

			//tensioner support
			translate([-wall*2.5,-outer_rad+(outer_rad-inner_rad)/2,thickness/2]) rotate([0,90,0])
			translate([0,0,10/2]) cylinder(r=bolt_cap_rad/cos(30), h=10, center=true, $fn=6);

			//arms
			translate([0,inner_rad+arm_rad,thickness/2]) cube([27,arm_rad*2,thickness], center=true);
			hull(){
				translate([0,outer_rad+arm_rad,thickness+rod_end_thickness]) arm_mounts(1);
				translate([0,outer_rad+arm_rad,1/2]) cube([27,arm_rad*2,1], center=true);
			}
		}

		//v wheel mounts
		for(i=[0,1]) mirror([0,i,0]) translate([rail_width/2+v_rad,(rail_width+v_rad*2)/sqrt(3),0]) wheel_mount(0, thickness);
		translate([-rail_width/2-v_rad,0,0]) wheel_mount(0, thickness);

		//belt mount
		translate([pulley_rad,0,0]) belt_mount(0, thickness);

		//belt cutouts
		hull() for(i=[0,1]) mirror([i,0,0]) {
			translate([pulley_rad,outer_rad,thickness+arm_rad*2]) rotate([90,0,0]) cylinder(r=pulley_rad/2+5, h=outer_rad*2, center=true);
			translate([pulley_rad,outer_rad,thickness+pulley_rad/2]) rotate([90,0,0]) cylinder(r=pulley_rad/2, h=outer_rad*2, center=true);
		}

		//arms
		translate([0,outer_rad+arm_rad,thickness+rod_end_thickness]) arm_mounts(0);

		//body cutout/tensioner
		translate([0,-outer_rad+(outer_rad-inner_rad)/2, thickness/2]) cube([wall, outer_rad, thickness+1], center=true);

		//nut slot
		translate([wall,-outer_rad+(outer_rad-inner_rad)/2,thickness/2]) rotate([0,90,0]) hull(){
			cylinder(r=nut_rad, h=nut_height, $fn=6);
			translate([-thickness,0,0]) cylinder(r=nut_rad, h=nut_height, $fn=6);
		}

		//bolt holes
		for(i=[0,0]) translate([-wall*2.5,-outer_rad+(outer_rad-inner_rad)/2,thickness/2]) rotate([0,90,0]) {
			translate([0,0,25/2-.1]) cylinder(r=bolt_rad, h=25, center=true);
			translate([0,0,-20/2]) hull(){
				cylinder(r=bolt_cap_rad/cos(30), h=20, center=true, $fn=6);
				translate([thickness/2,-bolt_cap_rad,0]) cylinder(r=bolt_cap_rad, h=20, center=true, $fn=6);
				translate([-thickness/2,-bolt_cap_rad,0]) cylinder(r=bolt_cap_rad, h=20, center=true, $fn=6);
			}
		}
	}
}

module belt_mount(solid = 1, thickness=16){
	if(solid){
		cylinder(r=v_rad-2, h=thickness);
	}else{
		translate([0,0,thickness-nut_height*2]) cylinder(r=nut_rad, h=nut_height*3.5, $fn=6);
		translate([0,0,wall]) cylinder(r=bolt_rad, h=thickness+1);
		translate([0,0,-.3]) cylinder(r=bolt_cap_rad, h=wall);
	}
}

module wheel_mount(solid = 1, thickness = 16){
	if(solid){
		cylinder(r=v_rad-2, h=thickness);
	}else{
		translate([0,0,thickness-nut_height*2]) cylinder(r=nut_rad, h=nut_height*3.25, $fn=6);
		translate([0,0,-.1]) cylinder(r=bolt_rad, h=thickness+nut_height*1.25);
	}
}

module arm_mounts(solid = 1){
	rotate([0,90,0])
	if(solid){
		for(i=[0,1]) mirror([0,0,i]){
			translate([0,0,arm_sep/2-cone_height-nut_mount/2]) cylinder(r=arm_rad, h=nut_mount, center=true, $fn=36);
			translate([0,0,arm_sep/2-cone_height]) cylinder(r1=arm_rad, r2=igus_rad, h=cone_height, $fn=36);
		}
	}else{
		//nut slot
		for(i=[0,-nut_rad]) translate([i,0,-.01]) cylinder(r=nut_rad, h=arm_sep-cone_height*2-wall, center=true, $fn=6);
		cylinder(r=bolt_rad, h=arm_sep+wall, center=true);

		//flatten the top
		translate([-arm_rad-6,0,0]) cube([20,25,arm_sep],center=true);

		//make sure the rod can't hit anything
		render() for(i=[0,1]) mirror([0,0,i]) translate([0,0,arm_sep/2+rod_end_thickness/2]) rod_end_sweep();
	}
}

module rod_end_sweep(rad=9.5){
	%difference(){
		sphere(r=rad, $fn=36);
		for(i=[0,1]) mirror([0,0,i]) translate([0,0,rod_end_thickness/2-.1]) cylinder(r1=igus_rad, r2=36, h=((36-igus_rad)/2)/sqrt(3),$fn=12);
	}
}

module rod_end(){
	length = bolt_length+rod_inset+wall*1.5;
	translate([0,0,(rod_size+.5)*cos(30)])
	rotate([90+taper-taper,0,0])
	
	difference(){
		cylinder(r=rod_size+.5, h=length, $fn=6);

		//taper
		for(i=[0]) mirror([0,i,0]) translate([-10,rod_size*cos(30)-.25,0]) rotate([taper,0,0]) translate([0,0,-1]) cube([20,10,length+20]);

		//carbon fiber hole
		translate([0,0,-.1]) rotate([0,0,]) cylinder(r=rod_size/2/cos(180/4), h=rod_inset+.1, $fn=4);
		//this champhers the hole, keeps the end flat
		translate([0,0,rod_inset-1]) rotate([0,0,]) cylinder(r=rod_size/2/cos(180/4)+.5, h=1, $fn=4);
		//this is a convenient spot to drop glue into
		translate([0,rod_size,rod_inset-1.5]) rotate([90,0,0]) cylinder(r=1.5/cos(30), h=wall, $fn=6);

		//nut hole
		translate([0,0,rod_inset+wall/2]){
			cylinder(r=bolt_rad, h=length);
			cylinder(r1=bolt_cap_rad+1, r2=bolt_cap_rad+.25, h=bolt_length, $fn=32);
		}
		
		//bolt insertion path
		translate([0,0,rod_inset+wall/2]) hull(){
			cylinder(r1=bolt_cap_rad+1, r2=bolt_cap_rad+.75, h=8, $fn=32);
			translate([0,bolt_cap_rad,0]) cylinder(r1=bolt_cap_rad+1, r2=bolt_cap_rad+.25, h=8, $fn=32);
		}
	}
}

module fan_mount(){
	//these settings are for 40mm fan
	hole = 39/2;
	screws = 45/2;
	bracket = 50;
	screw_rad = 3.2/2;

	//this'll do a 60mm fan
	//hole = 58/2;
	//screws = 70/2;
	//bracket = 70;
	//screw_rad = 3.2/2;

	mount_height = 30;
	scoop_height = 30;
	thick = 2;
	
	taper=0;

	%render() translate([0,0,30]) hotend_effector();

	translate([0,0,mount_height]) mirror([0,0,1])
	difference(){
		union(){
			//funnel to bottom
			translate([0,0,-height]) intersection(){
				rotate([0,0,30]) cylinder(r=11.5/cos(180/3), h=height-wall*3+.1, $fn=3);
				cylinder(r1=11.5/cos(180/64)-taper, r2=11.5/cos(180/64)+4, h=height-wall*3+.1, $fn=64);
			}

			//straight
			translate([0,0,-wall*3]) intersection(){
				rotate([0,0,30]) cylinder(r=11.5/cos(180/3), h=wall*3, $fn=3);
				cylinder(r=11.5/cos(180/64)+4, h=wall*3, $fn=64);
			}

			//taper to fan
			intersection(){
				rotate([0,0,30]) cylinder(r1=13/cos(180/3), r2=center_rad, h=mount_height, $fn=3);
				cylinder(r1=11.5/cos(180/64)+4, r2=center_rad, h=mount_height, $fn=64);
			}

			cylinder(r2=hole+thick, r1=extruder_rad-hotend_rad-wall, h=mount_height);

			rotate([0,0,45]) translate([0,0,mount_height-wall/2]) cylinder(r=20/cos(180/4), h=wall/2, $fn=4);
		}		

		//cutout the air path
		difference(){
			union() translate([0,0,-.1]) {
				cylinder(r2=hole, r1=extruder_rad-hotend_rad-wall-thick, h=mount_height+1);

				translate([0,0,-height+thick]) intersection(){
					rotate([0,0,30]) cylinder(r=11.5/cos(180/3)-thick, h=height-wall*3+.1, $fn=3);
					cylinder(r1=11.5/cos(180/64)-taper-thick, r2=11.5/cos(180/64)+4-thick, h=height-wall*3+.1, $fn=64);
				}

				translate([0,0,-height+thick])
					rotate([0,0,-30]) cylinder(r1=11.5/cos(180/64)+4, r2=11.5/cos(180/64)+4, h=height-wall*3+.2, $fn=3);
	
				//straight
				translate([0,0,-wall*3+.05]) intersection(){
					rotate([0,0,30]) cylinder(r=11.5/cos(180/3)-thick, h=wall*3, $fn=3);
					cylinder(r=11.5/cos(180/64)+4-thick, h=wall*3+.1, $fn=64);
				}

				//taper to fan
				intersection(){
					rotate([0,0,30]) cylinder(r1=11.5/cos(180/3)-thick, r2=center_rad-thick, h=mount_height, $fn=3);
					cylinder(r1=11.5/cos(180/64)+4-thick, r2=center_rad-wall/2, h=mount_height, $fn=64);
				}				
			}

			for(i=[0:120:359])
				rotate([0,0,i+30]) translate([0,-thick/4,-mount_height*3]) cube([30,thick/2,mount_height*6]);
		}

		//coutout around the hotends
		for(i=[0:120:359])
			rotate([0,0,i+90]) translate([extruder_rad,0,0]) sphere(r=hotend_rad+wall-.5, $fn=36);

		//cutout the fan mounting holes
		for(i=[0:90:359])
			rotate([0,0,i+45]) translate([screws,0,mount_height]) cylinder(r=screw_rad, h=10, center=true);
	}
}
