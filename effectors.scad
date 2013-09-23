include <configuration.scad>;

rail_width=25.4649-.25;
v_rad = 9.77;
arm_sep = 70;


rod_end_thickness = 8;

//translate([0,0,65]) cube([40,40,10],center=true);
//translate([0,36,20]) cube([40,10,40],center=true);

$fn=90;
height = 40;		//40
radius = 40;		//40
extruder_rad = 25;
center_rad = 15;
igus_rad = 6/2;
shroud_height = 40;	//height of fan shroud.  Adjust based on extruder.
rail_offset = 10;

//cube([12,200,50], center=true);

//%translate([0,0,0]) cylinder(r=extruder_rad, h=1);
//%rotate([0,0,30]) cylinder(r=center_rad/cos(60), h=1, $fn=3);


//translate([80,0,0])
//rail_effector();
//adjustable_wheel();
//hotend_effector();
//translate([0,33,0])
//hotend_clamp();
//translate([0,-33,0])
//rod_end();
fan_mount();


module hotend_effector(){
	difference(){
		union(){
			//body
			//hexamid();

			//arms
			for(i=[0:120:359]) rotate([0,0,i])
				translate([0,radius,height]) arm_mounts(1);

			//arm supports
			arm_supports();


			//extruder mounts
			render() for(i=[0:120:359]) rotate([0,0,i])
				translate([0,extruder_rad,0]) extruder_mount(1);

			//fan diverter
			//fan_shroud();

			//anchor
			*for(i=[0:120:359]) rotate([0,0,i])
				translate([-wall/4,0,0]) cube([wall/2,extruder_rad/2,15]);
		}

		//arms
		for(i=[0:120:359]) rotate([0,0,i])
			translate([0,radius,height]) arm_mounts(0);

		//extruder mounts
		for(i=[0:120:359]) rotate([0,0,i])
			translate([0,extruder_rad,0]) extruder_mount(0);

		//reprap logo
		for(i=[0:120:359]) rotate([0,0,i])
			translate([0,0,height/2+wall]) rotate([90,0,0]) teardrop(8,radius*2);
		

		//clean up the bottom
		translate([0,0,-50]) cube([100,100,100],center=true);
	}
}

module teardrop(r, h) {
  rotate([0,0,45]) 
  union () {
    cube([r,r,h]);
    cylinder(r=r, h=h);
  }
}

module arm_supports(){
	ring_rad = radius*sqrt(3)-arm_sep/2+cone_height;
	intersection(){
		rotate([0,0,30]) cylinder(r1=extruder_rad/cos(60), r2=(radius+wall+bolt_rad)/cos(60), h=height,$fn=3);
		rotate([0,0,30]) cylinder(r1=(radius+bolt_rad)/cos(60), r2=(radius+bolt_rad)/cos(60), h=height+10,$fn=3);
		union() for(i=[0:120:359]) rotate([0,0,i])
			translate([0,-radius*2,height/2]) difference(){
				union(){
					cylinder(r2=ring_rad+wall+nut_height,r1=ring_rad+wall+nut_height,h=height+wall*2, center=true);
					translate([0,ring_rad+wall*1.5,-height/4]) cylinder(r=wall*1.5, h=height/2, center=true, $fn=6);
				}
				cylinder(r2=ring_rad,r1=ring_rad+2,h=height+wall*2+1, center=true);
			}
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
		sphere(r=36, $fn=36);

		rotate([0,0,30]) cylinder(r=center_rad/2+wall, h=100, $fn=3);
	}
}

mount_height = 15;
mount_width = 60;

module extruder_mount(solid = 1){
	if(solid){
		translate([-mount_width/2,-wall*2,0]) cube([mount_width,wall*2,mount_height]);
		cylinder(r=(hotend_rad+wall)/cos(30), h=mount_height, $fn=6);
		
		for(i=[0,1]) mirror([i,0,0]) translate([radius/2,0,mount_height-.05]) rotate([90,0,0]) cube([wall*2, wall, wall*2]);
	}else{
		union(){
			for(i=[0,1]) mirror([i,0,0]) translate([radius/2-1.3,.05,mount_height+wall-.1]) rotate([90,0,0]) cylinder(r=wall,h=wall*2+3);

			//shore up the front
			translate([-mount_width/4,.01,-.1]) cube([mount_width/2,wall*3,mount_height+1]);

			//hotend hole
			translate([0,0,-.1]) cylinder(r=hotend_rad/cos(180/18), h=mount_height+1, $fn=36);
			%translate([0,0,0]) cylinder(r=2, h=50);

			//bolt slots
			render() for(i=[0,1]) mirror([i,0,0]){
				translate([hotend_rad+bolt_dia,0,mount_height/2]) rotate([-90,0,0]) cylinder(r=bolt_rad, h=wall*3, center=true);
				translate([hotend_rad+bolt_dia,-wall*2-.1-wall,mount_height/2]) rotate([-90,0,0]) rotate([0,0,30]) cylinder(r=nut_rad, h=nut_height+wall, $fn=6);

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


hotend_rad = 8.05;

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

//holds the extruder on
module hotend_clamp(){
	difference(){
		union(){
			//hotend block
			translate([0,0,bracket_thick/2]) cube([bracket_width, bracket_height, bracket_thick], center=true);
			//pushfit connector
			difference () {
				translate([0,bracket_height/2,0]) {
					translate([0,wall/2,(bracket_thick+pushfit_rad+wall/2)/2+.5]) cube([bracket_width, wall, bracket_thick+pushfit_rad+1+wall/2], center=true);
					translate([0,wall/2,bracket_thick+1]) rotate([90,0,0]) cylinder(r=pushfit_rad+wall, h=wall, center=true);
				}
			}
		}

		for(i=[0,1]) mirror([i,0,0]) translate([-bracket_width/2,bracket_height/2+wall/2,bracket_thick+1+pushfit_rad+wall]) scale([1.44,1,1]) rotate([-90,0,0]) cylinder(r=pushfit_rad+wall,h=wall+1, center=true);

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
		for(i=[0,1]) mirror([i,0,0]) hull(){
			translate([pulley_rad,outer_rad,thickness+arm_rad*2]) rotate([90,0,0]) cylinder(r=pulley_rad/2, h=outer_rad*2, center=true);
			translate([pulley_rad,outer_rad,thickness+pulley_rad/2]) rotate([90,0,0]) cylinder(r=pulley_rad/2, h=outer_rad*2, center=true);
		}

		//arms
		translate([0,outer_rad+arm_rad,thickness+rod_end_thickness]) arm_mounts(0);
		

		//body cutout/tensioner
		translate([0,-outer_rad+(outer_rad-inner_rad)/2, thickness/2]) cube([wall, outer_rad, thickness+1], center=true);

		//nut slot
		for(i=[0:10]) translate([wall,-outer_rad+(outer_rad-inner_rad)/2,thickness/2+i]) rotate([0,90,0]) cylinder(r=nut_rad, h=nut_height, $fn=6);

		//bolt holes
		for(i=[0,0]) translate([-wall*2.5,-outer_rad+(outer_rad-inner_rad)/2,thickness/2]) rotate([0,90,0]) {
			translate([0,0,25/2-.1]) cylinder(r=bolt_rad, h=25, center=true);
			translate([0,0,-20/2]) hull(){
				cylinder(r=bolt_cap_rad, h=20, center=true);
				translate([thickness/2,-bolt_cap_rad,0]) cylinder(r=bolt_cap_rad, h=20, center=true);
				translate([-thickness/2,-bolt_cap_rad,0]) cylinder(r=bolt_cap_rad, h=20, center=true);
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

arm_rad = wall*1.75;
//45 degrees: (arm_rad-igus_rad)
//60 degrees: (arm_rad-igus_rad)/sqrt(3);
cone_height = (arm_rad-igus_rad);
echo(cone_height);

module arm_mounts(solid = 1){
	rotate([0,90,0])
	if(solid){
		//cylinder(r=arm_rad, h=arm_sep-cone_height*2, center=true, $fn=36);
		for(i=[0,1]) mirror([0,0,i]){
			translate([0,0,arm_sep/2-cone_height-(wall+nut_height)/2]) cylinder(r=arm_rad, h=wall+nut_height, center=true, $fn=36);
			translate([0,0,arm_sep/2-cone_height]) cylinder(r1=arm_rad, r2=igus_rad, h=cone_height, $fn=36);
		}
	}else{
		//nut slot
		for(i=[0,-nut_rad]) translate([i,0,-.01]) cylinder(r=nut_rad, h=arm_sep-cone_height*2-wall*2, center=true, $fn=6);
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

rod_size = 8.6;
taper = 4.5;
bolt_length = 20+4;
rod_inset = 15;
module rod_end(){
	length = bolt_length+rod_inset+wall*1.5;
	translate([0,0,rod_size*cos(30)-1]) rotate([90+taper-taper,0,0])
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
			//cylinder(r1=nut_rad+1, r2=nut_rad, h=15, $fn=6);
			cylinder(r1=bolt_cap_rad+1, r2=bolt_cap_rad+.25, h=bolt_length, $fn=32);
			//cube([nut_rad+1,20,15],center=true);
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

	//bottom hole
	//%rotate([0,0,0]) cylinder(r=center_rad/cos(180/6), h=1, $fn=6);

	//top hole
	//%translate([0,0,mount_height+wall/2]) cube([40,40,wall], center=true);

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

			//pegs
			*for(i=[0:120:359])
				rotate([0,0,i+30]) translate([extruder_rad+wall/2,0,0]) cylinder(r=2.25, h=6, center=true, $fn=3);
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
