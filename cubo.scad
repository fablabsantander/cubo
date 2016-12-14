//FabLab Santander
//machine "cubo"
//licence creative common 

//profile:
profilex_length=500;
profiley_length=500;
profile_size=20;
profile_screw_D=5;
//bearing:
bearing_D=22;
bearing_dint=7;
bearing_th=7;
//x trail:
dx_guidey=80;
dz_guidey=profile_size+1;
//x trail plate:
xtrailPlateThickness=3;
xtrailPlate_dz=60;


ensemble();

//xtrailPlate();

module ensemble()
{
//guides for x translation
for (i=[-1,1])
translate([-profilex_length/2,i*(-profiley_length/2-10-bearing_th/2),0])rotate([0,90,0])color([0.2,0.2,0.2])import ("profil_ratrig_500mm.stl");

//guides for y translation
for (i=[-1,1])
    {
    //guides y
    translate([i*-dx_guidey/2,profiley_length/2,dz_guidey])rotate([90,0,0])color([0.2,0.2,0.2])import ("profil_ratrig_500mm.stl");
    //bearings:
    for (j=[-1,1])  for (k=[-1,1])translate([i*-dx_guidey/2,j*(profiley_length/2+bearing_th/2+10),k*dz_guidey])rotate([90,0,0])
        {
        bearing();
        bearingAdaptor();    
        }
    //screw for bearings:
     color([0.4,0.4,0.4])for (j=[-1,1]) for (k=[-1,1])translate([i*-dx_guidey/2,j*(profiley_length/2+15),k*dz_guidey])rotate([90,0,0])cylinder(r=profile_screw_D/2,h=40,$fn=30,center=true);
    //xtrail side plate:
    translate([0,i*(profiley_length/2+xtrailPlateThickness/2),dz_guidey+profile_size/2])xtrailPlate();
   
    }
}



module xtrailPlate()
{
difference()
    {
    translate([-(dx_guidey+profile_size)/2,-xtrailPlateThickness/2,-xtrailPlate_dz]) cube([dx_guidey+profile_size,xtrailPlateThickness,xtrailPlate_dz]);
    translate([0,0,-dz_guidey-profile_size/2])
        for (i=[-1,1]) for (k=[-1,1])translate([i*-dx_guidey/2,0,k*dz_guidey])rotate([90,0,0])cylinder(r=       profile_screw_D/2,h=40,$fn=20,center=true);
    translate([0,0,-xtrailPlate_dz])rotate([90,0,0])cylinder(r=xtrailPlate_dz/2,h=xtrailPlateThickness+2,$fn=40,center=true);
    }
}


module bearingAdaptor()
{
 color("pink")
translate([0,0,-bearing_th/2])
difference()
    {
    cylinder(r=bearing_dint/2,h=bearing_th);
    translate([0,0,-1])cylinder(r=profile_screw_D/2,h=bearing_th+2);  
    }   
}



// bearing
module bearing()
{
color([0.8,0.8,0.8])
translate([0,0,-bearing_th/2])
difference()
    {
    cylinder(r=bearing_D/2,h=bearing_th);
    translate([0,0,-1])cylinder(r=bearing_dint/2,h=bearing_th+2);  
    }
}