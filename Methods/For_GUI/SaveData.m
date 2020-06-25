function [success] = SaveData()

global correctedGlob datasetGlob dataTypeGlob

[file,path,index] = uiputfile({'*.mat','MATLAB format importable to Unscrambler X (*.mat)';
    '*.mat','MATLAB format importable to ISys (*.mat)'}, ...
    'Save corrected spectra','*.mat');

if index == 1
    % Unscrambler X
    disp('Exporting to Unscrambler X')
    
    k = strfind(file,'.');
    if (k>1)
        objname = file(1:(k-1));
    end
    
    object = evalin('base', correctedGlob);
    VarLabels0 = object.v;
    ObjLabels  = object.i;
    eval([objname ' = object.d;'])
    save([path file], 'VarLabels0', 'ObjLabels', objname)
    success = 1;

elseif index == 2
    % ISys
    disp('Exporting to ISys')
    object = evalin('base', correctedGlob);
    
    if strcmp(dataTypeGlob,'ISys')
        data = datasetGlob;
        no_NaN = data.no_NaN;
        data = rmfield(data,'no_NaN');
        fl = [min(str2num(object.v)) max(str2num(object.v))];
        fl(1,3) = (fl(2)-fl(1))/(size(object.v,1)-1);
        data = struct('numchannels',size(object.d,2), 'xsize', data.xsize, ...
            'ysize', data.ysize, 'firstx', fl(1), 'lastx', fl(2), ...
            'datatype', data.datatype, 'nregions', data.nregions, ...
            'regiontable', struct('array', fl, 'coadds', 0), ...
            'descriptionlength', data.descriptionlength, 'filedescription', data.filedescription);
    else
        answer = inputdlg({'X dimension','Y dimension'},'Image dimensions',1);
        fl = [min(str2num(object.v)) max(str2num(object.v))];
        fl(1,3) = (fl(2)-fl(1))/(size(object.v,1)-1);
        data = struct('numchannels',size(object.d,2), 'xsize', answer{1}, ...
            'ysize', answer{2}, 'firstx', fl(1), 'lastx', fl(2), ...
            'datatype', 31, 'nregions', 1, 'regiontable', struct('array', fl, 'coadds', 0), ...
            'descriptionlength', 0, 'filedescription', '');
    end
    spectra = zeros(data.xsize*data.ysize,data.numchannels);
    spectra(no_NaN,:) = object.d;
    
    spectra = reshape(spectra', [data.numchannels, data.ysize, data.xsize]);
    data.data = permute(spectra, [2,3,1]);
    save([path file], '-struct', 'data')
    success = 1;

else
    success = 0;
end
