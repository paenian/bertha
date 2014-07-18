bertha
======

Large format Rostock style printer, built with aluminum extrusions.

My plan is to design a large printer, emphasizing quality over cost.  Ideally there will be the 'full' version, and then various lower cost options.

The design of the plastic parts contained her is complete - that's not to say they won't be updated, just that everything in here is functional.

I am working on build instructions in a blog over here: http://berthareprap.blogspot.com/2013/05/mark-4-finally.html
I am currently constructing the very first machine, so instructions are coming out as I get build time.

BOM will be posted for each step, and when I've completed the bot I'll post a full BOM here.


Frame: 2060 aluminum extrusion.
Linear motion: openrail, with Delrin V wheels.  Low cost option: Run the carriages in the extrusion grooves.
Drive: Synchromesh cable.  Low cost option: Fishing line.
Rods: Igus rod ends, square carbon fiber tube.
Extruders: Three of them.  Bowden style.



Some Firmware Variables to get the Alpha group started.  I'll upload a sample config once I get there.
BELT_PITCH 3.81
PULLEY_TEETH 15

STEPS_PER_ROTATION 200
MICRO_STEPS 8


DELTA_DIAGONAL_ROD 400  //note: set this to exactly your rod length.  Ex.  Act.  Ly.

//these are all calculated, and may be a smidge off.  As long as your parts are identical, that's cool.  If these are off, your printer will be high or low in the center, its print surface will be convex or concave.
END_EFFECTOR_HORIZONTAL_OFFSET 40
CARRIAGE_HORIZONTAL_OFFSET 15
PRINTER_RADIUS 208.2328   //change this one if your printer is convex/concave.



Paul Chase.
