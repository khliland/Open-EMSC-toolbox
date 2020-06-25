dir = mfilename('fullpath');
addpath(genpath(dir(1:end-13)))

Raman = LoadFromUnscrambler_v96('./Data/','org200709.MAT');
[~,p] = size(Raman.d);
v = zeros(p,1); % Remove cm-1 from ordinates and reformat
for i=1:p
    s = regexp(Raman.v(i,:), 'cm-1', 'split');
    v(i) = str2num(s{1});
end
Raman.v = num2str(v);
for i=1:21
    Raman.i(i,:) = [' ' Raman.i(i,1:end-1)];
end

clear s v i p dir