url = 'http://www.astro-phys.com/api/de406/states?bodies=sun,moon,mercury,venus,earth,mars,jupiter,saturn';
json = urlread(url);
data = JSON.parse(json)

% List of bodies we care about
ssList = {'sun','moon','mercury','venus','earth','mars','jupiter','saturn'};

ss = [];
for i = 1:length(ssList)
    ssObjectName = ssList{i};
    ss(i).name = ssObjectName;
    ssVec = data.results.(ssObjectName);
    ss(i).position = ssVec(1:3);
    ss(i).velocity = ssVec(4:6);
end

pEarth = ss(5).position;
for i = 1:length(ss)
    % pe = position relative to earth
    % (i.e. a vector pointing from earth to body X)
    pe = ss(i).position - pEarth;
    % pne = normalized position relative to earth
    pne = pe/sqrt(dot(pe,pe));
    ss(i).pne = pne;
end

pEarth = ss(5).position;
pSun = ss(1).position;
vEarth = ss(5).velocity;

earthPlaneNormal = cross(vEarth,pSun - pEarth);

% Normalize this vector
earthPlaneNormalUnit = earthPlaneNormal/sqrt(dot(earthPlaneNormal,earthPlaneNormal));
for i = 1:length(ss)
    pne = ss(i).pne;
    pneProj = pne - dot(pne,earthPlaneNormalUnit)/dot(earthPlaneNormalUnit,earthPlaneNormalUnit)*earthPlaneNormalUnit;
    ss(i).pneProj = pneProj;
end

sun = ss(1).pneProj;
ss(1).theta = 0;

for i = 1:length(ss)
    pneProj = ss(i).pneProj;
    cosTheta = dot(sun,pneProj)/(sqrt(dot(sun,sun))*sqrt(dot(pneProj,pneProj)));
    theta = acos(cosTheta);
    
    % The earth-plane normal vector sticks out of the plane. We can use it
    % to determine the orientation of theta
    
    x = cross(sun,pneProj);
    theta = theta*sign(dot(earthPlaneNormalUnit,x));
    ss(i).theta = theta;    
end

% Plot the result
clf

k1 = 1.5;
k2 = 1.2;
for i = 1:length(ss)
    beta = ss(i).theta + pi/2;
    x = cos(beta);
    y = sin(beta);
    mArrow3([0 0 0],[x y 0], ...
        'stemWidth',0.01, ...
        'FaceColor',[0 0 1]);
    line([0 k1*x],[0 k1*y],'Color',0.8*[1 1 1])
    text(k1*x,k1*y,ss(i).name,'HorizontalAlignment','center')
end
t = linspace(0,2*pi,100);
line(k2*cos(t),k2*sin(t),'Color',0.8*[1 1 1])
line(0,0,1,'Marker','.','MarkerSize',40,'Color',[0 0 1])

axis equal
axis(2*[-1 1 -1 1])
axis off
set(gcf,'Color','white')
