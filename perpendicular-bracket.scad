include<constants.scad>;
use <vslot.scad>;

xExtrusionWidthSections = 2;
xExtrusionDepthSections = 1;
xExtrusionLength = 60;
xEndClosed = true;
yExtrusionWidthSections = 2;
yExtrusionDepthSections = 1;
yExtrusionLength = 40;
yEndClosed = false;

wallWidth=7;
screwHeight=wallWidth+vslotIndentHeight;
screwOffset=5;

PerpendicularBracket(avoidSupports=false);

module PerpendicularBracket(
    xExtrusionWidthSections = xExtrusionWidthSections,
    xExtrusionDepthSections = xExtrusionDepthSections,
    xExtrusionLength = xExtrusionLength,
    yExtrusionWidthSections = yExtrusionWidthSections,
    yExtrusionDepthSections = yExtrusionDepthSections,
    yExtrusionLength = yExtrusionLength,
    lengthHoleSpacing = profileSize,
    tolerance = tolerance,
    avoidSupports = false,
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
            translate([(xExtrusionLength-profileSize*yExtrusionDepthSections)/2, 0, 0])
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
            oversize=tolerance,
            rightIndent=!avoidSupports,
            leftScrewPoints = [profileSize/2, xExtrusionLength-profileSize/2],
            bottomScrewPoints = [profileSize/2, xExtrusionLength-profileSize/2],
            screwOffset = screwOffset,
            screwHeight=screwHeight
        );
        translate([(xExtrusionLength-profileSize*yExtrusionDepthSections)/2, vslotIndentHeight, 0])
        rotate([90,90,0])
        drawVslotExtrusion(
            height=yExtrusionLength+vslotIndentHeight,
            sectionCountWidth=yExtrusionWidthSections, 
            sectionCountDepth=yExtrusionDepthSections,
            rightIndent=!avoidSupports,
            leftScrewPoints = [profileSize/2, yExtrusionLength-profileSize/2],
            bottomScrewPoints = [yExtrusionLength-profileSize/2],
            topScrewPoints = [yExtrusionLength-profileSize/2],
            oversize=tolerance,
            screwOffset = screwOffset,
            screwHeight=yExtrusionLength/2
        );
    }
    
    
}
        