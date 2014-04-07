%% Sky Clock calculations
%
% I look up at the sky just after sunset and I see an especially bright
% star. It's probably a planet. But which one? This sort of question gives
% me a good opportunity to play around with MATLAB. Let's do a
% visualization that shows where the planets are relative to the earth and
% the sun.
%
% <<../explanation1.png>>
%
% Here is the basic grade-school illustration of the solar system, the one
% that shows the planets rolling around the Sun like peas on a plate. For
% simplicity, we're just showing the sun, the earth, the moon, Venus, and
% Mars. Viewed from far above the sun, it looks something like this.
%
% <<../explanation2.png>>
%
% But we don't really have the luxury of this high-level view. Instead, we
% see little bright spots on a dark background somewhere "up there." Let's
% reduce our problem to determining what direction the planets are in. This
% leads to an image like this.
%
% <<../explanation3.png>>
%
% Our goal is to make an accurate up-to-date version of this diagram.
% Specifically, in the plane of the ecliptic, and relative rto the sun,
% where should we look to find the moon and the naked-eye planets (Mercury,
% Venus, Mars, Jupiter, and Saturn)? To do this, we need to solve a few
% problems.
%
% * Where are the planets?
% * Find the vector pointing from earth to each planet
% * Squash all these vectors into a single plane
% * Visualize the resulting disk

%% Where Are the Planets?
% First of all, where are the planets? There's a free JSON service for just
% about everything these days. Here's one that I've found for
% planetary data is hosted on Davy Wybiral's sitt here:
%
% <http://davywybiral.blogspot.com/2011/11/planetary-states-api.html>

url = 'http://www.astro-phys.com/api/de406/states?bodies=sun,moon,mercury,venus,earth,mars,jupiter,saturn';
json = urlread(url);

%% Parse the data
% Now we can use
% <http://www.mathworks.com/matlabcentral/fileexchange/42236-parse-json-text
% Joe Hicklin's JSON parser> from the File Exchange. It returns a
% well-bahaved MATLAB structure.

data = JSON.parse(json)

%%

data.results

%%
% The distances are in kilometers, and I'm not even sure how this
% representation is oriented relative to the surrounding galaxy. But it
% doesn't really matter, because all I care about is the relative positions
% of the bodies in question.

%% Aerospace Toolbox Ephemeris
% Note: We can also use the Aerospace Toolbox to get the same information.
%
% |[pos,vel] = planetEphemeris(juliandate(now),'Sun','Earth')|

%% Build the Solar System Structure

% List of bodies we care about
ssList = {'sun','moon','mercury','venus','earth','mars','jupiter','saturn'};

ss = [];
for i = 1:length(ssList)
    ssObjectName = ssList{i};
    ss(i).name = ssObjectName;
    ssVec = data.results.(ssObjectName);
    ss(i).position = ssVec(1:3);
end
ss

%% Plot the planets

clf
for i = 1:length(ss)
    p = ss(i).position;
    plot3(p(1),p(2),p(3),'r.');
    
    text(p(1),p(2),p(3),[' ' ss(i).name]);
    hold on
end

hold off
axis equal

%%
% This is accurate, but not yet very helpful. As we said earlier, from our
% point of view here on the ground, the sun DOES go around the earth, as do
% the moon and all the planets.
%
% Let's calculate the geocentric position vectors of each planet. To do
% this, we'll put the earth at the center of the system. Copernicus won't
% mind, because A) he's dead, and B) we admit this reference frame orbits
% the sun. That's no worry to us here since we're just looking at
% instantaneous positions in space.
%
% We're also going to use another file from the File Exchange.  Georg
% Stillfried's <http://www.mathworks.com/matlabcentral/fileexchange/25372
% mArrow3>

addpath([fxpath(25372) filesep])

clf
pEarth = ss(5).position;
for i = 1:length(ss)
    % pe = position relative to earth
    % (i.e. a vector pointing from earth to body X)
    pe = ss(i).position - pEarth;
    % pne = normalized position relative to earth
    pne = pe/sqrt(dot(pe,pe));
    ss(i).pne = pne;
    
    mArrow3([0 0 0],pne, ...
        'stemWidth',0.01,'FaceColor',[1 0 0]);
    
    text(pne(1),pne(2),pne(3),[' ' ss(i).name]);
    hold on
end
light
hold off
axis equal
axis off

%%
% These are unit vectors pointing out from the center of the earth towards
% each of the other objects.


%%
% If we change our view point to look at the system edge-on, we can see the
% objects are not quie co-planar. For simplicity, let's squash them all
% into the same plane. We'll use the plane defined by the earth, moon, and
% sun.

% vsun is the unit vector that points from earth to sun
% vmoon is the unit vector that points from earth to moon
% The cross product of these two vectors will define the desired plane.

% cla
psun = ss(1).pne;
pmoon = ss(2).pne;
psunXpmoon = cross(psun,pmoon);
mArrow3([0 0 0],psunXpmoon, ...
    'stemWidth',0.01,'FaceColor',[0 0 0]);
view(-45,15)
a = axis
axis(a/2)
set(gca,'Clipping','off')

%%
% You can see that some of the planets deviate from this plane. The planets
% stay close to the ecliptic, but they do wander a little.
% Now we project the vectors onto the plane defined by earth-moon-sun
% See http://en.wikipedia.org/wiki/Vector_projection

hold on
for i = 1:length(ss)
    pne = ss(i).pne;
    pneProj = pne - dot(pne,psunXpmoon)/dot(psunXpmoon,psunXpmoon)*psunXpmoon;
    ss(i).pneProj = pneProj;
    
    mArrow3([0 0 0],pneProj, ...
        'stemWidth',0.01,'FaceColor',[0 0 1]);
    text(pneProj(1),pneProj(2),pneProj(3),[' ' ss(i).name]);
end
hold off
axis equal

%%
% Calculate the angle between the sun and each of the bodies
%
% $$ cos(\theta) =   $$

sun = ss(1).pneProj;
ss(1).theta = 0;

for i = 1:length(ss)
    pneProj = ss(i).pneProj;
    cosTheta = dot(sun,pneProj)/(sqrt(dot(sun,sun))*sqrt(dot(pneProj,pneProj)));
    theta = acos(cosTheta);
    
    % The sun-moon cross vector sticks out of the plane. We can use it to
    % determine the orientation of theta
    
    x = cross(sun,pneProj);
    theta = theta*sign(dot(psunXpmoon,x));
    ss(i).theta = theta;
    
end

%% Plot the result

cla

k1 = 1.5;
k2 = 1.2;
for i = 1:length(ss)
    beta = ss(i).theta + pi/2;
    x = cos(beta);
    y = sin(beta);
    mArrow3([0 0 0],[x y 0], ...
        'stemWidth',0.01, ...
        'FaceColor',[0 0 1])
    line([0 k1*x],[0 k1*y],'Color',0.8*[1 1 1])
    text(k1*x,k1*y,ss(i).name,'HorizontalAlignment','center')
end
t = linspace(0,2*pi,100);
line(k2*cos(t),k2*sin(t),'Color',0.8*[1 1 1])
line(0,0,1,'Marker','.','MarkerSize',40,'Color',[0 0 1])

axis equal
axis(2*[-1 1 -1 1])

%%
% And there you have it: an accurate map of where the planets are in the
% sky for today's date.


