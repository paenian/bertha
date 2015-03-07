
wall = 2;
width = 30;
duct_r = 16.1;
fan_r = (width-wall)/2;
screw_w = 24;
screw_r = 2.1;
screw_cap_r = 6.3/2;

angle=220;
twist = 15;     //rotates the duct a little.  I figure it stirs the air in my heated chamber :-)

tinyduct();

module tinyduct(){
    difference(){
        translate([0,0,wall/2]) union(){
            cube([width, width, wall], center=true);
            translate([-duct_r,0,0]) rotate([twist,0,0]) rotate([90,0,0]) rotate_extrude(convexity=10, $fn=60){
                translate([duct_r,0,0]) circle(r=fan_r+wall, $fn=60);
            }
        }
        
        //screwholes
        for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([screw_w/2, screw_w/2, -.1]) {
            cylinder(r=screw_r, h=wall*2, $fn=30);
            translate([0,0,wall]) cylinder(r=screw_cap_r, h=width, $fn=30);
        }
        
        //hollow out the duct
        difference(){
            translate([-duct_r,0,0]) rotate([twist,0,0]) rotate([90,0,0]) rotate_extrude(convexity=10, $fn=60){
                translate([duct_r,0,0]) circle(r=fan_r, $fn=60);
            }
            //this makes sure there's no holes where the screw heads go.
            for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([screw_w/2, screw_w/2, -.1]) {
                cylinder(r=screw_cap_r+wall/4, h=width, $fn=30);
            }
        }
        
        //cut off the duct angle
        translate([-duct_r,0,0]) rotate([twist,0,0]) for(i=[90:width:angle])
               rotate([0,i,0]) translate([0,-width,-width*2]) cube([width*2, width*2, width*2]);
        translate([-duct_r,0,0]) rotate([0,angle,0]) translate([0,-width,-width*2]) cube([width*2, width*2, width*2]);
        
        translate([0,0,-width*2]) cube([width*2, width*2, width*4], center=true);
        
    }
}