% Sky Clock calculations
% As an input we get the positions of the planets
% Desired outputs is the projections onto the earth-sun-moon plane

%%
% Positions of [sun mercury venus earth moon mars jupiter saturn]

p = [ ...
    105466.57862061243 -320513.0525348927 -153075.22353957177
    -28254617.546911404 33413899.08547402 20807485.255014483
    101892433.53560476 35869153.31981312 9688685.825101694
    87994759.91391698 108869760.5619592 47182570.1411031
    88318269.65765092 109070078.26608586 47271779.78689272
    -175033175.6172045 156838581.5712689 76659903.66643791
    -147654424.0403505 696873333.1511024 302281137.98811287
    -1054977146.3189284 -970294923.8394519 -355362682.91360706];
nm = {'Sun','Mercury','Venus','Earth','Moon','Mars','Jupiter','Saturn'};

planet = [];
% First assign the positions
for i = 1:size(p,1)
    p_i = p(i,:);
    planet(i).p = p_i;
    planet(i).nm = nm{i};
    
    plot3(p_i(1),p_i(2),p_i(3),'r.');
    text(p_i(1),p_i(2),p_i(3),[' ' planet(i).nm]);
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

