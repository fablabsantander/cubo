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
dx_guidey=60;
dz_guidey=profile_size+1;
//x trail plate:
xtrailPlateThickness=3;
xtrailPlate_dz=60;
//head:
headPlateThickness=5;
headPlate_dx=dx_guidey-profile_size;
headPlate_dy=80;

//dim cube:
thickness_panel = 10;
cube_length_x = profilex_length+2*thickness_panel;
cube_length_y = profiley_length+2*profile_size;
h_stop_extruder = 120;
height_cube = profilex_length+h_stop_extruder+2*thickness_panel;

//windows cube:
    difference(){      
ensemble_cube();
translate([0,0,-height_cube/2+h_stop_extruder])      
        union(){ 
cube([2*cube_length_x,cube_length_y-cube_length_x*2/5,+height_cube*3/5],center=true);     
rotate([0,0,90])
translate([-cube_length_x/2,0,0])    
cube([cube_length_x,cube_length_y-cube_length_x*2/5,height_cube*3/5],center=true);
rotate([0,90,0])
translate([-cube_length_x/2,0,0])    
cube([cube_length_x,cube_length_y-cube_length_x*1/4,height_cube*3/5],center=true);
        }   
    }

module ensemble_cube()
{
//upper panel:
color("orange")
translate ([-cube_length_x/2,-cube_length_y/2-thickness_panel,h_stop_extruder-thickness_panel])
cube([cube_length_x,cube_length_y+2*thickness_panel,thickness_panel]);
//bottom panel:
color("orange")
translate ([-cube_length_x/2,-cube_length_y/2-thickness_panel,-height_cube+h_stop_extruder])
cube([cube_length_x,cube_length_y+2*thickness_panel,thickness_panel]);
//left panel:
color("orange")
translate ([cube_length_x/2-thickness_panel,-cube_length_y/2-thickness_panel,-height_cube+h_stop_extruder+thickness_panel])
cube([thickness_panel,cube_length_y+thickness_panel,height_cube-2*thickness_panel]); 
//right panel (Left mirrored):
mirror(0,1,0){
color("orange")
translate ([cube_length_x/2-thickness_panel,-cube_length_y/2-thickness_panel,-height_cube+h_stop_extruder+thickness_panel])
cube([thickness_panel,cube_length_y+thickness_panel,height_cube-2*thickness_panel]);
}    
//back panel:
color("orange")
translate ([-cube_length_x/2,cube_length_y/2,-height_cube+h_stop_extruder+thickness_panel])
cube([cube_length_x,thickness_panel,height_cube-10*thickness_panel]);
//front panel:
color("cyan")
translate ([-cube_length_x/2,-cube_length_y/2-2*thickness_panel,-height_cube+h_stop_extruder])
cube([cube_length_x,thickness_panel,height_cube]);
//tirador puerta:
color("black")
translate([cube_length_x/2-50,-cube_length_y/2-3*thickness_panel,-height_cube/2+h_stop_extruder])
sphere(r=12.5,$fn=20);

}

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
    
//head:
 translate([-headPlate_dx/2,-headPlate_dy/2,dz_guidey+profile_size/2+2]) cube([headPlate_dx,  headPlate_dy,headPlateThickness]);
//example of extuder:    
 translate([0,0,dz_guidey+profile_size/2+headPlateThickness])color("blue")rotate([0,0,0])import("extruder.stl");    
    

}



module xtrailPlate()
{
difference()
    {
    translate([-(dx_guidey+profile_size)/2,-xtrailPlateThickness/2,-xtrailPlate_dz]) cube([dx_guidey+profile_size,xtrailPlateThickness,xtrailPlate_dz]);
    translate([0,0,-dz_guidey-profile_size/2])
        for (i=[-1,1]) for (k=[-1,1])translate([i*-dx_guidey/2,0,k*dz_guidey])rotate([90,0,0])cylinder(r=       profile_screw_D/2,h=40,$fn=20,center=true);
    translate([0,0,-xtrailPlate_dz])scale([0.75,1,1.3])rotate([90,0,0])cylinder(r=xtrailPlate_dz/2,h=xtrailPlateThickness+2,$fn=40,center=true);
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