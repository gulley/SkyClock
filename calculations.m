% Sky Clock calculations
% As an input we get the positions of the planets
% Desired outputs is the projections onto the earth-sun-moon plane

%%
% Positions of [sun mercury venus earth moon mars]

p = [ ...
    98737.65714089875 -322333.36244940694 -153695.74901326824
    6941996.601020642 40110318.72735843 20735265.058509897
    107376698.98967445 16606844.809812635 674753.2904573642
    102641024.09369242 97848513.33584224 42404420.99743636
    102797481.67090186 97531216.1543806 42302953.91258208
    -164532329.9741314 165301295.37539384 80258023.65923128];
nm = {'sun','mercury','venus','earth','moon','mars'};

planet = [];
% First assign the positions
for i = 1:size(p,1)
    pi = p(i,:);
    planet(i).p = pi;
    planet(i).nm = nm{i}

    plot3(pi(1),pi(2),pi(3),'r.');
    text(pi(1),pi(2),pi(3),[' ' planet(i).nm]);
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
% cos(theta) = dot(u,v)/(sqrt(dot(u,u))*sqrt(sqrt(dot(v,v))))

x = cross(planet(1).pen2,planet(5).pen2)
y = cross(planet(1).pen2,planet(3).pen2)
x./y

% http://stackoverflow.com/questions/15101103/euler-angles-between-two-3d-vectors

