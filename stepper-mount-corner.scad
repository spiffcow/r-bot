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
m3HoleRadius = 3.1/2;
tolerance=0.8;
vslotIndentHeight = 1;

module drawVslotExtrusion(
    height, 
    sectionCountWidth, 
    sectionCountDepth, 
    topIndent=true, 
    rightIndent=true, 
    leftIndent=true, 
    bottomIndent=true, 
    oversize=0,
    screwOffset=wallSpacing,
    screwHeight=vslotIndentHeight + wallSpacing,
    leftScrewPoints = [],
    rightScrewPoints = [],
    topScrewPoints = [],
    bottomScrewPoints = []
    ) 
{
    linear_extrude(height=height) 
        VSlot2dProfile(
            sectionCountWidth=sectionCountWidth,
            sectionCountDepth=sectionCountDepth,
            topIndent=topIndent,
            bottomIndent= bottomIndent,
            leftIndent=leftIndent,
            rightIndent=rightIndent,
            oversize=oversize);
    translate([sectionCountDepth*sectionWidth-screwHeight, 0, sectionWidth/2])
        for(i = [0:len(leftScrewPoints)], j=[0:sectionDepth:sectionCountDepth*sectionDepth]) {
            translate([0,leftScrewPoints[i],j]) rotate([90,0,180])
                negativeSpaceHole(largeHoleHeight = screwHeight-screwOffset, fullIndentHeight = screwHeight);
        } 
    
}
module drawExtrusions(extrudeOffsetVal = 0, disableIndents=false, oversize=0, printVertical = true) {
    module drawExtrusion(height, topIndent=true, rightIndent=true, leftIndent=true, bottomIndent=true,
        leftScrewPoints = [], rightScrewPoints = [], topScrewPoints = [], bottomScrewPoints = []) 
    {
        drawVslotExtrusion(
            height=height,
            sectionCountWidth=sectionCountWidth,
            sectionCountDepth=sectionCountDepth,
            topIndent=topIndent && !disableIndents,
            bottomIndent= bottomIndent && !disableIndents,
            leftIndent=leftIndent && !disableIndents,
            rightIndent=rightIndent && !disableIndents,
            oversize=extrudeOffsetVal*2,
            leftScrewPoints = leftScrewPoints,
            rightScrewPoints = rightScrewPoints,
            topScrewPoints = topScrewPoints,
            bottomScrewPoints = bottomScrewPoints
        );
    }
    drawExtrusion(height=sectionWidth);
    translate([0,0,sectionWidth])
        drawExtrusion(height=sectionWidth, rightIndent=false, leftScrewPoints=[20,40]);
    translate([sectionWidth,0,2*sectionWidth]) rotate([0,90,0])  
        drawExtrusion(height=sectionWidth, leftIndent=!printVertical);
    translate([0,-extrudeOffsetVal,2*sectionWidth]) rotate(-[90,90,0]) {
        // first do the short portion over the top with no indent
        drawExtrusion(height=sectionDepth+extrudeOffsetVal, rightIndent=!printVertical, leftIndent=false); 
        // ... then do the rest
        translate([0,0,sectionDepth])
            drawExtrusion(height=1.5*sectionDepth, rightIndent=!printVertical);
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

//rotate([0,-90,0]) 
difference() {
    union() {
            
        hull() {
            translate([-wallSpacing,0, wallSpacing + nema17Offset])
                linear_extrude(height=wallSpacing)
                square([nema17Width+wallSpacing*2,0.001], center=false);
            
            translate([-wallSpacing, -nema17Width - wallSpacing, nema17Height + nema17Offset])
                linear_extrude(height=wallSpacing)
                square([nema17Width+wallSpacing*2,nema17Width+wallSpacing], center=false);
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
        drawExtrusions(extrudeOffsetVal=tolerance);
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



translate([100,0,0]) 
    color ("red", .5) drawExtrusions();