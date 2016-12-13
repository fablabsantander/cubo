//FabLab Santander
//machine "cubo"
//licence creative common 

//profile:
profilex_length=500;
profiley_length=500;
profile_size=20;
//bearing:
bearing_D=22;
bearing_dint=7;
bearing_th=7;


ensemble();



module ensemble()
{
//guides for x translation
for (i=[-1,1])
translate([-profilex_length/2,i*(-profiley_length/2-5-bearing_th/2),0])rotate([0,90,0])color([0.2,0.2,0.2])import ("profil_ratrig_500mm.stl");

//guides for y translation
dx_guidey=40;
dz_guidey=profile_size+3;
for (i=[-1,1])
    {
    translate([i*-dx_guidey,profiley_length/2,dz_guidey])rotate([90,0,0])color([0.2,0.2,0.2])import ("profil_ratrig_500mm.stl");
    for (j=[-1,1]) translate([i*-dx_guidey,j*(profiley_length/2+bearing_th/2+5),dz_guidey])rotate([90,0,0])bearing();
    }
}


//627 bearing
module bearing()
{
translate([0,0,-bearing_th/2])
difference()
    {
    cylinder(r=bearing_D/2,h=bearing_th);
    translate([0,0,-1])cylinder(r=bearing_dint/2,h=bearing_th+2);  
    }
}