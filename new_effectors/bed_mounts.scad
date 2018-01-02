include <configuration.scad>

//623_bearing();
$fn=90;


sensor_rad = 20/2;
sensor_width = 9;
sensor_length = 50+15;

sensor_pad(height = wall+2.5);

//bed_retainer(start_height = wall+2.5, bed_thick = 7.5, glass_thick=3, bed_rad = 300/2);

module sensor_footprint(height = wall){
	translate([0,0,height/2]) union(){
		cube([sensor_width, sensor_length, height], center=true);
		translate([0, sensor_length/2, 0]) cylinder(r=sensor_rad, h=height, center=true);
	}
}

//this is a simple resting spot for the pressure sensor.  It recesses the sensor, and ties it in place with zip ties.
module sensor_pad(height = wall){
	sensor_recess = 1;
	min_rad = wall/2;
	difference(){
		union(){
			translate([0,0,0]) 
			minkowski(){
				sensor_footprint(height = height-.5);
				cylinder(r=min_rad, h=.5);
			}
		}

		translate([0,0,height-sensor_recess]) sensor_footprint(height = height);

		//mounting holes
		for(i=[min_rad*2-sensor_length/2,sensor_length/2]) translate([0, i, -.1]) {
			cylinder(r=m5_rad, h=height);
			translate([0,0,height-sensor_recess-m5_cap_height]) cylinder(r=m5_washer_rad, h=height);
		}

		//zip tie slots
		for(i=[-sensor_length/3,sensor_length/3]) translate([0, i, 0]) {
			rotate([0,90,0]) rotate([0,0,45]) cylinder(r=2.2, h=sensor_length, $fn=4, center=true);
			translate([0,0,height-sensor_recess+2.2/sqrt(2)]) rotate([0,90,0]) rotate([0,0,45]) cylinder(r=2.2, h=sensor_length, $fn=4, center=true);
		}
	}
}

module bed_retainer(start_height = wall+2.5, bed_thick = 7.5, glass_thick=3, bed_rad=300/2){
	height = start_height+bed_thick+glass_thick;

	//these should be related better - this is a kludge til I do the math properly.
	size = 30;
	offset = bed_rad-15;

	difference(){
		union(){
			//main body
			intersection(){
				union(){
					cube([size,size,height]);

					//wings for clips
					cube([size,size*2,glass_thick+bed_thick]);
					cube([size*2,size,glass_thick+bed_thick]);
				}
				translate([offset,offset,-.1]) cylinder(r=bed_rad+size, h=100, $fn=360);
			}
		}

		//cutout for actual bed
		translate([offset,offset,-.1]) cylinder(r=bed_rad, h=100, $fn=360);

		//cutout to miss other bits
		translate([offset,offset,glass_thick]) cylinder(r=bed_rad+wall, h=100, $fn=360);

		//screwhole for mounting
		translate([size/2,size/2,-.1]){
			cylinder(r=m5_washer_rad, h=height-wall);
			translate([0,0,height-wall+.1]) cylinder(r=m5_rad, h=height);
		}
	}
}