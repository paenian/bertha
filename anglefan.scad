fan_size = 40;
hole_sep = 32;
hole_rad = 2;
hole_cap_rad = 6.6/2;
center_rad = 36/2;

mount_tab = 8;

corner_rad = (fan_size-hole_sep)/2;

nozzle_rad = 10;
nozzle_offset = -10;

wall=2;

bottom_flat = -fan_size/2-50+1;

duct_rad = 40;


anglefan(angle=35);

module anglefan(angle=20){
    difference(){
        union(){
            hull(){
                //mounting tab
                for(i=[-1, 1])
                    translate([i*(fan_size/2-corner_rad), 0, wall/2]) {
                        
                       //rotate([angle,0,0])
                       translate([0,fan_size/2+mount_tab,0]) cylinder(r=corner_rad, h=wall, center=true, $fn=32);
                        //translate([0,0,0]) cylinder(r=corner_rad, h=wall, center=true, $fn=32);
                    }
                    
                    cylinder(r=nozzle_rad, h=5, center=true);
                    
            }
               hull(){
               //fan mount
               translate([0,fan_size/2,0]) rotate([-angle,0,0]) translate([0,-fan_size/2,0]) fanMount();
            
                //duct
                *intersection(){
                        translate([0,duct_rad,0]) rotate([0,90,0]) rotate_extrude(convexity=10, $fn=60, angle=20){
                            translate([duct_rad,0,0]) circle(r=fan_size/2, $fn=60);
                            }
            
                    hull(){
                        translate([0,0,wall/2]) cube([fan_size, fan_size, wall], center=true);
                        translate([0,fan_size/2,wall/2]) rotate([-angle,0,0]) translate([0,-fan_size/2,0])
                    cube([fan_size, fan_size, wall], center=true);
                    }
                }
                
                //duct v2 - straight
                hull(){
                    translate([0,nozzle_offset,0]) cylinder(r=nozzle_rad, h=wall, center=true);
                    
                    translate([0,fan_size/2,wall*2]) rotate([-angle,0,0]) translate([0,-fan_size/2,0])
                    cylinder(r=fan_size/2, h=.1, center=true);
                }
            }
            
    }
    
        //hollow out the duct
            *difference(){
            translate([0,duct_rad,0]) rotate([0,90,0]) rotate_extrude(convexity=10, $fn=60, angle=20){
                           translate([duct_rad,0,0]) circle(r=fan_size/2-wall, $fn=60);
                            }
                            
                            translate([0,bottom_flat+wall,0]) cube([100,100,100], center=true);
                            
         }
         
         //v2 duct hollow
         hull(){
                    translate([0,nozzle_offset,wall/2]) cylinder(r=nozzle_rad-wall, h=wall+.2, center=true);
                    
                   translate([0,fan_size/2,0]) rotate([-angle,0,0]) translate([0,-fan_size/2,wall*1.5])
                    cylinder(r=fan_size/2-wall, h=wall+.1, center=true, $fn=64);
                }
                        
        
        //fan holes
        translate([0,fan_size/2,0]) rotate([-angle,0,0]) translate([0,-fan_size/2,0])fanHoles();
                            
        //mounting holes
        for(i=[-1, 1])
            translate([i*hole_sep/2, fan_size/2+mount_tab, -wall*10]) {
                cylinder(r=hole_rad, h=wall*20, $fn=32);
            }
            
        //cut off the bottom flat
        translate([0,bottom_flat,0]) cube([100,100,100], center=true);
            
        translate([0,0,-50]) cube([100,100,100], center=true);
    }
}

module fanMount(){
    hull(){
        for(i=[-1, 1])
            for(j=[-1,1])
                translate([i*(fan_size/2-corner_rad), j*(fan_size/2-corner_rad), wall]) cylinder(r=corner_rad, h=wall*2, center=true, $fn=32);
    }
}

module fanHoles(){
    for(i=[-1, 1])
        for(j=[-1,1])
            translate([i*hole_sep/2, j*hole_sep/2, -wall*10]) {
                cylinder(r=hole_rad, h=wall*20, $fn=32);
                cylinder(r1=hole_cap_rad+1, r2=hole_cap_rad, h=wall*10, $fn=6);
            }
    
    //cylinder(r=center_rad, h=wall, center=true, $fn=64);
    
    //translate([0,0,wall*3]) cube([fan_size, fan_size, wall*4], center=true);
}