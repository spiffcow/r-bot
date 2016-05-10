use <vslot.scad>;

sectionWidth = 40;
sectionDepth = 20;
sectionCountWidth = 2;
sectionCountDepth = 1;
nema17Width = 42.3;
nema17HoleRadius = 11.05;
nema17Height = 3.5*sectionWidth;
nema17BoltSpacing = 31;
nema17BeltHoleHeight = 8;
nema17BeltOffsetFromTopExtrusion = 8;
nema17BeltHeightWidth = 15;
wallSpacing=5;
tolerance = .1;
m3HoleRadius = 3.1/2;


module drawExtrusions(extrudeOffsetVal = 0, disableIndents=false) {
    topIndent=!disableIndents;
    module drawExtrusion(height, topIndent=true, rightIndent=true, leftIndent=true, bottomIndent=true) {
        linear_extrude(height=height) 
            offset(r=extrudeOffsetVal, chamfer=true)
            VSlot2dProfile(
                sectionCountWidth=sectionCountWidth,
                sectionCountDepth=sectionCountDepth,
                topIndent=topIndent && !disableIndents,
                bottomIndent= bottomIndent && !disableIndents,
                leftIndent=leftIndent && !disableIndents,
                rightIndent=rightIndent && !disableIndents);
    }
    drawExtrusion(height=sectionWidth);
    translate([0,0,sectionWidth])
        drawExtrusion(height=sectionWidth, rightIndent=false);
    translate([sectionWidth,0,2*sectionWidth]) rotate([0,90,0])  
        drawExtrusion(height=sectionWidth);
    translate([0,-extrudeOffsetVal,2*sectionWidth]) rotate(-[90,90,0]) {
        // first do the short portion over the top with no indent
        drawExtrusion(height=sectionDepth+extrudeOffsetVal, leftIndent=false); 
        // ... then do the rest
        translate([0,0,sectionDepth])
            drawExtrusion(height=2*sectionWidth-sectionDepth);
    }
}

module drawNema17(extrudeOffsetVal=0, nemaZOffset=-2, drawHoles=false) {
    nema17BoltOffset = (nema17Width - nema17BoltSpacing)/2;
    
    translate([0, -wallSpacing - nema17Width, nemaZOffset])
    {
        linear_extrude(height=nema17Height) 
            offset(r=extrudeOffsetVal) 
            square([nema17Width,nema17Width]);
        translate([0,0,nema17Height + wallSpacing])
        linear_extrude(height=sectionWidth) 
            offset(r=extrudeOffsetVal) 
            square([nema17Width,nema17Width]);
        translate([nema17Width/2, nema17Width/2, nema17Height])
            linear_extrude(height=sectionWidth)
            offset(r=extrudeOffsetVal) 
            circle(r=nema17HoleRadius, center=true);
        if (drawHoles) {
            translate([nema17BoltOffset,nema17BoltOffset,nema17Height])
            for(i = [0,1], j = [0,1]) {
                translate([i*nema17BoltSpacing, j*nema17BoltSpacing, 0]) 
                    linear_extrude(height=sectionWidth+wallSpacing)
                    circle(r=m3HoleRadius, center=true);
            }
        }
    }
}

wallSpacing=5;
nema17Height=2.5*sectionWidth;
nema17Offset = -2;

difference() {
    union() {
            
        hull() {
            translate([0,0, wallSpacing + nema17Offset])
                linear_extrude(height=wallSpacing)
                offset(r=wallSpacing)
                square([nema17Width,0.001], center=false);
            
            translate([nema17Width/2,-nema17Width/2, nema17Height + nema17Offset])
                linear_extrude(height=wallSpacing)
                offset(r=wallSpacing)
                square([nema17Width,nema17Width], center=true);
        }
        hull() {
            drawExtrusions(
                extrudeOffsetVal=wallSpacing, 
                disableIndents=true);  
            /*
            drawNema17(
                extrudeOffsetVal=wallSpacing, 
                nemaZOffset=sectionWidth-2, 
                nema17Height=1.5*sectionWidth);
            */
        } 
    }
    //color ("red", .5) 
        drawExtrusions();
    //color ("green", .5) 
        drawNema17(
            nemaZOffset=-2, 
            nema17Height=nema17Height,
            drawHoles=true);
};
/*
    color ("red", .5) drawExtrusions();
    color ("green", .5) drawNema17(
        nemaZOffset=-2, 
        nema17Height=nema17Height,
        drawHoles=true);
*/



