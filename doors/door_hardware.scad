use <write.scad>

base_rad = 30;
base_h = 20;
font_size = 10;

writecylinder("K N O X",[0,0,0],base_rad,base_h/2,h=font_size);

wall=5;

h1 = "BERTHA";

for(i=[0:len(h1)]) translate([0,0,i*font_size]) rotate([90,0,0]) scale([1.5,1,1]) write(h1[len(h1)-i],t=wall*3,h=font_size,center=true, font = "Writescad/orbitron.dxf");