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

//distance between the 2 guides x
inter_guides_x=profiley_length/2+10+bearing_th/2;
echo("distance between the 2 guides x:",2*inter_guides_x,"mm");
//x trail:
dx_guidey=60;//distance between the 2 guides y
dz_guidey=profile_size/2+bearing_D/2-1.5;//profile_size-0.5;
//x trail plate:
xtrailPlateThickness=3;
//head:
headPlateThickness=5;
headPlate_dx=dx_guidey-profile_size-2;
headPlate_dy=80;

//stepper motor nema17:
motNema17Side=42;
motNema17Dep=47.65;
motNema17AxisD=5;
motNema17AxisL=26;
motNema17ScrewFixD=3;
motNema17ScrewsDist=31;
motNema17FrontD=22;
motNema17FrontH=1.5;
//motor pulley GT2
pulleyTeethDiameter=12;
pulleyDiameter=16;
pulleyThickness=16;
//belts:
belt_th=6;//belt thickness
belt_thi=2;//belt thickness
z_belts=3;
//half distance between pulley in y direction
inter_pulleys_y=profiley_length*0.46;
//head plateform parameters:
head_bearing_axis_z=profile_size/2+bearing_D/2-1.5;


head_X=50;
head_Y=0;



//the CUBE machine mounted:
ensemble();

//rotate([-90,0,0])xtrailPlate();
//bearingPusher();
//bearingAdaptor(); 
//stepper_holder();
//pulley_holder();
//rotate([180,0,0])head_plateform();
//rotate([-90,0,0])head_bearing_holder();
//pulley_washer();

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


translate([profilex_length/2,0,0]) provisory_side_plate();
mirror([1,0,0])translate([profilex_length/2,0,0]) provisory_side_plate();

	
//guides for x translation
for (i=[-1,1])
translate([-profilex_length/2,i*(-profiley_length/2-10-bearing_th/2),0])rotate([0,90,0])color([0.2,0.2,0.2])import ("profil_ratrig_500mm.stl");

//guides for y translation
translate([head_X,0,0])//Y carriage ensemble
{
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
translate([0,head_Y,dz_guidey])
	{
	//bearings
	 for (x=[-1,1]) for (y=[-1,1]) translate([x*dx_guidey/2,y*headPlate_dy*0.4,head_bearing_axis_z])rotate([0,0,90]) rotate([90,0,0])bearing();
	 for (x=[-1,1])  translate([x*dx_guidey/2,0,-head_bearing_axis_z])rotate([0,0,90]) rotate([90,0,0])bearing();
	//head plateform:
	head_plateform();
	//head bearings holder (with springs to push down the bearings
	for (y=[-1,1])translate([0,y*headPlate_dy*0.44,head_bearing_axis_z])head_bearing_holder();
	 // extuder:    
	//prusa i2 extruder:
	//translate([0,0,headPlateThickness])color("blue")rotate([0,0,0])import("extruder.stl");  
	//extruder head alone:
	color("gray")translate([0,0,5])extruder();  
	}

//pulleys fixed on the Y guides:
for (x=[-1,1])for (y=[-1,1])translate([-x*dx_guidey/2,y*(profiley_length*0.45-bearing_D),z_belts]) 
		{
		bearing();
		translate([0,0,-bearing_th])pulley_washer();
		}
}//end of X carriage ensemble

translate([0,0,z_belts])
{

for (c=[0,1]) mirror([0,c,0])
	{
	//stepper holder:
	translate([-profilex_length/2+motNema17Side/2,inter_pulleys_y,-17])stepper_holder();
	//pulley holder:
	translate([profilex_length*0.47,-inter_guides_x-profile_size/2,-17])pulley_holder();
	}

for (y=[-1,1])
	{
	//stepper motors:
	translate([-profilex_length/2+motNema17Side/2,y*inter_pulleys_y,-17])rotate([0,-90,0])color("skyblue")motor_nema17();
	//GT2 pulleys on steppers:
	color("grey")translate([-profilex_length/2+motNema17Side/2,y*inter_pulleys_y,-pulleyThickness*0.7]) pulley();//bearing();
	//pulleys on the other side:
	translate([profilex_length*0.47,y*inter_pulleys_y,0]) bearing();
	}
	
	//pulleys on the other side:
	for (c=[0,1]) mirror([0,c,0])translate([profilex_length*0.42,inter_pulleys_y-20,0]) bearing();
	
	


//belt at right
color("blue")for (c=[0,1]) mirror([0,c,0])translate([profilex_length*0.47+bearing_D/2,inter_pulleys_y*0.05,-belt_th/2])rotate([2,0,0])cube([belt_thi,inter_pulleys_y*1.9,belt_th],center=true);
//belts:
for (y=[-1,1])
	{
	color("blue")translate([-profilex_length/2+motNema17Side/2,y*(inter_pulleys_y+bearing_D/2),-belt_th/2])cube([inter_pulleys_y*2,belt_thi,belt_th]);
	color("blue")translate([-profilex_length/2+motNema17Side/2,y*(inter_pulleys_y-bearing_D/2),-belt_th/2])cube([profiley_length/2,belt_thi,belt_th]);
	color("blue")translate([head_X+dx_guidey/2,y*(inter_pulleys_y-bearing_D/2),-belt_th/2])cube([profiley_length/2-head_X-dx_guidey,belt_thi,belt_th]);
	}
//belts on the x rail:
color("blue")for (x=[-1,1]) translate([head_X-x*dx_guidey/2+x*bearing_D/2,-inter_pulleys_y+bearing_D,-belt_th/2])cube([belt_thi,inter_pulleys_y*2-bearing_D*2,belt_th]);

}

}


module head_plateform()
{
//bearing holders size:	
aay=36;
aax=5;
aaz=28;
coefy=0.44;
coefx=0.35;
difference()
	{
	union()
		{
		//main base:
		translate([-headPlate_dx/2,-headPlate_dy/2,0]) cube([headPlate_dx,  headPlate_dy,headPlateThickness]);
		//bearings holders:
		//for (x=[-1,1]) for (y=[-1,1]) translate([x*(headPlate_dx-aax)*0.5-aax/2,y*headPlate_dy*0.4-aay/2,0])cube([aax,aay,aaz]);
		//lower bearing holders:
		for (x=[-1,1])  translate([x*(headPlate_dx-aax)*0.5-aax/2,-aay/2,-aaz])cube([aax,aay,aaz]);
		//reinforcement for lower bearing axis:	
		//for (x=[-1,1])  translate([x*headPlate_dx*0.55,0,-head_bearing_axis_z]) rotate([0,90,0])cylinder(r=18/2,h=9,$fn=20,center=true);
		for (x=[-1,1])  translate([x*headPlate_dx*0.55,0,-head_bearing_axis_z]) cube([9,36,17],center=true);	
		//reinforcement for upper bearings pushers:		
		for (x=[-1,1])for (y=[-1,1])translate([headPlate_dx*coefx*x,y*headPlate_dy*coefy,-4])cylinder(r=7/2,h=8,$fn=20,center=false);	
		
		}
	//big hole:
	translate([0,0,-1])scale([1,1.4,1])cylinder(r=14,h=50,$fn=30);
	//holes to fix the extruder:
	for (y=[-1,1])translate([0,25*y,-1])cylinder(r=2,h=50,$fn=30);
	//holes for the bearings pushers
	for (x=[-1,1])for (y=[-1,1])translate([headPlate_dx*coefx*x,y*headPlate_dy*coefy,0])cylinder(r=4/2,h=headPlate_dx+2,$fn=20,center=true);	
	//holes for bearing axis:	
	for (x=[-1,1])  translate([x*dx_guidey/2,0,-head_bearing_axis_z]) rotate([0,90,0])cylinder(r=2,h=40,$fn=20,center=true);
	//belt place:
	for (v=[-1,0])mirror([v,0,0])translate([-dx_guidey/2+bearing_D/2-0,0,-dz_guidey+z_belts])cube([belt_thi*2+1,40,belt_th+2],center=true);
	//holes for belt pressing:
	for (v=[-1,0])mirror([v,0,0])for (y=[-1,1])  translate([-dx_guidey/2,13*y,-dz_guidey+z_belts]) rotate([0,90,0])cylinder(r=2.5/2,h=40,$fn=20,center=true);
	//chamfer:
	for (v=[-1,0])mirror([0,v,0])translate([0,0,-head_bearing_axis_z*1.65])rotate([10,0,0])cube([headPlate_dx*2,headPlate_dy,headPlate_dx/3],center=true);
	}
}

//head lower bearing holder:
module head_bearing_holder()
{
coefx=0.35;
difference()
	{
	union()
		{
	//body
	translate([0,0,-2])cube([dx_guidey-bearing_th-2,  8,12],center=true);
	translate([0,0,-6])cube([dx_guidey-profile_size-2,  8,12],center=true);
		}
	//space for springs:
	translate([0,0,4])cube([dx_guidey-bearing_th-14,  8+2,12],center=true);
	
	//holes for spring screws:
	for (x=[-1,1])translate([headPlate_dx*coefx*x,0,0])cylinder(r=3.5/2,h=headPlate_dx+2,$fn=20,center=true);		
	//holes for bearings screws:
	for (x=[-1,1])translate([headPlate_dx*coefx*x,0,0])rotate([0,90,0])cylinder(r=4/2,h=headPlate_dx+2,$fn=20,center=true);		
	
	}
}
	
	
//stepper motor holder:
module stepper_holder()
{
difference()
	{
	//main plate
	translate([-motNema17Side/2,-motNema17Side/2,0])cube([motNema17Side,65,4]);
	//place for the stepper head:
	translate([0,0,-1])cylinder(r=(motNema17FrontD+1)/2,h=20,$fn=30);
	//holes to fix on the rails with M5 screws:
	for (x=[-1,1]) translate([10*x,33.5,-1])cylinder(r=5/2,h=20,$fn=30);
	//hole to fix the stepper motor nema17
	for (x=[-1,1])for (y=[-1,1])translate([motNema17ScrewsDist/2*x,motNema17ScrewsDist/2*y,-1])cylinder(r=3.5/2,h=20,$fn=30);
	}
}
	
	
	
//pulley holder:
module pulley_holder()
{
ax=20;
ay=50;
difference()
	{
	//main plate
	translate([-ax/2,0,0])cube([ax,ay,4]);
	//hole for the pulley axis:
	translate([0,inter_guides_x+profile_size/2-inter_pulleys_y,-1])cylinder(r=(5)/2,h=20,$fn=30);
	//holes to fix on the rails with M5 screws:
	for (x=[-1,1]) translate([5*x,profile_size/2,-1])cylinder(r=5/2,h=20,$fn=30);
	}
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
		translate([0,xtrailPlateThickness/2,-xtrailPlate_dz*1.6])  rotate([90,0,0]) cylinder(h=xtrailPlateThickness,r=xtrailPlate_dz*0.5,$fn=70);
		//vertical reinforcement:
		translate([-xtrailPlateThickness/2,-a*0.3,-a*1.8]) cube([xtrailPlateThickness,a*0.3,a*1.8]);
		//horizontal reinforcement:
		translate([-(dx_guidey-profile_size-2)/2,-a*0.3,-xtrailPlateThickness]) cube([dx_guidey-profile_size-2,a*0.3,xtrailPlateThickness]);
		// screw pressing holder: 
		translate([0,-a+xtrailPlateThickness/2,-a*1.6])translate([-a/4,0,-a/2]) cube([a/2,a,a/2]);
	  	}
    //holes
	translate([0,0,-dz_guidey-a/2])
        for (i=[-1,1]) for (k=[-1,1])translate([i*-dx_guidey/2,0,k*dz_guidey])rotate([90,0,0])cylinder(r=       profile_screw_D/2,h=40,$fn=20,center=true);
	// screw pressing holder: 
	translate([0,-a+xtrailPlateThickness/2,-a*1.6])
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
translate([0,0,1])
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



/*
plates use to test the X Y system:
*/
module provisory_side_plate()
{
h=100;
dy=profiley_length+50;
color("orange")
difference()
	{
	translate ([0,-dy/2,-h+20]) cube([thickness_panel,dy,h]);
	for (y=[-1,1])translate ([profilex_length*0.3,y*(inter_guides_x),0])rotate([0,90,0])cylinder(h=200,r=5/2,$fn=20);
	}
}






module bearingAdaptor()
{
 color("pink")
translate([0,0,-bearing_th/2])
difference()
    {
    cylinder(r=bearing_dint/2,h=bearing_th,$fn=20);
    translate([0,0,-1])cylinder(r=profile_screw_D/2,h=bearing_th+2,$fn=20);  
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

module pulley()
{
difference()
   {
	union()
		{
		cylinder(r=pulleyDiameter/2,h=pulleyThickness/2); 
		translate([0,0,pulleyThickness*0.5])cylinder(r=pulleyTeethDiameter/2,h=pulleyThickness/2,$fn=30); 
		translate([0,0,pulleyThickness*0.9])cylinder(r=pulleyDiameter/2,h=pulleyThickness*0.1); 
		}
    translate([0,0,-1])	cylinder(r=motNema17AxisD/2,h=pulleyThickness+2,$fn=30); 
		n=20;
	for (a=[0:n-1]) rotate([0,0,a*360/n]) translate([pulleyTeethDiameter*0.5,0,pulleyThickness*0.7]) cube([2,1,pulleyThickness*0.4],center=true);
    }
}


module pulley_washer()
{
difference()
   {
	union()
		{
		cylinder(r=(bearing_D+8)/2,h=2,$fn=60); 
		cylinder(r=(bearing_dint+2)/2,h=3,$fn=60); 
		}
	translate([0,0,-1])	cylinder(r=(5)/2,h=4+2,$fn=30); 
	}
}


module motor_nema17()
{
//moteur
difference()
	{
	translate([-motNema17Dep/2,0,0])	cube (size=[motNema17Dep,motNema17Side,motNema17Side],center=true);
	//screw holes:
	for(i=[-1,1])for(j=[-1,1])translate([-8,i*motNema17ScrewsDist/2,j*motNema17ScrewsDist/2]) rotate([0,90,0]) cylinder(h=10,r=1.5,$fn=10);
	}
//rehaut
rotate([0,90,0]) cylinder(h=motNema17FrontH,r=motNema17FrontD/2,center=false,$fn=20);

//axe moteur
translate([motNema17FrontH,0,0])rotate([0,90,0]) cylinder(h=motNema17AxisL,r=motNema17AxisD/2,center=false,$fn=20);

}



module extruder()
{
difference()
	{
	union()
		{
		cylinder(h=3.8,r=16/2,$fn=40);
		translate([0,0,-3.8])	cylinder(h=6,r=12/2,$fn=40);
		translate([0,0,-3.8-6+3])	cylinder(h=3,r=16/2,$fn=40);
		translate([0,0,-3.8-6+3-1.5])	cylinder(h=1.5,r=8/2,$fn=40);
		translate([0,0,-3.8-6+3-1.5-1])	cylinder(h=1,r=16/2,$fn=40);
		for (z=[0:11]) translate([0,0,-3.8-6+3-1.5-1-2.5*z])cylinder(h=1,r=22/2,$fn=40);
		translate([0,0,-3.8-6+3-1.5-1-25-18])	cylinder(h=18,r=5/2,$fn=40);
		//fan:
		translate([0,24,-24])cube([27,7,30],center=true);
		//fan holder
		translate([0,27/2,-20])cube([22,20,26],center=true);
		translate([0,5,-45])cube([16,20,11.6],center=true);
		}
	translate([0,0,-60])	cylinder(h=100,r=1.75/2,$fn=40);
	translate([0,0,-5])	cylinder(h=10,r=5/2,$fn=40);
}
	
}







