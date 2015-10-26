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
*/



#ifndef VEC2_H
#define VEC2_H

#include "Headers.h"


class Vec2{

public:

     // Constructor and Destructor

        Vec2();
        Vec2(double x, double y);
        Vec2(const Vec2& v );

        ~Vec2() {delete[] mTuple;};

     // Assignment.
    Vec2& operator= (const Vec2& vec);

    // Coordinate access.
//    inline double X () const;
    inline double& X ();
//    inline double Y () const;
    inline double& Y ();

    double& operator[] (int i) {return mTuple[i];};
    // Arithmetic operations.
    inline Vec2 operator+ (const Vec2& vec) const;
    inline Vec2 operator- (const Vec2& vec) const;
    inline Vec2 operator* (double scalar) const;
    inline Vec2 operator/ (double scalar) const;
    inline Vec2 operator- () const;

    // Arithmetic updates.
    inline Vec2& operator+= (const Vec2& vec);
    inline Vec2& operator-= (const Vec2& vec);
    inline Vec2& operator*= (double scalar);
    inline Vec2& operator/= (double scalar);

    // Vector operations.
    inline double Length () const;
    inline double SquaredLength () const;
    inline double Dot (const Vec2& vec) const;

    // Returns (y,-x).
    inline Vec2 Perp () const;

    // Returns (y,-x)/sqrt(x*x+y*y).
//    inline Vec2 UnitPerp () const;

    // Returns DotPerp((x,y),(V.x,V.y)) = x*V.y - y*V.x.
    inline double DotPerp (const Vec2& vec) const;


    friend std::ostream& operator<< (std::ostream& outFile,  Vec2& vec);


protected:

        double* mTuple = new double[2];

};

#include "Vec2.inl"
#endif // VEC2_H
