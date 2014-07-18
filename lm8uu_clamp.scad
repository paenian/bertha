slop = .25;

m3_dia = 3;
m3_rad = m3_dia/2+slop;

m3_cap_dia = 5.7;
m3_cap_rad = m3_cap_dia/2+slop;
m3_cap_thick = 1.65+slop/2;
m3_cap_hex_rad = (2/cos(30))/2;

m3_nut_dia = 6.4;
m3_nut_rad = m3_nut_dia/2+slop;
m3_nut_thick = 2.4+slop;


lm8uu_dia = 15;
lm8uu_rad = lm8uu_dia/2+slop;
lm8uu_len = 24+slop;

lm8uu_inset = 2;  //inset into frame

wall = 3;
width = 10;
hole_sep = 20;

$fn=32;

bearing_clamp();

module bearing_clamp(){
	difference(){
		hull(){
			rotate([-90,0,0]) translate([0,lm8uu_inset-lm8uu_rad,0]) cylinder(r=lm8uu_rad+wall, h=width, center=true);

			for(i=[0,1]) mirror([i,0,0]) translate([hole_sep/2,0,0]) cylinder(r=m3_rad+wall, h=wall);
		}

		//bearing
		rotate([-90,0,0]) hull(){
			translate([0,lm8uu_inset-lm8uu_rad,0]) cap_cylinder(r=lm8uu_rad, h=lm8uu_len, center=true);
			cap_cylinder(r=lm8uu_rad, h=lm8uu_len, center=true);
		}

		//screwholes
		for(i=[0,1]) mirror([i,0,0]) translate([hole_sep/2,0,-.1]) {
			cylinder(r=m3_rad, h=wall+.1);
			translate([0,0,wall/2]) cylinder(r=m3_cap_rad, h=lm8uu_dia);
		}

		translate([0,0,-50]) cube([100,100,100], center=true); 
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

module cap_cylinder(r=1, h=1, center=false){
	cylinder(r=r, h=h, center=center);
	intersection(){
		rotate([0,0,22.5]) cylinder(r=r/cos(180/8), h=h, $fn=8, center=center);
		translate([0,-r/cos(180/4),0]) rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
	}
}