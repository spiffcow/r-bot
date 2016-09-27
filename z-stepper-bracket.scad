include<constants.scad>;
use <vslot.scad>;

wallWidth=5;
xSectionCountWidth=2;
xSectionCountDepth=1;
zSectionCountWidth=2;
zSectionCountDepth=1;
screwOffset=5;
screwDiameter=5;
tolerance=.8;
bracketWidth = 80;
bracketDepth = xSectionCountDepth * profileSize + wallWidth;
    
nema17BoltOffset = (nema17Width - nema17BoltSpacing)/2;
        
// from Carl Feniak's drawing..  
nema17BeltHoleCenterOffsetX = profileSize/2 + 12;//-5;// was -1, deviating from the description based on visual assessment
nema17BeltHoleCenterOffsetZ = 14;
nema17BeltHoleWidth = 16;
nema17BeltHoleHeight = 8;
m3HoleRadius = 1.5;
nemaZOffset = (bracketWidth - nema17Width - wallWidth)/2;

module ZStepperBracket(hOffset = 24)
{
    xExtrusionScrewPoints = [wallWidth+screwDiameter/2,bracketWidth-wallWidth-screwDiameter/2];
    difference() {
        hull() {
            cube([bracketWidth,hOffset+bracketDepth,xSectionCountWidth*profileSize + 2*wallWidth]);
            translate([nemaZOffset, -nema17Width-tolerance*2, 0])
            {
                linear_extrude(height=wallWidth) 
                    square([nema17Width+wallWidth,nema17Width]);
            }
        };
        translate([0,hOffset+wallWidth,wallWidth+xSectionCountWidth*profileSize])
                color("red")
                rotate([0,90,0])
                drawVslotExtrusion(
                    height=bracketWidth,
                    sectionCountWidth=xSectionCountWidth, 
                    sectionCountDepth=zSectionCountDepth, 
                    topIndent=false, 
                    bottomIndent=true,
                    rightIndent=false, 
                    leftIndent=true,  
                    oversize=tolerance,
                    screwDiameter=screwDiameter,
                    screwHeight=bracketWidth,
                    screwOffset=screwOffset,
                    topScrewPoints = xExtrusionScrewPoints,
                    rightScrewPoints = xExtrusionScrewPoints
            ); 
        translate([nemaZOffset, -nema17Width-tolerance, 0])
        {
            translate([wallWidth/2-tolerance/2,0, wallWidth])
                linear_extrude(height=bracketWidth) 
                    square([nema17Width+tolerance,nema17Width]);
            translate([nema17Width/2+wallWidth/2, nema17Width/2, 0])
                linear_extrude(height=extrusionWidth)
                offset(r=extrudeOffsetVal) 
                circle(r=nema17HoleRadius+tolerance, center=true);
            translate([nema17BoltOffset+wallWidth/2,nema17BoltOffset,0])
                for(i = [0,1], j = [0,1]) {
                    translate([i*nema17BoltSpacing, j*nema17BoltSpacing, 0]) 
                        linear_extrude(height=extrusionWidth+wallWidth)
                        circle(r=m3HoleRadius, center=true, $fn=90);
                }
        } 
    }
                
            
    
}

ZStepperBracket();