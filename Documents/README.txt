
ForceTile 
by Sumantra Sarkar

-------------------------------------------------------------

OVERVIEW:
---------
The ForceTile package will generate the force tile network (FTN) for a two dimensional force balanced granular packing. The present code deals with only dry granular materials, which deals with only repulsive contact interactions. I'll add the code to generate the FTN for grains with attractive interactions in a future version.  

To learn more about the algorithm read the FTN_Algo.pdf. Additionally, learn basics of graph theory and minimum cycle basis(MCB) and an algorithm to generate MCB from Minimum Cycle Basis.pdf. I use the same algorithm for my code. 


RUNNNING THE CODES:
-------------------

These codes have been tested in 64 bit Windows 8 and Ubuntu 14.04 Machine with GCC-4.8. 
Some of the CPP codes require C++11 features, and hence that flag must be enabled during compilation. 

For example, 
g++ -std=c++11 -o calc_rand_IC calc_vectors_random_IC.cpp

If you want to build the cpp files from the source, do the following. 

1. Compile all the files in the MCB folder to generate the executable to compute Minimum Cycle Basis (MCB.exe or MCB). 
   A nice way to build the MCB files would be through a makefile. Though, simply g++ *.h *.cpp -o MCB, also does the trick.  

2. Compile other CPP files separately to generate other required executables. 
	A. calc_vector_random_IC.cpp --> calc_vectors_random_IC.exe or calc_rand_IC 
	B. dual_Adj.cpp --> dual_Adj.exe or dAdj

Copy all the executable files to the folder with the matlab codes. 

Run Force_Tile_Generic or your own code to generate force tile. 


EXAMPLES:
---------

Two examples of the generated force tiles are shown on tri_regular.pdf and tri_randomForce.pdf. 
In tri_regular, each bond carries unit force, whereas in tri_randomForce each bond carries a random force, but the net force
on a grain is zero. 
  
