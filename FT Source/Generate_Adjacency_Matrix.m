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



function realConfig = Generate_Adjacency_Matrix(posFile,forceFile, eliminateRattlers)

% I assume the posFile will contain the grain positions in the following
% format: ID x y d and
% forceFile will have the forces in the following format 
% ID1 ID2 ff fx fy. ff is the magnitude of the force, wheras fx and fy are 
% the unit vectors. 


%% Position

gindx = posFile(:,1)+1;
nGrain = max(gindx);
a = nan(nGrain,3); 

a(gindx,:) = posFile(:,2:4); 
a(:,3) = 2*a(:,3);

xy = a(:,1:2); 

distance = sqrt(sqdistance(xy',xy'));
id = distance > 4; 
%% Adjacency Matrix

s = zeros(nGrain,nGrain,3);


for ii = 1: length(forceFile)
        
        i = forceFile(ii,1)+1; j = forceFile(ii,2)+1;  
   
       fx = forceFile(ii,4); fy = forceFile(ii,5);
       ff = forceFile(ii,3); 
        
       s(i,j,1) = ff;
       s(j,i,1) = ff;   

       s(i,j,2) = fx/sqrt(fx^2+fy^2);
       s(j,i,2) = -fx/sqrt(fx^2+fy^2);

       s(i,j,3) = fy/sqrt(fx^2+fy^2);
       s(j,i,3) = -fy/sqrt(fx^2+fy^2);
            
%     end
end
 
 
Z = sum((logical(s(:,:,1)))); 
[r, c] = find(triu(s(:,:,1))); 

    E = [r c];

    E = sortrows(E);
%% Eliminate rattlers and save data

if eliminateRattlers
    [a,s,~] = eliminate_rattlers(a,s);
 
    Z = sum((logical(s(:,:,1)))); 

    [r, c] = find(triu(s(:,:,1))); 

    E = [r c];

    E = sortrows(E);
end


%% Find dimension of the sample

% x = a(:,1); 
% y = a(:,2); 
% 
% k = convhull(x,y);
% 
% x = x(k); 
% y = y(k); 
% 
% [x,y,~,~] = minboundparallelogram(x,y,'p');
% 
% % D = sqrt(P^2/4 - 4*A); 
% % Lx = 0.5*(P/2 + D); 
% % Ly = 0.5*(P/2 - D); 
% if (abs(x(1) - x(4)) > abs(y(1) - y(4)))
%     Lx = sqrt((x(1) - x(4))^2 + (y(1) - y(4))^2); 
%     Ly = sqrt((x(3) - x(4))^2 + (y(3) - y(4))^2);
% else
%     Ly = sqrt((x(1) - x(4))^2 + (y(1) - y(4))^2); 
%     Lx = sqrt((x(3) - x(4))^2 + (y(3) - y(4))^2);
% end

% s1 = s(:,:,1); 
% s1(id) = 0; 
% s(:,:,1) = s1; 
realConfig.xyd = a; 
realConfig.Adj = s; 
realConfig.Edges = E;    
realConfig.Z   = Z;
% realConfig.Lx  = Lx; 
% realConfig.Ly  = Ly; 
 


