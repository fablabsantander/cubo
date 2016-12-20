# cubo
Machine for 3D printing and laser engraving
Some members of the FabLab Santander have committed themselves to build the machines of the lab in a co-creation process.
This machine is a cubic shape 3D printer with option of laser engraving.
This side size of the cube is more or less 500mm.
The purpose of the design is to get a big size open source 3D printer, nice-looking, easy to build, robust with metal profiles and standart bearings (not the linear ones...).
The main design software is openscad which allow a natural integration in CVS or github software repositories.
The design is parametrized as much as possible. The elements choosen for the first version are:

- RatRig profiles
- 627 bearings
- wood/plexiglass plates

Coding conventions for openscad files:
- try to comment every decision in the design
- try to use parameters for all dimensions such we have not to redesign when changing one piece dimension.
- minimize the number of parameters
- put the parameters at the beginning of the file with explicit names and comments
- then put the modules to be 3D printed (commented)
- then put the module called "ensemble" that gather all the pieces
- then put eventually cut views
- then put the modules
