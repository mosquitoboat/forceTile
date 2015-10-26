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


function plot_Grains_and_FT(realConfig, FTConfig, colmap1, colmap2)

%% Set Up


xyd = realConfig.xyd;

PBC = realConfig.PBC; 

if (PBC ~= 0)

    Lx   = realConfig.Lx; 
    Ly   = realConfig.Ly; 
    strn = realConfig.Strn; 
    xythresh = realConfig.xythresh; 
    
end

da     = FTConfig.xy; 
dCycle = FTConfig.Cycles; 
Gidx   = FTConfig.GrainIndex; 
loc    = FTConfig.FTCenters; 
    

id = ~isnan(Gidx);  
Gidx = Gidx(id);
loc = loc(id,:);
dCycle = dCycle(id,:); 
N = length(xyd); 


% rng(2)

% colidmax = 512;
% cid = [1:512; 1:512]; 
% cid = cid(:); 
% cid = cid(1:N,:); 

colidmax = size(colmap1,1); 

cid = randi([1 colidmax],N,1); 
col1 = colmap1; 
col2 = colmap2; 
if (realConfig.Friction == false)
    cid = realConfig.GrainId ; 
end
% cid
tcolor = [0 0 0];%[1 1 1];



edgePart1 = 'k';%[0 80 150]/255; % particles edge color

%% Plot particles

x = xyd(:,1); 
y = xyd(:,2); 
d = xyd(:,3)/2; 


id = x(Gidx) < -0.5*Lx | x(Gidx) > 0.5*Lx | y(Gidx) < -0.5*Ly | y(Gidx) > 0.5*Ly; 

cmapid = zeros(size(Gidx)); 



cmapid(id) = 2; 
cmapid(~id) = 1; 

% clear Gidx

figure(1),
clf
% subplot(2,2,[1 3])

% subplot(2,1,1)

hold on


for i = 1:N
    
    r = find(Gidx==i,1); 
    
   if (~isempty(r))%(k == 0 && l == 0)                 
        colid = cid(i);

        if(cmapid(r) == 1)
            rectangle('Position',[x(i)-.5*d(i)  y(i)-.5*d(i) d(i) d(i)],...
                'Curvature',[1 1],'edgecolor',edgePart1,'facecolor',col1(colid,:));
        else 
            pcol = [0.8 0.8 0.8];%col2(colid,:); 
            rectangle('Position',[x(i)-.5*d(i)  y(i)-.5*d(i) d(i) d(i)],...
                'Curvature',[1 1],'edgecolor',edgePart1,'facecolor',pcol);
        end
    else
%                         rectangle('Position',[x(i)-.5*d(i) y(i)-.5*d(i) d(i) d(i)],...
%                             'Curvature',[1 1],'edgecolor',[0.4 0.4 0.4],'facecolor',[0.4 0.4 0.4]);
%                           continue;   
    end
end

%     plot([-0.5*Lx -0.5*Lx],[-0.5*Ly  0.5*Ly],'k--')
%     plot([-0.5*Lx  0.5*Lx],[ 0.5*Ly  0.5*Ly],'k--')
%     plot([ 0.5*Lx  0.5*Lx],[ 0.5*Ly -0.5*Ly],'k--')
%     plot([ 0.5*Lx -0.5*Lx],[-0.5*Ly -0.5*Ly],'k--')

axis([-xythresh*Lx xythresh*Lx -xythresh*Ly xythresh*Ly])
axis off



 
%         labels = cellstr( num2str((Gidx) ));
%         text(xyd(Gidx,1), xyd(Gidx,2), labels, 'VerticalAlignment','middle','HorizontalAlignment','center',...
%             'Color',tcolor,'FontSize',10)



daspect([1 1 1])



hold off



%% Dual Graph
figure(2),
clf
col1 = colmap1; 
col2 = colmap2; 
if(~isempty(da))

    NG = size(dCycle,1); 

%     subplot(2,2,[2 4])
%       subplot(2,1,2)  
    
    hold on 
   
    for i = 1:NG
        
        ci = dCycle(i,:); 
        ci = ci(ci>0); 
       
        x = da(ci,1); 
        y = da(ci,2); 
        
            id = cid(Gidx(i,1),1); 
            if (cmapid(i) ==1)
                pcol = col1(id,:); 
            else
                pcol = [0.8 0.8 0.8];%col2(id,:);
            end
            
        fill(x,y,pcol)
        
    end
        
    


%             labels = cellstr( num2str(Gidx));
%             text(loc(:,1), loc(:,2), labels, 'VerticalAlignment','middle','HorizontalAlignment','center',...
%                 'Color',tcolor,'FontSize',10)

    
    
%     axis square 
    axis off 
    
    
    hold off 
else
%     subplot(1,2,2)
    cla
end

daspect([1 1 1])

hold off



%% Set Figure Background Color
% set(gcf,'color',[0.6 0.6 0.6]); 