include <configuration.scad>;

//%translate([0,0,-.05]) cube([200,200,.1],center=true);

radius = 48;
fudge=4;


height = ext_y;

inner = ext_x+wall;
rounding = 10;

$fn=8;


//motor for printing
//bracket(motor=true);

//idler for printing
bracket(motor=false);
//translate ([0,-60,0]) idler();
//translate([0,0,sb_width/2]) rotate([0,90,0]) switch_bracket_screwed();


//idler assembly put together
//render() bracket(motor=false);
//translate ([0,46,-40]) rotate ([90,0,0]) idler();
//%translate ([0,17,5]) rotate ([-90,0,0]) switch();
//switch_bracket_screwed();


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
      mirror([i,0,0]) difference() {
        translate([ext_x/2+wall+30/2,-(30/2*sqrt(3))-(wall*2-wall/2*sqrt(3)),-.1]) cylinder(r=30,h=height+1, $fn=3);
			 translate([ext_x/2+wall,0,ext_y/2]) rotate([0,0,-30]) rotate([-90,0,0]) translate([ext_x/2,0,-50]) rotate([0,0,180/8]) cylinder(r=bolt_cap_rad+wall, h=50, $fn=8);
      }

    //trim the wings to free up extrusion slots
    for(i=[0:1])
      mirror([i,0,0]) difference() {
        translate([ext_x/2+wall+30/2,-(30/2*sqrt(3))-(wall*2-wall/2*sqrt(3))+wall+1,-.1]) cylinder(r=30,h=height+1, $fn=3);
			 translate([ext_x/2+wall,0,ext_y/2]) rotate([0,0,-30]) rotate([-90,0,0]) translate([0,0,-70]) cylinder(r=height/2, h=70, $fn=4);
      }

    //cut out extrusion slots
    translate([-ext_x/2, -ext_y,-.1]) ext_slot(ext_y+1,1, 0, [[1,0,1], [1,0,1]], [1,0,1]);
    for(i=[0:1]) mirror([i,0,0]) {
      translate([ext_x/2+wall,0,-.1]) rotate([0,0,-30]) ext_slot(ext_y+1, 1, ext_y, [[1,0,1], [0, 25, 0]], [0, 1, 0]);
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
  //cut out the mounting hole
  intersection(){
    translate([0,fudge-wall*3,-.1]) cylinder(r=radius+wall,h=height+.2,$fn=6);
    translate([0,fudge,-.1]) cylinder(r=radius,h=height+.2,$fn=6);
	 union(){
      translate([0,(inner)*cos(30)+wall,-.1]) cylinder(r=inner,h=height+1,$fn=6);
      for(i=[-1,1])
        translate([0,(inner)*cos(30)+wall,-.1]) rotate([0,0,i*30+90]) translate([20,0,0]) cylinder(r=inner,h=height+1,$fn=6);
    }
  }

  //this is the channel for the idler slider
  render() translate([0,(radius+wall)*cos(30)-wall,0]){
    translate([0,0,height/2-wall*3.5]) cylinder(r=20, h=height,center=true, $fn=4);
    
    translate([0,0,height+wall/2]) cylinder(r=bolt_cap_rad, h=wall*2,center=true);
    translate([0,0,height-wall/2+.3+.5]) cylinder(r=bolt_rad, h=wall*2+1,center=true);

    translate([0,0,height-wall*2+1]) cylinder(r=bolt_rad, h=wall,center=true);
    
    translate([0,0,height-wall*3+nut_height/2+.3]) rotate([0,0,30]) cylinder(r=nut_rad, h=nut_height+.1, center=true, $fn=6);
    translate([0,3,height-wall*3+nut_height/2+.3]) rotate([0,0,30]) cylinder(r=nut_rad, h=nut_height+.1, center=true, $fn=6);

    translate([0,0,height-wall*3+.3]) rotate([0,0,30]) cylinder(r=bolt_rad, h=5, center=true, $fn=6);
  }
}

//idler slider
//Fits in the slot made above.  Has a nut trap on the outside, and a sloped ridge on the inside for the bearing to ride on.  Bolt goes through bearing into nut trap - with washers added if needed for adjustment.
module idler(){
  translate([0,(radius+wall)*cos(30)-wall,0])
  rotate([-90,0,0])
  translate([0,-wall,0])
  difference(){
    union(){
      //body
      intersection(){
        translate([0,0,height/3]) cylinder(r=20-.5, h=height*2/3,center=true, $fn=4);
		  translate([0,0,height/3]) cube([40,wall*2,height*2/3],center=true);
      }

      //idler support
		translate([0,-wall+.01,height/4]) rotate([90,0,0]) cylinder(r1=bolt_cap_dia, r2=bolt_cap_rad, h=wall);
    }

    //idler bolt hole
    translate([0,-.2,height/4]) rotate([90,0,0]) cylinder(r=bolt_rad, h=wall*3);

    //idler nut trap
    translate([0,wall+.05,height/4]) rotate([90,0,0]) cylinder(r=nut_rad, h=wall, $fn=6);

    //tensioner mount
    translate([0,0,height*2/3-wall-1]) cube([8.2,wall*3,5.2],center=true);
    translate([0,0,height*2/3-wall*1.5]) cylinder(r=bolt_rad, h=wall*4.5, center=true);
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
        translate([ext_x/2,ext_x/2+i*(ext_y/3),-wall]) cylinder(r=bolt_rad, h=radius*3, center=true, $fn=8);
        for(k=[-wall*2-ext_x,height+wall*2])
          translate([ext_x/2,ext_x/2+i*(ext_y/3),k]) cylinder(r=bolt_cap_rad, h=head_len, $fn=16);
      }

      if(holes_y[i] >= 1){
        translate([ext_x/2,ext_y/2,ext_x/2+i*(ext_y/3)]) rotate([90,0,0]) cylinder(r=bolt_rad, h=ext_y+wall*2+1, center=true, $fn=8);
        for(k=[-.1-wall,ext_y+wall+head_len]){
          translate([ext_x/2,k,ext_x/2+i*(ext_y/3)]) rotate([90,0,0]) cylinder(r=bolt_cap_rad, h=head_len, $fn=16);
        }
      }

      //side
      for(j=[0:rows]){
		  if(holes_x[j][i] >= 1){
          translate([-wall-.1,ext_x/2+j*(ext_y/3),ext_x/2+i*(ext_y/3)]) rotate([0,90,0]) cylinder(r=bolt_rad, h=radius*3, center=true, $fn=8);
          for(k=[-wall-holes_x[j][i],ext_x+wall])
          translate([k,ext_x/2+j*(ext_y/3),ext_x/2+i*(ext_y/3)]) rotate([0,90,0]) cylinder(r=bolt_cap_rad, h=holes_x[j][i], $fn=16);
        }
      }
    }
  }
}

//can lower this in order to adjust switch up/down.  Don't think we need to, but you always need a little slop :-)
sb_width = 24;
//Contributed by Doug!  Thanks!
module switch_bracket_screwed() {
	//mounting plate, taken from "acccess hole down center" in the bracket module then modified
	translate([0,3.75,height/2]) rotate([90,0,0]) {
		difference (){
			rotate([0,0,180/8]) translate([0,0,.125]) cylinder(r=sb_width/2/cos(22.5), h=7.25,center=true, $fn=8);//oct
			cylinder (r=3.5/2,h=16,center=true,$fn=16);//screw hole
			translate ([0,0,-4]) cylinder (r=4,h=3,center=false,$fn=16);//head relief
		}

		//switch mount
		difference () {
			union() {
				translate ([0,-17.5,-2.5]) cube ([sb_width,25,2],center=true);//plate
				hull(){//makes a filleted top mtg block
					translate ([0,-24,-7.05+3.5]) cube ([sb_width,12,.1],center=true); //teeny flat bottom
					union() { //rounded corners
						translate ([sb_width/2-1,-24,3.5-6-6.725]) rotate ([90,0,0]) cylinder (r=1,h=12,center=true);
						translate ([-sb_width/2+1,-24,3.5-6-6.725]) rotate ([90,0,0]) cylinder (r=1,h=12,center=true);
						//#translate ([0,-19,3.5-6-6.725]) rotate ([0,90,0]) cylinder (r=1,h=23,center=true);
					}
					//#translate ([0,-24,3.5-6.95-6.725]) cube ([25,12,.1],center=true);//mtg block
				}

				
			}
			translate ([0,-20,-5]) cylinder (r=bolt_cap_rad+0.5,h=5,center=false);//head clearance
			translate ([0,-20.25,-9]) rotate ([0,0,0]) { //switch holes for plastic screws
				translate ([9.5/2,-2.4,0]) cylinder (r=0.95,h=10,center=true);
				translate ([-9.5/2,-2.4,0]) cylinder (r=0.95,h=10,center=true);
			}	
		}
	}
} 


//Contributed by Doug!
module switch() { //models donghai kw4-3z-3 switch
	//body
	difference () {
		cube ([20,10,6.55],center=true);
		translate ([9.5/2,-2.4,0]) cylinder (r=1.25,h=7,center=true);
		translate ([-9.5/2,-2.4,0]) cylinder (r=1.25,h=7,center=true);
	}
	
	//roller
	translate ([8.25,12.2,0]) cylinder (r=4.75/2,h=3.3,center=true);
	//lever
	translate ([1.5,7.5,0]) rotate ([0,0,10]) {
		cube ([20,.4,4], center=true);
		translate ([-10,-1,0]) rotate ([0,0,100]) cube ([2,.4,4], center=true);
	}
	//terminals
	translate ([16.5/2,-7,0]) cube ([.44,4,3.4],center=true);
	translate ([-16.5/2,-7,0]) cube ([.44,4,3.4],center=true);
	translate ([-0.75,-7,0]) cube ([.44,4,3.4],center=true);
}
