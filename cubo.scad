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
dz_guidey=profile_size-0.5;
//x trail plate:
xtrailPlateThickness=3;
//head:
headPlateThickness=5;
headPlate_dx=dx_guidey-profile_size;
headPlate_dy=80;

ensemble();

//rotate([-90,0,0])xtrailPlate();
//bearingPusher();

//dim cube:
thickness_panel = 10;
cube_length_x = profilex_length+2*thickness_panel;
cube_length_y = profiley_length+2*profile_size;
h_stop_extruder = 120;
height_cube = profilex_length+h_stop_extruder+2*thickness_panel;



module ensemble()
{
//the clothes of the machine:
//cover();

//guides for x translation
for (i=[-1,1])
translate([-profilex_length/2,i*(-profiley_length/2-10-bearing_th/2),0])rotate([0,90,0])color([0.2,0.2,0.2])import ("profil_ratrig_500mm.stl");

//guides for y translation
for (i=[-1,1])
    {
    //guides y
    translate([i*-dx_guidey/2,profiley_length/2,dz_guidey])rotate([90,0,0])color([0.2,0.2,0.2])import ("profil_ratrig_500mm.stl");
    //bearings:
    for (j=[-1,1]) translate([i*-dx_guidey/2,j*(profiley_length/2+bearing_th/2+10),dz_guidey])rotate([90,0,0])
        {
        bearing();
        bearingAdaptor();    
        }
    //screw for bearings:
     color([0.4,0.4,0.4])for (j=[-1,1])translate([i*-dx_guidey/2,j*(profiley_length/2+10),dz_guidey])rotate([90,0,0])cylinder(r=profile_screw_D/2,h=20,$fn=30,center=true);
    }
	 
//lower bearings 
for (j=[-1,1]) translate([0,j*(profiley_length/2+bearing_th/2+10),-dz_guidey])
	{
	rotate([90,0,0])bearing();
	rotate([90,0,0])bearingAdaptor();    
	//screw for bearings:
	color([0.4,0.4,0.4])translate([0,-profile_size/2,0])rotate([90,0,0])cylinder(r=profile_screw_D/2,h=30,$fn=30,center=true);
   }
	 
	 
	 
//xtrail side plates:
translate([0,profiley_length/2+xtrailPlateThickness/2,dz_guidey+profile_size/2])
	{
	xtrailPlate();
	bearingPusher();
	}
mirror([0,1,0]) translate([0,profiley_length/2+xtrailPlateThickness/2,dz_guidey+profile_size/2])
	{
	xtrailPlate();
	bearingPusher();
	}
  
//head:
 translate([-headPlate_dx/2,-headPlate_dy/2,dz_guidey+profile_size/2+2]) cube([headPlate_dx,  headPlate_dy,headPlateThickness]);
//example of extuder:    
 translate([0,0,dz_guidey+profile_size/2+headPlateThickness])color("blue")rotate([0,0,0])import("extruder.stl");    
    

}



module xtrailPlate()
{
xtrailPlate_dz=profile_size;
a=profile_size;
dy=a;
difference()
	{
	union()
		{
		//plate to attach the 2 y profiles:
		translate([-(dx_guidey+profile_size)/2,-xtrailPlateThickness/2,-xtrailPlate_dz]) cube([dx_guidey+profile_size,xtrailPlateThickness,xtrailPlate_dz]);
		//plate that connects the lower bearing:
		translate([-(profile_size)/2,-xtrailPlateThickness/2,-xtrailPlate_dz*1.7]) cube([a,xtrailPlateThickness,xtrailPlate_dz]);
		//rounded plate:
		translate([0,xtrailPlateThickness/2,-xtrailPlate_dz*1.65])  rotate([90,0,0]) cylinder(h=xtrailPlateThickness,r=xtrailPlate_dz*0.5,$fn=70);
		//vertical reinforcement:
		translate([-xtrailPlateThickness/2,-a*0.3,-a*1.8]) cube([xtrailPlateThickness,a*0.3,a*1.8]);
		//horizontal reinforcement:
		translate([-(dx_guidey-profile_size-2)/2,-a*0.3,-xtrailPlateThickness]) cube([dx_guidey-profile_size-2,a*0.3,xtrailPlateThickness]);
		// screw pressing holder: 
		translate([0,-a+xtrailPlateThickness/2,-a*1.65])translate([-a/4,0,-a/2]) cube([a/2,a,a/2]);
	  	}
    //holes
	translate([0,0,-dz_guidey-a/2])
        for (i=[-1,1]) for (k=[-1,1])translate([i*-dx_guidey/2,0,k*dz_guidey])rotate([90,0,0])cylinder(r=       profile_screw_D/2,h=40,$fn=20,center=true);
	// screw pressing holder: 
	translate([0,-a+xtrailPlateThickness/2,-a*1.65])
		{
		translate([-a/8,-a/2,-a/2-1]) cube([a/4,profile_size,a/2+2]);
		//hole for rotation axis:
		translate([-a/4-1,a/4,-a/4]) rotate([0,90,0]) cylinder(r=2.5/2,h=a/2+2,$fn=20);
		}
	//hole for pressing screw:
	translate([0,a*-0.1,-a*2.5])cylinder(r=2.5/2,h=a,$fn=20);
	}
    
}



module bearingPusher()
{
a=profile_size;
difference()
	{
	union()
		{
		//hold the axis screw:
		translate([-(a*0.2)/2,-a,-a*2.75]) cube([a*0.2,a/2,a*1.1]);   
		//hold the bearing screw:
		translate([-a/2/2,-a,-a*2.75]) cube([a/2,a/2*2.7,a*0.5]);   
		}
	//hole/space for pressing screw
	translate([0,a*-0.1,-a*3])cylinder(r=5/2,h=a,$fn=20);
	//hole for rotation axis:
	translate([-a*0.5,-a*0.675,-a*1.9])rotate([0,90,0])cylinder(r=3.5/2,h=a,$fn=20);
	//hole threaded to fix the bearing axis:
	translate([0,a*1.9,-a*2.5])rotate([90,0,0])cylinder(r=4.8/2,h=2*a,$fn=20);
		
	}
	
}

//windows cube:
module cover()
{
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