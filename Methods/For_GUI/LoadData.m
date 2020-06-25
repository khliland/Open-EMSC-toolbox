function [ZSaisir, filenameEval] = LoadData()

[filename, pathname, index] = uigetfile( ...
    {'*.mat;*.MAT','Unscrambler export for MATLAB (*.mat)';
    '*.mat;*.MAT','ISys export for MATLAB (*.mat)';
    '*.*',  'All Files (*.*)'},...
    'Select MATLAB spectra to analyse');%, ...
%     '','MultiSelect', 'off');
k = strfind(filename,'.');
if (k>1)
    filenameEval = filename(1:(k-1));
end

global dataTypeGlob datasetGlob

if index == 1 %~isnumeric(pathname)
    % UNSCRAMBLER
    disp('Importing from Unscrambler')
    
    NameSaisir = strcat(pathname,filename);
    load(NameSaisir);
    data = load(NameSaisir);
    datasetGlob = data;
    ZSaisir = [];
    
    % Check Unscrambler version
    if exist('SamplesName','var') % Old?
        ObjLabels = SamplesName;
        Matrix    = DataMatrix;
        TempName  = VariableName;
        dataTypeGlob = 'Unscrambler_Old';
        
    else % 10.01+
        if exist('VarLabels0','var')
            Matrix   = eval(filenameEval);
            TempName = VarLabels0;
            dataTypeGlob = 'Unscrambler_10';
            
        else % 9.6
            TempName = VarLabels;
            dataTypeGlob = 'Unscrambler_96';
        end
    end
    
    ZSaisir.i = num2str(ObjLabels);
    TempName(TempName==0) = ' ';
    ZSaisir.v = clean_strings(TempName);
    ZSaisir.d = Matrix;

elseif index == 2
    % ISYS
    disp('Importing from ISys')

    NameSaisir = strcat(pathname,filename);
    % load the matlab file saved by Unscrambler and put it to the saisir
    % structure
    data = load(NameSaisir);
    
    spectra = permute(data.data, [3,1,2]);
    spectra = spectra(:,:)';
    no_NaN  = find(~isnan(spectra(:,1)));
    data.no_NaN = no_NaN;
    ZSaisir.d  = spectra(no_NaN,:);
    ZSaisir.v  = num2str((data.firstx:(data.lastx-data.firstx)./ ...
        (data.numchannels-1):data.lastx)');
    ZSaisir.i = num2str((1:size(ZSaisir.d,1))');
    dataTypeGlob = 'ISys';
    datasetGlob = data;

else
    % User canceled
    ZSaisir = [];
    filenameEval = [];
end

%%
function strs = clean_strings(strs)
strs = cellstr(strs); % strs <- data.VarLabels
tmp = [];
if ~isempty(regexp(strs{1},'[a-zA-Z]')) %#ok<RGXP1>
    tmp = cell2mat(strfind(strs, strs{1}(regexp(strs{1},'[a-zA-Z]'):end)));
end
if length(tmp) == length(strs)
    strs = regexprep(strs, strs{1}(regexp(strs{1},'[a-zA-Z]'):end), '');
end
strs = char(strs);