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
% Author: Sumantra Sarkar                                               %
%         Martin Fisher School of Physics                               %
%         Brandeis University                                           %
%         forcetileenquiries@gmail.com                                  %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%% Generic Force Tile Code %%%%%%%%%%%%%%%%%%%

% In this code, I'll generate the force tile for a force balanced triangular 
% network with random forces through the contacts. In this case, there won't 
% be any rattlers in the network, though for an actual data, there may be 
% rattlers (grains with 2 or less contacts), and they have to be removed 
% carefully.  

clear all
%% Real Space Configuration

% You may have to process the data to generate the data in posFile and
% forceFile format, which is explained in the Generate_Adjacency_Matrix.m file.

%%%%%%%%%%%%%%%%% Generate a force balanced triangular lattice %%%%%%%%

m = 20; % Length of the triangular lattice

% fmin = minimum force magnitude. fmax = 1. 
% Hence, put fmin = 1 to generate a regular FT, and between 0 to 1 for
% disordered force tile. This particular force doesn't deal with attractive
% interactions, so fmin has to be >= 0. 

fmin = 1; 

%%%%%%%%%%%% Generate force balanced config %%%%%%%%%%%

[p,s,E] = triangularfb(m, fmin); 
p = [(1:length(p))' p 0.5*ones(length(p),1)];

dlmwrite('forcesTriangularLattice.txt',E,'delimiter','\t')
dlmwrite('triangularLattice.txt',p,'delimiter','\t')

%%%%%%%%%%%% Start of the Generic Code %%%%%%%%%%%%%%%

N = (m+1)^2; 
posFile = load('triangularLattice.txt'); 
forceFile = load('forcesTriangularLattice.txt'); 

eliminateRattlers = false;

realConfig = Generate_Adjacency_Matrix(posFile,forceFile, eliminateRattlers); 

realConfig.PBC = 0; 
%% Compute the minimal cycles 

MinCycles = Compute_Minimal_Cycles(realConfig); 


%% Compute Stress Tensor (Optional)

realConfig = Calc_Stress_Tensor(realConfig);


eval = abs(realConfig.StressEigVal); 
        ST = realConfig.GlobalST; 
        ev = eig(ST); 
        P = abs(ev(1)+ev(2)); 
        tau = abs(ev(2) - ev(1)); 
anisotropy = abs(eval(:,2) - eval(:,1))./abs(eval(:,2) + eval(:,1));
%% Obtain topology of the force tiles

FTConfig = Generate_Dual_Adj_Mat(realConfig, MinCycles); 

%% Compute the height vertices 

FTConfig = Compute_Height_Vertices(FTConfig); 

%% Compute the cycles of the dual graph and grain index

   Zmax = max(realConfig.Z); 

    if (~isempty(FTConfig.xy))
    
        vert    = FTConfig.xy; 
        Adj     = FTConfig.Adj; 
        cycles  = MinCycles.MCB; 
        
        [Gidx,loc,dCycle] = Find_FT_Index(vert,Adj,cycles,Zmax);
    end

    clear vert Adj cycles 
    
FTConfig.Cycles = dCycle; 
FTConfig.GrainIndex = Gidx; 
FTConfig.FTCenters = loc; 

%% Find the geometric properties (Area etc) of the Force Tile

 FTGeom = Compute_Geometric_Properties_of_Tiles(FTConfig); 
 
 Area = FTGeom.Area; 
 Peri = FTGeom.Perimeter; 
 
%  Aspect = FTConfig.AspectRatio; 
%  Ecc = FTConfig.ShapeAnisotropy; 
 
%% Find the global aspect ratio
         
        xy = FTConfig.xy; 
        k = convhull(xy(:,1), xy(:,2)); 
        

             XY = [xy(k,1) xy(k,2)]';
             
                 mBB = minBoundingBox(XY); 
        [pgx,pgy,area1,peri1] = minboundparallelogram(XY(1,:),XY(2,:),'p');
        
        mBP = [pgx(1:5) pgy(1:5)]';
        
        
        Fx = [pgx(1)-pgx(4) pgy(1) - pgy(4)]; 
        Fy = [pgx(3)-pgx(4) pgy(3) - pgy(4)];
        Fx(Fx<0) = 0; Fy(Fy<0) = 0; 
        Lx = realConfig.Lx; 
        Ly = realConfig.Ly; 
        
        Sigma = [Lx 0; 0 Ly]*[Fx(1) Fx(2); Fy(1) Fy(2)];  
        
        
        EV = eig(Sigma); 
        
        PG = sum(EV)/2; 
        DG = abs(diff(EV))/2; 
%              peri2 = Calc_Perimeter(XY');
%              area2 = polyarea(XY(1,:),XY(2,:));
%              
%              xsArea1 = (peri1/4)^2 - area1; 
%              xsArea2 = (peri2/4)^2 - area2; 
%              
%              PG = peri1/4; DG = sqrt(xsArea1); 
%              
             h = PG - DG; 
             w = PG + DG; 
             
             
             
    
         xy = xy'; 
%% Plot the Contact Network and Force Tile


id = XY(2,:) == min(XY(2,:)); 
%     a = sortrows(XY'); 
    a = XY(:,id); 
   
figure(1), 
    plot(xy(1,:),xy(2,:),'.',mBP(1,:),mBP(2,:))
%     hold on 
%     rectangle('position',[a(1), a(2), h, w ])
%     hold off
% figure(1), 
% clf
% % colmap = jet(512); 
% % graphMap= jet(512); 
% % plot_Grains_and_FT(realConfig, FTConfig, colmap,graphMap)
% 
% graphMap= jet(512); 
% graphplot(realConfig,FTConfig,graphMap)
% 
% figure(2)
%  scatter(1- 1./Aspect, anisotropy(Gidx))
%  hold on 
%   scatter(Ecc, anisotropy(Gidx),'r')
%   hold off