%% Load Data
N = 150; 
maxSeed = 15; 
first_step = 0.01; 
last_step = 0.1; 
folder = '../Data/Statistics/'; 

config = ['Mitch_N' num2str(N) '_geo' num2str(1) 'TO' num2str(maxSeed)];
runid = ['_Compression_' num2str(first_step) 'TO' num2str(last_step)]; 

file = [folder 'Stats_' config runid '.mat'];

load(file,'geomCell','statCell'); 

%% Prepare for plotting

nSample = size(statCell,1); 
nConfig = size(statCell,2); 

PeriCF = cell(nConfig,1); 
AreaCF = cell(nConfig,1); 
PeriVar = cell(nConfig,1); 
AreaVar = cell(nConfig,1); 
for i = 1:nConfig
    
    PCorr = []; 
    ACorr = [];
    PVar = [];
    AVar = [];
    
    for j = 1:nSample
        
        PCorr = [PCorr; statCell{j,i}.PeriCorFn];
        ACorr = [ACorr; statCell{j,i}.AreaCorFn];
        
        
        varofP = cellfun(@var,statCell{j,i}.ClusterPerimeter);
        varofA = cellfun(@var,statCell{j,i}.ClusterArea);
        Ntiles(j,i) = size(geomCell{j,i}.Area,1); 
        PVar = [PVar; varofP']; 
        AVar = [AVar; varofA']; 
        
    end
    
    PeriCF(i) = {[ 1 nanmean(PCorr)]}; 
    AreaCF(i) = {[ 1 nanmean(ACorr)]}; 
    
    PeriVar(i) = {nanmean(PVar)};
    AreaVar(i) = {nanmean(AVar)}; 
   
end
        

%% Plot
p = zeros(nConfig,1);
for i = 1:nConfig
    
    p(i,:) = PeriCF{i}(2);
end
% 
figure(4),
semilogy(0.01:0.01:0.1,smooth(p(:,1)),0.005:0.01:0.105,exp(-1.7221)*exp(-18.241*(0.005:0.01:0.105)))%,0.01:0.01:0.1,smooth(p(:,2)/p(1,2)),0.01:0.01:0.1,smooth(p(:,3)/p(1,3)))
xlim([0.0 0.11])
% step = 10;
% figure(3)
% plot((0:10),PeriCF{step},'-o')
% axis square
% hold on 

%%
