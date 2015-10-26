
%% Load Data
% load('../Data/Processed/Processed_3B_r2.mat')

%% Find the number of the NC Polygon
nSteps = length(realCell);
NNC = nan(nSteps,1); 
NC = nan(nSteps,1);
for step = 1:nSteps
centroid = realCell{step}.MinCycles.Centers;
nanid = dualCell{step}.nanid; 
Adj = dualCell{step}.Adj(:,:,1); 
V = dualCell{step}.xy; 

[r,c] = find(triu(Adj)); 

E  = sortrows([r c]); 

centroid(nanid,:) = []; 


Config.xyd = centroid;
Config.Edges = E; 


MinCycles = Compute_Minimal_Cycles(Config); 

%%%%%%%%%%%%%%%%%%%%%%%%%

cycle = MinCycles.MCB; 
nCycle = size(cycle,1); 

vert = V; 
cArea = zeros(nCycle,1); 
chArea = cArea; 
for i = 1:nCycle

            vlist = cycle(i,:); 
            vlist = vlist(vlist > 0); 

%             Z =  length(vlist) 

           X = vert(vlist,1); 
           Y = vert(vlist,2);
%            angles = polyangle(X, Y);
%            nonConvex(i) = any(angles>=180);
          if(size(unique([X Y],'rows'),1)>2)

           % Area of the tile

        %    cArea(i) = area_polygon(X,Y);  % Ignore

                cArea(i) = polyarea(X,Y);    

           % Area of the convex hull

                [~,chArea(i)] = convhull(X,Y); 
          end
end
 
AreaRatio = chArea./cArea;
nonConvex = abs(log10(AreaRatio)) > 1e-10;

NNC(step) = sum(nonConvex); 
NC(step) = nCycle; 
end


