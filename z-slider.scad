include<constants.scad>;
use <vslot.scad>;

xExtrusionWidthSections = 1;
xExtrusionDepthSections = 2;
xEndClosed = true;
yExtrusionWidthSections = 1;
yExtrusionDepthSections = 2;
yEndClosed = false;
sliderSpacing=5;
sliderTolerance=0.8;
tolerance=0.6;
wallWidth=7;
screwOffset=5;

xExtrusionLength = xExtrusionDepthSections * profileSize*2;//profileSize*1 + 2*wallWidth;
yExtrusionLength = yExtrusionDepthSections * profileSize*1;
screwHeight=wallWidth+vslotIndentHeight;

ZSliderBracket();

module ZSliderBracket(
    xExtrusionWidthSections = xExtrusionWidthSections,
    xExtrusionDepthSections = xExtrusionDepthSections,
    xExtrusionLength = xExtrusionLength,
    yExtrusionWidthSections = yExtrusionWidthSections,
    yExtrusionDepthSections = yExtrusionDepthSections,
    yExtrusionLength = yExtrusionLength,
    lengthHoleSpacing = profileSize,
    tolerance = tolerance,
    sliderTolerance = sliderTolerance
)
{
    difference() {
        hull() {
            rotate([0,90,0])
            drawVslotExtrusion(
                height=xExtrusionLength,
                sectionCountWidth=xExtrusionWidthSections, 
                sectionCountDepth=xExtrusionDepthSections,
                oversize=tolerance,
                topIndent = false,
                bottomIndent = false,
                rightIndent = false,
                leftIndent = false,
                oversize = wallWidth*2
            );
            translate([wallWidth, -sliderSpacing, 0])
            rotate([90,90,0])
            drawVslotExtrusion(
                height=yExtrusionLength,
                sectionCountWidth=yExtrusionWidthSections, 
                sectionCountDepth=yExtrusionDepthSections,
                oversize=tolerance,
                topIndent = false,
                bottomIndent = false,
                rightIndent = false,
                leftIndent = false,
                oversize = wallWidth*2
            );
        };
        rotate([0,90,0])
        drawVslotExtrusion(
            height=xExtrusionLength,
            sectionCountWidth=xExtrusionWidthSections, 
            sectionCountDepth=xExtrusionDepthSections,
            oversize=sliderTolerance,
            screwOffset = screwOffset,
            screwHeight=screwHeight,
            bottomIndent = false,
            topIndent = false
        );
        translate([wallWidth, -sliderSpacing, 0])
        rotate([90,90,0])
        drawVslotExtrusion(
            height=yExtrusionLength+vslotIndentHeight,
            sectionCountWidth=yExtrusionWidthSections, 
            sectionCountDepth=yExtrusionDepthSections,
            rightIndent=!avoidSupports,
            leftScrewPoints = [yExtrusionLength-profileSize/2],
            rightScrewPoints = [yExtrusionLength-profileSize/2],
            oversize=tolerance,
            screwOffset = screwOffset,
            screwHeight=yExtrusionLength/2
        );
    }
    
}
        