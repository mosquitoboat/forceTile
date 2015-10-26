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



%%%%%%%%%%%%%% Force Tile Code for Generic Data %%%%%%%%%%%%%%%%%%%


%% Very Very Important 

% I assume you're working in the '../ForceTile_v1.0/FT Source/' folder  


%% Add folders to path

addpath(genpath('../../ForceTile_v1.0')); 


%% Load Raw Data



folder = '../Data/Raw/'; 
config = 'Generic_'; 
runid  = num2str(1); 

datafile = [folder 'rawData_' config runid '.mat']; 

 destination = '../Data/Raw/'; 

if (~exist(destination,'dir'))
    mkdir(destination); 
end


data = load(datafile); 

rawData = data.rawData; 
Lx = data.Lx; 
Ly = data.Ly; 
xythresh = data.xythresh;
grainid = data.gid;
clear data


%% Variable Declaration

maxSeed = 1; % Number of Configurations
nSteps  = 1; % Number of steps per configuration


realCell = cell(maxSeed,nSteps); % A Cell which will store all the real space data
dualCell = cell(maxSeed,nSteps); % A Cell which will store all the force space data

%% Start Analysis
for seed = 1:maxSeed
       
for steps =1:nSteps
    %% Adjacency Matrix
    posData = rawData{seed,steps}.pF; 
    forceData = rawData{seed,steps}.fF;  

    eliminateRattlers = true;

    realConfig = Generate_Adjacency_Matrix(posData,forceData, eliminateRattlers); 

   
    realConfig.Friction = false; % Frictional (true) or frictionless (false) configuration
    
    realConfig.GrainId  = grainid; % Id of the grains
    realConfig.Strn = 0; % Applied shear strain
    realConfig.Lx = Lx;  % Size of the box in the x-direction
    realConfig.Ly = Ly; % Size in the y direction
    realConfig.xythresh = xythresh; % This is a method to take care of the PBC. See the attached PBC document. 
    realConfig.PBC = 1; % Whether Periodic Boundary Condition or not
 
    %% Compute Stress Tensor (Optional)


%         realConfig = Calc_Stress_Tensor(realConfig);
%             
%         eval = abs(realConfig.StressEigVal); 
%         ST = realConfig.GlobalST; 
%         ev = (eig(ST)); 
%         P = abs(ev(1)+ev(2)); 
%         tau = abs(ev(2) - ev(1));
%         
%         realConfig.P = P; 
%         realConfig.T = tau; 
%         P = abs(eval(:,2) + eval(:,1))/2;
%         tau = abs(eval(:,2) - eval(:,1))/2; 
%         anisotropy = tau./P; 


    %% Compute the minimal cycles 
    
    MinCycles = Compute_Minimal_Cycles(realConfig); 
    realConfig.MinCycles = MinCycles; 
    
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

            [Gidx,loc,dCycle,dAdj] = Find_FT_Index(vert,Adj,cycles,Zmax);
        end

%         clear vert Adj cycles 

    FTConfig.Cycles = dCycle; 
    FTConfig.GrainIndex = Gidx; 
    FTConfig.FTCenters = loc; 
    FTConfig.dAdj = dAdj;


    %% Save the configurations in a cell
  
          
         realCell(seed,steps) = {realConfig};
        dualCell(seed,steps) = {FTConfig}; 
        
    %% Plot the Force Tile
        
      gplot(Adj(:,:,1),vert);     
      daspect([1 1 1])
end


end


%% Save processed data

 destination = '../Data/Processed/'; 

    if (~exist(destination,'dir'))
        mkdir(destination); 
    end
    
savefile = [destination 'FT_Frictional.mat'];

save(savefile,'realCell','dualCell','-v7.3');

%% Plot mean stuff
% figure,
% FT = dualCell{1,1}; 
% s = FT.Adj(:,:,1); 
% vert = FT.xy; 
% id = 1:length(vert);  
% s(s>0) = 1; 
% s(s<0) = -1; 
% nVert = length(vert(id,:));
% cmrange = [-1 1]; 
% daspect([1 1 1])
%    [~,~]=wgPlot(s(id,id),vert(id,:),'vertexWeight',ones(nVert,1),'vertexMetadata',ones(nVert,1),'edgeColorMap',othercolor('RdYlBu4',64));%,'colormaprange',cmrange);
   

% a = vert(id,:); 
%   labels = cellstr( num2str([1:length(a)]') ); 
%   text(a(:,1), a(:,2), labels, 'fontsize',5,'VerticalAlignment','bottom','HorizontalAlignment','right','Color',[0.5 0.5 0.5])
%  hold on 