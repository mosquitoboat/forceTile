function [a,s] = eliminate_floaters(a,s)

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
    
    a(rg,:)=[];
    s(rg,:,:)=[];
    s(:,rg,:)=[];
    
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
