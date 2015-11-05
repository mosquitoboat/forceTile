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
 *
 *
 *
calc_vectors_random_IC.cpp

Author: Sumantra Sarkar
	Martin Fisher School of Physics
	Brandeis University
	forcetileenquiries@gmail.com

Function: Takes the topological information about the Force Tile Network from ForceNetInfo.txt,
	  and performs and iterative optimization algorithm to obtain the force tile network.
	  Initially, the heights are randomly distributed, but all topological and metric information
	  is known from the ForceNetInfo.txt. That's we know which height vertex is connected to which one
	  and if connected, what is the distance between them. Starting from this information, this code
	  calculates the position of each vertex up to an origin. The calculated heights are stored in
	  Height_Positions.txt.

Input:   RandomIC_Input.txt provides the total number of iterations nIter, and a multiplier randmult.
	 Change nIter to whatever values you want. Changing randmult is inconsequential. The initial
	 positions don't really matter.

---------------------------------------------------------------------------------------------------------

This code may be further improved by defining a distance between two height configurations, and setting a
tolerance. The code will be terminated, if the distance between two configurations is less than the tolerance.

---------------------------------------------------------------------------------------------------------


*/

#include <iostream>
//#include <cstdio>
#include <cstdlib>
#include <map>
#include <vector>
#include <fstream>
#include <string>
#include <sstream>
#include <limits>

using namespace std;

#define nan std::numeric_limits<double>::quiet_NaN()

////////////////////////////////////////////////////////////////////////

struct position
{
	double x, y;
};

struct Nbr
{
    int id; // id of the neighbor

	double fx, fy; // The x and y component of the forces

};

/*class Nbr
{
    public:
	int id; // id of the neighbor

	double fx, fy; // The x and y component of the forces


        Nbr(int ID=1, double FX=0.0, double FY = 0.0)
        {id = ID; fx = FX; fy = FY;};

        Nbr(vector<int>& v)
        {id = v[0]; fx = v[1]; fy = v[2];}


};
 */


////////////////////////////////////////////////////////////////////////

typedef std::vector<Nbr> NbrVec;
typedef std::map<int, NbrVec> NbrMap;
typedef std::map<int, position> PosMap;

///////////////////////////////////////////////////////////////////////


bool is_file_empty(std::ifstream& pFile)
{
    return pFile.peek() == std::ifstream::traits_type::eof();
}




void parse(string *ext, NbrMap& nAdj)
{
	istringstream iss(*ext);
	string token;
	// you can replace ' ' with whatever you
	// would like to parse at
	int count = 0;
	int gid;
	Nbr nv;
	while(getline(iss,token,'\t'))
		{
           // cout <<token<<endl;

                switch(count)
                {

                    case 0:
                        gid = atoi(token.c_str());

                    case 1:
                        nv.id = atoi(token.c_str());

                    case 2:
                        nv.fx = atof(token.c_str());

                    case 3:
                        nv.fy = atof(token.c_str());

                }
                count++;




		} // push numbers into vector

         nAdj[gid].push_back(nv);

         nAdj.erase(0);

}

////////////////////////////////////////////////////////////////////

/*
   This function is created to prevent overflow of the NbrMap.

*/


void Check_Missing_Keys(NbrMap& nbr)

{

    int kMax = nbr.crbegin()->first;


    for (int k = 1; k<=kMax; k++)

    {

        if(nbr.count(k)==0)
            {
                //cout << k <<endl;

                Nbr v;
                v.id = 0;
                v.fx = 0.0;
                v.fy = 0.0;
                nbr[k].push_back(v);
            }


    }

}

///////////////////////////////////////////////////////////////////////

void file_reader(NbrMap& nAdj)
{

    //ifstream myfile ("example.txt");
    //myfile.open();
    ifstream myfile ("./ForceNetInfo.txt");

    if (!is_file_empty(myfile))
    {
    string line;

    if (myfile.is_open())
    {
        while (myfile.good())
        {
          //stream_reader(myfile, cycles);

        	getline (myfile,line);
        	//cout <<line<<endl;
        	//cycles[cidx].push_back(atoi(line.c_str()));

        	parse(&line, nAdj);

        }

        myfile.close();

        //cout<<nAdj.size();
    }
    else
    {
        cout << "Unable to open ForceNetInfo.txt";
    }

    }

    //Check_Missing_Keys(nAdj);
}





////////////////////////////////////////////////////////////////////

void Print_Nbr_Info(NbrMap& nAdj)
{

    std::map<int, NbrVec>::iterator it;

	for (int i = 1; i<= nAdj.size(); i++)
		{
		    NbrVec nv =  nAdj[i];
		    for (int j = 0; j < nv.size(); j++)
		      {

		       cout << i << "\t"<< nv[j].id << "\t"<< nv[j].fx << "\t"<< nv[j].fy<<"\n";
               //cout <<"a b c d\n";

		      }
		}

}

void Print_Position(PosMap& pos, const int& nCycle)
{

    ofstream fout("Height_Positions.txt",ios::out|ios::app);

	for (int i = 1; i<=nCycle; i++)
		{

		       fout << "\t"<< pos[i].x << "\t"<< pos[i].y<<"\n";
		       cout << i<<"\t"<< pos[i].x << "\t"<< pos[i].y<<"\n";

		}

    fout.close();
}
//////////////////////////////////////////////////////////////////


void Initiate_Position(PosMap& pos, const int& nCycle, const int& randMult, const int& seedVal)

{

	srand (seedVal);

	for (int j = 1; j<=nCycle; j++)
	{

		pos[j].x = (double) (rand()/RAND_MAX)*randMult;
		pos[j].y = (double) (rand()/RAND_MAX)*randMult;

	}

}

////////////////////////////////////////////////////////////////////



void Iterate_Postion(PosMap& pos, NbrMap& nbr, const int& nIter)
{

   if(nbr.size()>=2)

   {
       vector<Nbr> v;
        int nbr_id;
        double fx;
        double fy;

        for(int iter = 0; iter < nIter; iter++)
        {

            //cout<<iter<<endl;

            for (int i = 1; i <= nbr.size();i++ )
            {
                //cout<<nbr.size()<<"\t"<<i<<endl;

               // v.clear();
                v = nbr[i];


        if(v[0].id!=0)
            {

               /* cout << v.size()<<endl;

                for (int k = 0; k < v.size();k++)
                {
                    cout<<"(" <<v[k].id<<", "<< v[k].fx <<", "<<v[k].fy<<")"<<endl;

                }
                */

                    double tmpX = 0;
                    double tmpY = 0;

                    for(int j = 0; j<v.size(); j++)
                    {

                        nbr_id = v[j].id;

                        tmpX+= pos[nbr_id].x + v[j].fx;
                        tmpY+= pos[nbr_id].y + v[j].fy;

                    }


                        tmpX = tmpX/v.size();
                        tmpY = tmpY/v.size();

                    pos[i].x = tmpX;
                    pos[i].y = tmpY;


            }

        else
                {
                    pos[i].x = nan;
                    pos[i].y = nan;
                }
            }


        }
   }



}


/////////////////////////////////////////////////////////////////

int main(int argc, char const *argv[])
{

    int nIter, randMult, seedVal;

    ifstream inFile ("RandomIC_Input.txt");

     if (!is_file_empty(inFile))
    {
        inFile >> nIter >> randMult >> seedVal;
        //cout << nIter <<"\t"<< randMult <<endl;

        inFile.close();
    }
    else
    {
        cout << "Unable to open RandomIC_Input.txt";
    }

	NbrMap nbr;

  //  cout << nbr.size();


	PosMap pos;

	file_reader(nbr);
	Check_Missing_Keys(nbr);

    //Print_Nbr_Info(nbr);
   // cout << nbr.size();

	int nCycle = nbr.size();

	//cout << "Number of cycles = "<< nCycle <<endl;


	Initiate_Position(pos, nCycle, randMult, seedVal);

	Iterate_Postion(pos,nbr,nIter);

	Print_Position(pos,nCycle);

//	nbr[1].push_back(nv);
	//Print_Nbr_Info(nbr);


	return 0;
}
