%% 
load ('C:\Users\Sumantra\Dropbox\MATLAB\Force chain\Source code\forcetile\Data\Processed\Processed_3B_r2.mat') 

%%
ncol = 128; 
seed = 1; 
    colid = randi([1 ncol],1000,1); 
for steps = 1:101
    
    fC = dualCell{steps}; 

da = fC.xy; 
dadj = fC.Adj(:,:,1);
dCycle = fC.Cycles; 
Gidx = fC.GrainIndex; 

figure(2),
clf
col1 = othercolor('RdYlBu11',ncol);
 moviefolder = './Scaled/';
 name = num2str(steps,'%3.3d'); 
 filename = [moviefolder name];
if(~isempty(da))

    NG = size(dCycle,1);
    
    N = max([nanmax(Gidx) NG])
    cid = colid(1:N); 
    
%     subplot(2,2,[2 4])
%       subplot(2,1,2)  
    
    hold on 
   
    for i = 1:NG
        
        ci = dCycle(i,:); 
        ci = ci(ci>0); 
       
        x = da(ci,1); 
        y = da(ci,2); 
        
        if(~isnan(Gidx(i)))
                 id = cid(Gidx(i),1); 
           
                pcol = col1(id,:); 
           
            
        h = fill(x,-y,pcol); 
        set(h,'EdgeColor','None');
        end
      
    end
end
  gplot(dadj,[da(:,1) -da(:,2)],'-k')
  h1 = findobj(gca,'type','line');
  set(h1,'linewidth',2,'linesmoothing','on')
  axis([-400 400 -250 250])
        axis off 
        
        daspect([1 1 1])
hold off
set(gcf, 'InvertHardCopy', 'off');
drawnow
print('-dpng','-r0',filename)
end