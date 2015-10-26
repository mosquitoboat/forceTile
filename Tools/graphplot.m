function graphplot(realConfig, FTConfig,graphCmap)


subplot(1,2,1)
% figure(1),
cla
% Plot the contact network
s = realConfig.Adj; 
xyd = realConfig.xyd; 

[~,~,v] = find(s(:,:,1));
cmrange = [ (min(v)) (max(v))];  

% [~,~]=wgPlot1(s(:,:,1),xyd(:,1:2),'vertexWeight',ones(length(xyd),1),'vertexMetadata',ones(length(xyd),1),'edgeColorMap',graphCmap,'colormaprange',cmrange);
gplot(s(:,:,1),xyd(:,1:2))
daspect([1 1 1])


subplot(1,2,2)
% figure(2),
cla

dAdj = FTConfig.Adj; 
da   = FTConfig.xy; 

% [~,~]=wgPlot1(dAdj(:,:,1),da(:,1:2),'vertexWeight',ones(length(da),1),'vertexMetadata',ones(length(da),1),'edgeColorMap',graphCmap,'colormaprange',cmrange);
 gplot(dAdj(:,:,1),da(:,1:2))
daspect([1 1 1])
