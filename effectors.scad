include <configuration.scad>;

rail_width=25.4649;
v_rad = 9.77;
arm_sep = 80;

body_rad=25;

%cube([rail_width,100,wall],center=true);

rail_effector();

module hotend_effector(){
}

module rail_effector(){
	union(){
		//v wheels
		translate([-rail_width/2-v_rad,0,0]) wheel_mount();
		for(i=[0,1]) mirror([0,i,0]) translate([rail_width/2+v_rad,(rail_width+v_rad*2)/sqrt(3),0]) wheel_mount();

		//arms
		translate([0,arm_sep/2,0]) arm_mounts();

		//belt mount
		//-rail_width/2-v_rad-8;
		translate([8,(rail_width/2+v_rad+8)/sqrt(3),0]) belt_mount();
		translate([8,-(rail_width/2+v_rad+8)/sqrt(3),0]) belt_mount();

		//connect everything up
		difference(){
			cylinder(r=body_rad/cos(60), h=wall);
			translate([0,0,-.1]) cylinder(r=(body_rad-wall)/cos(60), h=wall+.2);
		}
	}
}

module belt_mount(){
	difference(){
		union(){
			cylinder(r=25/2, h=wall);
			translate([0,0,wall]) cylinder(r1=25/2, r2=bolt_cap_rad, h=nut_height+1);
		}
		translate([0,0,-.01]) cylinder(r=nut_rad, h=nut_height, $fn=6);
		translate([0,0,nut_height+.3]) cylinder(r=bolt_rad, h=wall+1);
	}
}

module wheel_mount(){
	difference(){
		union(){
			cylinder(r=25/2, h=wall);
			translate([0,0,wall]) cylinder(r1=25/2, r2=8/2, h=10);
		}
		translate([0,0,-.01]) cylinder(r=nut_rad, h=nut_height, $fn=6);
		translate([0,0,nut_height+.3]) cylinder(r=bolt_rad, h=20);
	}
}

arm_rad = wall+2;

module arm_mounts(){
	%cube([arm_sep,1,30], center=true);

	translate([0,0,wall]) rotate([0,90,0]) difference(){
		union(){
			cylinder(r=arm_rad/cos(30), h=arm_sep-wall*2, center=true);
			for(i=[0,1]) mirror([0,0,i]) translate([0,0,arm_sep/2-wall]) cylinder(r1=arm_rad/cos(30), r2=bolt_cap_rad, h=wall);
		}

		//nut slot
		translate([0,0,-.01]) cylinder(r=nut_rad, h=arm_sep-wall*4, center=true, $fn=6);
		translate([nut_rad,0,-.01]) cylinder(r=nut_rad, h=arm_sep-wall*4, center=true, $fn=6);
		translate([0,0,nut_height-.02]) cylinder(r=bolt_rad, h=arm_sep+wall, center=true);

		//flatten the bottom
		translate([wall+10,0,0]) cube([20,25,arm_sep],center=true);
	}
}
