oversize = 0.8;
lengthHoleSpacing=20;
wallWidth=5;
vslotIndentHeight=1;
sectionWidth=20;

testPiece=true;
if (testPiece) {
    zExtrusionLength = 100;
    zExtrusionWidthSections = 2;
    zExtrusionDepthSections = 1;
    difference() {
        linear_extrude(height=zExtrusionLength)
            square([
                sectionWidth*zExtrusionWidthSections+wallWidth*2,
                sectionWidth*zExtrusionDepthSections+wallWidth*2
            ]);
        translate([wallWidth, wallWidth, 0]) {
            linear_extrude(height=zExtrusionLength)
            VSlot2dProfile(
                sectionCountWidth=zExtrusionWidthSections, 
                sectionCountDepth=zExtrusionDepthSections,
                indentHeight=vslotIndentHeight,
                oversize=oversize
            );
        }; 
        
        negativeSpaceHoles(
            extrusionLength=zExtrusionLength,
            fullIndentHeight=wallWidth+vslotIndentHeight,
            firstIndentOffset=wallWidth,
            widthSections=zExtrusionWidthSections,
            lengthHoleSpacing=lengthHoleSpacing
        );        
    };
}
    


negativeSpaceHolePoints(fullIndentHeight=5,points=[[10,10],[20,20],[30,30]]);

module extrusionIndent(_indentWidthInside, _indentWidthOutside, _indentHeight) {
    polygon(points=[
            [0,0], 
            [(_indentWidthOutside-_indentWidthInside)/2, _indentHeight], 
            [_indentWidthInside + (_indentWidthOutside-_indentWidthInside)/2, _indentHeight],
            [_indentWidthOutside, 0]
        ]);
};

module VSlot2dProfile(
    extrusionLength,
    sectionWidth = 20,
    indentWidthOutside = 9,
    indentWidthInside = 7,
    indentHeight = 1,
    sectionCountWidth,
    sectionCountDepth,
    topIndent = true,
    bottomIndent = true,
    leftIndent = true,
    rightIndent = true,
    oversize = 0
)
{
    translate([-oversize/2,-oversize/2,-oversize/2])
    resize([
        sectionWidth*sectionCountWidth+oversize,
        sectionWidth*sectionCountDepth+oversize,
        extrusionLength+oversize
    ]) difference() {
        
            square(
                size=[
                    sectionWidth*sectionCountWidth, 
                    sectionWidth*sectionCountDepth
                ]
            );
        for(i = [0:sectionCountWidth]) {
            // bottom indents
            if (bottomIndent) 
                translate([i * sectionWidth + (sectionWidth-indentWidthOutside)/2, 0, 0])
                extrusionIndent(indentWidthInside,indentWidthOutside,indentHeight);
            
            // top indents
            if (topIndent)
                translate([
                    i * sectionWidth + (sectionWidth-indentWidthOutside)/2, 
                    sectionWidth*sectionCountDepth, 
                    0
                ])
                rotate([180,0,0])
                extrusionIndent(indentWidthInside,indentWidthOutside,indentHeight);
        }
        for(i = [0:sectionCountDepth]) {
            // left side indent
            if (leftIndent)
                translate([0, (i+1) * sectionWidth - (sectionWidth-indentWidthOutside)/2, 0])
                rotate([0,0,-90]) 
                extrusionIndent(indentWidthInside,indentWidthOutside,indentHeight);
            
            // right side inden
            if (rightIndent)
                translate([
                    sectionWidth*sectionCountWidth, 
                    i * sectionWidth + (sectionWidth-indentWidthOutside)/2, 
                    0
                ])
                rotate([0,0,90]) 
                extrusionIndent(indentWidthInside,indentWidthOutside,indentHeight);
        }
    }
};


module negativeSpaceHole(
    largeHoleHeight = 1,
    fullIndentHeight = 6,
    largeHoleRadius = 5,
    smallHoleRadius = 2.5,
    )
{ 
    cylinder(h=largeHoleHeight,r=largeHoleRadius,center=false, $fn=90);
    cylinder(h=fullIndentHeight,r=smallHoleRadius,center=false, $fn=90);
}

module negativeSpaceHolePoints(
    largeHoleIndent = 1,
    largeHoleRadius = 5,
    smallHoleRadius = 2.5,
    fullIndentHeight,
    points = []
    )
{
    for (i=[0:len(points)-1]){
        translate([points[i][1],0,points[i][0]]) {
            rotate([-90,0,0]) {
                echo(points[i][0], points[i][1]);
                negativeSpaceHole(
                    largeHoleHeight=largeHoleIndent,
                    fullIndentHeight=fullIndentHeight,
                    largeHoleRadius=largeHoleRadius,
                    smallHoleRadius=smallHoleRadius);
            };
        }
    }
}

module negativeSpaceHoles(
    largeHoleIndent = 1,
    largeHoleRadius = 5,
    smallHoleRadius = 2.5,
    widthHoleSpacing = 20,
    fullIndentHeight,
    lengthHoleSpacing,
    extrusionLength,
    firstIndentOffset,
    widthSections
    ) 
{
    
    negativeSpaceHolePoints(
        largeHoleIndent = largeHoleIndent,
        largeHoleRadius = largeHoleRadius,
        smallHoleRadius = smallHoleRadius,
        fullIndentHeight = fullIndentHeight,
        lengthHoleSpacing = lengthHoleSpacing,
        widthSections = widthSections,
        points=[ 
            for (p = [lengthHoleSpacing/2+firstIndentOffset:lengthHoleSpacing:extrusionLength-firstIndentOffset-lengthHoleSpacing/2]) 
            for (s = [firstIndentOffset+widthHoleSpacing/2:widthHoleSpacing:widthHoleSpacing*widthSections]) 
            [p,s]
         ]
            
    );
}


        