include <configuration.scad>;

rail_width=25.4649;
v_rad = 9.77;

rail_effector();


module rail_effector(){
	union(){
		//v wheels
		translate([-rail_width/2-v_rad,0,0]) wheel_mount();
		translate([rail_width/2+v_rad,-rail_width/2-v_rad,0]) wheel_mount();
		translate([rail_width/2+v_rad,rail_width/2+v_rad,0]) wheel_mount();

		//arms
		translate([0,0,0]) arm_mounts();
	}
}

module wheel_mount(){
	difference(){
		union(){
			cylinder(r=25/2, h=wall);
			translate([0,0,wall]) cylinder(r1=25/2, r2=8/2, h=10);
		}
		translate([0,0,-.01]) cylinder(r=bolt_rad, h=20);
	}
}

module hotend_effector(){
}

module arm_mounts(){
}
