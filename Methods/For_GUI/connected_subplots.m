function connected_subplots(axes1,axes2,x1,x2,y1,y2,leg)

C = [    0         0    1.0000
         0    0.5000         0
    1.0000         0         0
         0    0.7500    0.7500
    0.7500         0    0.7500
    0.7500    0.7500         0
    0.2500    0.2500    0.2500];
styles = {'-','--',':','.-'};

n1 = size(y1,1);
n2 = size(y2,1);

axes(axes1)
cla
hold on
for i=1:n1
    p1(i) = plot(x1,y1(i,:),'Color',C(mod(i-1,7)+1,:));
end

% Cover white area
diffx = abs(diff(x1));
ind = find(diffx > 2*median(diffx)); % Find unnormal jumps
if ~isempty(ind)
    ymin = min(min(y1));
    ymax = max(max(y1));
    ydiff = (ymax-ymin)*0.005;
    for i=1:length(ind)
        pa1(i) = patch([x1(ind)+1, x1(ind+1)-1, x1(ind+1)-1, x1(ind)+1], [ymin+ydiff,ymin+ydiff,ymax-ydiff,ymax-ydiff],[1 1 1],'EdgeColor',[1 1 1]);
    end
else
    pa1 = [];
end

axes(axes2)
cla
hold on
for i=1:n2
    if nargin < 7
        set(gca,'YTickMode','auto')
        p2(i) = plot(x2,y2(i,:),'Color',C(mod(i-1,7)+1,:));
    else
        set(gca,'YTick',[])
        y2s = y2(i,:)-min(y2(i,:));
        y2s = y2s./max(y2s);
        p2(i) = plot(x2,y2s,styles{mod(floor((i-1)/7),4)+1},'Color',C(mod(i-1,7)+1,:));
    end
end

% Cover white area
diffx = abs(diff(x2));
ind = find(diffx > 2*median(diffx)); % Find unnormal jumps
if ~isempty(ind)
    ymin = min(min(y2));
    ymax = max(max(y2));
    ydiff = (ymax-ymin)*0.005;
    for i=1:length(ind)
        pa2(i) = patch([x2(ind)+1, x2(ind+1)-1, x2(ind+1)-1, x2(ind)+1], [ymin+ydiff,ymin+ydiff,ymax-ydiff,ymax-ydiff],[1 1 1],'EdgeColor',[1 1 1]);
    end
else
    pa2 = [];
end

% Clickable areas
if nargin < 7
    for i=1:n1
        set(p1(i),'ButtonDownFcn',@(handle,event)(change_lines(i,n1,p1,p2,pa1,pa2,C)))
        set(p2(i),'ButtonDownFcn',@(handle,event)(change_lines(i,n1,p1,p2,pa1,pa2,C)))
    end
    set(axes1,'ButtonDownFcn',@(handle,event)(change_lines(0,n1,p1,p2,pa1,pa2,C)))
    set(axes2,'ButtonDownFcn',@(handle,event)(change_lines(0,n1,p1,p2,pa1,pa2,C)))
    for i=1:length(pa1)
        set(pa1(i),'ButtonDownFcn',@(handle,event)(change_lines(0,n1,p1,p2,pa1,pa2,C)))
    end
    for i=1:length(pa2)
        set(pa2(i),'ButtonDownFcn',@(handle,event)(change_lines(0,n1,p1,p2,pa1,pa2,C)))
    end
%     legend('off')
else
%     legend('off')
%     legend(leg,'Location', 'SouthEast')
end


function change_lines(j,n,p1,p2,pa1,pa2,C)
for i=1:n
    set(p1(i),'LineWidth',1,'Color',C(mod(i-1,7)+1,:))
end
if j>0
    set(p1(j),'LineWidth',2,'Color',[0,0,0])
    uistack(p1(j),'top')
end

for i=1:n
    set(p2(i),'LineWidth',1,'Color',C(mod(i-1,7)+1,:))
end
if j>0
    set(p2(j),'LineWidth',2,'Color',[0,0,0])
    uistack(p2(j),'top')
    disp(['Selected: ' num2str(j)])
else
    disp('Selected: none')
end
if ~isempty(pa1)
    for i=1:length(pa1)
        uistack(pa1(i),'top')
    end
end
if ~isempty(pa2)
    for i=1:length(pa2)
        uistack(pa2(i),'top')
    end
end