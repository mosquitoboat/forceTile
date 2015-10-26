%% Very Very Important 

% I assume you're working in the '../ForceTile_v1.0/Preparation/' folder  



%% Generic

maxSeed = 1; 
steps = 1;%0.01:0.01:0.1;
Nstep = numel(steps);



rawData = cell(maxSeed,Nstep); 


for seed = 1:maxSeed; 

    
 xythresh = 0.51; % This is a parameter to take care of PBC. Check the document

if (strcmp(getenv('OS'),'Windows_NT'))
 folder = '../Sample/'; 
else
  folder  = '../Sample/'; % Change this to the directory where you've stored your raw data file in the text format
end

subfolder = ''; % If there is any subfolder.  


 %%
 
data = load([folder subfolder 'system_phi0.835']); % This is not necessary, but required for the present data. This file stores the packing fraction and Lx and Ly. 

Lx = data(:,2); 
Ly = data(:,3); 
strn = data(:,4);

Lx

for istep = 1:Nstep
       step = steps(istep);
       data = load([folder subfolder 'confforcetiles_phi0.835.xyz']);  % Load the position data
        xyd = [data(:,1:2) data(:,3)+5e-5];
%xyd = [data(:,1:2) data(:,3).*data(:,4)];
%         xyd = Config{step};
%        strn = 0;%Strain(step);
%     
         strn    
%         Lx = 1; Ly = 1;
%        
    [xyd,aLE,gid, E, nAdj,dummyxy,dummyAdj] = Calc_Adj_Mat_PBC(xyd,Lx,Ly,strn, xythresh); % In the frictionless case, the force is generated from the position
% 
    [a1,NS] = eliminate_floaters(aLE,nAdj); % Eliminate the floaters

    Z = sum(logical(NS(:,:,1))); % Coordination numbers

    [r, c] = find(triu(NS(:,:,1))); 
% 
    E1 = [r c];

    E1 = sortrows(E1); % Get the edges (contacts)
    
    NV = size(a1,1); % Number of vertices
    NE = size(E1,1); % Number of edges
    
    pF = [[1:NV]' a1];  % Prepare the position files
    fF = zeros(NE,5); 
    
    
    for i = 1:NE
       
        g1 = E1(i,1); g2 = E1(i,2); 
        ff = NS(g1,g2,1); 
        fx = NS(g1,g2,2); 
        fy = NS(g1,g2,3); 
        
        
        fF(i,:) = [g1 g2 ff fx fy]; % Prepare the forces
        
        
    end
    
    rawConfig.pF = pF; 
    rawConfig.fF = fF; 
    rawData(seed,istep) = {rawConfig}; 
    

end 

end
%% Save the data 
% I assume there is a directory dir in which you store the "forcetile"
% folder, and your current working directory is 'dir/forcetile/FT
% Source/'. The following code will save the datafile in the
% dir/forcetile/Data/ folder. If the folder doesn't exist, it'll create the 
% folder. 



% savefile = <your_data_file_name>

first_step = -5;
last_step  = -1;
step_size  = 0.01;
Nstep = round((last_step-first_step)/step_size)+1;

 
 config = 'Generic_'; 
runid = '1'; 
 destination = '../Data/Raw/'; 

if (~exist(destination,'dir'))
    mkdir(destination); 
end

% Stepid = ['_Steps' Stepid];


savefile = [destination 'rawData_' config runid '.mat']; 
save(savefile, 'rawData','Lx','Ly','xythresh','gid')%,'P','T','EV','-v7.3'); 
