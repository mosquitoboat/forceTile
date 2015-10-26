function [E, adj] = neighbornp(a)

n = length(a);
adj = zeros(n,n,3);
E=[];
for i = 1:n
    for j = 1:i-1 
       %R = sqrt(mod((a(i,1)-a(j,1)),xmod)^2+(mod((a(i,2)-a(j,2)),ymod))^2);
        
       xij = a(i,1)-(a(j,1));
       yij = a(i,2)-(a(j,2));
       
       % Following two lines are for Tianqi's data. 
      % xij = xij -round(xij);
      % yij = yij -round(yij);
       
        R = sqrt((xij)^2+(yij)^2);
       
%         Rx = mod(abs(a(i,1)-a(j,1)),xmod);
%         Ry =  mod(abs(a(i,2)-a(j,2)),ymod);
        D =((a(i,3)+a(j,3))/2); 
%         kx = Rx-D;
%         ky = Ry-D;
        k = R-D; k0 = 1e-5; 
        %if (kx <= 0 && ky<=0)
        if (k<=k0)
           % f= (2*(1-R/D))/D; %Mitch
            f= ((1-R/D))/D;% Tianqi and Carl
            adj(i,j,1) = f;
            adj(j,i,1) = f;
            adj(i,j,2) = (a(j,1)-(a(i,1)))/R;%ii
            adj(j,i,2) = -adj(i,j,2);%ii;%
            adj(i,j,3) = (a(j,2)-(a(i,2)))/R;%jj;%
            adj(j,i,3) = - adj(i,j,3);%jj;%
            E = [E;j i];
        end
         
    end
end

