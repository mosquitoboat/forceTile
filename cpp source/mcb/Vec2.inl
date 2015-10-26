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



#define MAX_T std::numeric_limits<double>::max()


//----------------------------------------------------------------------------

Vec2::Vec2 ()
{
    // Uninitialized for performance in array construction.
}
//----------------------------------------------------------------------------

Vec2::Vec2 (const Vec2& vec)
{
    mTuple[0] = vec.mTuple[0];
    mTuple[1] = vec.mTuple[1];
}

//----------------------------------------------------------------------------

Vec2::Vec2 (double x, double y)
{
    mTuple[0] = x;
    mTuple[1] = y;
}
//----------------------------------------------------------------------------

//inline double& Vec2::operator[] (int i) const
//{
//    return mTuple[i];
//}

//----------------------------------------------------------------------------

Vec2& Vec2::operator= (const Vec2& vec)
{
    mTuple[0] = vec.mTuple[0];
    mTuple[1] = vec.mTuple[1];
    return *this;
}
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------

//inline double Vec2::X () const
//{
//    return mTuple[0];
//}
//----------------------------------------------------------------------------

inline double& Vec2::X ()
{
    return mTuple[0];
}
//----------------------------------------------------------------------------

//inline double Vec2::Y () const
//{
//    return mTuple[1];
//}
//----------------------------------------------------------------------------

inline double& Vec2::Y ()
{
    return mTuple[1];
}
//----------------------------------------------------------------------------

inline Vec2 Vec2::operator+ (const Vec2& vec) const
{
    return Vec2
    (
        mTuple[0] + vec.mTuple[0],
        mTuple[1] + vec.mTuple[1]
    );
}
//----------------------------------------------------------------------------

inline Vec2 Vec2::operator- (const Vec2& vec) const
{
    return Vec2
    (
        mTuple[0] - vec.mTuple[0],
        mTuple[1] - vec.mTuple[1]
    );
}
//----------------------------------------------------------------------------

inline Vec2 Vec2::operator* (double scalar) const
{
    return Vec2
    (
        scalar*mTuple[0],
        scalar*mTuple[1]
    );
}
//----------------------------------------------------------------------------

inline Vec2 Vec2::operator/ (double scalar) const
{
    Vec2 result;

    if (scalar != (double)0)
    {
        double invScalar = ((double)1)/scalar;
        result.mTuple[0] = invScalar*mTuple[0];
        result.mTuple[1] = invScalar*mTuple[1];
    }
    else
    {
        result.mTuple[0] = MAX_T;
        result.mTuple[1] = MAX_T;
    }

    return result;
}
//----------------------------------------------------------------------------

inline Vec2 Vec2::operator- () const
{
    return Vec2
    (
        -mTuple[0],
        -mTuple[1]
    );
}
//----------------------------------------------------------------------------

inline Vec2& Vec2::operator+= (const Vec2& vec)
{
    mTuple[0] += vec.mTuple[0];
    mTuple[1] += vec.mTuple[1];
    return *this;
}
//----------------------------------------------------------------------------

inline Vec2& Vec2::operator-= (const Vec2& vec)
{
    mTuple[0] -= vec.mTuple[0];
    mTuple[1] -= vec.mTuple[1];
    return *this;
}
//----------------------------------------------------------------------------

inline Vec2& Vec2::operator*= (double scalar)
{
    mTuple[0] *= scalar;
    mTuple[1] *= scalar;
    return *this;
}
//----------------------------------------------------------------------------

inline Vec2& Vec2::operator/= (double scalar)
{
    if (scalar != (double)0)
    {
        double invScalar = ((double)1)/scalar;
        mTuple[0] *= invScalar;
        mTuple[1] *= invScalar;
    }
    else
    {
        mTuple[0] *= MAX_T;
        mTuple[1] *= MAX_T;
    }

    return *this;
}
//----------------------------------------------------------------------------

inline double Vec2::Length () const
{
    return sqrt
    (
        mTuple[0]*mTuple[0] +
        mTuple[1]*mTuple[1]
    );
}
//----------------------------------------------------------------------------

inline double Vec2::SquaredLength () const
{
    return
        mTuple[0]*mTuple[0] +
        mTuple[1]*mTuple[1];
}
//----------------------------------------------------------------------------

inline double Vec2::Dot (const Vec2& vec) const
{
    return
        mTuple[0]*vec.mTuple[0] +
        mTuple[1]*vec.mTuple[1];
}

//----------------------------------------------------------------------------

inline Vec2 Vec2::Perp () const
{
    return Vec2
    (
        mTuple[1],
        -mTuple[0]
    );
}
//----------------------------------------------------------------------------

//inline Vec2 Vec2::UnitPerp () const
//{
//    Vec2 perp(mTuple[1], -mTuple[0]);
//    perp.Normalize();
//    return perp;
//}
//----------------------------------------------------------------------------

inline double Vec2::DotPerp (const Vec2& vec) const
{
    return mTuple[0]*vec.mTuple[1] - mTuple[1]*vec.mTuple[0];
}

//----------------------------------------------------------------------------


//----------------------------------------------------------------------------

std::ostream& operator<< (std::ostream& outFile, Vec2& vec)
{
     return outFile << vec.X() << ' ' << vec.Y();
}
//----------------------------------------------------------------------------

