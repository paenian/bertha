
$fn = 36; 

module base() {

hull() {

 cylinder(h=3, d1=6, d2=8, center=false);
 
 
 
translate([0,0,40])
 
cylinder(h=3, d1=8, d2=6, center=false);
    
translate([3,-3,3])
 
cube ([1,6,43-3-3]);  
  
translate([3,-2,1])
  
cube ([1,4,41]);      
    
}

}


module holes() {

translate([-10,-5,3+8/2])
cube ([10,10,43-3-3-8]);   

cylinder(h=43, d=4, center=false);


translate([0,0,4.5])
cylinder(h = 43-3-3-8+5, d = 6.5, center = false, $fn = 6 );


}

difference (){
base();

holes();
    
}