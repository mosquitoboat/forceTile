// Geometric Tools, LLC
// Copyright (c) 1998-2014
// Distributed under the Boost Software License, Version 1.0.
// http://www.boost.org/LICENSE_1_0.txt
// http://www.geometrictools.com/License/Boost/LICENSE_1_0.txt
//
// File Version: 5.0.2 (2014/01/04)

#ifndef EDGEKEY_H
#define EDGEKEY_H

#include "Headers.h" 

class EdgeKey
{
public:
    EdgeKey (int v0 = -1, int v1 = -1);
    bool operator< (const EdgeKey& key) const;
    int V[2];
};

class OrderedEdgeKey
{
public:
    OrderedEdgeKey (int v0 = -1, int v1 = -1);
    bool operator< (const OrderedEdgeKey& key) const;
    int V[2];
};

#include "EdgeKey.inl"



#endif
