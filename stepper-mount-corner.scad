use <vslot.scad>;

profileSize=20;
sectionCountWidth = 2;
sectionCountDepth = 1;
extrusionWidth=profileSize*sectionCountWidth;
extrusionDepth=profileSize*sectionCountDepth;
nema17Width = 42.3;
nema17HoleRadius = 11.05;
nema17Height = 3.5*extrusionWidth;
nema17BoltSpacing = 31;
nema17BeltHoleHeight = 8;
nema17BeltOffsetFromTopExtrusion = 8;
nema17BeltHeightWidth = 15;
wallSpacing=5;
tolerance=0.4;
vslotIndentHeight = 1;
forwardExtrudeMultiplier = 2.5;
screwHeight=vslotIndentHeight + wallSpacing;
screwOffset=wallSpacing;

rendering = true;
supportWalls=true;

module drawExtrusions(
    oversize=0,
    extrudeOffsetVal = 0, 
    disableIndents=false, 
    withHoles=false) 
{
    module drawExtrusion(
        height, 
        topIndent=true, 
        rightIndent=true, 
        leftIndent=true, 
        bottomIndent=true,
        leftScrewPoints = [], 
        //rightScrewPoints = [], 
        topScrewPoints = [], 
        bottomScrewPoints = [],
        backScrewPoints = []) 
    {
        drawVslotExtrusion(
            height=height,
            sectionCountWidth=sectionCountWidth,
            sectionCountDepth=sectionCountDepth,
            topIndent=topIndent && !disableIndents,
            bottomIndent= bottomIndent && !disableIndents,
            leftIndent=leftIndent && !disableIndents,
            rightIndent=rightIndent && !disableIndents,
            oversize=oversize,
            screwOffset=screwOffset,
            leftScrewPoints = leftScrewPoints,
            //rightScrewPoints = rightScrewPoints,
            topScrewPoints = topScrewPoints,
            bottomScrewPoints = bottomScrewPoints,
            backScrewPoints=backScrewPoints,
            screwHeight = sectionCountWidth*profileSize
        );
        }
        extrusionWidthPoints = withHoles 
            ? [for (x = [profileSize/2:profileSize:extrusionWidth]) x] 
            : [];
        extrusionDepthPoints = withHoles 
            ? [for (x = [profileSize/2:profileSize:extrusionDepth]) x] 
            : [];
        ybarPoints = withHoles 
            ? [for (x = [profileSize/2: profileSize:(forwardExtrudeMultiplier-1.5)*sectionCountDepth*profileSize]) x] 
            : [];
        drawExtrusion(
            height=extrusionWidth, 
            topScrewPoints=extrusionWidthPoints,
            bottomScrewPoints=extrusionWidthPoints,
            leftScrewPoints=extrusionDepthPoints,
            rightIndent=false
        );
        translate([0,0,extrusionWidth])
            drawExtrusion(
                height=extrusionWidth, 
                rightIndent=false, 
                topScrewPoints=extrusionWidthPoints,
                leftScrewPoints=extrusionDepthPoints,
                bottomScrewPoints=extrusionWidthPoints
            );
        translate([extrusionWidth,0,2*extrusionWidth]) rotate([0,90,0])  
            drawExtrusion(
                height=extrusionWidth, 
                topScrewPoints=extrusionWidthPoints,
                bottomScrewPoints=extrusionWidthPoints
           );
        translate([0,-extrudeOffsetVal,2*extrusionWidth]) rotate(-[90,90,0]) {
            // first do the short portion over the top with no indent
            drawExtrusion(height=extrusionDepth+extrudeOffsetVal, leftIndent=false, topIndent=false,
                topScrewPoints=extrusionDepthPoints,
                backScrewPoints=extrusionDepthPoints); 
            // ... then do the rest
            translate([0,0,extrusionDepth])
                drawExtrusion(height=(forwardExtrudeMultiplier-1)*extrusionDepth, topIndent=false, topScrewPoints=ybarPoints);
    }
}

module drawNema17(extrudeOffsetVal=0, nemaZOffset, drawHoles=false, isLeft=true) {
    nema17BoltOffset = (nema17Width - nema17BoltSpacing)/2;
    
    // from Carl Feniak's drawing
    nema17BeltHoleCenterOffsetX = -1;
    nema17BeltHoleCenterOffsetZ = wallSpacing + 9;
    nema17BeltHoleWidth = 16;
    nema17BeltHoleHeight = 8;
    m3HoleRadius = 1.5;
        
    
    translate([0, -wallSpacing - nema17Width, nemaZOffset])
    {
        linear_extrude(height=nema17Height) 
            offset(r=extrudeOffsetVal) 
            square([nema17Width+wallSpacing,nema17Width]);
        translate([0,0,nema17Height + wallSpacing])
        linear_extrude(height=extrusionWidth) 
            offset(r=extrudeOffsetVal) 
            square([nema17Width,nema17Width]);
        translate([nema17Width/2, nema17Width/2, nema17Height])
            linear_extrude(height=extrusionWidth)
            offset(r=extrudeOffsetVal) 
            circle(r=nema17HoleRadius, center=true);
        if (drawHoles) {
            translate([nema17BoltOffset,nema17BoltOffset,nema17Height])
            for(i = [0,1], j = [0,1]) {
                translate([i*nema17BoltSpacing, j*nema17BoltSpacing, 0]) 
                    linear_extrude(height=extrusionWidth+wallSpacing)
                    circle(r=m3HoleRadius, center=true, $fn=90);
            }
            // belt hole
            translate([
                wallSpacing+nema17Width/2 + nema17BeltHoleCenterOffsetX, 
                wallSpacing+nema17Width,
                nema17Height+nema17BeltHoleCenterOffsetZ
            ]) cube([
                nema17BeltHoleWidth, 
                4*extrusionDepth + 2*wallSpacing,
                nema17BeltHoleHeight
                ], center=true);
                
        }
    }
}

wallSpacing=5;
nema17Height=2.5*extrusionWidth;
nemaZOffset = -4;

module drawNema17Platform() {
    translate([(sectionCountDepth-1)*profileSize,0,0])
    hull() {
        translate([-wallSpacing,0, wallSpacing + nemaZOffset])
            linear_extrude(height=wallSpacing)
            square([nema17Width+wallSpacing,0.001], center=false);
        
        translate([-wallSpacing, -nema17Width - wallSpacing, nema17Height + nemaZOffset])
            linear_extrude(height=wallSpacing)
            square([nema17Width+wallSpacing,nema17Width+wallSpacing], center=false);
    }
}

rotate([0,rendering ? -90 : 0,0]) {
    difference() {
        union() {
            drawNema17Platform();    
            
            hull() {
                drawExtrusions(
                    extrudeOffsetVal=wallSpacing, 
                    oversize=wallSpacing*2,
                    disableIndents=true);  
                /*
                drawNema17(
                    extrudeOffsetVal=wallSpacing, 
                    nemaZOffset=extrusionWidth-2, 
                    nema17Height=1.5*extrusionWidth);
                */
            } 
        }
        //color ("red", .5) 
            drawExtrusions(oversize=tolerance, withHoles=true);
        //color ("green", .5) 
            translate([(sectionCountDepth-1)*profileSize,0,0])
            drawNema17(
                nemaZOffset=nemaZOffset, 
                nema17Height=nema17Height,
                drawHoles=true);
    };
    
    // hack to make a thin layer to avoid having to use supports
    //translate([extrusionDepth-0.1,-wallSpacing,2*extrusionWidth]) 
    //cube([0.1,forwardExtrudeMultiplier*profileSize,extrusionWidth]);
    if (supportWalls)
    {
        difference() {
            drawExtrusions(
                        extrudeOffsetVal=wallSpacing, 
                        oversize=0.2,
                        disableIndents=true); 
            drawExtrusions(
                        extrudeOffsetVal=wallSpacing, 
                        disableIndents=true);
        }
        difference() {
            drawExtrusions(
                        extrudeOffsetVal=wallSpacing, 
                        oversize=2*(screwOffset-vslotIndentHeight)+0.2,
                        disableIndents=true); 
            drawExtrusions(
                        extrudeOffsetVal=wallSpacing, 
                        oversize=2*(screwOffset-vslotIndentHeight),
                        disableIndents=true);
        }
    }
}

/*
    color ("red", .5) drawExtrusions();
    color ("green", .5) drawNema17(
        nemaZOffset=nemaZOffset, 
        nema17Height=nema17Height,
        drawHoles=true);
*/


if (!rendering)
{
    translate([100,0,0]) {
        color ("red", .5) drawExtrusions(withHoles=true);
        //color ("green", .5) drawNema17(
        //    nemaZOffset=nemaZOffset, 
        //    nema17Height=nema17Height,
        //    drawHoles=true);
    }
}