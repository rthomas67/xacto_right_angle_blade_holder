// right angle X-Acto blade holder

rightHanded=true;

wallThickness=2;

holderThickness=12;

bladeRecessBottomHeight=3;  // from bottom surface (enough room for screw head and enough for screw threads to hold)

// Small x-acto blade
bladeRecessWidth=6.1;  // root width of exacto blade (slightly larger)
bladeRecessLength=12; // from right side (root length of xacto blade)
bladeMountHoleDia=2.4; // slightly smaller than the opening in the actual blade
bladeMountHoleInset=7; // closer to root end of elongated slot, to prevent slide-out

/*
// Large x-acto blade
bladeRecessWidth=9.1;  // root width of exacto blade (slightly larger)
bladeRecessLength=17; // from right side (root length of xacto blade)
bladeMountHoleDia=2.75; // slightly smaller than the opening in the actual blade
bladeMountHoleInset=11; // closer to root end of elongated slot, to prevent slide-out
*/

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

holderBodyDia=thumbHoleMajorDia+fingerHoleMajorDia+bladeRecessWidth+wallThickness*4;
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