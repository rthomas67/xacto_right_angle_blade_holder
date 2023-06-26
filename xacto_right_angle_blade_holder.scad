// right angle X-Acto blade holder

rightHanded=true;

small=false;

wallThickness=2;

holderThickness=12;

bladeRecessBottomHeight=5;  // from bottom surface (enough room for screw head and enough for screw threads to hold)

// Small x-acto blade
bladeRecessWidth=(small) ? 6.1 : 9.1;  // root width of exacto blade (slightly larger)
bladeRecessLength=(small) ? 12 : 17; // from right side (root length of xacto blade)
bladeMountHoleInset=(small) ? 7 : 11; // closer to root end of elongated slot, to prevent slide-out

bladeMountHoleDia=2.75;
bladeMountScrewHeadDia=7;

fingerHoleMajorDia=20;
fingerHoleMinorDia=15;
fingerHoleMinorAxisScale=fingerHoleMinorDia/fingerHoleMajorDia;
fingerHoleYRotation=-20;
fingerHoleZRotation=-20;
fingerHoleOutTaperFactor=1.2;

thumbHoleMajorDia=22;
thumbHoleMinorDia=15;
thumbHoleMinorAxisScale=thumbHoleMinorDia/thumbHoleMajorDia;
thumbHoleYRotation=-20;
thumbHoleZRotation=20;
thumbHoleOutTaperFactor=1.4;

holderBodyDia=thumbHoleMajorDia+fingerHoleMajorDia+bladeRecessWidth;
holderBodyElongation=5;
handleEndFlatteningFactor=0.85;

approachCutoutDia=45;

overlap=0.01;
$fn=50;

holderWithHandedness();

module holderWithHandedness() {
    if (rightHanded) {
        mirror([1,0,0]) holder();
    } else {
        holder();
    }
}

module holder() {
    bodyXDimension=holderBodyDia*1.5+holderBodyElongation;
    clippingSphereXScale=bodyXDimension/holderThickness;
    clippingSphereYScale=(bladeRecessWidth+fingerHoleMinorDia/2+thumbHoleMinorDia/2)/holderThickness;
    intersection() {
        // Bounding flat-bottomed sphere (dome) that clips off the full finger-hole sides
        translate([holderBodyDia/2,0,0])
            hull() {
                scale([clippingSphereXScale,clippingSphereYScale,1])
                    translate([0,0,holderThickness/2])
                        sphere(d=holderThickness);
                scale([clippingSphereXScale,clippingSphereYScale,1]) 
                    cylinder(d=holderThickness, h=overlap);
            }
        difference() {
            // body
            hull() { 
                scale([handleEndFlatteningFactor,1,1])
                    cylinder(d=holderBodyDia, h=holderThickness);
                translate([holderBodyElongation,0,0])
                    cylinder(d=holderBodyDia, h=holderThickness);
            }

            // finger hole
            rotate([0,fingerHoleYRotation,fingerHoleZRotation])
                translate([0,bladeRecessWidth/2+fingerHoleMinorDia/2,-holderThickness])
                    scale([1,fingerHoleMinorAxisScale,1])
                        cylinder(d1=fingerHoleMajorDia, d2=fingerHoleMajorDia*fingerHoleOutTaperFactor ,h=holderThickness*3);

            // thumb hole
            rotate([0,thumbHoleYRotation,thumbHoleZRotation])
                translate([0,-bladeRecessWidth/2-thumbHoleMinorDia/2,-holderThickness])
                    scale([1,thumbHoleMinorAxisScale,1])
                        cylinder(d1=thumbHoleMajorDia, d2=thumbHoleMajorDia*thumbHoleOutTaperFactor ,h=holderThickness*3);

            // blade recess
            translate([holderBodyElongation+holderBodyDia/2-bladeRecessLength,-bladeRecessWidth/2,bladeRecessBottomHeight])
                cube([bladeRecessLength+overlap,bladeRecessWidth,holderThickness-bladeRecessBottomHeight+overlap]);
            translate([holderBodyElongation+holderBodyDia/2-bladeMountHoleInset,0,-overlap])
                cylinder(d=bladeMountHoleDia, h=holderThickness+overlap*2);       

            // approach cutouts
            translate([holderBodyElongation+holderBodyDia/2,approachCutoutDia/2+bladeRecessWidth/2+wallThickness,-overlap])
                cylinder(d=approachCutoutDia, h=holderThickness+overlap*2);
            translate([holderBodyElongation+holderBodyDia/2,-approachCutoutDia/2-bladeRecessWidth/2-wallThickness,-overlap])
                cylinder(d=approachCutoutDia, h=holderThickness+overlap*2);
        }
    }
}