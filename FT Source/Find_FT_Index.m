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

%%
function [idx,loc,dual_cycles,dAdj] = Find_FT_Index(pos,adj,rCycle,Zmax)


  
[r, c] = find(triu(adj(:,:,1))); 
E = [r c];
E = sortrows(E);  

%  [~,dual_cycles] = setup(pos,adj,E,1000);
 
 config.xyd = pos; 
 config.Edges = E;  
 config.Adj = adj; 
 
 dcycles = Compute_Minimal_Cycles(config); 

 dconfig = Generate_Dual_Adj_Mat(config, dcycles);    
 
 dAdj = dconfig.Adj; 
 nCycle  = dcycles.N; 
 dual_cycles = dcycles.MCB; 
 loc = dcycles.Centers; 

   
    idx = nan(nCycle,1);

for i = 1:nCycle
      ci = dual_cycles(i,:); 
      ci = ci(ci>0); 
     vec = rCycle(ci(1),:);
     vec = vec(vec>0); 
     
     for j = 2:length(ci);
        
        cyc_curr = rCycle(ci(j),:); 
        cyc_curr = cyc_curr(cyc_curr>0); 
        
        vec = intersect(vec,cyc_curr);
         
         
     end
     if(~isempty(vec) && length(ci) <= Zmax)
        idx(i) = vec; 
     end
end



