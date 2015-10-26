function [FTConfig,nanidx] = Compute_Height_Vertices(FTConfig)

delete('./Height_Positions.txt');

cAdj = FTConfig.Adj; 

if (strcmp(getenv('OS'),'Windows_NT'))
    !calc_vectors_random_IC.exe 
else
    !./calc_rand_IC 
end
  
 
 if exist('./Height_Positions.txt','file')
    cvert = load('./Height_Positions.txt'); 
    nanidx = find(isnan(cvert(:,1)));
    cvert(nanidx,:) = []; 
    cAdj(nanidx,:,:)= [];
    cAdj(:,nanidx,:)= [];
    FTConfig.nanid = nanidx;
 else
     cvert =[]; 
     cAdj = []; 
     FTConfig.nanid = []; 
 end
 
 
 FTConfig.xy = cvert; 
 FTConfig.Adj = cAdj; 