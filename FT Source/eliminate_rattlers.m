function [a,s,n2rat] = eliminate_rattlers(a,s)

% tic 
% Eliminate all the grains with 0 or 1 contacts

contacts = zeros(1,length(s));
for idx = 1:length(s)
contacts(idx) = length(find(s(idx,:,1)));
end

 rattlers = find(contacts <= 1); 
 a(rattlers,:)=[];
 s(rattlers,:,:)=[];
 s(:,rattlers,:)=[];

% Eliminate all the grains with 2 contacts and replace that grain with a
% contact between its neighbors


% length(s)
% 
% 
% 
% rperi =[];
n2rat = 0;
 while(numel(rattlers)>1)
     
%  contacts = zeros(1,length(s));
%  for idx = 1:length(s)
%  contacts(idx) = length(find(s(idx,:,1)));
%  end
contacts = sum(logical(s(:,:,1)));
 
 rattlers = find(contacts == 2);
 
 if(~isempty(rattlers))
%  for i = 1: length(rattlers)   
    
    rg  = rattlers(1);%randsample(rattlers,1);
    nbr = find(s(rg,:,1)); 
    
    
    if(numel(nbr)==2)
    g1 = nbr(1); g2 = nbr(2); 
    
    n2rat = n2rat+1;
%     rperi = [rperi; abs(s(g1,rg,1))+abs(s(g2,rg,1))];
    fx = s(g1,rg,1)*s(g1,rg,2)+s(rg,g2,1)*s(rg,g2,2); 
    fy = s(g1,rg,1)*s(g1,rg,3)+s(rg,g2,1)*s(rg,g2,3); 
    
    s(g1,g2,1) = sqrt(fx^2+fy^2);
    s(g1,g2,2) = fx/sqrt(fx^2+fy^2);
    s(g1,g2,3) = fy/sqrt(fx^2+fy^2);
    
    s(g2,g1,1) = sqrt(fx^2+fy^2);
    s(g2,g1,2) =  -fx/sqrt(fx^2+fy^2);
    s(g2,g1,3) = -fy/sqrt(fx^2+fy^2);
    
    a(rg,:)=[];
    s(rg,:,:)=[];
    s(:,rg,:)=[];
    end
 end
%  end
 end
% t = toc; 

% display(['Eliminate_rattlers ends. Time elapsed: ' num2str(t)])
 %%
%  contacts = zeros(1,length(s));
% for idx = 1:length(s)
% contacts(idx) = length(find(s(idx,:,1)));
% end
% 
%  rattlers = find(contacts <= 1); 
%  a(rattlers,:)=[];
%  s(rattlers,:,:)=[];
%  s(:,rattlers,:)=[];
