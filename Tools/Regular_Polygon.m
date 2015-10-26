function X = Regular_Polygon(n)

sides=n; 
degrees=2*pi/sides; 
theta=0:degrees:2*pi;
radius=ones(1,numel(theta)); 
polar(theta,radius);

x = radius.*cos(theta); 
y = radius.*sin(theta); 

X = [x; y]; 