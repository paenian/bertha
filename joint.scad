slop = .25;

screw_dia = 3;
screw_rad = screw_dia/2+slop;

cap_dia = 5.7;
cap_rad = cap_dia/2+slop;
cap_thick = 1.65+slop/2;
cap_hex_rad = (2/cos(30))/2;

nut_dia = 6.4;
nut_rad = nut_dia/2+slop;
nut_thick = 2.4+slop;

bearing_dia = 10;
bearing_rad = bearing_dia/2+slop;
bearing_thick = 5+slop;



wall = 2.5;
bearing_cone_height = 2;
arm_width = 14;
center = arm_width-bearing_cone_height*2-slop*2;
center_height = nut_dia+wall/2;
screw_len = 11;

//%cube([27,27,27],center=true);

$fn=32;

//uses two m3 by 10mm, one m3 by 30mm, three nuts, four 603zz bearings.
*union(){
	rotate([0,90,0]) center();
	half_arm();
	rotate([0,180,0]) half_arm();

	rotate([0,0,180]) rotate([0,90,0]) rotate([80,0,0]){
		half_arm();
		rotate([0,180,0]) half_arm();
	}
}

//for printing
difference(){
	translate([0,0,12.5]) rotate([7.1,0,0]) rotate([0,90,0]) half_arm();
	translate([0,0,-25]) cube([100,100,50], center=true);
}
//center();


//NOTE:  Rostock jaws are 8.4mm wide.
echo("arm_sep=", center+bearing_cone_height*2);
//Right now these are 13.5mm.  That's kind of a lot.




module half_arm(){
	rod_rad = 4.5;
	width = arm_width+wall+bearing_thick*2;
	cutout_offset = 9;
	clamp_dist = -27;

	difference(){
		union(){
			hull(){
				//caress the bearing
				translate([arm_width/2+wall/2,0,0]) rotate([0,90,0]) cylinder(r=bearing_rad+wall, h=bearing_thick);
				//grab the rod
				translate([wall/2,-20,0]) rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=(rod_rad+wall)/cos(22.5), h=30, center=true, $fn=8);
			}

			//clamping wings
			hull(){
				for(i=[0,1]) mirror([0,0,i]) translate([0, clamp_dist, rod_rad/cos(45)+screw_rad]) rotate([0,90,0]) rotate([0,0,0]) cylinder(r=nut_rad+wall/2, h=wall*4, $fn=6);
				//translate([0, clamp_dist, 0]) rotate([0,90,0]) rotate([0,0,0]) cylinder(r=nut_rad+wall/2, h=wall*4, $fn=6);
			}
		}

		//rod cutout
		translate([0,-32,0]) rotate([90,0,0]) cylinder(r=rod_rad/cos(45), h=30, center=true, $fn=4);
		translate([-25+slop,0,0]) cube([50,100,100],center=true);

		//center hole
		hull(){
			for(i=[0,1]) mirror([0,i,0]) translate([0,cutout_offset,0]) scale([1,1.25,1]) cylinder(r=(arm_width+wall)/2, h=50, center=true);
			
		}

		//screw mounts
		translate([-wall, clamp_dist, rod_rad/cos(45)+screw_rad]) rotate([0,90,0]){
			cylinder(r=screw_rad, h=wall*2-.5);
			translate([0,0,wall*2]) cylinder(r=cap_rad+slop, h=10);
		}
		translate([-wall, clamp_dist, -rod_rad/cos(45)-screw_rad]) rotate([0,90,0]){
			cylinder(r=screw_rad, h=wall*2-.5);
			translate([0,0,wall*2]) cylinder(r=nut_rad, h=10, $fn=6);
		}

		//bearing hole
		translate([arm_width/2+wall/2-bearing_thick*3,0,0]) rotate([0,90,0])cylinder(r=bearing_rad+wall, h=bearing_thick*3);
		translate([arm_width/2,0,0]) rotate([0,90,0])cylinder(r=bearing_rad, h=bearing_thick);
		translate([arm_width/2+wall,0,0]) rotate([0,90,0]) cylinder(r=cap_rad+slop, h=bearing_thick);
	}
}

//this is a m3 bearing mounted up against the hotend effector, modifying the current design for the smaller bolt.
//Should be a bit more compact.
module triple_center(){
	%translate([0,0,bearing_rad]) bearing();
	

}

module center(){
	screw_offset = -screw_len/2+center/2+bearing_thick+bearing_cone_height;
	difference(){
		hull(){
			intersection(){
				cube([center, center, center_height],center=true);
				rotate([0,0,45]) cube([center, center, center_height],center=true);
			}
		
			for(i=[0:90:359]) rotate([0,0,i])  rotate([0,90,0]) translate([0,0,center/2]) cylinder(r1=center_height/2, r2=cap_rad, h=bearing_cone_height);
		}

		//core it
		intersection(){
			cube([center-wall*2, center-wall*2, center_height+.1],center=true);
			rotate([0,0,45]) cube([center-wall*2, center-wall*2, center_height+.1],center=true);
		}

		//screwholes
		for(i=[0:90:359]) rotate([0,0,i]){
			//screws
			#rotate([0,90,0]) translate([0,0,screw_offset]) cap_screw(screw_len);
			//bearings - these are just drawn in place
			%rotate([0,90,0]) translate([0,0,center/2+bearing_cone_height]) bearing();
		}
		//nut traps
		hull() {
			//rotate([0,0,30]) cylinder(r=nut_rad, h=nut_thick, center=true, $fn=6);
			translate([0,0,center_height/2]) for(i=[0:180:359]) rotate([0,0,i]) rotate([0,90,0]) translate([0,0,center/2+bearing_cone_height-nut_thick/2-wall])
				rotate([0,0,30]) cylinder(r=nut_rad, h=nut_thick, center=true, $fn=6);
		}
	}
}

module bearing(){
	difference(){
		cylinder(r=bearing_rad, h=bearing_thick);
		translate([0,0,-.1]) cylinder(r=screw_rad, h=bearing_thick+.2);
	}
}

module cap_screw(len = 10){
	color([.25,.25,.25])
	difference(){
		union(){
			translate([0,0,-len/2]) rotate([0,0,-90]) cap_cylinder(r=screw_rad, h=len, center=true);
			translate([0,0,len/2-.1]) difference(){
				scale([1,1,.75]) sphere(r=cap_rad);
				translate([0,0,-cap_dia/2]) cube([cap_dia+1, cap_dia+1, cap_dia],center=true);
				translate([0,0,cap_dia/2+.1+cap_thick]) cube([cap_dia+1, cap_dia+1, cap_dia],center=true);
			}
		}
		
		translate([0,0,len/2+slop]) cylinder(r=cap_hex_rad, h=cap_thick, $fn=6);
	}
}

module cap_cylinder(r=1, h=1){
	cylinder(r=r, h=h);
	intersection(){
		rotate([0,0,22.5]) cylinder(r=r/cos(180/8), h=h, $fn=8);
		translate([0,-r/cos(180/4),0]) rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4);
	}
}