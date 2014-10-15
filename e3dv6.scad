////////
//This is a fan shroud for the e3d v6 with some room for the cables.

slop = .2;

heatsink_rad = 22/2+slop;
fan = 30+slop*2;
fan_holes = 24;
fan_rad = 29/2;
fan_thickness = 10+slop*2;

thickness = 10;
offset = 8;

wall = 4;

angle=130;

m3_rad = 2.9/2;

$fn=36;

difference(){
	hull(){
		translate([0,offset+fan_thickness/2+wall/2+heatsink_rad,0]) cube([fan+wall,fan_thickness+wall,fan+wall], center=true);
		cylinder(r=heatsink_rad+wall/2, h=fan+wall, center=true);
	}

	//cut out the heatsink
	union(){
		cylinder(r=heatsink_rad, h=fan+wall*3, center=true);
		translate([0,offset,wall]) cylinder(r=heatsink_rad-wall, h=fan, center=true); //this is the wire path
	}
	
	//air path
	hull(){
		translate([0,offset+thickness/2+heatsink_rad,0]) rotate([90,0,0]) cylinder(r=fan_rad, h=20, center=true);
		cylinder(r=heatsink_rad-wall/2, h=fan-wall, center=true);
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

