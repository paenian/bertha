in = 24.5;
slop = .2;


front_site();

translate([15,0,0]) rear_site();


//this is the trapezoid with the half-moon top.
module rear_site(){
    base_w = .483*in - slop;
    base_rad = base_w/sqrt(3);
    base_len = .82*in;
    
    base_height = .09*in;
    
    top_height = .21*in-base_height;
    top_rad = .379/2*in-slop/2;
    top_w = .1*in;
    
    union(){
        difference(){
            translate([0,0,base_rad*cos(60)]) rotate([90,0,0]) rotate([0,0,-30]) cylinder(r=base_rad, h=base_len, center=true, $fn=3);
            translate([0,0,base_rad*cos(60)+base_height]) rotate([90,0,0]) rotate([0,0,-30]) cylinder(r=base_rad, h=base_len+1, center=true, $fn=3);
        }
            
        intersection(){
            translate([0,0,base_height]) scale([1,1,(top_height/top_rad)]) rotate([90,0,0]) cylinder(r=top_rad, h=top_w, center=true, $fn=60);
            translate([0,0,base_rad*cos(60)+base_height-.1]) rotate([90,0,0]) rotate([0,0,-30]) cylinder(r=base_rad, h=base_len+1, center=true, $fn=3);
        }
    }
}

module front_site(){
    base_w = .374*in - slop-.06*in*2;
    base_rad = base_w/sqrt(3);
    base_len = .6*in;
    
    base_cutoff=.075*in;
    
    echo(base_w/25.4);
    
    base_height = .067*in;
    
    top_height = .15*in;
    top_width = .4*in;
    
    peak_width=.110*in;
    
    union(){
        //base
        difference(){
            translate([0,0,base_rad*cos(60)]) rotate([90,0,0]) rotate([0,0,-30]) cylinder(r=base_rad, h=base_len, center=true, $fn=3);
            translate([0,0,base_rad*cos(60)+base_height+.01]) rotate([90,0,0]) rotate([0,0,-30]) cylinder(r=base_rad, h=base_len+1, center=true, $fn=3);
        }
         
        //top
        difference(){
            hull(){
                translate([0,0,base_height]) cube([top_width,base_len,.01], center=true);
                translate([0,0,top_height]) cube([.01,peak_width,.01], center=true);
            }
            
            translate([0,0,base_height-.1]) cube([base_len, peak_width,10], center=true);
        }
        
        //raised center base
        difference(){
            translate([0,0,base_rad*cos(60)]) rotate([90,0,0]) rotate([0,0,-30]) cylinder(r=base_rad, h=peak_width+.1, center=true, $fn=3);
            translate([0,0,base_rad*cos(60)+base_cutoff]) rotate([90,0,0]) rotate([0,0,-30]) cylinder(r=base_rad, h=base_len+1, center=true, $fn=3);
        }
    }
}