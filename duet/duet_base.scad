

 module hexbase () {

// Customizable hex pattern
// Created by Kjell Kernen
// Date 22.9.2014

/*[Pattern Parameters]*/
// of the pattern in mm:
width=129;       // [10:100]

// of the pattern in mm:
lenght=106;      // [10:100]

// of the pattern in tens of mm:
height=50;       // [2:200]

// in tens of mm:
border_width=100;// [2:100]

// in mm:
hex_radius=10;   // [1:20]

// in tens of mm: 
hex_border_width=30; // [2:50]

/*[Hidden]*/

xborder=(border_width/10<width)?width-border_width/10:0;
yborder=(border_width/10<lenght)?lenght-border_width/10:0;

x=sqrt(3/4*hex_radius*hex_radius);
ystep=2*x;
xstep=3*hex_radius/2;

module hex(x,y)
{
	difference()
	{
		translate([x,y,-height/20]) 
			cylinder(r=(hex_radius+hex_border_width/20), h=height/10, $fn=6);	
		translate([x,y,-height/20-.1]) 
			cylinder(r=(hex_radius-hex_border_width/20), h=height/10+.2, $fn=6);
	}
}

//Pattern
intersection()
{
	for (xi=[0:xstep:width])
		for(yi=[0:ystep:lenght])
			hex(xi-width/2,((((xi/xstep)%2)==0)?0:ystep/2)+yi-lenght/2);
	translate([-width/2, -lenght/2, -height/20]) 
		cube([width,lenght,height/10]);
}

// Frame
difference()
{
	translate([-width/2, -lenght/2, -height/20]) 
		cube([width,lenght,height/10]);
	translate([-xborder/2, -yborder/2, -(height/20+0.1)]) 
		cube([xborder,yborder,height/10+0.2]); 
}


}




 module pins () {

translate([0,0,0]) 
cylinder(h = 5, d = 10, center = false );


translate([0,92,0]) 
cylinder(h = 5, d = 10, center = false );

translate([115,0,0]) 
cylinder(h = 5, d = 10, center = false );

translate([115,92,0]) 
cylinder(h = 5, d = 10, center = false );

translate([0,0,0]) 
cylinder(h = 7, d = 8, center = false );


translate([0,92,0]) 
cylinder(h = 7, d = 8, center = false );

translate([115,0,0]) 
cylinder(h = 7, d = 8, center = false );

translate([115,92,0]) 
cylinder(h = 7, d = 8, center = false );







 }
 
thick = 13;
 module holes () {

translate([0,0,-.1]) 
cylinder(h = 11.2, d = 4.2, center = false );


translate([0,92,-.1]) 
cylinder(h = 11.2, d = 4.2, center = false );

translate([115,0,-.1]) 
cylinder(h = 11.2, d = 4.2, center = false );

translate([115,92,-.1]) 
cylinder(h = 11.2, d = 4.2, center = false );


rotate ([90,0,0])
translate([20,thick/2,10]) 
cylinder(h = 10, d = 4, center = false );

rotate ([90,0,0])
translate([95,thick/2,10]) 
cylinder(h = 10, d = 4, center = false );


rotate ([90,0,0])
translate([20,thick/2,3]) 
cylinder(h = 11, d = 6.5, center = false, $fn = 36 );

rotate ([90,0,0])
translate([95,thick/2,3]) 
cylinder(h = 11, d = 6.5, center = false, $fn = 36 );



 }





 module side () {


hull(){
    cube([129,10,13]);
    cube([129,13,5]);
}
 }

 module base () {

translate([129/2,106/2,5/2])
hexbase ();


translate([7,9,0])
pins();

translate([0,-10,0])
side ();

 }

difference(){
base();


translate([7,9,0])   
holes (); 
 
translate([20+7.3/2,-5,5]) 
cube([7.3,8.1,8.1]); 

translate([95+7.3/2,-5,5]) 
cube([7.3,8.1,8.1]); 
    
    
}