function plotClock(x0,y0,r,ratio,fgColor)
% plotClock(x,y,r,ratio,fgColor, bgColor)

% foreground
t = linspace(0,2*pi*ratio)-pi/2;
x = r*cos(t) + x0;
y = r*sin(t) + y0;
x = [x x0 x(1)];
y = [y y0 y(1)];
hold on
fill(x,y,fgColor);

% backgoround
t = linspace(2*pi*ratio,2*pi)-pi/2;
x = r*cos(t) + x0;
y = r*sin(t) + y0;
x = [x x0 x(1)];
y = [y y0 y(1)];
fill(x,y,[0.5 0.5 0.5]);
