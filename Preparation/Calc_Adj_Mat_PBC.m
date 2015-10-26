function [xyd,a,gid, E, adj,dummyxy,dummyAdj] = Calc_Adj_Mat_PBC(xyd,Lx,Ly,strn, xythresh)



% Lees-Edwards boundary condition

x = xyd(:,1); 
y = xyd(:,2); 
d = xyd(:,3); 

corx = round(x/Lx);
x=x-corx*Lx;
y=y-corx*strn;
y=y-round(y/Ly)*Ly;


xyd = [x y d]; 

a = [];  
gid = []; 
N = length(xyd); 
for k = -1:1
    for l = -1:1
        
        a = [a; x+k*Lx y+l*Ly+k*Lx*strn d]; 
        gid = [gid; [1:N]'];
        
    end
end


% Keep all the particles within a box of size [2*xythresh*Lx,
% 2*xythresh*Ly], else remove them. 



x = a(:,1);
y = a(:,2);
ymod = Ly*3;

max(y) 
min(y)
cory = round(y/ymod); 
y = y-cory*ymod; 
a(:,2) = y; 

dummyxy = a(:,1:3); 




id = x < -xythresh*Lx | x > xythresh*Lx | y < -xythresh*Ly | y > xythresh*Ly; 

a(id,:) = []; 
gid(id,:) = []; 
xythresh = xythresh*1.4; 

x = dummyxy(:,1);
y = dummyxy(:,2);

id = x < -xythresh*Lx | x > xythresh*Lx | y < -xythresh*Ly | y > xythresh*Ly; 
dummyxy(id,:) = []; 

[~,dummyAdj] = neighbornp(dummyxy); 

%% Calculate Stress Tensor

n = length(a); 
adj = zeros(n,n,3); 

for i = 1:n
    for j = 1:i-1 
        
        dij =((a(i,3)+a(j,3))/2); 
        
        xij = a(i,1) - a(j,1); 
      
        if(abs(xij)<dij)
            yij = a(i,2) - a(j,2);  
       
           if(abs(yij)<dij)
                    rij = sqrt(xij*xij+yij*yij);


                    if (rij < dij)
                        
                        fc = (1.0-rij/dij)/dij;
                        fr = fc/rij;
                        f_x = fr*xij;
                        f_y = fr*yij;
                        f = sqrt(f_x^2+f_y^2); 
                        
                    
                        if(f>0)
                            % Adjacency Matrix

                            adj(i,j,1) = f;
                            adj(j,i,1) = f;

                            % Construction of the unit vectors for the force. Since force
                            % act normally to the grain boundary, the direction of the
                            % force is from center to center. I'll need to change this part
                            % for other calculations. 

                            adj(i,j,2) = xij/rij;
                            adj(j,i,2) = -adj(i,j,2);
                            adj(i,j,3) = yij/rij;
                            adj(j,i,3) = - adj(i,j,3);
                        
                        end
                       
                    end
           end
        end
    end
end



[r, c] = find(triu(adj(:,:,1))); 
% 
E = [r c];

E = sortrows(E);








      