include <configuration.scad>;

slot_w = 6;
slot_h = 6;
rivet_w = slot_w+2;

tslot_rivet(bolt_dia);
translate([rivet_w, 0,0]) tslot_rivet(4.2);
translate([rivet_w*2, 0,0]) tslot_rivet(3.2);
facets = 3;

$fn=64;

module tslot_rivet(b = bolt_dia){
	dia = b;
	rad = dia/2;

	difference(){
		translate([0,0,slot_h/2]) cube([slot_w, rivet_w, slot_h], center=true);

		//cut the corners
		for(i=[0:1]) mirror([i,0,0]) translate([-slot_w/2,0,slot_h]) rotate([0,45,0]) cube([1,rivet_w+1, slot_h], center=true);
	
		//pivot slot
		translate([0,0,slot_h/2+2]) cube([1,rivet_w+1, slot_h], center=true);
		//bolt hole
		translate([0,0,-.1]) cylinder(r1=rad, r2=rad/2, h=slot_h+.2);

		//grip slots
		for(i=[0:facets]){
			rotate([0,0,i*360/facets]) translate([0,0,slot_h/2]) cube([1, dia, slot_h+1], center=true);
		}
	}	
}