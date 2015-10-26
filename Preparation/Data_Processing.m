% Data Processing

folder = '../Sample/'; 
posfile = [folder 'Vinutha_Position.xyz']; 
forcefile = [folder 'Vinutha_Force.xyz']; 


pF = load(posfile); 
fF = load(forcefile); 

%Fluff variables which you need not worry about
Lx = 1; 
Ly = 1; 
xythresh = 1; 
gid = 1; 


    % Save the position and the forces in a struct. 
    
    rawConfig.pF = pF; 
    rawConfig.fF = fF; 
    
    % Save the struct in a MatLab cell. Helpful, if you're dealing with a
    % bunch of data. 
    rawData(1,1) = {rawConfig};
    
    
    config = 'Vinutha_'; 
runid = '1'; 
 destination = '../Data/Raw/'; 

if (~exist(destination,'dir'))
    mkdir(destination); 
end

% Stepid = ['_Steps' Stepid];


savefile = [destination 'rawData_' config runid '.mat']; 
save(savefile, 'rawData','Lx','Ly','xythresh','gid');
