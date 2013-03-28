%translate([0,0,-.05]) cube([200,200,.1],center=true);

radius = 45;

ext_x = 20;
ext_y = 60;
wall = 5;

floor = -.1;

height = ext_y+floor;

bolt_slop = .2;
bolt_dia = 5+bolt_slop;
bolt_rad = bolt_dia/2;



inner = ext_x+wall;

//pencil in the motor
%translate([0,radius*cos(30)+50/2,height/2]) cube([42.3,50,42.3],center=true);
for(i=[0:3])
  %translate([0,radius*cos(30),height/2]) rotate([90,0,0]) rotate([0,0,90*i]) translate([31/2,31/2,0]) cylinder(r=1.8, h=20, $fn=18, center=true);

rounding = 5;


translate([100,0,0]) lower_bracket();
//rounding();

module rounding(){
  minkowski(){
    difference() {
      translate([0,0,rounding]) cylinder(r=radius-rounding,h=height-rounding*2,$fn=6);
      translate([0,rounding-radius,height/2]) rotate([0,90,0]) cylinder(r=radius/2.5,h=height,$fn=32, center=true);
    for(j=[0,height])
      for(i=[-1,1]) translate([i*radius,0,j]) rotate([0,-90*i,0]) rotate([60,0,0]) cylinder(r=radius/2.5,h=height-wall,$fn=32, center=true);
    }
    sphere(r=rounding);
  }
}


module lower_bracket(){
  difference(){
    minkowski(){
      difference() {
        translate([0,0,rounding]) cylinder(r=radius-rounding,h=height-rounding*2,$fn=6);
        translate([0,rounding-radius,height/2]) rotate([0,90,0]) cylinder(r=radius/2.5,h=height,$fn=32, center=true);
        //for(j=[0,height])
          //for(i=[-1,1]) translate([i*radius,0,j]) rotate([0,-90*i,0]) rotate([60,0,0]) cylinder(r=radius/2.5,h=height-wall,$fn=32, center=true);
      }
      sphere(r=rounding);
    }

    //cut out outer wings
    for(i=[0:1])
      mirror([i,0,0]) intersection() {
        translate([ext_x/2+wall+30/2,-(30/2*sqrt(3))-(wall*2-wall/2*sqrt(3)),-.1]) cylinder(r=30,h=height+1, $fn=3);
        //translate([0,0,-.1]) cylinder(r=radius-wall,h=height+1,$fn=6);
      }


    //cut out motor hole
    intersection(){
      translate([0,0,-.1]) cylinder(r=radius-wall,h=height+1,$fn=6);
      translate([0,(inner)*cos(30)+wall,-.1]) cylinder(r=inner,h=height+1,$fn=6);
    }
    
    //and the motor mount
    translate([0,radius*cos(30),height/2]) rotate([90,0,0]) cylinder(r=13, h=20,center=true);
    for(i=[0:3])
      translate([0,radius*cos(30),height/2]) rotate([90,0,0]) rotate([0,0,90*i]) translate([31/2,31/2,0]) cylinder(r=1.8, h=20, $fn=18, center=true);

    //cut out extrusion slots
    translate([-ext_x/2, -ext_y,floor]) ext_slot(ext_y+1,1, 0, [1,0,1], [1,0,1]);
    for(i=[0:1]) mirror([i,0,0]) {
      translate([ext_x/2+wall,0,floor]) rotate([0,0,-30]) ext_slot(ext_y+1, 0, ext_y, [1,0,1], [0, 1, 0]);
      translate([ext_x/2+wall,0,-.1]) rotate([0,0,-30]) translate([ext_x-.1, -ext_y/2,0]) cube([ext_x, ext_y, height+1]);
    }

    //cut out screwholes
  }
}

//this makes holes for extrusions - cubes with filleted holes, vertically.
module ext_slot(height=ext_y, rows=0, head_len=ext_x+wall, holes_x=[0,0,0], holes_y=[0,0,0], holes_z=[0,0,0]){
  render() union(){
    cube([ext_x, ext_y,height]);
    for(i=[.25,ext_x-.25]){
      for(j=[.25,ext_y-.25]){
        translate([i,j,0]) cylinder(r=.5, h=height, $fn=8);
      }
    }

    //screw holes everywhere!
    //three in each direction.
    for(i=[0:2]){
      if(holes_z[i] == 1){
        //top/bottom
        translate([ext_x/2,ext_x/2+i*(ext_y/3),-wall]) cylinder(r=bolt_rad, h=height+wall+wall, $fn=8);
        for(k=[-wall*2-ext_x,height+wall*2])
          translate([ext_x/2,ext_x/2+i*(ext_y/3),k]) cylinder(r=bolt_dia, h=head_len, $fn=16);
      }

      if(holes_y[i] == 1){
        translate([ext_x/2,ext_y+wall+.1,ext_x/2+i*(ext_y/3)]) rotate([90,0,0]) cylinder(r=bolt_rad, h=height+wall+wall+.2, $fn=8);
        for(k=[-.1-wall,ext_y+wall+head_len])
          translate([ext_x/2,k,ext_x/2+i*(ext_y/3)]) rotate([90,0,0]) cylinder(r=bolt_dia, h=head_len, $fn=16);
      }

      if(holes_x[i] == 1){
        //side
        for(j=[0:rows])
          translate([-wall-.1,ext_x/2+j*(ext_y/3),ext_x/2+i*(ext_y/3)]) rotate([0,90,0]) cylinder(r=bolt_rad, h=ext_x+wall+wall+.2, $fn=8);
      }
    }
  }
}
