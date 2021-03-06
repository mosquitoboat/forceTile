/*

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                       %
    %  Copyright (C) 2012-2014 Sumantra Sarkar, Bulbul Chakraborty          %
    %                                                                       %
    %  This file is part of the ForceTile program.                          %
    %                                                                       %
    %  The ForceTile program is free software; you can redistribute it      %
    %  and/or modify it under the terms of the GNU General Public License   %
    %  version 3 as published by the Free Software Foundation.              %
    %                                                                       %
    %  See the file COPYING for details.                                    %
    %                                                                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

mcb.cpp

Modified from a code from the package WildMagic 5.10 from Geometric Tools
 
Author: Sumantra Sarkar 
	Martin Fisher School of Physics	
	Brandeis University
	forcetileenquiries@gmail.com


Function: Generates the Minimal Cycle Basis (MCB) of a planar graph. 	




*/




#include "Headers.h"
#include "Vec2.h"
#include "PlanarGraph.h"

using namespace std;


#define EXTRACT_PRIMITIVES

 ofstream fout;
//--------------
typedef PlanarGraph<Vec2> Graph;


void Usage()
{
	cout<<"\n"<<"Prints the coordinate of a cycle."<<"\n";


}

void Load(Graph& mGraph, vector<Graph::Primitive*>& mPrimitives)
{
    // std::string path = Environment::GetPathR("tri.txt");
    //std::ifstream inFile(path.c_str());
    ifstream inFile("./PlanarGraph.txt");

	//ofstream verify;
  //verify.open("verify.txt",ios::out|ios::app);

    int numVertices;
    inFile >> numVertices;
    //verify<< numVertices<<"\n";
    int i;

    for (i = 0; i < numVertices; ++i)
    {
        double x, y;
        inFile >> x;
        inFile >> y;
      // verify<< x <<"\t"<< y <<"\n";
        //y = GetHeight() - 1 - y;
        mGraph.InsertVertex(Vec2(x, y), i);
    }

    int numEdges;
    inFile >> numEdges;
     //verify<< numEdges<<"\n";
    for (i = 0; i < numEdges; ++i)
    {
        int v0, v1;
        inFile >> v0;
        inFile >> v1;
       // verify<< v0 <<"\t"<< v1 <<"\n";
        mGraph.InsertEdge(v0, v1);
    }

#ifdef EXTRACT_PRIMITIVES
    mGraph.ExtractPrimitives(mPrimitives);
#endif

}

void Print(const Graph& mGraph, const vector<Graph::Primitive*>& mPrimitives)
{
    #ifdef EXTRACT_PRIMITIVES
    Vec2 v0, v1;
    double x0, y0, x1, y1;
    int j0, j1, index;

    const int numPrimitives = (int)mPrimitives.size();
    int i;
    for (i = 0; i < numPrimitives; ++i)
    {
        Graph::Primitive* primitive = mPrimitives[i];
        int numElements = (int)primitive->Sequence.size();
        switch (primitive->Type)
        {
        case Graph::PT_ISOLATED_VERTEX:


            v0 = primitive->Sequence[0].first;
            x0 = v0.X();
            y0 = v0.Y();
            index = primitive->Sequence[0].second;
            fout.open("./isolated_vert_PlanarGraph.txt",ios::out|ios::app);
            fout<<index+1<<" ";
	    fout.close();
            //SetThickPixel(x0, y0, 1, mColors[i]);
            break;


        case Graph::PT_FILAMENT:
            for (j0 = 0, j1 = 1; j1 < numElements; ++j0, ++j1)
            {
                v0 = primitive->Sequence[j0].first;
                x0 = (int)v0.X();
                y0 = (int)v0.Y();
                v1 = primitive->Sequence[j1].first;
                x1 = (int)v1.X();
                y1 = (int)v1.Y();


	   int index2 = primitive->Sequence[j1].second;
            fout.open("./Filaments_PlanarGraph.txt",ios::out|ios::app);

		if (j0==0)
		{
			int index1 = primitive->Sequence[j0].second;
	   		 fout<<index1+1<<" "<<index2+1<<" ";
 		}             //DrawLine(x0, y0, x1, y1, mColors[i]);
		else
		{
			fout<<index2+1<<" ";

		};


            }

		fout<<endl;
		fout.close();

            break;
        case Graph::PT_MINIMAL_CYCLE:

	 // if (fout.is_open())
       {
        //cout<<"File is open\n";
	 	//fout << numElements<<"\n";
     		//cout << "Number of points in the cycle: "<<numElements<<"\n";
  		fout.open("./Cycles_PlanarGraph.txt",ios::out|ios::app);
            for (j0 = numElements - 1, j1 = 0; j1 < numElements; j0 = j1++)
            {
                v0 = primitive->Sequence[j0].first;
                x0 = (int)v0.X();
                y0 = (int)v0.Y();
                v1 = primitive->Sequence[j1].first;
                x1 = (int)v1.X();
                y1 = (int)v1.Y();

		index = primitive->Sequence[j0].second;
                fout<<index+1<<" ";
		// cout<<index+1<<" ";
                //DrawLine(x0, y0, x1, y1, mColors[i]);
            }
                  fout<<endl;
		 // cout<<endl;
		 fout.close();
            break;
      }

	 }
    }
#endif
}

int main()
{


	    Graph mGraph;
	    std::vector<Graph::Primitive*> mPrimitives;

/*
	if (iQuantity != 3)
    	{
	        Usage();
	        return -1;
    	}

  // Get the files

	    const char* acInFile = aacArgument[1];
	    const char* acOutFile = aacArgument[2];
	*/

 // Read from file

Load(mGraph,mPrimitives);
cout<< "success\n";
Print(mGraph, mPrimitives);

 return 0;

}
