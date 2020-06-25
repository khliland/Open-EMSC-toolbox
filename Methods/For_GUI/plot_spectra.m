function h = plot_spectra(s, subset, spec_type)

[n p] = size(s.d);
xlabs = zeros(p,1);
for i=1:p
    xlabs(i,1) = str2double(s.v(i,:));
end

if nargin == 1 || isempty(subset)
    subset = 1:n;
end

h = plot(xlabs, s.d(subset,:)');
% xlim([min(xlabs) max(xlabs)])
% ylim([min(min(s.d(subset,:))) max(max(s.d(subset,:)))])
axis('tight');

if nargin == 3
    if spec_type == 1 % FTIR
        xlabel('Wavenumber [cm^-^1]')
        set(gca,'XDir','reverse')
    elseif spec_type == 2 % Raman
        xlabel('Raman Shift [cm^-^1]')
        set(gca,'XDir','reverse')
    elseif spec_type == 3 ; NIR
        xlabel('Wavelength [nm]')
    end
    ylabel('Intensity')
end

diffx = abs(diff(xlabs));
ind = find(diffx > 2*median(diffx)); % Find unnormal jumps
y = s.d(subset,:);
ymin = min(min(y));
ymax = max(max(y));
ydiff = (ymax-ymin)*0.005;
for i=1:length(ind)
    patch([xlabs(ind)+1, xlabs(ind+1)-1, xlabs(ind+1)-1, xlabs(ind)+1], [ymin+ydiff,ymin+ydiff,ymax-ydiff,ymax-ydiff],[1 1 1],'EdgeColor',[1 1 1]);
end
