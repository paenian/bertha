////////
//This is a fan shroud for the e3d v6 with some room for the cables.

slop = .2;

heatsink_rad = 22/2+slop;
wire_rad = 6;

fan = 30;
fan_holes = 24;
fan_rad = 28/2;
fan_thickness = 10+slop*3;

heatblock_rad = 40/2+slop;

thickness = 10;
offset = 8;

wall = 4;

angle=130;

m3_rad = 2.9/2;

$fn=72;

duct_2();

//more minimal duct, that'll slip in above the heat block
module duct_2(){
	height = 28;
	wall=2;
	
	difference(){
		translate([0,0,(height-fan)/2]) hull(){
			translate([0, heatsink_rad+offset+wall/2]) cube([fan, wall, height], center=true);

			cylinder(r=heatsink_rad+wall, h=height, center=true);
		}

		//cut out the heatsink
		union(){
			cylinder(r=heatsink_rad, h=fan+wall*3, center=true);
			translate([0,heatsink_rad-2,0]) cylinder(r=wire_rad, h=fan+wall*3, center=true); //this is the wire path
		}

		//air path
		hull(){
			translate([0,offset+thickness/2+heatsink_rad,0]) rotate([90,0,0]) cylinder(r=fan_rad, h=20, center=true);
			cylinder(r=heatsink_rad-wall*1.5, h=fan_rad*2-wall*3, center=true);
		}

		//clip on slot
		difference(){
			union(){
				for(i=[angle/2-45, -angle/2+45]) rotate([0,0,i]) translate([0,-sqrt(2)*25,0]) rotate([0,0,45]) cube([50,50,50], center=true);
			}

			for(i=[angle/2, -angle/2]) rotate([0,0,i]) translate([0,-heatsink_rad-wall/2,0]) cylinder(r=wall/2, h=fan+wall*2, center=true);
		}

		//mounting holes for fan
		for(i=[-fan_holes/2, fan_holes/2]) for(j=[-fan_holes/2, fan_holes/2])
			translate([i, heatsink_rad+offset+wall/2, j]) rotate([90,0,0]) cylinder(r1=m3_rad, r2=m3_rad-.1, h=wall*5, center=true);
	}
}

module duct_1(){
	difference(){
		hull(){
			translate([0,offset+fan_thickness/2+wall/2+heatsink_rad,0]) cube([fan+wall,fan_thickness+wall,fan+wall], center=true);
			cylinder(r=heatsink_rad+wall/2, h=fan+wall, center=true);
		
			translate([0,0,-(fan+wall)/2]) cylinder(r=heatblock_rad+wall/2, h=(fan+wall)/3-3);
		}

		//cut out the heatsink
		union(){
			cylinder(r=heatsink_rad, h=fan+wall*3, center=true);
			translate([0,offset,wall]) cylinder(r=heatsink_rad-wall, h=fan, center=true); //this is the wire path

			//we need to widen the bottom for the heat block
			hull(){
				translate([0,0,-3]) cylinder(r=heatsink_rad, h=.1, center=true);
				translate([0,0,-(fan+wall)/2-.1]) cylinder(r=heatblock_rad, h=(fan+wall)/3-3);
			}
		}
	
		//air path
		hull(){
			translate([0,offset+thickness/2+heatsink_rad,0]) rotate([90,0,0]) cylinder(r=fan_rad, h=20, center=true);
			cylinder(r=heatsink_rad-wall*1.5, h=fan-wall, center=true);
		}

		//fan slot
		translate([0,offset+fan_thickness/2+wall/2+heatsink_rad,wall/2]) cube([fan,fan_thickness,fan+wall], center=true);

		//clip on opening
		difference(){
			union(){
				for(i=[angle/2-45, -angle/2+45]) rotate([0,0,i]) translate([0,-sqrt(2)*25,0]) rotate([0,0,45]) cube([50,50,50], center=true);
			}

			for(i=[angle/2, -angle/2]) rotate([0,0,i]) translate([0,-heatsink_rad,0]) cylinder(r=wall/2, h=fan+wall*2, center=true);
		}
	}
}

