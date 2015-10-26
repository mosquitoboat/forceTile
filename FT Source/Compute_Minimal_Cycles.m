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




function MinCycles = Compute_Minimal_Cycles(Config)
    %% Set Up
    cycles = []; 
    E  = Config.Edges; 
    xyd = Config.xyd; 
    
    delete('./PlanarGraph.txt');
    delete('./Cycles_PlanarGraph.txt');
    
    E = sortrows(E);
    
    
    NVert = int16(length(xyd));
    NEdge = int16(length(E));
    
    filename = './PlanarGraph.txt';
    dlmwrite(filename, NVert, '-append', 'delimiter', ' ')
    dlmwrite(filename, xyd(:,1:2), '-append', 'delimiter', ' ')
    dlmwrite(filename, NEdge, '-append', 'delimiter', ' ')
    dlmwrite(filename, E-1, '-append', 'delimiter', ' ')

    %% Compute the cycles
    % The following code generates the minimal cycles
    
    % Change to the name of the executable from the MCB codes.
    
    
    if (strcmp(getenv('OS'),'Windows_NT'))
        % For Windows
        !MCB.exe  
    else
        % For Unix
        !./MCB
    end
    
    
    if (exist('./Cycles_PlanarGraph.txt','file'))
    
        cycles = dlmread('./Cycles_PlanarGraph.txt');
    
    end
    
    %% Compute the centroids of the cycles 
  if(exist('cycles','var'))  
        nCycle   = size(cycles,1);

        Centroids = zeros(nCycle,2);

    for i = 1:nCycle
          ci = cycles(i,:); 
          ci = ci(ci>0); 
         Centroids(i,:) = mean(xyd(ci,1:2));
    end
  end
%% Store Data

MinCycles.MCB = cycles; 
MinCycles.N   = nCycle;
MinCycles.Centers = Centroids; 