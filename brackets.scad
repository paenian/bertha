%translate([0,0,-.05]) cube([200,200,.1],center=true);

radius = 48;
fudge=4;

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
//%translate([0,radius*cos(30)+50/2,height/2]) cube([42.3,50,42.3],center=true);
//for(i=[0:3])
  //%translate([0,radius*cos(30),height/2]) rotate([90,0,0]) rotate([0,0,90*i]) translate([31/2,31/2,0]) cylinder(r=1.8, h=20, $fn=18, center=true);

rounding = 10;


//%translate([-65/2,-84/2+4,0]) cube([65,84,50]);

bracket(motor=false);
//rounding();

$fn=32;

module rounding(){
  minkowski(){
    difference() {
      translate([0,0,rounding]) cylinder(r=radius-rounding,h=height-rounding*2,$fn=6);
      translate([0,rounding-radius,height/2]) rotate([0,90,0]) cylinder(r=radius/2.5,h=height,$fn=36, center=true);
    for(j=[0,height])
      for(i=[-1,1]) translate([i*radius,0,j]) rotate([0,-90*i,0]) rotate([60,0,0]) cylinder(r=radius/2.5,h=height-wall,$fn=36, center=true);
    }
    sphere(r=rounding);
  }
}

module bracket(motor = true){
  difference(){
    minkowski(){
      difference() {
        translate([0,fudge,0]) cylinder(r=radius-rounding,h=height-rounding,$fn=6);
      }
		intersection(){
      		sphere(r=rounding);
			translate([0,0,rounding]) cube([rounding*2, rounding*2, rounding*2],center=true);
		}
    }

    //cut out outer wings
    for(i=[0:1])
      mirror([i,0,0]) intersection() {
        translate([ext_x/2+wall+30/2,-(30/2*sqrt(3))-(wall*2-wall/2*sqrt(3)),-.1]) cylinder(r=30,h=height+1, $fn=3);
        //translate([0,0,-.1]) cylinder(r=radius-wall,h=height+1,$fn=6);
      }

    //cut out extrusion slots
    translate([-ext_x/2, -ext_y,floor]) ext_slot(ext_y+1,1, 0, [[1,0,1], [1,0,1]], [1,0,1]);
    for(i=[0:1]) mirror([i,0,0]) {
      translate([ext_x/2+wall,0,floor]) rotate([0,0,-30]) ext_slot(ext_y+1, 1, ext_y, [[1,0,1], [0, 15, 0]], [0, 1, 0]);
      translate([ext_x/2+wall,0,-.1]) rotate([0,0,-30]) translate([ext_x-.1, -ext_y/2,0]) cube([ext_x, ext_y, height+1]);
    }

    //access hole down the center
    translate([0,-radius/2,height/2]) rotate([90,0,0]) rotate([0,0,180/8]) cylinder(r=13.5, h=80,center=true, $fn=8);

    //access holes on the sides
    translate([0,20,height/2]) rotate([90,0,0]) rotate([0,60,0]) rotate([0,0,180/8]) translate([0,0,10]) cylinder(r=10.63, h=40,center=true, $fn=8);
    translate([0,20,height/2]) rotate([90,0,0]) rotate([0,-60,0]) rotate([0,0,180/8]) translate([0,0,10]) cylinder(r=10.63, h=40,center=true, $fn=8);

    if(motor){
      motor_mount();
    }else{
      idler_mount();
    }
  }
}

inner_radius = radius*cos(30);

//idler cutout and mount
module idler_mount(){
  intersection(){
    translate([0,fudge-wall*3,-.1]) cylinder(r=radius+wall,h=height+.2,$fn=6);
    translate([0,fudge,-.1]) cylinder(r=radius,h=height+.2,$fn=6);
	 union(){
      translate([0,(inner)*cos(30)+wall,-.1]) cylinder(r=inner,h=height+1,$fn=6);
      for(i=[-1,1])
        translate([0,(inner)*cos(30)+wall,-.1]) rotate([0,0,i*30+90]) translate([20,0,0]) cylinder(r=inner,h=height+1,$fn=6);
    }
  }

  //TODO:: Make this a vertical, angled slot so the idler can ride up and down it.  Leave 5mm at the top bridge, with a hole in the middle for adjusting.
  translate([0,radius*cos(30),height/2]) rotate([90,0,0]) cylinder(r=15, h=20,center=true, $fn=16);
}

//idler slider
//TODO::  Fits in the slot made above.  Has a nut trap on the outside, and a sloped ridge on the inside for the bearing to ride on.  Bolt goes through bearing into nut trap - with washers added if needed for adjustment.
module idler_slider(){
	union(){
	}
}

//motor cutout and mount
module motor_mount(){
  //cut out motor hole
  intersection(){
    translate([0,fudge,-.1]) cylinder(r=radius-wall,h=height+1,$fn=6);
	 union(){
      translate([0,(inner)*cos(30)+wall,-.1]) cylinder(r=inner,h=height+1,$fn=6);
      for(i=[-1,1])
        translate([0,(inner)*cos(30)+wall,-.1]) rotate([0,0,i*30+90]) translate([20,0,0]) cylinder(r=inner,h=height+1,$fn=6);
    }
  }
    
  //and the motor mount
  translate([0,radius*cos(30),height/2]) rotate([90,0,0]) cylinder(r=13, h=20,center=true, $fn=16);
  for(i=[0:3]){
    translate([0,radius*cos(30),height/2]) rotate([90,0,0]) rotate([0,0,90*i]) translate([31/2,31/2,0]) cylinder(r=2, h=20, $fn=18, center=true, $fn=8);
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
      if(holes_z[i] >= 1){
        //top/bottom
        translate([ext_x/2,ext_x/2+i*(ext_y/3),-wall]) cylinder(r=bolt_rad, h=height+wall+wall, $fn=8);
        for(k=[-wall*2-ext_x,height+wall*2])
          translate([ext_x/2,ext_x/2+i*(ext_y/3),k]) cylinder(r=bolt_dia, h=head_len, $fn=16);
      }

      if(holes_y[i] >= 1){
        translate([ext_x/2,ext_y+wall+.1,ext_x/2+i*(ext_y/3)]) rotate([90,0,0]) cylinder(r=bolt_rad, h=height+wall+wall+.2, $fn=8);
        for(k=[-.1-wall,ext_y+wall+head_len])
          translate([ext_x/2,k,ext_x/2+i*(ext_y/3)]) rotate([90,0,0]) cylinder(r=bolt_dia, h=head_len, $fn=16);
      }

      //side
      for(j=[0:rows]){
		  if(holes_x[j][i] >= 1){
          translate([-wall-.1,ext_x/2+j*(ext_y/3),ext_x/2+i*(ext_y/3)]) rotate([0,90,0]) cylinder(r=bolt_rad, h=ext_x+wall+wall+.2, $fn=8);
          for(k=[-wall-holes_x[j][i],ext_x+wall])
          translate([k,ext_x/2+j*(ext_y/3),ext_x/2+i*(ext_y/3)]) rotate([0,90,0]) cylinder(r=bolt_dia, h=holes_x[j][i], $fn=16);
        }
      }
    }
  }
}
