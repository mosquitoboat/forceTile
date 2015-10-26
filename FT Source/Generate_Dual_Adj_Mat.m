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




%%%-------------------------------------------------------------------%%%

% Produces the vectors of the dual lattice. The vector should be
% provided in a (n,n,3) adjacency matrix, where n is the number of
% vertices. Each element of the (n,n) matrix contains 1. Magnitude, 2. X
% component, and 3. Y component of the force.


function FTConfig = Generate_Dual_Adj_Mat(realConfig, MinCycles)

% (pos,rAdj,nCycle,centroidM)

%% Set Up

delete('ForceNetInfo.txt');

pos = realConfig.xyd; 
rAdj = realConfig.Adj;

nCycle = MinCycles.N; 
centroidM = MinCycles.Centers; 

CycleAdj=zeros(nCycle,nCycle,3);


%% Obtain the dual Adj
tic 

delete('dual_Adj.txt')

if (strcmp(getenv('OS'),'Windows_NT'))
    !dual_Adj.exe
else
    !./dual_Adj
end

localFolder = '';%'/home/sumantra/Dropbox/MATLAB/Force chain/Source code/funk/CPP_Executables/';
M = sortrows(load([localFolder 'dual_Adj.txt'])); 

t = toc; 
size(M)
display(t)
%%

Adj = []; 
tic 


S = rAdj(:,:,1); 

medF = median(S(S>0)); 

[r,c] = find(S > 10*medF); 


 for i = 1:length(r)
            rAdj(r(i),c(i),1) = 0; 
            rAdj(c(i),r(i),1) = 0; 
            rAdj(r(i),c(i),2) = 0; 
            rAdj(c(i),r(i),2) = 0; 
            rAdj(r(i),c(i),3) = 0; 
            rAdj(c(i),r(i),3) = 0; 
 end




for ii = 1:size(M,1)
    
        i = M(ii,2); j = M(ii,1); 
        v = M(ii,3:4); 
        
          
          CycleAdj(i,j,1)=rAdj(v(1),v(2),1);
          CycleAdj(j,i,1)=rAdj(v(1),v(2),1);
          
          A = pos(v(1),1:2); B = pos(v(2),1:2);
          
          X = centroidM(i,:);
          
           position = sign( (B(1,1)-A(1,1))*(X(1,2)-A(1,2)) - (B(1,2)-A(1,2))*(X(1,1)-A(1,1)) );

%            if position == 0
%             display('position ==0');
%            end
          if (position == -1)
                CycleAdj(i,j,2)=-rAdj(v(1),v(2),3);
                CycleAdj(j,i,2)=+rAdj(v(1),v(2),3);
          
                CycleAdj(i,j,3)=+rAdj(v(1),v(2),2);
                CycleAdj(j,i,3)=-rAdj(v(1),v(2),2);
                
                
          elseif (position == 1)
          
                CycleAdj(i,j,2)=+rAdj(v(1),v(2),3);
                CycleAdj(j,i,2)=-rAdj(v(1),v(2),3);
          
                CycleAdj(i,j,3)=-rAdj(v(1),v(2),2);
                CycleAdj(j,i,3)=+rAdj(v(1),v(2),2);
          end
                
          fxij = CycleAdj(i,j,1)*CycleAdj(i,j,2); 
          fxji = -fxij; 
          fyij = CycleAdj(i,j,1)*CycleAdj(i,j,3);
          fyji = -fyij; 
         
          Adj = [Adj; i j fxij fyij; j i fxji fyji ]; 
          
end
    
Adj = sortrows(Adj); 
dlmwrite('ForceNetInfo.txt',Adj,'delimiter','\t')
t = toc;

clear Adj

% % 
display(['Construction of dual adjacency matrix ends. Time elapsed: ' num2str(t)])

%% Store data 

FTConfig.Adj = CycleAdj; 


