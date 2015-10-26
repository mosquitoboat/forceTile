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


function [p,s,E] = triangularfb(m,fmin,Nnf)

% rng (randi([1 64],1,1))

a = [1 0];
b = [0.5 sqrt(3)/2 ];
count = 1;
%m = 2;
for i = 0:m
    for j = 0:m
        p(count,:) = i.*a+j.*b;
        count = count+1;
    end
end
p = sortrows(p);
%plot(p(:,1), p(:,2),'.')

%load q.mat
%q = p;
n = length(p);
s = zeros(n,n,3);

%p = p';
rng(1)
% rmin = 0.5;
fmax = 1;
E = [];
%% Find out the neighbor
for i = 1: n
    for j = 1:i-1;
        R = sqrt((p(i,1)-(p(j,1)))^2+(p(i,2)-(p(j,2)))^2);
        %R1 = sqrt((q(i,1)-(q(j,1)))^2+(q(i,2)-(q(j,2)))^2);
        if uint8(R)==1
            s(i,j,1) = 1;%rand*(fmax - fmin)+fmin;
            s(j,i,1) = 1;%s(i,j,1);
            s(i,j,2) = (p(i,1)-p(j,1))/R;
            s(j,i,2) = -s(i,j,2);
            s(i,j,3) = (p(i,2)-p(j,2))/R;
            s(j,i,3) = -s(i,j,3);
            
            
        end
    end
end

% s(32,23,1) = -2; 
% s(23,32,1) = -2; 

[r, c] = find(triu(s(:,:,1)));

Ep = sortrows([r c]); 
if(Nnf~=0)
% j = randsample(1:length(Ep),Nnf); 
Y = round(p(:,2)/sqrt(3)*2);

x = []; y = [];  
for i = 0:3:18
j = find(Y==i); 
x = [x; p(j,1);nan]; 
y = [y; p(j,2);nan]; 

for k = 1:length(j)-1
    
%     g1 = Ep(j(k),1); g2 = Ep(j(k),2); 
      g1 = j(k); g2 = j(k+1);   
    s(g1,g2,1) = -1; 
    s(g2,g1,1) = -1; 
end
end
end



figure(2),
gplot(s(:,:,1),p)
axis square
axis off
daspect([1 1 1])

if(exist('x','var'))
hold on 
plot(x,y,'-r')
hold off 
end
% 
% for i = 1:n
%     
%    r = find(s(i,:,1));
%    
%    if (length(r)==6)
%     
%        index = max(r); 
%        
%        r = setdiff(r,index);
%        s(i,index,1) = sqrt((sum(s(i,r,1).*s(i,r,2)))^2+(sum(s(i,r,1).*s(i,r,2)))^2);
%        s(index,i,1) = s(i,index,1); 
%        
%        % x component
%        
%        s(i,index,2) = -sum(s(i,r,1).*s(i,r,2))/s(i,index,1);
%        s(index,i,2) = -s(i,index,2);
%        s(i,index,3) = -sum(s(i,r,1).*s(i,r,3))/s(i,index,1);
%        s(index,i,3) = -s(i,index,3);
%    end
%     
% end


[r, c] = find(triu(s(:,:,1)));


for i = 1:length(r)
   
    ii = r(i); jj = c(i); 
    
    ff = s(ii,jj,1); 
    fx = s(ii,jj,2);
    fy = s(ii,jj,3);
    E = [E; ii jj ff fx fy]; 
    
    
end



%spy(s(:,:,1))      
%figure,
%labels = cellstr( num2str([1:length(p)]') );
%h =  gplot(s(:,:,1),p(:,1:2),'o-b');
%  text(p(:,1), p(:,2), labels, 'VerticalAlignment','bottom', ...
%     'HorizontalAlignment','right')
%% Plot the force tile

