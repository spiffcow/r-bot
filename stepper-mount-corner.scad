include<constants.scad>;
use <vslot.scad>;

module motorMount(isLeft = true)
{
    wallSpacing=7;
    forwardExtrudeMultiplier = 2.5;
    screwHeight=vslotIndentHeight + wallSpacing;
    screwOffset=screwHeight-3;

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
                ? [for (x = [profileSize/2,extrusionWidth-profileSize/2]) x] 
                : [];
            extrusionDepthPoints = withHoles 
                ? [for (x = [profileSize/2,extrusionDepth-profileSize/2]) x] 
                : [];
            ybarPoints = withHoles 
                ? [for (x = [profileSize/2: profileSize:(forwardExtrudeMultiplier-1.5)*sectionCountDepth*profileSize]) x] 
                : [];
            drawExtrusion(
                height=extrusionWidth, 
                topScrewPoints=extrusionWidthPoints,
                leftScrewPoints=extrusionWidthPoints
            );
            translate([extrusionWidth,0,2*extrusionWidth]) rotate([0,90,0])  
                drawExtrusion(
                    height=extrusionWidth, 
                    topScrewPoints=extrusionWidthPoints
               );
            translate([0,-extrudeOffsetVal,extrusionWidth]) rotate(-[90,90,0]) {
                // first do the short portion over the top with no indent
                drawExtrusion(height=extrusionDepth+extrudeOffsetVal, leftIndent=false, topIndent=false,
                    topScrewPoints=extrusionDepthPoints,
                    backScrewPoints=extrusionDepthPoints); 
                // ... then do the rest
                translate([0,0,extrusionDepth])
                    drawExtrusion(height=(forwardExtrudeMultiplier-1)*extrusionDepth, topIndent=false, topScrewPoints=ybarPoints);
        }
    }

    module drawNema17(extrudeOffsetVal=0, nemaZOffset, drawHoles=false) {
        nema17BoltOffset = (nema17Width - nema17BoltSpacing)/2;
        
        // from Carl Feniak's drawing..  
        nema17BeltHoleCenterOffsetX = profileSize/2 + 12;//-5;// was -1, deviating from the description based on visual assessment
        nema17BeltHoleCenterOffsetZ = 14;
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
                    nema17BeltHoleCenterOffsetX, 
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

    nema17Height=1.5*extrusionWidth-(isLeft ? 0 : 20);
    nemaZOffset = -4;

    module drawNema17Platform() {
        translate([(sectionCountDepth-1)*profileSize,0,0])
        hull() {
            translate([-wallSpacing,-wallSpacing, 0])
                linear_extrude(height=wallSpacing)
                square([nema17Width+wallSpacing,0.001], center=false);
            
            translate([-wallSpacing, -nema17Width - wallSpacing, nema17Height + nemaZOffset])
                linear_extrude(height=wallSpacing)
                square([nema17Width+wallSpacing,nema17Width+wallSpacing], center=false);
        }
    }

    // draw the thing
    mirror([isLeft ? 0 : 1, 0, 0])
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
    }

    /*
        color ("red", .5) drawExtrusions();
        color ("green", .5) drawNema17(
            nemaZOffset=nemaZOffset, 
            nema17Height=nema17Height,
            drawHoles=true);
    */
}

rendering = true;

motorMount(isLeft = false);

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