include <constants.scad>;
use <vslot.scad>;

sectionCountWidth=2;
sectionCountDepth=1;
screwDiameter=5;
tolerance=.8;
wallWidth=2 + tolerance/2;
profileSize=20;
sideNum = 2;
allTogether = true;
diagonalSeparation=false;
isOpen = true;
sideWidth = 1;
backWidth = 7;

holeDistWidth=60;
holeDistHeight=51.9;
blockHeight = wallWidth*2 + sectionCountWidth*profileSize;
blockWidth = (isOpen ? backWidth : sideWidth) + sideWidth + sectionCountDepth*profileSize;
cubeX = holeDistHeight+screwDiameter+2*wallWidth;
cubeZ = holeDistWidth+screwDiameter+2*wallWidth;

difference() {
    cube([cubeX,blockWidth,cubeZ]);
    translate([wallWidth+screwDiameter/2, 0, wallWidth+screwDiameter/2])
    {
        rotate([-90,0,0])
            cylinder(r=screwDiameter/2,h=blockWidth, $fn=90);
        translate([0, 0, holeDistWidth])
            rotate([-90,0,0])
            cylinder(r=screwDiameter/2,h=blockWidth, $fn=90);
    }
    translate([wallWidth+screwDiameter/2 + holeDistHeight, 0, wallWidth+screwDiameter/2])
    {
        rotate([-90,0,0])
            cylinder(r=screwDiameter/2,h=blockWidth, $fn=90);
        translate([0, 0, holeDistWidth])
            rotate([-90,0,0])
            cylinder(r=screwDiameter/2,h=blockWidth, $fn=90);
    }
    translate([(cubeX-(sectionCountWidth*profileSize))/2,sideWidth,0])
        drawVslotExtrusion(
            height=cubeZ,
            sectionCountWidth=sectionCountWidth, 
            sectionCountDepth=sectionCountDepth, 
            topIndent=true, 
            rightIndent=true, 
            leftIndent=true, 
            bottomIndent=!isOpen, 
            oversize=tolerance,
            //screwOffset,
            topScrewPoints = [cubeZ/2]
            //rightScrewPoints = [],
            //topScrewPoints = [],
            //bottomScrewPoints = [],
            //backScrewPoints = []
    );
    if (isOpen) {
        translate([(cubeX-(sectionCountWidth*profileSize)-tolerance)/2,0,0])
        cube([sectionCountWidth*profileSize + tolerance, sideWidth, cubeZ]);
    };
    if (allTogether != true)
    {
        if (diagonalSeparation == true)
        {
            //translate ([sideNum == 1 ? 0 : cubeX, 0, 0])
            if (sideNum == 1) {
                linear_extrude(h=cubeZ) 
                    polygon(points=[
                        [0,sideWidth-tolerance/2], 
                        [(cubeX-(sectionCountWidth*profileSize))/2-tolerance/2,sideWidth-tolerance/2],
                        [cubeX-(cubeX-(sectionCountWidth*profileSize))/2+tolerance/2,blockWidth-sideWidth+tolerance/2],
                        [cubeX+tolerance/2, blockWidth-sideWidth+tolerance/2],
                        [cubeX+tolerance/2, blockWidth+tolerance/2],
                        [0, blockWidth]
                    ]);
            }
            else {
                linear_extrude(h=cubeZ) 
                    polygon(points=[
                        [0,-tolerance],
                        [0,sideWidth-tolerance/2], 
                        [(cubeX-(sectionCountWidth*profileSize))/2-tolerance/2,sideWidth-tolerance/2],
                        [cubeX-(cubeX-(sectionCountWidth*profileSize))/2+tolerance/2,blockWidth-sideWidth+tolerance/2],
                        [cubeX+tolerance/2, blockWidth-sideWidth+tolerance/2],
                        [cubeX+tolerance, blockWidth+tolerance/2],
                        [cubeX+tolerance, -tolerance]
                    ]);
            }
        }
        else
        {
            translate([sideNum == 1 ? 0 : (screwDiameter/2+profileSize+(profileSize-indentWidthOutside)/2),0,0])
            cube([blockHeight-screwDiameter-(profileSize-indentWidthOutside)/2,blockWidth,cubeZ]);
        }
    };
    /*
    translate([-(holeDistHeight-blockHeight)/2+holeDistHeight, 0, cylinderRadius])
        rotate([-90,0,0])
        cylinder(r=cylinderRadius,h=blockWidth, $fn=90);
    translate([-(holeDistHeight-blockHeight)/2+holeDistHeight, 0, cylinderRadius+holeDistWidth])
        rotate([-90,0,0])
        cylinder(r=cylinderRadius,h=blockWidth, $fn=90);
    */
}



