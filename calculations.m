% Sky Clock calculations
% As an input we get the positions of the planets
% Desired outputs is the projections onto the earth-sun-moon plane

% http://davywybiral.blogspot.com/2011/11/planetary-states-api.html

%%
% Let's say we're interested in plotting the actual current state of the
% solar system. To be specific, there are seven naked-eye heavenly bodies
% in our neighborhood: sun, moon, mercury, venus, mars, saturn, Jupiter. I
% want to plot them in their classic peas-on-a-plate configuration, as seen
% from "above". Everything's relative in space, so when I say "above", I
% mean looking down at the sun as the earth sweeps a counterclockwise
% orbit.
%
% See http://www.starchamber.com/skyclock/explanation.html for more notes.
%
% So the problem is this: first get the data from the web. Then mash all
% the planets into a plane. Then figure out the angles to planets sun and
% moon when looking from earth. It's a nice little 3-D geometry problem,
% and gives us an opportunity to explore MATLAB.

%% Planetary Positions
% First of all, where are the planets? There's a free JSON service for
% everything these days, or so it seems. One that I've found for planetary
% data is hosted here http://davywybiral.blogspot.com/2011/11/planetary-states-api.html
% Davy Wybiral

url = 'http://www.astro-phys.com/api/de406/states?bodies=sun,moon,mercury,venus,earth,mars,jupiter,saturn';
json = urlread(url);
data = JSON.parse(json);

%% Aerospace Toolbox Ephemeris
% It turns out we can use the Aerospace Toolbox to get the same
% information.

% [pos,vel] = planetEphemeris(juliandate(now),'Sun','Earth')

% TODO: Does this square with what my other source is telling me?

%%

% List of bodies we care about 
bList = {'sun','moon','mercury','venus','earth','mars','jupiter','saturn'};

% 1 Astronomical Unit = 149 597 871 kilometers
au = 149597871;

% We'll store our distances in AU.
b = [];
for i = 1:length(bList)
    bName = bList{i};
    b(i).name = bName;
    bVec = data.results.(bName);
    b(i).position = bVec(1:3)/au;
    b(i).velocity = bVec(4:6);
end

%%
% Make the sun stationary and at the center of the coordinate system.

for i = 1:length(b)
    b(i).position = b(i).position - b(1).position;
    b(i).velocity = b(i).velocity - b(1).velocity;
end


%% Plot the planets

for i = 1:length(b)-2
    p = b(i).position;
    plot3(p(1),p(2),p(3),'r.');
    text(p(1),p(2),p(3),[' ' b(i).name]);
    hold on
end
hold off

%%
% Now calculate the geocentric position vectors of each planet

pearth = planet(4).p;
for i = 1:length(planet)
    pe = planet(i).p - pearth;
    % pen = normalized position relative to earth
    % (i.e. a unit vector pointing from earth to body X
    pen = pe/sqrt(dot(pe,pe));
    planet(i).pen = pen;
    
    plot3([0 pen(1)],[0 pen(2)],[0 pen(3)],'r.-');
    text(pen(1),pen(2),pen(3),[' ' planet(i).nm]);
    hold on
end
% hold off

%%
% psun is the unit vector that points from earth to sun
% pmoon is the unit vector that points from earth to moon

psun = planet(1).pen;
pmoon = planet(5).pen;
b = cross(psun,pmoon);

%%
% Now we project the vectors onto the plane defined by earth-moon-sun
% See http://en.wikipedia.org/wiki/Vector_projection

for i = 1:length(planet)
    pen = planet(i).pen;
    pen2 = pen - dot(pen,b)/dot(b,b)*b;
    planet(i).pen2 = pen2;
    
    plot3([0 pen2(1)],[0 pen2(2)],[0 pen2(3)],'b.-');
    text(pen2(1),pen2(2),pen2(3),[' ' planet(i).nm]);
    hold on
end
hold off

%%
% Calculate the angle between the sun and each of the bodies

sun = planet(1).pen2;
planet(1).theta = 0;

for i = [2 3 5 6 7 8]
    body = planet(i).pen2;
    cosTheta = dot(sun,body)/(sqrt(dot(sun,sun))*sqrt(dot(body,body)));
    theta = acos(cosTheta);
    % The sun-moon cross vector sticks out of the plane. We can use it to
    % determine the orientation of theta
    
    x = cross(sun,body);
    theta = theta*sign(dot(b,x));
    planet(i).theta = theta;
    
end

%% Plot the result

cla
for i = [1 2 3 5 6 7 8]
    beta = planet(i).theta + pi/2;
    x = cos(beta);
    y = sin(beta);
    line([0 x],[0 y])
    line(x,y,'Marker','o','MarkerSize',6)
    text(x,y,['  ' planet(i).nm]) 
end
line(0,0,'Marker','o','MarkerSize',9)

axis equal
axis(2*[-1 1 -1 1])
% axis square
box on

