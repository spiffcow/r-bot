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
m3HoleRadius = 3.1/2;
tolerance=0.8;
vslotIndentHeight = 1;
forwardExtrudeMultiplier = 2.5;

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
    
    if (len(topScrewPoints) > 0) {
        points = [ 
            for(i = [0:len(topScrewPoints)-1])
            for(j=[profileSize/2:profileSize:sectionCountWidth*profileSize])
            [topScrewPoints[i],j]
        ];
            translate([0,-screwHeight+vslotIndentHeight,0])
        negativeSpaceHolePoints(
            largeHoleIndent = screwHeight-screwOffset,
            smallHoleRadius = m3HoleRadius,
            fullIndentHeight=screwHeight,
            points = points
        );
    }
    if (len(bottomScrewPoints) > 0) {
        points = [ 
            for(i = [0:len(bottomScrewPoints)-1])
            for(j=[profileSize/2:profileSize:sectionCountWidth*profileSize])
            [bottomScrewPoints[i],j]
        ];
            translate([0,screwHeight+sectionCountDepth*profileSize-vslotIndentHeight,0])
            rotate([180,0,0])
        negativeSpaceHolePoints(
            largeHoleIndent = screwHeight-screwOffset,
            smallHoleRadius = m3HoleRadius,
            fullIndentHeight=screwHeight+oversize,
            points = points
        );
    }
    /*
        translate([profileSize/2,0,0])
        for(i = [0:len(leftScrewPoints)])
        for(j=[0:profileSize:sectionCountDepth*profileSize]) {
            translate([0,leftScrewPoints[i]],j) 
                negativeSpaceHole(largeHoleHeight = screwHeight-screwOffset, fullIndentHeight = screwHeight);
            }
    */
}
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
        rightScrewPoints = [], 
        topScrewPoints = [], 
        bottomScrewPoints = []) 
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
            leftScrewPoints = leftScrewPoints,
            rightScrewPoints = rightScrewPoints,
            topScrewPoints = topScrewPoints,
            bottomScrewPoints = bottomScrewPoints,
            screwHeight = sectionCountWidth*profileSize
        );
        }
        extrusionWidthPoints = withHoles 
            ? [for (x = [profileSize/2:profileSize:extrusionWidth]) x] 
            : [];
        extrusionDepthPoints = withHoles 
            ? [for (x = [profileSize/2:profileSize:extrusionDepth]) x] 
            : [];
        drawExtrusion(
            height=extrusionWidth, 
            topScrewPoints=extrusionWidthPoints,
            bottomScrewPoints=extrusionWidthPoints,
            rightIndent=false
        );
        translate([0,0,extrusionWidth])
            drawExtrusion(
                height=extrusionWidth, 
                rightIndent=false, 
                topScrewPoints=extrusionWidthPoints,
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
                topScrewPoints=extrusionDepthPoints); 
            // ... then do the rest
            translate([0,0,extrusionDepth])
                drawExtrusion(height=(forwardExtrudeMultiplier-1)*extrusionDepth, topIndent=false, topScrewPoints=extrusionDepthPoints);
    }
}

module drawNema17(extrudeOffsetVal=0, nemaZOffset, drawHoles=false, isLeft=true) {
    nema17BoltOffset = (nema17Width - nema17BoltSpacing)/2;
    
    // from Carl Feniak's drawing
    nema17BeltHoleCenterOffsetX = 0;
    nema17BeltHoleCenterOffsetZ = wallSpacing + 9;
    nema17BeltHoleWidth = 16;
    nema17BeltHoleHeight = 8;
        
    
    translate([0, -wallSpacing - nema17Width, nemaZOffset])
    {
        linear_extrude(height=nema17Height) 
            offset(r=extrudeOffsetVal) 
            square([nema17Width,nema17Width]);
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
                    circle(r=m3HoleRadius, center=true);
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

rotate([0,-90,0]) {
    difference() {
        union() {
                
            translate([(sectionCountDepth-1)*profileSize,0,0])
            hull() {
                translate([-wallSpacing,0, wallSpacing + nemaZOffset])
                    linear_extrude(height=wallSpacing)
                    square([nema17Width+wallSpacing,0.001], center=false);
                
                translate([-wallSpacing, -nema17Width - wallSpacing, nema17Height + nemaZOffset])
                    linear_extrude(height=wallSpacing)
                    square([nema17Width+wallSpacing,nema17Width+wallSpacing], center=false);
            }
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
            drawExtrusions(extrudeOffsetVal=tolerance, withHoles=true);
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
    /*
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
                    oversize=2*wallSpacing+0.2,
                    disableIndents=true); 
        drawExtrusions(
                    extrudeOffsetVal=wallSpacing, 
                    oversize=2*wallSpacing,
                    disableIndents=true);
    }
    */
}

/*
    color ("red", .5) drawExtrusions();
    color ("green", .5) drawNema17(
        nemaZOffset=nemaZOffset, 
        nema17Height=nema17Height,
        drawHoles=true);
*/



translate([100,0,0]) {
    color ("red", .5) drawExtrusions(withHoles=true);
    //color ("green", .5) drawNema17(
    //    nemaZOffset=nemaZOffset, 
    //    nema17Height=nema17Height,
    //    drawHoles=true);
}