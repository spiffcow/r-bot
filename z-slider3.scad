include <constants.scad>;
use <vslot.scad>;

xSectionCountWidth=2;
xSectionCountDepth=1;
zSectionCountWidth=2;
zSectionCountDepth=1;
screwDiameter=5;
tolerance=.8;
sliderTolerance=1.1;
wallWidth=7;
profileSize=20;
separation = 3;
isOpen = true;
screwOffset=5;
blockDepth = (xSectionCountDepth+zSectionCountDepth)*profileSize + separation + 2*wallWidth;
halfSize = false;
xExtrusionScrewPoints = 
    halfSize 
    ? [wallWidth+screwDiameter/2] 
    : [wallWidth+screwDiameter/2,xSectionCountWidth*profileSize+wallWidth-screwDiameter/2];
openAreaOffset = isOpen ? profileSize - 5.5 : 0;

difference() {
    hull() {
        translate([0, openAreaOffset + wallWidth/2, 0])
            cylinder(r=wallWidth/2,h=xSectionCountWidth*profileSize+2*wallWidth, $fn=90);
        translate([xSectionCountWidth*profileSize+wallWidth, openAreaOffset + wallWidth/2, 0])
            //rotate([-90,0,0])
            cylinder(r=wallWidth/2,h=xSectionCountWidth*profileSize+2*wallWidth, $fn=90);
        translate([0, blockDepth, 0])
            //rotate([-90,0,0])
            cylinder(r=wallWidth/2,h=xSectionCountWidth*profileSize+2*wallWidth, $fn=90);
        translate([xSectionCountWidth*profileSize+wallWidth, blockDepth, 0])
            //rotate([-90,0,0])
            cylinder(r=wallWidth/2,h=xSectionCountWidth*profileSize+2*wallWidth, $fn=90);
    };
    translate([wallWidth/2,wallWidth,0])
        rotate([0,0,0])
        color("red")
        drawVslotExtrusion(
            height=blockDepth,
            sectionCountWidth=zSectionCountWidth, 
            sectionCountDepth=zSectionCountDepth, 
            topIndent=true, 
            bottomIndent=true,
            rightIndent=true, 
            leftIndent=true,  
            oversize=sliderTolerance
    );  
    translate([
        halfSize 
        ? ((xSectionCountWidth/2)*profileSize - wallWidth/2)
        : xSectionCountWidth*profileSize + 3/2 * wallWidth,
        wallWidth + zSectionCountDepth*profileSize + separation + wallWidth/2, 
        wallWidth])
        rotate([0,-90,0])
        color("red")
        drawVslotExtrusion(
            height=
                halfSize 
                ? ((zSectionCountWidth*profileSize)/2) 
                : (zSectionCountWidth*profileSize+wallWidth*2),
            sectionCountWidth=xSectionCountWidth, 
            sectionCountDepth=xSectionCountDepth, 
            topIndent=true, 
            bottomIndent=true,
            rightIndent=true, 
            leftIndent=true,  
            oversize=tolerance,
            screwHeight=wallWidth*2,
            screwHeight=blockDepth,
            screwOffset=screwOffset,
            bottomScrewPoints = xExtrusionScrewPoints,
            backScrewPoints = [profileSize/2]
        ); 
};


