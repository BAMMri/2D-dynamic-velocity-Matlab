function fs_quiver_color(varargin)
% fs_quiver(u,v)
% fs_quiver(x,y,u,v)

magTh = 1;%mag of Vector less than magTh is not visible
scale = 3;

if length(varargin) == 4

    u = varargin{1};
    v = varargin{2};
    sz = size(u);
    x = repmat(1:sz(2), sz(1), 1);
    y = repmat(1:sz(1)', 1, sz(2));
elseif length(varargin) == 5

    u = varargin{1};
    v = varargin{2};
    maxCorrectedMagSq = varargin{3};
    sz = size(u);
    x = repmat(1:sz(2), sz(1), 1);
    y = repmat(1:sz(1)', 1, sz(2));        
elseif length(varargin) >= 6

    u = varargin{1};
    v = varargin{2};
    w = varargin{3};
%     maxQr = varargin{3};  %  maxQg = varargin{4};
        sz = size(u);
        x = repmat(1:sz(2), sz(1), 1);
        y = repmat(1:sz(1)', 1, sz(2));     
else
    error('2 or at least 4 arguments required');
end
if length(varargin) >= 6
    scale = varargin{6};
end

x = x(:);
y = y(:);
u = u(:); v = v(:); w = w(:);

mag = sqrt(u.^2 + v.^2+w.^2);

magMask = (mag < magTh);
x(magMask) = [];
y(magMask) = [];
u(magMask) = [];v(magMask) = [];w(magMask) = [];

maxMag = max(mag);
%u=u.*0.5;v=v.*0.5;
%maxQ=max(maxQr+maxQg)
%maxQ=max([maxQr;maxQg])

% relative luminance: Y = 0.2126 R + 0.7152 G + 0.0722 B
% u is encoded as red, v is encoded as green: scale accordingly
red= abs(u)/max(abs(u(:))); % (u).^2;
green = abs(v)/max(abs(v(:)));% (v).^2;
blue= abs(w)/max(abs(w(:)));
%correctedMagSq = correctedUSq + correctedVSq;
%maxCorrectedMagSq = max(correctedMagSq)
% 
% red = correctedUSq./correctedMagSq.*1;
% green = correctedVSq./correctedMagSq.*1;

u=u.*0.5;v=v.*0.5;

cMap = [red blue green];


% % rescale vectors
% u = u*scale/maxMag;
% v = v*scale/maxMag;

% draw vectors
hold on
for i=1:length(x)
    startX = x(i);
    startY = y(i);
    endX = startX + u(i);
    endY = startY + v(i);
    
    if(startX<1)
        startX=1;
    end
    if(startY<1)
        startY=1;
    end
    if(endX>sz(2))
        endX=sz(2);
    end
    if(endY>sz(1))
        endY=sz(1);
    end   
     if(endX<1)
        endX=1;
    end
    if(endY<1)
        endY=1;
    end 
    
    line([startX endX], [startY endY], 'Color', cMap(i, :),'LineWidth',1);
end

hold off
